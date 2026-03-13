# AGENTS.md — Backend Development Standards

> This file governs how AI agents (Claude, Copilot, Cursor, etc.) should behave when working on this backend codebase. All generated code must follow the rules below **without exception**.

---

## Table of Contents

1. [Core Philosophy](#core-philosophy)
2. [SOLID Principles](#solid-principles)
3. [Clean Code Standards](#clean-code-standards)
4. [Security Requirements](#security-requirements)
5. [Database & Query Optimization](#database--query-optimization)
6. [API Design & Postman Sync](#api-design--postman-sync)
7. [Error Handling](#error-handling)
8. [Testing Standards](#testing-standards)
9. [File & Folder Conventions](#file--folder-conventions)
10. [Commit & PR Conventions](#commit--pr-conventions)

---

## Core Philosophy

- **Write code for the next developer**, not just for the compiler.
- **Security is not optional.** Every input is untrusted until validated.
- **Performance is a feature.** Every DB query must be intentional.
- **Consistency over cleverness.** Follow existing patterns in the codebase before introducing new ones.
- When in doubt, **do less and ask** rather than assume and over-build.

---

## SOLID Principles

Agents must apply all five SOLID principles in every file they touch.

### S — Single Responsibility Principle
Each class, module, or function must have **one reason to change**.

```typescript
// BAD — one class doing too much
class UserService {
  createUser() { /* ... */ }
  sendWelcomeEmail() { /* ... */ }   // belongs in EmailService
  hashPassword() { /* ... */ }      // belongs in AuthService
  saveToDatabase() { /* ... */ }    // belongs in UserRepository
}

// GOOD — focused responsibility
class UserService {
  constructor(
    private userRepo: UserRepository,
    private emailService: EmailService,
    private authService: AuthService,
  ) {}

  async createUser(dto: CreateUserDto): Promise<User> {
    const hashed = await this.authService.hashPassword(dto.password);
    const user = await this.userRepo.save({ ...dto, password: hashed });
    await this.emailService.sendWelcome(user.email);
    return user;
  }
}
```

### O — Open/Closed Principle
Classes must be **open for extension, closed for modification**. Prefer adding new implementations over editing existing ones.

```typescript
// GOOD — add new payment method without touching existing logic
interface PaymentProvider {
  charge(amount: number, currency: string): Promise<PaymentResult>;
}

class StripeProvider implements PaymentProvider { /* ... */ }
class PayPalProvider implements PaymentProvider { /* ... */ }

class PaymentService {
  constructor(private provider: PaymentProvider) {}
  charge(amount: number, currency: string) {
    return this.provider.charge(amount, currency);
  }
}
```

### L — Liskov Substitution Principle
Subtypes must be **fully substitutable** for their base types. Never override methods in a way that breaks callers.

```typescript
// BAD — subtype changes expected behavior
class Rectangle { setWidth(w: number) { this.w = w; } }
class Square extends Rectangle {
  setWidth(w: number) { this.w = w; this.h = w; } // breaks caller assumptions
}

// GOOD — use a shared interface instead
interface Shape { area(): number; }
class Rectangle implements Shape { area() { return this.w * this.h; } }
class Square implements Shape { area() { return this.side ** 2; } }
```

### I — Interface Segregation Principle
Clients must **not be forced to depend on interfaces they don't use**. Prefer many small interfaces over one large one.

```typescript
// BAD
interface UserRepository {
  findById(id: string): Promise<User>;
  findAll(): Promise<User[]>;
  save(user: User): Promise<User>;
  generateReport(): Promise<Report>;  // not a repository concern
}

// GOOD
interface UserReader { findById(id: string): Promise<User>; }
interface UserWriter { save(user: User): Promise<User>; }
interface UserRepository extends UserReader, UserWriter {}
```

### D — Dependency Inversion Principle
High-level modules must **depend on abstractions**, not concrete implementations. Always inject dependencies.

```typescript
// BAD — hard dependency on concrete class
class OrderService {
  private repo = new PostgresOrderRepository(); // tightly coupled
}

// GOOD — depends on abstraction, injected at composition root
class OrderService {
  constructor(private readonly repo: OrderRepository) {}
}
```

---

## Clean Code Standards

### Naming
- **Variables & functions**: `camelCase`, descriptive, verb-first for functions (`getUserById`, `validateToken`).
- **Classes & interfaces**: `PascalCase` (`UserService`, `IPaymentProvider`).
- **Constants**: `SCREAMING_SNAKE_CASE` (`MAX_RETRY_COUNT`).
- **Files**: `kebab-case` (`user-service.ts`, `order-repository.ts`).
- Avoid abbreviations (`usr`, `cnt`, `mgr`). Names must be self-documenting.

### Functions
- Maximum **20 lines** per function. If longer, extract helper functions.
- Maximum **3 parameters**. Use a DTO/options object for more.
- No side effects in functions named as queries (`get*`, `find*`, `is*`).
- Functions must do **one thing**. If you need "and" to describe it, split it.

### Comments
- **Never comment what the code does** — write code that explains itself.
- **Do comment why** something is done in a non-obvious way.
- No dead code in commits. Delete it; version control remembers it.

```typescript
// BAD
// increment i by 1
i++;

// GOOD
// Skipping the first element because it is always the root node
for (let i = 1; i < nodes.length; i++) { ... }
```

### Magic Numbers & Strings
Always use named constants.

```typescript
// BAD
if (user.role === 2) { ... }
setTimeout(refresh, 86400000);

// GOOD
const ROLE_ADMIN = 2;
const ONE_DAY_MS = 24 * 60 * 60 * 1000;
if (user.role === ROLE_ADMIN) { ... }
setTimeout(refresh, ONE_DAY_MS);
```

---

## Security Requirements

These rules are **non-negotiable**. Agents must never bypass them.

### Input Validation
- **Validate all inputs** at the controller/handler layer before they reach the service layer.
- Use a validation library (e.g., `zod`, `class-validator`, `joi`). Never validate manually with ad-hoc checks.
- Reject unknown fields — use strict/strip mode in schemas.

```typescript
// GOOD — zod schema at the boundary
const CreateUserSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(12).max(128),
  name: z.string().trim().min(1).max(100),
});
```

### SQL Injection Prevention
- **Always use parameterized queries or ORM methods.** Never interpolate user input into SQL strings.

```typescript
// CRITICAL VULNERABILITY — never do this
db.query(`SELECT * FROM users WHERE email = '${email}'`);

// SAFE — parameterized
db.query('SELECT * FROM users WHERE email = $1', [email]);
// or via ORM
userRepo.findOne({ where: { email } });
```

### Authentication & Authorization
- Never store plain-text passwords. Always use `bcrypt` (cost >= 12) or `argon2`.
- JWTs must be signed with a secret of at least 256 bits. Store secrets in environment variables, never in code.
- Every protected route must verify **both** authentication (who you are) and authorization (what you can do).
- Use short-lived access tokens (<= 15 min) + refresh token rotation.

### Sensitive Data
- Never log passwords, tokens, PII, or payment data.
- Mask/redact sensitive fields in error messages and logs.
- Secrets and credentials must **only** come from environment variables or a secrets manager. No hardcoded values.

```typescript
// BAD
const JWT_SECRET = "my-super-secret-key";

// GOOD
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) throw new Error("JWT_SECRET environment variable is required");
```

### HTTP Security
- Set security headers: `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options`, `Strict-Transport-Security`.
- Enforce HTTPS in all environments except local dev.
- Apply rate limiting to all public endpoints.
- Sanitize all outputs rendered as HTML to prevent XSS.

### Dependency Security
- Run `npm audit` / `pip audit` before every release.
- Pin dependency versions in lock files.
- Never install packages not in `package.json` / `requirements.txt`.

---

## Database & Query Optimization

### General Rules
- **Select only the columns you need.** Never use `SELECT *` in production code.
- Every query touching user-supplied values must be parameterized (see Security above).
- All tables must have a primary key. Foreign keys must be indexed.
- Use **transactions** for any operation that writes to more than one table.

```typescript
// BAD — fetches all columns, no transaction
const user = await db.query('SELECT * FROM users WHERE id = $1', [id]);
await db.query('UPDATE orders SET user_name = $1 WHERE user_id = $2', [user.name, id]);

// GOOD — select only needed columns, use transaction
await db.transaction(async (trx) => {
  const { name } = await trx.query<{ name: string }>(
    'SELECT name FROM users WHERE id = $1', [id]
  );
  await trx.query(
    'UPDATE orders SET user_name = $1 WHERE user_id = $2', [name, id]
  );
});
```

### Indexing Strategy
- Add indexes to columns used in `WHERE`, `JOIN ON`, `ORDER BY`, and `GROUP BY` clauses.
- Use **composite indexes** when queries filter on multiple columns together.
- Use **partial indexes** for queries with a constant filter (e.g., `WHERE deleted_at IS NULL`).
- Avoid over-indexing — every index slows down writes. Audit unused indexes regularly.

```sql
-- Partial index for soft-delete pattern
CREATE INDEX idx_users_active_email ON users (email) WHERE deleted_at IS NULL;

-- Composite index for common join + filter
CREATE INDEX idx_orders_user_status ON orders (user_id, status);
```

### Query Patterns
- **Avoid N+1 queries.** Use eager loading, joins, or `IN` clauses instead of looping queries.

```typescript
// BAD — N+1: fires one query per order
const orders = await orderRepo.findAll();
for (const order of orders) {
  order.user = await userRepo.findById(order.userId); // N queries
}

// GOOD — single JOIN
const orders = await orderRepo.findAllWithUser(); // uses LEFT JOIN internally
```

- **Paginate all list endpoints.** Never return unbounded result sets.

```typescript
// GOOD — cursor-based pagination
async function getOrders(cursor?: string, limit = 20): Promise<OrderPage> {
  const rows = await db.query(
    `SELECT id, user_id, total, created_at
     FROM orders
     WHERE ($1::uuid IS NULL OR id > $1::uuid)
     ORDER BY id ASC
     LIMIT $2`,
    [cursor ?? null, Math.min(limit, 100)]
  );
  return {
    data: rows,
    nextCursor: rows.length === limit ? rows[rows.length - 1].id : null,
  };
}
```

- Use **`EXPLAIN ANALYZE`** before merging any new or modified query. Paste the output in the PR description.
- Prefer **read replicas** for analytics/reporting queries.
- Use **connection pooling**. Never create raw connections inside request handlers.

### ORM Usage
- Use the ORM's query builder for complex conditions rather than raw string concatenation.
- Explicitly list selected fields in all repository methods.
- Use `lazy: false` / explicit `relations` in ORM configs — never rely on implicit lazy loading in loops.

---

## API Design & Postman Sync

### RESTful Conventions
- Use **nouns** for resource paths, **HTTP verbs** for actions.
- Nest resources a maximum of **two levels** deep.

```
GET    /users               list users
POST   /users               create user
GET    /users/:id           get user
PATCH  /users/:id           partial update user
DELETE /users/:id           delete user
GET    /users/:id/orders    list orders for user  (2-level max)
```

- Use correct HTTP status codes:
  - `200 OK` — successful GET, PATCH
  - `201 Created` — successful POST (include `Location` header)
  - `204 No Content` — successful DELETE
  - `400 Bad Request` — validation failure
  - `401 Unauthorized` — missing/invalid auth
  - `403 Forbidden` — authenticated but not authorized
  - `404 Not Found` — resource does not exist
  - `409 Conflict` — duplicate resource
  - `422 Unprocessable Entity` — business rule violation
  - `429 Too Many Requests` — rate limited
  - `500 Internal Server Error` — unexpected server fault

### Response Shape
All responses must follow a consistent envelope:

```json
// Success
{
  "data": { "id": "abc123", "email": "user@example.com" },
  "meta": { "requestId": "req_xyz" }
}

// List
{
  "data": [],
  "meta": { "total": 100, "nextCursor": "abc123" }
}

// Error
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is invalid.",
    "details": [{ "field": "email", "message": "Must be a valid email address." }]
  },
  "meta": { "requestId": "req_xyz" }
}
```

### Postman Collection — Automatic Sync Rule

**Every time an API endpoint's request shape or response shape changes, the Postman collection must be updated in the same commit/PR.**

Agents must follow this workflow for any API change:

1. **Locate the collection file** at `postman/collection.json` (or the path defined in `.agentsrc`).
2. **Update the affected request** — modify URL, method, headers, path/query params, or request body examples to match the new contract.
3. **Update the response example(s)** — update saved example response(s) to match the new response shape, including status code, headers, and body.
4. **Bump the collection version** in `info.version` using semantic versioning.
5. **Add a changelog entry** to `postman/CHANGELOG.md` in the format:

```markdown
## [COLLECTION VERSION] — YYYY-MM-DD
### Changed
- `PATCH /users/:id` — added `phoneNumber` field to request body
- `GET /users/:id` — added `phoneNumber` to response body
```

**Validation:** The CI pipeline runs `npm run postman:validate`, which checks that every route registered in the router has a matching entry in the Postman collection. PRs fail if this check does not pass.

```bash
# Run locally before pushing
npm run postman:validate
```

---

## Error Handling

- **Never swallow errors silently.** Always log or rethrow.
- Catch errors at the **outermost layer** (controller/middleware). Services and repositories should throw, not return error objects.
- Use typed custom error classes to distinguish error categories.

```typescript
// GOOD — typed error hierarchy
export class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number,
  ) { super(message); this.name = this.constructor.name; }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found.`, 'NOT_FOUND', 404);
  }
}

export class ValidationError extends AppError {
  constructor(
    message: string,
    public readonly details: ValidationDetail[],
  ) { super(message, 'VALIDATION_ERROR', 400); }
}
```

- **Never expose stack traces or internal error messages to API consumers** in production. Log them server-side; return a sanitized message to the client.
- Always include a `requestId` in error responses and logs for traceability.

---

## Testing Standards

- Every new service method must have a **unit test**.
- Every new API endpoint must have an **integration test** (real HTTP request against a test DB).
- Minimum coverage thresholds (enforced in CI): **80% lines**, **75% branches**.
- Test file naming: `user-service.spec.ts` co-located with the source file.
- Follow the **AAA pattern**: Arrange -> Act -> Assert. One assertion group per test.
- Mock external services (email, payment, SMS) in unit tests. Never call live third-party APIs in tests.
- Use a **dedicated test database** seeded with fixtures. Never run tests against production or staging data.

---

## File & Folder Conventions

```
src/
  modules/
    users/
      users.controller.ts    <- HTTP layer only, no business logic
      users.service.ts       <- business logic, orchestration
      users.repository.ts    <- DB access only
      users.dto.ts           <- request/response shapes + validation schemas
      users.entity.ts        <- DB entity / model
      users.spec.ts          <- unit tests
  common/
    errors/                  <- typed error classes
    middleware/              <- auth, rate-limit, logging
    guards/                  <- authorization guards
    interceptors/            <- response transformation, logging
  config/                    <- env var loading and validation
  database/
    migrations/              <- versioned migration files
    seeds/                   <- test/dev seed data
postman/
  collection.json            <- Postman collection (keep in sync!)
  CHANGELOG.md               <- collection version history
```

**Rules:**
- No business logic in controllers. Controllers only parse input, call services, and return responses.
- No DB calls in services. Services call repositories or other services only.
- No HTTP concepts (`req`, `res`, status codes) in services or repositories.

---

## Commit & PR Conventions

### Commit Messages (Conventional Commits)

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`, `security`

Examples:
```
feat(users): add phone number field to user profile
fix(auth): prevent timing attack in password comparison
perf(orders): add composite index on (user_id, status)
security(deps): upgrade jsonwebtoken to 9.0.2
docs(postman): sync collection after adding phone number field
```

### PR Checklist (Agents must satisfy all before marking PR ready)

- [ ] All new functions have unit tests
- [ ] Integration tests cover the happy path and at least one error path
- [ ] No `SELECT *` in any query
- [ ] `EXPLAIN ANALYZE` output included for any new/modified SQL query
- [ ] No secrets or credentials in code
- [ ] All inputs validated with schema
- [ ] Postman collection updated if any endpoint changed
- [ ] `postman/CHANGELOG.md` updated with version bump
- [ ] `npm run postman:validate` passes
- [ ] `npm audit` shows no high/critical vulnerabilities
- [ ] No TODO comments left in changed files

---

*Last updated: see git log. This file is the source of truth — when in conflict with other documentation, AGENTS.md wins.*