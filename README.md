# career-apply

A Claude Code pipeline for tailoring resumes, drafting voice-matched cover letters,
and producing submission-ready job applications.

The pipeline scores resume-to-JD fit, surfaces hidden achievements through structured
discovery prompts, tailors resume bullets extractively (no invented experience), and
drafts cover letters that mirror your actual writing voice. Every application is
treated as a one-shot opportunity — quality, not volume.

---

## What you get

- A `/career-apply` slash command that runs the full pipeline against any job description
- A `career-agent` subagent with 10 specialized career skills
- Five reference templates you fill in once (resume, LinkedIn, achievements, voice samples, candidate profile)

The pipeline runs entirely inside Claude Code — no API keys, no servers, no cost
beyond your existing Claude Code subscription.

---

## Prerequisites

- [Claude Code](https://docs.claude.com/en/docs/claude-code) installed and signed in
- A folder you'll use as a workspace (this repo, or a clone of it)

---

## Setup (10–15 minutes)

### 1. Clone the repo

```bash
git clone <this-repo-url> career-apply
cd career-apply
```

### 2. Fill in your reference artifacts

Five files in `references/career/` need your real content before the pipeline runs.
Open each file and replace every `[PLACEHOLDER]` value:

| File | What goes in it |
|---|---|
| `base-resume.yaml` | Your current resume in structured form |
| `linkedin-profile.yaml` | Your LinkedIn About + Experience sections |
| `achievement-inventory.yaml` | Pre-verified accomplishments the agent can select from |
| `voice-profile.yaml` | 3+ writing samples (LinkedIn posts, emails, docs) |
| `candidate-profile.yaml` | Starts empty — fills in as you run applications |

**Quick start:** paste your resume into Claude Code and say:
> "Fill in `references/career/base-resume.yaml` from this resume."

Do the same for `linkedin-profile.yaml` (paste LinkedIn) and
`voice-profile.yaml` (paste 3+ writing samples).

For `achievement-inventory.yaml`: aim for 15+ entries before your first real run.
Anything you'd be willing to put on a resume bullet is a candidate entry.

### 3. Open the workspace in Claude Code

```bash
claude
```

Claude Code will auto-load `.claude/agents/career-agent.md` and
`.claude/commands/career-apply.md`.

---

## Running the pipeline

In Claude Code, type:

```
/career-apply
```

The agent will:

1. Verify all five reference files are populated (and ask you to paste content
   if anything still has `[PLACEHOLDER]` markers)
2. Ask for a job description and company name
3. Walk through 9 stages with checkpoints at each major step

### Pipeline stages

| Stage | What happens | Stops for review? |
|---|---|---|
| 1. JD analysis | Decompose JD, extract ATS keywords, score JD confidence | Yes |
| 2. Company research | Web search for news, culture signals, ratings, hooks | Yes |
| 3. Go / No-Go | Honest decision with rationale | Yes |
| 4. Alignment + discovery | Match score, ATS check, employer-anchored discovery prompts | Yes (hard stop) |
| 5. Resume tailoring | Extractive bullet selection with claim-risk flags | Yes |
| 6. Cover letter | Voice-matched draft, <250 words, no em-dashes | Yes (hard gate) |
| 7. Application package | Final ATS revalidation + LinkedIn consistency check + interview prep | — |
| 8. Log + writeback | Updates inventory, voice samples, candidate profile, run log | — |

### Output

Each run writes a markdown file to `docs/test-runs/YYYY-MM-DD-{company-slug}.md`
with the full application package: tailored resume bullets, cover letter, ATS
result, interview prep, and follow-up schedule.

---

## Operating principles

1. **Extractive first, controlled rephrase second.** The agent selects from your
   achievement inventory. It inserts exact JD terminology only where the factual
   claim is fully supported.
2. **Never modify** employment dates, company names, official job titles,
   education institutions, or certifications.
3. **Evidence-based matching.** Scores reflect verifiable evidence, not language
   similarity.
4. **One shot, zero margin for error.** Every application is permanent.
5. **Claim-risk classification on every edit:** LOW (terminology only),
   MEDIUM (scope reframed — review), HIGH (factual claim — verify),
   BLOCKED (cannot be truthfully made).

---

## Folder structure

```
career-apply/
├── .claude/
│   ├── agents/career-agent.md       # Subagent definition (10 skills)
│   └── commands/career-apply.md     # Slash command — pipeline orchestrator
├── skills/career/                   # 10 career skills (YAML)
├── references/career/               # Your reference artifacts (fill in once)
└── docs/test-runs/                  # Application output files
```

---

## License

MIT — see [LICENSE](LICENSE).
