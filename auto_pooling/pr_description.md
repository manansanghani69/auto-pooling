# Pull Request (PR) Description Guidelines

## When to Generate a PR Description

When instructed to **“generate the PR file for the branch”**, follow these steps in order:

1. **Identify the current branch**  
   Determine the branch for which the pull request is being created.

2. **Compare against `dev`**  
   Compare the current branch with the `dev` branch to detect:
   - Added files
   - Modified files
   - Deleted files
   - Relevant code diffs

3. **Analyze Changes**  
   Review and summarize all meaningful changes introduced in the current branch relative to `dev`.

4. **Generate the PR Description**  
   Automatically create a complete PR description including:
   - A clear, concise PR title
   - A detailed summary of changes
   - The purpose or motivation behind the changes
   - Relevant context (issues, tickets, features, etc.)
   - Key files modified
   - Testing notes and potential impact (if applicable)

5. **Output**  
   Provide the final PR description content ready for use.

---

## What Every PR Description Should Answer

### What?
Explain **what changes were made**.  
Keep it high-level and clear so reviewers can quickly understand the overall effect of the PR.

### Why?
Explain **why these changes are needed**.  
Describe the engineering problem and/or business objective this PR addresses.

### How?
Explain **how the solution was implemented**, highlighting:
- Important design decisions
- Non-obvious approaches
- Trade-offs or alternatives considered

### Testing?
Describe **how the changes were tested**.  
If no tests were added, clearly explain why.

### Screenshots (Optional)
For UI-related changes, screenshots are highly encouraged:
- Before vs After
- Current state vs Local development

### Anything Else? (Optional)
Mention technical debt, architectural considerations, limitations, or future improvements.

---

## PR File Location

`pr/[branch_name].md`

---

# Pull Request Template

## Pull Request Title
<!-- Write a concise, descriptive title (used as the PR title) -->
e.g. `[FIX | FEAT | REFACTOR] Authentication UI and Validations`

---

## Description
<!-- Provide a detailed summary of the changes -->

### What does this PR do?
<!-- High-level explanation of the changes -->

### Why are these changes needed?
<!-- Problem being solved or business/engineering goal -->

### How was this implemented?
<!-- Key implementation details and design decisions -->

### Related Issues / Tickets
<!-- Example: Fixes #123, Closes #456 -->

---

## Changes Overview
<!-- Select all that apply -->

- [ ] Feature addition
- [ ] Bug fix
- [ ] Refactoring / Code improvement
- [ ] Documentation update
- [ ] Tests added or updated
- [ ] Other (please specify):

---

## Key Files Modified

| File Path           | Description of Changes |
|---------------------|------------------------|
| `path/to/file1.ext` | Updated logic for ...  |
| `path/to/file2.ext` | Refactored ...         |
| `path/to/new.ext`   | New file added for ... |

---

## Testing Done
<!-- Describe testing approach -->

- [ ] Manual testing
- [ ] Unit tests added/updated
- [ ] Integration tests
- [ ] No tests needed (explain why)

### Steps to test:
1. 
2. 
3. 

---

## Screenshots (if applicable)
<!-- Add screenshots or GIFs here -->

---

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated (if required)
- [ ] Tests pass locally
- [ ] No new warnings or errors introduced
- [ ] Branch is up-to-date with `dev`

---

## Additional Notes
<!-- Any extra context reviewers should know -->

