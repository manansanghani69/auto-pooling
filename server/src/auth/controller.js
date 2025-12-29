// src/auth/controller.js
import * as authService from './service.js';

function toTrimmedString(value) {
    if (value === undefined || value === null) return '';
    return String(value).trim();
}

function toOptionalTrimmedString(value) {
    const trimmed = toTrimmedString(value);
    return trimmed ? trimmed : undefined;
}

function sendError(res, status, message) {
    return res.status(status).json({
        status: 'error',
        code: status,
        data: null,
        error: { message },
    });
}

function sendServerError(res, error) {
    console.error(error);
    return res.status(500).json({
        status: 'error',
        code: 500,
        data: null,
        error: { message: 'server error' },
    });
}

function sanitizeUser(user) {
    if (!user) return user;
    const { password: _password, ...safeUser } = user;
    return safeUser;
}

function sendSuccess(res, status, data) {
    return res.status(status).json({
        status: 'success',
        code: status,
        data,
    });
}

export async function requestOtp(req, res) {
    try {
        const body = req.body ?? {};
        const phone = toTrimmedString(body.phone);
        if (!phone) return sendError(res, 400, 'phone required');
        
        const { otp, expiresIn } = await authService.requestOtp(phone);
        const response = { ok: true, expiresIn };
        if (authService.shouldReturnOtp()) {
            response.otp = otp;
            console.log('otp is ' + otp);
        }
        return sendSuccess(res, 200, response);
    } catch (e) {
        return sendServerError(res, e);
    }
}

export async function verifyOtp(req, res) {
    try {
        const body = req.body ?? {};
        const phone = toTrimmedString(body.phone);
        const otp = toTrimmedString(body.otp);
        const name = toTrimmedString(body.name);
        const role = toOptionalTrimmedString(body.role);

        if (!phone || !otp) return sendError(res, 400, 'phone & otp required');

        const valid = await authService.verifyOtp(phone, otp);
        if (!valid) return sendError(res, 401, 'invalid otp');

        let user = await authService.findUserByPhone(phone);
        let isNewUser = false;

        if (!user) {
            // if (!name) return sendError(res, 400, 'name required for new user');
            user = await authService.createUser({ phone, name, role });
            isNewUser = true;
        }

        const tokens = await authService.issueTokens(user);
        return sendSuccess(res, isNewUser ? 201 : 200, {
            user: sanitizeUser(user),
            tokens,
            isNewUser,
        });
    } catch (e) {
        return sendServerError(res, e);
    }
}

export async function refresh(req, res) {
    try {
        const { refreshToken } = req.body ?? {};
        if (!refreshToken) return sendError(res, 400, 'refreshToken required');

        const tokens = await authService.refreshAccessToken(refreshToken);
        return sendSuccess(res, 200, tokens);
    } catch (e) {
        console.error(e);
        return sendError(res, 401, 'invalid refresh token');
    }
}

export async function logout(req, res) {
    try {
        const { refreshToken } = req.body ?? {};
        if (refreshToken) await authService.revokeRefreshToken(refreshToken);
        return sendSuccess(res, 200, { ok: true });
    } catch (e) {
        return sendServerError(res, e);
    }
}

export async function deleteAccount(req, res) {
    try {
        const { userId } = req.body ?? {};
        if (!userId) return sendError(res, 401, 'unauthorized');
        const deleted = await authService.deleteUserById(userId);
        if (!deleted) return sendError(res, 404, 'user not found');
        return sendSuccess(res, 200, { ok: true });
    } catch (e) {
        return sendServerError(res, e);
    }
}

