// src/auth/controller.js
import * as authService from './service.js';

export async function signup(req, res) {
    try {
        const { phone, name, password, role } = req.body;
        if (!phone || !password || !name)
            return res.status(400).json({ error: 'phone, name & password required' });
        const exists = await authService.findUserByPhone(phone);
        if (exists)
            return res.status(409).json({ error: 'phone already registered' });
        const user = await authService.createUser({ phone, name, password, role });
        const tokens = await authService.issueTokens(user);
        res.status(201).json({ user, tokens });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: 'server error' });
    }
}

export async function login(req, res) {
    try {
        const { phone, password } = req.body;
        if (!phone || !password)
            return res.status(400).json({ error: 'phone & password required' });
        const user = await authService.findUserByPhone(phone);
        if (!user)
            return res.status(404).json({ error: 'user not found' });
        const ok = await authService.verifyPassword(password, user.password);
        if (!ok) return res.status(401).json({ error: 'invalid credentials' });
        const tokens = await authService.issueTokens(user);
        // don't send password back
        delete user.password;
        res.json({ user, tokens });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: 'server error' });
    }
}

export async function refresh(req, res) {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) return res.status(400).json({ error: 'refreshToken required' });
        const tokens = await authService.refreshAccessToken(refreshToken);
        res.json(tokens);
    } catch (e) {
        console.error(e);
        res.status(401).json({ error: 'invalid refresh token' });
    }
}

export async function logout(req, res) {
    try {
        const { refreshToken } = req.body;
        if (refreshToken) await authService.revokeRefreshToken(refreshToken);
        res.json({ ok: true });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: 'server error' });
    }
}

export async function deleteAccount(req, res) {
    try {
        const { userId } = req.body;
        if (!userId) return res.status(401).json({ error: 'unauthorized' });
        const deleted = await authService.deleteUserById(userId);
        if (!deleted) return res.status(404).json({ error: 'user not found' });
        res.json({ ok: true });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: 'server error' });
    }
}
