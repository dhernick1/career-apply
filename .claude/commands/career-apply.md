# Career Apply — Claude Code Pipeline

Run the full career application pipeline against a job description.
Reads reference artifacts from disk. Writes all updates back to disk after the run.
Cost: $0 incremental — uses your Claude Code subscription, not the Anthropic API credit balance.

---

## STARTUP — Read reference artifacts from disk

Read all five files now. Do not proceed until all five are loaded:

1. `references/career/base-resume.yaml`
2. `references/career/linkedin-profile.yaml`
3. `references/career/achievement-inventory.yaml`
4. `references/career/voice-profile.yaml`
5. `references/career/candidate-profile.yaml`

For each file that still contains `PLACEHOLDER` or `[PASTE`:
- Report it by name
- Ask you to paste the content directly into the chat
- Do not proceed to the next missing file until the current one is provided
- Do not accept a JD until all five are populated

If all five are populated, confirm:
"All reference artifacts loaded. Paste the job description and company name to begin."

---

## OPERATING PRINCIPLES

1. **Extractive first, controlled rephrase second.** Select from the Achievement Inventory.
   Insert exact JD terminology only where the factual claim is fully supported.
   You are a router and selector, not an author.

2. **Immutable — never modify:** employment dates, company names, official job titles,
   education institutions and degrees, certifications and issuing bodies.

3. **Evidence-based matching.** Score by verifiable evidence, not language similarity.
   Partial matches are partial — not strong.

4. **One shot, zero margin for error.** Every application is permanent.

5. **Claim risk classification on every resume edit:**
   - LOW: terminology change only, facts unchanged
   - MEDIUM: scope or context emphasized differently — you should review
   - HIGH: edit touches factual claims — you must verify before submission
   - BLOCKED: change not supportable — cannot be truthfully made

6. **Staged execution.** Stop at every [PAUSE] marker. Do not run ahead.
   Running ahead wastes tokens and produces lower-quality output.

---

## VOICE MATCHING RULES

For cover letter writing, mirror the syntactic structure of the samples in voice-profile.yaml.
Do not describe the voice — demonstrate it. Match:
- Sentence length patterns (short punchy openers, medium elaborations)
- Opener style (declarative, never throat-clearing)
- No em dashes — forbidden in cover letters and resume edits
- No filler phrases ("results-driven", "passionate about", "leverage" as a verb)
- Active voice, first person, direct

---

## PIPELINE

### STAGE 1 — JD ANALYSIS

**STEP 1 — JD ANALYSIS**
Decompose the job description:
- Exact job title and seniority level
- Required skills (must-have) vs. preferred (nice-to-have)
- Top 20 ATS keywords — exact phrasing from JD, no paraphrase
- Role signal decoding: implicit expectations behind standard phrases
- Red flags or concerns
- JD confidence score (0.0–1.0): how specific and complete is this JD?

**[PAUSE 1A — JD REVIEW]**
Present:
- JD confidence score with explanation
- Top 20 ATS keywords (exact phrasing)
- Top 3 role signals or red flags
- Seniority level and reporting structure (if present)

Ask: "JD confidence score is [X]. Here's what I found. Ready to research the company?"
Wait for confirmation before running company research.

---

### STAGE 2 — COMPANY RESEARCH

**STEP 2 — COMPANY RESEARCH**
Use the WebSearch tool to research the company:
- Recent news (last 6 months)
- Tech stack signals
- Culture signals
- Glassdoor / Indeed ratings: overall score, category breakdown, top culture themes, pros/cons
  — if ratings unavailable, note it, do not fabricate
- 2–3 specific cover letter hooks with sources cited
- If web search fails after 3 attempts: proceed with JD-only context, label output clearly

**[PAUSE 1B — COMPANY RESEARCH REVIEW]**
Present:
- Company research summary (or degradation notice)
- Employee sentiment with breakdown
- 2–3 specific cover letter hooks
- Any culture signals or red flags

Ask: "Here's what I found on [Company]. Does anything change your interest?
Ready to run the Go/No-Go strategy?"
Wait for confirmation before continuing.

---

### STAGE 3 — GO/NO-GO

**STEP 3 — APPLICATION STRATEGY**
Go/No-Go with rationale:
- If No-Go: specific reasons (gap too large, culture misalignment, seniority mismatch)
- If Go: confidence level (strong/viable/stretch) + narrative angle, priority tier 1/2/3

Edge-case handling:
1. `jd_confidence_score < 0.5` (vague JD) → default GO, cap at Tier 3, state uncertainty caveat
2. `ghost_posting_risk == true` → default NO-GO, state harvesting risk, keep override available
3. Stretch fit + immutable dealbreakers + well-written JD → NO-GO, list dealbreakers explicitly,
   include career_pivot_assessment (12–18 month development plan)

Immutable dealbreaker: clearance, mandated certifications, licensure, hard years-of-experience
floor not close to met, core technology with zero production exposure. Soft gaps do NOT qualify.

**[PAUSE 2 — GO/NO-GO GATE]**
Present decision with honest rationale.
Ask: "Decision: [GO/NO-GO]. [Rationale]. Proceed with full alignment evaluation?"
If NO-GO confirmed: jump to STEP 9. Do not run Steps 4–8.
Wait for confirmation before continuing.

---

### STAGE 4 — ALIGNMENT + DISCOVERY

**STEP 4 — ALIGNMENT EVALUATION**

Read candidate-profile.yaml before generating Section D.

Section A — Match Score:
- Overall match % (weighted: skills 35%, domain 20%, responsibilities 20%, seniority 15%, education 10%)
- Per-requirement evidence mapping: Strong / Partial / No evidence
- Fit classification: 85–100 Strong | 70–84 Viable | 55–69 Stretch | <55 Weak

Section B — ATS Validation:
- Simulate text extraction — does chronological order survive?
- Are all 20 target keywords present?
- Do section headings parse correctly?
- Result: PASS or FAIL with specific failure points

Section C — Keyword Map:
| Keyword | JD Importance | Resume Evidence | Location | Status |
- Missing keyword remediation: only truthfully addable keywords
- Keyword density check (stuffing risk)

Section D — Achievement Discovery (prior_employer_sweep):
- Read candidate_profile.high_yield_categories and employer_context first
- Sweep ALL employers against each JD gap before declaring a miss
- Check candidate_profile.domain_adjacency_map before any domain score < 70%
- Generate employer-anchored discovery prompts:
  GOOD: "At John Deere, did you write release notes or user guides?"
  BAD:  "Do you have documentation experience?"

**[PAUSE 3 — ACCURACY CHECK + DISCOVERY LOOP]**
Present match score, ATS result, keyword map, discovery prompts.
Ask: "Before tailoring runs, review for accuracy. Answer each discovery prompt or type 'none'.
Type 'ready' when done."
HARD STOP. Do not generate resume changes until user confirms and responds to prompts.

---

### STAGE 5 — TAILORING + PACKAGE

*Run only after user responds to discovery prompts.*
Update match score if discovery added new evidence.

**STEP 5 — RESUME TAILORING**

Pass 1 — Extractive: select most relevant pre-verified achievements
Pass 2 — Controlled rephrase: insert exact JD terminology where factually supported

Change log for every edit:
| Section | Original | Recommended | Rationale | JD Evidence | Claim Risk |

Immutable — DO NOT TOUCH: dates, company names, job titles, education, certifications.
Calculate and report: Resume Delta (% of bullets changed from base)

**STEP 6 — COMPETITIVE POSITIONING**
- Typical applicant profile for this role (JD-based)
- Where your background is atypical in a valuable way
- 2–3 specific differentiation hooks with evidence
- Risk areas with honest mitigation (no spin)

**[PAUSE 4 — RESUME REVIEW]**
Present full change log, resume delta, any HIGH or BLOCKED flags.
Ask: "Review the change log. Any changes to reject or modify? Type 'approved' or list adjustments."
Wait for approval before writing the cover letter.

**STEP 7 — COVER LETTER**
Under 250 words. No em dashes (—) anywhere in the output — use periods or rewrite the sentence.
- Opens with company-specific hook (not "I am writing to apply...")
- 2–3 proof points (achievements, not resume repetition)
- States why you are specifically better positioned (not just qualified)
- Closes with confidence and forward momentum
- Matches syntactic structure of voice_profile.yaml samples
- Self-assesses: "This letter matches X% of your voice patterns"

**STEP 8 — APPLICATION PACKAGE**
- ATS re-validation on final tailored resume → if FAIL, list fixes before marking ready
- LinkedIn consistency check: compare tailored resume to LinkedIn Experience, flag deviations,
  list 2–3 interview questions a recruiter might ask about deviations
- Submission checklist: file naming, contact info, links
- Interview prep: 3–5 talking points, 3 questions to ask the interviewer

---

### STAGE 6 — LOG + FILE UPDATES (ALWAYS RUNS)

**STEP 9 — LOG AND WRITE BACK**

Produce the application log:
- Company, role, date, channel, req ID
- Match score (initial and final)
- ATS result
- Go/No-Go decision and rationale
- Resume delta
- New achievements discovered (ID + one-line description)
- Follow-up schedule: +7 days (check), +14 days (follow-up), +28 days (close)

Then write all updates to disk:

**1. New achievements → `references/career/achievement-inventory.yaml`**
Append each confirmed discovery as a new entry following the existing schema.
Increment `meta.total_entries`. Update `meta.last_updated`.

**2. New voice samples → `references/career/voice-profile.yaml`**
If any cover letter sentence or phrasing stood out as distinctly your voice,
append it to `samples:` with a new id, channel: cover-letter, and voice_notes.
Update `meta.current_sample_count` and `meta.last_updated`.
Only add if it genuinely demonstrates something not already in the existing samples.

**3. Run log → `references/career/candidate-profile.yaml`**
Append to `run_history:`. If new high-yield categories surfaced, append to
`high_yield_categories:`. If new domain adjacency confirmed, append to
`domain_adjacency_map:`. Update `meta.last_updated`.

**4. Application log → `docs/CareerApp/test-runs/YYYY-MM-DD-{company-slug}.md`**
Write the full Step 9 output as a markdown file. Date format: today's date.

After all writes are complete, ask:
"Updates written to disk. Commit now, or continue to next application first?"
