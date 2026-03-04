# Claude Code Skills

Custom agents and slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## What's Included

### Agents (6)

| Agent | Description |
|-------|-------------|
| `codebase-analyzer` | Analyzes implementation details — traces data flow and explains technical workings |
| `codebase-locator` | Locates files, directories, and components relevant to a feature or task |
| `codebase-pattern-finder` | Finds similar implementations, usage examples, and existing patterns with code details |
| `thoughts-analyzer` | Deep-dives on research topics by extracting insights from thought documents |
| `thoughts-locator` | Discovers relevant documents in `thoughts/` directory for metadata and history |
| `web-search-researcher` | Researches web-discoverable information using search and fetch |

### Commands (9)

| Command | Description |
|---------|-------------|
| `/commit` | Creates git commits with user approval and no Claude attribution |
| `/create_handoff` | Creates handoff documents for transferring work to another session |
| `/create_plan` | Creates detailed implementation plans through iterative research |
| `/describe_pr` | Generates comprehensive PR descriptions following repo templates |
| `/implement_plan` | Implements approved technical plans with verification |
| `/iterate_plan` | Updates existing plans based on feedback and codebase reality |
| `/research_codebase` | Researches codebase comprehensively using parallel sub-agents |
| `/resume_handoff` | Resumes work from handoff documents with context analysis |
| `/validate_plan` | Validates implementation against plan and verifies success criteria |

### Reference Config

| File | Description |
|------|-------------|
| `config/settings.json` | Claude Code settings (permissions, plugins, env vars, status line) |
| `config/CLAUDE.md` | RPI workflow instructions and global conventions |

These are **not** auto-installed. See [Manual Config](#manual-config) below.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- `git` (for cloning this repo)
- `bash` (macOS or Linux)

## Installation

```bash
git clone <repo-url> ~/code/skills
cd ~/code/skills
./install.sh
```

This symlinks all agents and commands into `~/.claude/agents/` and `~/.claude/commands/`. Existing files are backed up to `~/.claude/backups/<timestamp>/` before being replaced.

Running `./install.sh` again is safe — it skips files already linked.

## Uninstallation

```bash
./uninstall.sh
```

Removes only symlinks pointing to this repo. Restores backed-up originals if available. Leaves non-repo files untouched.

## Manual Config

The files in `config/` are reference copies — review and adopt what you need:

```bash
# Review and merge into your existing settings
diff ~/.claude/settings.json config/settings.json

# Review and merge into your existing CLAUDE.md
diff ~/.claude/CLAUDE.md config/CLAUDE.md
```

## External Dependencies

Some commands reference tools that may not be available on every machine. They degrade gracefully when missing.

| Dependency | Used By | Notes |
|------------|---------|-------|
| `gh` CLI | `/describe_pr` | Required for PR creation |
| `thoughts/shared/` directory | Most commands | Local project directory for plans, handoffs, research |

## Cross-References

Commands that use agents internally:

| Command | Agents Used |
|---------|-------------|
| `/research_codebase` | `codebase-analyzer`, `codebase-locator`, `codebase-pattern-finder`, `thoughts-analyzer`, `thoughts-locator`, `web-search-researcher` |
| `/create_plan` | `codebase-analyzer`, `codebase-locator` |

## Adding New Skills

### New Agent

1. Create `agents/your-agent.md` with YAML frontmatter:
   ```yaml
   ---
   name: your-agent
   description: One-line description
   tools: [Read, Grep, Glob, LS]
   ---
   ```
2. Add the agent prompt below the frontmatter
3. Run `./install.sh` to symlink it

### New Command

1. Create `commands/your_command.md` with the command prompt
2. Run `./install.sh` to symlink it
3. Use it in Claude Code with `/your_command`

## Repository Structure

```
skills/
├── README.md
├── agents/           # 6 agent definitions
├── commands/         # 9 slash commands
├── config/           # Reference configs (not auto-installed)
│   ├── settings.json
│   └── CLAUDE.md
├── install.sh        # Symlink installer
└── uninstall.sh      # Symlink remover
```
