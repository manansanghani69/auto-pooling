// src/profile/controller.js
import * as profileService from './service.js';

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

export async function updateProfile(req, res) {
    try {
        const body = req.body ?? {};
        const userId = req.user?.sub;
        if (!userId) return sendError(res, 401, 'unauthorized');

        const name = toOptionalTrimmedString(body.name);
        const email = toOptionalTrimmedString(body.email);
        const profilePhoto = toOptionalTrimmedString(body.profilePhoto ?? body.profile_photo);
        const gender = toOptionalTrimmedString(body.gender);

        const updates = {};
        if (name !== undefined) updates.name = name;
        if (email !== undefined) updates.email = email;
        if (profilePhoto !== undefined) updates.profilePhoto = profilePhoto;
        if (gender !== undefined) updates.gender = gender;

        if (!Object.keys(updates).length) {
            return sendError(res, 400, 'no profile fields provided');
        }

        const user = await profileService.updateUserProfile(userId, updates);
        if (!user) return sendError(res, 404, 'user not found');
        return sendSuccess(res, 200, { user: sanitizeUser(user) });
    } catch (e) {
        return sendServerError(res, e);
    }
}

export async function profile(req, res) {
    try {
        const userId = req.user?.sub;
        if (!userId) return sendError(res, 401, 'unauthorized');

        const user = await profileService.findUserById(userId);
        if (!user) return sendError(res, 404, 'user not found');
        return sendSuccess(res, 200, { user: sanitizeUser(user) });
    } catch (e) {
        return sendServerError(res, e);
    }
}
