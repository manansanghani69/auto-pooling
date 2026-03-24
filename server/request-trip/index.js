import dotenv from 'dotenv';
import app from './app.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const PORT = Number(process.env.PORT || 4003);

app.listen(PORT, () => {
  console.log(`request-trip service running on ${PORT}`);
});
