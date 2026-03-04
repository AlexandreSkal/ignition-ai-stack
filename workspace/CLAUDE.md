# Project: Ignition AI Stack

Ignition 8.3 platform with Claude Code as development assistant.

## Environment
- Gateway: Ignition 8.3.3 on Docker (http://ignition:8088 internal, http://localhost:8088 external)
- Database: PostgreSQL 16 (host: postgres, user: ignition, db: ignition)
- Ignition project JSONs: mounted read-only at /ignition-data
- Workspace: /workspace

## Architecture
- Frontend: Perspective views (mobile-first)
- Scripts: Jython 2.7 (gateway and session scope)
- Historian: Core Historian (QuestDB) + PostgreSQL
- REST API: native to 8.3, port 8088

## Conventions
- Views: area/subarea/view-name
- Named queries: queries/module/name
- UDT tags: [default]UDTs/UdtName
- Gateway scripts: project-scripts/module/
- Commits: feat|fix|docs|refactor(scope): message

## Rules
- Prefer named queries over runQuery/runPrepUpdate
- Prefer bindings over scripting in views
- Never use system.util.execute() without validation
- Test queries on PostgreSQL before creating named queries
- Ignition project JSONs at /ignition-data are read-only — do not edit directly

## References
@.claude/rules/coding-standards.md
@.claude/rules/git-conventions.md
