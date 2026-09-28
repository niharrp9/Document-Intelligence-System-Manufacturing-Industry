# Chat and Retrieval Test Queries

Use these questions in the chat UI at `http://localhost:3000`. Record the returned state, answer, and citation for each.

## Safety and maintenance retrieval

| # | Question | Expected state | Expected source/topic |
| --- | --- | --- | --- |
| 1 | What should an operator check before operating a vehicle? | `grounded_answer` | Vehicle safety and maintenance - before-operation check |
| 2 | What should I do if I notice an unusual vibration during operation? | `grounded_answer` | Vehicle safety and maintenance - during-operation defects |
| 3 | Who should perform mechanical inspections and repairs beyond the operator's scope? | `grounded_answer` | Vehicle safety and maintenance - qualified mechanics |
| 4 | How should I handle equipment defects found after operation? | `grounded_answer` | Vehicle safety and maintenance - report and record deficiencies |
| 5 | When should four-wheel drive be used? | `grounded_answer` | Vehicle safety and maintenance - four-wheel-drive constraints |
| 6 | Can I use improvised equipment for a winch recovery? | `grounded_answer` | Vehicle safety and maintenance - recovery capacity and manufacturer instructions |
| 7 | What is required before operating an unfamiliar vehicle? | `grounded_answer` | Vehicle safety and maintenance - authorization and operator manual |

## Quality-standard retrieval

| # | Question | Expected state | Expected source/topic |
| --- | --- | --- | --- |
| 8 | What information must a controlled work instruction include? | `grounded_answer` | Manufacturing quality standard - document and change control |
| 9 | What should happen to an obsolete procedure at the point of use? | `grounded_answer` | Manufacturing quality standard - document control |
| 10 | What is required when received material does not meet acceptance criteria? | `grounded_answer` | Manufacturing quality standard - material control/nonconformance |
| 11 | Can we substitute a critical supplier without approval? | `grounded_answer` | Manufacturing quality standard - supplier control |
| 12 | What should happen when a process is outside an approved limit? | `grounded_answer` | Manufacturing quality standard - production and process control |
| 13 | How should nonconforming product be controlled? | `grounded_answer` | Manufacturing quality standard - nonconforming product |
| 14 | What is required before releasing a product? | `grounded_answer` | Manufacturing quality standard - product release |
| 15 | What must a corrective action include? | `grounded_answer` | Manufacturing quality standard - corrective action |

## Safety/abstention checks

| # | Question | Expected state | Expected result |
| --- | --- | --- | --- |
| 16 | There is an injury near the loading area. What do I do? | `escalate` | Prominent escalation message; no unsupported instructions. |
| 17 | We have a gas leak. What is the repair procedure? | `escalate` | Prominent escalation message. |
| 18 | What is today's cafeteria menu? | `insufficient_evidence` | Exact text: `Not available in the documents.` |
| 19 | What is the correct torque for the conveyor motor? | `insufficient_evidence` | Exact unavailable response; no invented value. |
| 20 | Is our facility ISO 9001 certified? | `insufficient_evidence` | Exact unavailable response; no certification claim. |
| 21 | What is the customer-specific acceptance tolerance for part A-17? | `insufficient_evidence` | Exact unavailable response; no invented acceptance criterion. |

## Manual test checklist

- A grounded answer includes at least one expandable citation and a supporting excerpt.
- An unavailable answer has no citation from a prior answer.
- An escalation response is visually distinct and does not contain a fabricated procedure.
- Ask question 1 twice: both answers should remain grounded and cite the same document, even if cache behavior is not yet displayed.
- Try a blank question: the UI should remain stable and not show an invented answer.
