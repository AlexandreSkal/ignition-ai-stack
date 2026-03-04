# Git Conventions

## Branches
- main: production (protected)
- staging: QA / pre-production
- feature/*: development
- fix/*: bug fixes
- docs/*: documentation

## Commits (Conventional Commits)
- feat(perspective): add dashboard view
- fix(scripting): handle null on tag read
- docs(readme): update setup instructions
- refactor(queries): optimize historian lookup

## Pull Requests
- Title follows commit format
- Description includes: what changed, why, how to test
- At least 1 approval before merge
