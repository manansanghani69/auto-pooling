import { pool } from '../common/db.js';

(async () => {
  try {
    const res = await pool.query('SELECT NOW()');
    console.log('✅ Database connected successfully at:', res.rows[0].now);
  } catch (err) {
    console.error('❌ Database connection failed:', err);
  } finally {
    await pool.end();
  }
})();
