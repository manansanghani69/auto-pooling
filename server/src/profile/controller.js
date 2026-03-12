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

function toOptionalPositiveInteger(value) {
    if (value === undefined || value === null || value === '') return undefined;
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) return null;
    return parsed;
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
        const role = req.user?.role;
        if (!userId) return sendError(res, 401, 'unauthorized');

        const name = toOptionalTrimmedString(body.name);
        const email = toOptionalTrimmedString(body.email);
        const photoLink = toOptionalTrimmedString(body.photoLink ?? body.photo_link);
        const gender = toOptionalTrimmedString(body.gender);
        const residentailAddress = toOptionalTrimmedString(body.residentail_address ?? body.residential_address);
        const vehicalType = toOptionalTrimmedString(body.vehical_type ?? body.vehicle_type);
        const vehicalRegistrationNo = toOptionalTrimmedString(
            body.vehical_registration_no ?? body.vehicle_registration_no
        );
        const passengerCapacity = toOptionalPositiveInteger(body.passenger_capacity);
        const vehicalPhoto = toOptionalTrimmedString(body.vehical_photo ?? body.vehicle_photo);
        const drivingLicensePhoto = toOptionalTrimmedString(body.driving_license_photo);
        const vehicalRcPhoto = toOptionalTrimmedString(body.vehical_rc_photo ?? body.vehicle_rc_photo);
        const onboardingStatus = toOptionalTrimmedString(body.onboarding_status);

        const updates = {};
        if (name !== undefined) updates.name = name;
        if (email !== undefined) updates.email = email;
        if (photoLink !== undefined) updates.photoLink = photoLink;
        if (gender !== undefined) updates.gender = gender;
        if (residentailAddress !== undefined) updates.residentailAddress = residentailAddress;
        if (vehicalType !== undefined) updates.vehicalType = vehicalType;
        if (vehicalRegistrationNo !== undefined) updates.vehicalRegistrationNo = vehicalRegistrationNo;
        if (passengerCapacity === null) {
            return sendError(res, 400, 'passenger_capacity must be a positive integer');
        }
        if (passengerCapacity !== undefined) updates.passengerCapacity = passengerCapacity;
        if (vehicalPhoto !== undefined) updates.vehicalPhoto = vehicalPhoto;
        if (drivingLicensePhoto !== undefined) updates.drivingLicensePhoto = drivingLicensePhoto;
        if (vehicalRcPhoto !== undefined) updates.vehicalRcPhoto = vehicalRcPhoto;
        if (onboardingStatus !== undefined) updates.onboardingStatus = onboardingStatus;

        if (!Object.keys(updates).length) {
            return sendError(res, 400, 'no profile fields provided');
        }

        const user = await profileService.updateUserProfile(userId, role, updates);
        if (!user) return sendError(res, 404, 'user not found');
        return sendSuccess(res, 200, { user: sanitizeUser(user) });
    } catch (e) {
        return sendServerError(res, e);
    }
}

export async function profile(req, res) {
    try {
        const userId = req.user?.sub;
        const role = req.user?.role;
        if (!userId) return sendError(res, 401, 'unauthorized');

        const user = await profileService.findUserById(userId, role);
        if (!user) return sendError(res, 404, 'user not found');
        return sendSuccess(res, 200, { user: sanitizeUser(user) });
    } catch (e) {
        return sendServerError(res, e);
    }
}
