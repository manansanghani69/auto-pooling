import { pool } from '../common/db.js';
import { USER_SAFE_COLUMNS } from '../common/userColumns.js';

export async function findUserById(userId) {
    const res = await pool.query(`SELECT ${USER_SAFE_COLUMNS} FROM users WHERE id=$1`, [userId]);
    return res.rows[0];
}

export async function updateUserProfile(userId, updates) {
    const fields = [];
    const values = [];
    let idx = 1;

    if (updates.name !== undefined) {
        fields.push(`name=$${idx++}`);
        values.push(updates.name);
    }
    if (updates.email !== undefined) {
        fields.push(`email=$${idx++}`);
        values.push(updates.email);
    }
    if (updates.profilePhoto !== undefined) {
        fields.push(`profile_photo=$${idx++}`);
        values.push(updates.profilePhoto);
    }
    if (updates.gender !== undefined) {
        fields.push(`gender=$${idx++}`);
        values.push(updates.gender);
    }

    if (!fields.length) return null;

    values.push(userId);
    const sql = `UPDATE users SET ${fields.join(', ')} WHERE id=$${idx} RETURNING ${USER_SAFE_COLUMNS}`;
    const res = await pool.query(sql, values);
    return res.rows[0];
}
