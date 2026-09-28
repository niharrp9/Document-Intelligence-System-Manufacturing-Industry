# Engineering Guidelines

This is a timed AI prototyping project.

## Priorities

1. Build the smallest working end-to-end vertical slice first.
2. Prefer simple, readable architecture over unnecessary abstractions.
3. Keep deterministic logic deterministic.
4. Use agents/LLMs only where reasoning or dynamic decisions add value.
5. Use Pydantic or equivalent typed schemas at system boundaries.
6. Keep external systems and model providers behind interfaces.
7. Never hardcode credentials or secrets.
8. Add tests for critical business rules and failure modes.
9. Fail safely on uncertain or consequential actions.
10. Keep code easy to explain to another engineer.

## Workflow

Before large changes:
- inspect existing contracts
- state assumptions
- preserve stable interfaces

After changes:
- run relevant tests
- report failures
- inspect generated code before proceeding

Do not over-engineer a prototype.