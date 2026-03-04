# Workflow Orchestratio# Workflow Orchestration

## RPI Loop (Research → Plan → Implement)

Every non-trivial task follows the RPI loop. Do not skip phases. If something goes sideways at any phase, STOP and restart from the appropriate earlier phase.

### Phase 1: Research

All research MUST be conducted by launching agent teams. Never research in the main context window.

- **Launch agent teams** to investigate the problem space, codebase, dependencies, and constraints
- Offload exploration, analysis, and discovery to parallel agents — throw compute at it
- One focused research question per agent for clean results
- **Always collate findings** by running the `/research_codebase` skill at the end of the research phase
- Do not proceed to planning until research is collated and reviewed

#### Subagent Research Rules
- Use subagents liberally within each member of the agent team to keep main context window clean
- For complex problems, fan out multiple subagents in parallel
- Each subagent gets a single, well-scoped research question
- Subagents report back structured findings, not stream-of-consciousness

### Phase 2: Plan

All planning MUST be conducted by launching agent teams informed by the research output.

- **Launch agent teams** to draft architectural decisions, enumerate approaches, and identify trade-offs
- Agents should reference the collated research when forming plans
- **Always produce the final plan** by running the `/create_plan` skill
- Write detailed specs upfront to reduce ambiguity
- Check in with the user before moving to implementation

#### Subagent Planning Rules
- Assign subagents to each member of the agent team to evaluate different approaches or components in parallel
- Each subagent proposes a scoped solution with rationale and trade-offs
- The `/create_plan` skill synthesizes subagent outputs into a single actionable plan
- If the plan feels hacky, pause and ask "is there a more elegant way?" before proceeding

### Phase 3: Implement

Implementation always executes against the approved plan.

- **Always run the `/implement_plan` skill** to drive implementation
- Follow the plan sequentially — do not freelance or deviate without re-planning
- Never mark a task complete without proving it works
- Run tests, check logs, demonstrate correctness
- Ask yourself: "Would a staff engineer approve this?"
- Diff behavior between main and your changes when relevant

---

## Task Management (RPI-Aligned)

1. **Research**: Launch agent teams → collate with `/research_codebase` → write findings to `tasks/research.md`
2. **Plan**: Launch agent teams → synthesize with `/create_plan` → write plan to `tasks/todo.md` with checkable items
3. **Verify Plan**: Check in with user before starting implementation
4. **Implement**: Execute via `/implement_plan` → mark items complete as you go
5. **Verify Done**: Prove correctness — tests pass, logs clean, behavior correct
6. **Document Results**: Add review section to `tasks/todo.md`
7. **Capture Lessons**: Update `tasks/lessons.md` after any corrections

## Self-Improvement Loop
- After ANY correction from the user write rules for yourself that prevent the same mistake
- Update a `rules` sections of the project CLAUDE.md as concisely as possible
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

## Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests — then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how
- Still follows RPI: quick research → quick plan → fix

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.
- **Demand Elegance (Balanced)**: For non-trivial changes, challenge your own work. Skip for obvious fixes — don't over-engineer.ouch what’s necessary. Avoid introducing bugs.
