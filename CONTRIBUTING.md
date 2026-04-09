# Contributing

Thanks for contributing to Mini-fy.

The point of this repo is not to become the biggest OpenClaw workspace template on GitHub. The point is to stay **small, sharp, and source-backed**.

## Before You Open A PR

Please check that your change fits at least one of these:

- improves agent quality
- reduces cost or latency without losing capability
- improves safety or public-repo hygiene
- makes the workspace easier for OpenClaw to ingest
- adds a clearly better primary-source reference

## Repo Rules

### 1. Keep The Hot Path Lean

Files loaded every session should stay compact:

- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- `IDENTITY.md`
- `TOOLS.md`
- `HEARTBEAT.md`
- `MEMORY.md`

If a change is long or task-specific, it probably belongs in:

- `skills/`
- `docs/`
- `data/`

### 2. Prefer Primary Sources

If you add or change guidance based on external information:

1. use official docs, specs, release notes, or vendor repos
2. update `docs/SOURCES.md`
3. update `data/source-index.json`
4. note the new check date if the repo guidance changed

### 3. Do Not Add Scraped Dumps

Do not paste large chunks of external docs into the repo.

Mini-fy prefers:

- summaries
- structured notes
- links
- small examples

### 4. Keep Public And Private State Separate

Do not commit:

- secrets
- auth files
- private transcripts
- private memory logs
- machine-specific credentials

### 5. Verify Behavioral Changes

If you change prompts, skills, or config guidance, include:

- the problem being solved
- why this is better
- how you validated it

## Good PR Shape

A strong Mini-fy PR usually does four things:

1. states the problem clearly
2. changes the smallest useful artifact
3. updates docs and sources together
4. keeps the root prompt path tight

## Style

- Prefer plain Markdown.
- Prefer direct language over marketing language.
- Prefer reusable guidance over one-off tricks.
- Prefer sharp scope over broad sprawl.
