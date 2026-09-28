# Floor Supervisor Document Intelligence Assistant — Build Guide

## Purpose

Build a small end-to-end prototype that helps a floor supervisor get reliable answers from approved operational documents. The system should understand or route a question, retrieve supporting passages, assemble grounded context, and generate an answer with citations.

The first vertical slice should prioritize safety procedures, equipment manuals, and quality-control standards. It is a document assistant, not an autonomous decision maker: it must never invent procedures or provide unsupported operational instructions.

## Prototype Outcome

A supervisor submits a question through a chat interface. The backend:

1. Checks for an equivalent, still-valid answer in a semantic cache.
2. Classifies or routes the query when that improves retrieval.
3. Retrieves relevant document chunks.
4. Reranks the candidates and selects the best three evidence chunks.
5. Builds a prompt from the query and approved evidence.
6. Generates a concise answer with source citations.
7. Returns `Not available in the documents.` when evidence is insufficient.

Success means a supervisor can verify every material answer against a specific source document, section/page, and quoted passage.

## Scope and Guardrails

### In scope

- Read-only answers from approved documents.
- Safety procedures, operating manuals, and quality-control standards.
- Document ingestion, retrieval, citations, semantic caching, and evaluation.
- A simple chat UI and a single query API.

### Out of scope for the first prototype

- Taking actions in production systems.
- Creating or changing safety procedures. DONOT CHANGE ANY DOCUMENT.
- Real-time machine control, workflow approvals, or incident reporting.
- Answers based on general model knowledge, the public web, or uncited assumptions.

### Safety and trust rules

- Answer only from retrieved, approved evidence.
- Preserve document version, effective date, source, and page/section metadata.
- Display the citations used to form the answer.
- If retrieval confidence is low, the sources conflict, or the question is outside the corpus, return the standard unavailable response and offer the closest relevant documents when safe.
- For emergency, injury, or imminent-danger language, show a prominent escalation instruction configured by the organization (for example, contact the site safety lead/emergency response process); do not rely on RAG alone.
- Do not store credentials, personal data, or sensitive incident details in prompts, logs, or the semantic cache unless explicitly approved and protected.

## Reference Architecture

```text
Supervisor chat
  -> POST /query
  -> input validation + authentication + safety/escalation check
  -> semantic cache lookup
       -> cache hit: return validated cached answer + citations
       -> cache miss:
            -> optional Intent Agent / deterministic router
            -> query embedding
            -> hybrid retrieval over approved chunks
            -> reranker (top 3 evidence chunks)
            -> context assembly + prompt generation
            -> grounded LLM generation
            -> citation/grounding validation
            -> response, telemetry, and eligible cache write
```

Keep provider-specific implementations behind interfaces so that embeddings, vector databases, rerankers, and LLMs can be replaced without changing API contracts.

## Core Components

| Component | Responsibility | Prototype guidance |
| --- | --- | --- |
| Query API | Accept and validate the supervisor query; return a typed answer envelope. | Include request ID, corpus/version filter, answer, citations, cache status, and latency. |
| Intent router (optional) | Identify likely domain, document class, equipment, or whether a query needs escalation. | Start with deterministic rules/metadata filters. Add an LLM intent agent only if testing shows clear retrieval benefit. |
| Document intelligence pipeline | Parse, normalize, chunk, embed, and index approved documents. | Preserve original text and location metadata; make ingestion repeatable and version-aware. |
| Retrieval | Find candidate chunks relevant to the query. | Use vector search plus lexical/keyword search where available; apply metadata filters first. |
| Reranker | Order candidate chunks by relevance and select the top 3. | Capture retrieval and reranking scores for evaluation. |
| Context assembler | Create a bounded, deduplicated evidence packet. | Include only the evidence needed; never silently truncate citation metadata. |
| Generation service | Produce a concise grounded answer. | Require citations; use the exact unavailable response when sources do not support an answer. |
| Citation validator | Confirm that each cited source was actually supplied as context. | Reject or retry answers with missing/invalid citations. |
| Semantic cache | Reuse answers to sufficiently similar queries. | Key by normalized query embedding plus corpus/version, access scope, and prompt/model configuration. TTL and invalidate on document updates. |
| Observability/evaluation | Measure quality, latency, cost, and failure modes. | Log structured, privacy-safe events; never log secret values. |

## Document Intelligence and RAG Ingestion

### Source policy

Prefer organization-approved and versioned documents. Public material can seed a demo corpus but must be clearly labeled as external/reference material and must not override local procedures.

Candidate public sources to assess for demo content or metadata enrichment:

- [OSHA data and safety resources](https://www.osha.gov/data/) — public datasets and links to regulations, directives, and guidance.
- [OSHA Technical Manual](https://www.osha.gov/otm) — occupational safety and health technical guidance.
- [NIOSH publications and products](https://www.cdc.gov/niosh/pubs/default.html) — searchable occupational-safety publications and reference materials.
- [eCFR API](https://www.ecfr.gov/developers/documentation/api/v1) — programmatic access to current federal regulatory text, where applicable.

Before ingestion, confirm licensing, terms of use, version/effective date, document authority, and whether the content is appropriate for the facility and jurisdiction. Treat external sources as reference information, not site-specific instructions.

### Ingestion flow

1. Register the document source and authority level.
2. Parse PDF, DOCX, HTML, or other supported files into structured text while retaining headings, pages, tables, and images/OCR provenance.
3. Normalize text without losing the source representation.
4. Chunk by semantic boundaries (for example, heading and procedure step), with modest overlap when needed.
5. Assign metadata and stable chunk identifiers.
6. Produce embeddings using the same embedding model that will embed user queries.
7. Store chunks, embeddings, and metadata in the selected vector database/search index.
8. Validate ingestion quality: chunk count, text extraction, metadata completeness, embedding success, and sampled retrieval tests.
9. Version and publish the corpus only after approval; invalidate affected semantic-cache entries.

### Required chunk metadata

- `document_id`, title, document type, owner/authority, and source URL or repository path
- version, effective date, ingestion timestamp, and approval status
- section title/number, page number or source offset, chunk sequence, and stable `chunk_id`
- facility, equipment, process, jurisdiction, language, and access-control tags when relevant
- parser/OCR confidence and source checksum
- embedding model/version and index version

## Query and Generation Flow

### API contract (conceptual)

`POST /query` accepts the user question and request context such as user identity/role, facility or equipment scope, language, and optional conversation ID. It returns:

- answer text or `Not available in the documents.`
- citations with document title, version, section/page, and a link or identifier
- response state: `cache_hit`, `grounded_answer`, `insufficient_evidence`, `escalate`, or `error`
- request ID and safe diagnostic metadata such as latency

### Retrieval and context assembly

1. Validate input, authorize corpus access, and normalize the query.
2. Detect emergency/escalation terms before normal retrieval.
3. Look up an answer only in a cache partition matching the user’s access level, document corpus/index version, and model/prompt version.
4. Apply deterministic routing/metadata filters; run the optional Intent Agent only if it routes more accurately in evaluation.
5. Embed the query with the same embedding model used for indexed chunks.
6. Retrieve a candidate set using semantic retrieval, optionally combined with lexical retrieval.
7. Apply a reranker and select the top three evidence chunks, subject to a relevance threshold and diversity across documents/sections.
8. Assemble context with source identifiers, citations, and explicit evidence boundaries.
9. Generate an answer using a strict grounding prompt.
10. Validate citation syntax and grounding; if validation fails, return the unavailable response instead of guessing.
11. Cache only validated, non-sensitive results, with citations and version keys.

### Prompt rules

The prompt must instruct the model to:

- Answer only from the supplied evidence.
- Cite each material claim using the supplied citation identifiers.
- State `Not available in the documents.` if the evidence does not answer the question.
- Call out conflicts or ambiguous instructions rather than reconciling them from model knowledge.
- Avoid unsafe extrapolation; direct urgent safety concerns to the configured escalation process.
- Use clear, short language suitable for a floor supervisor.

## End-User Experience

The initial UI is a focused chat interface:

- A clearly labeled query field with optional facility/equipment scope.
- Answer view that distinguishes sourced answers, unavailable results, and escalation messages.
- Expandable citations showing title, version, section/page, and supporting excerpt.
- Visible loading and retry states; no false implication that the system is searching live systems unless it is.
- Feedback controls such as “helpful,” “not helpful,” and “citation does not support answer,” captured with request ID for evaluation.
- A concise disclaimer that the assistant is a document lookup aid and does not replace required safety procedures or escalation channels.

## Interfaces and Data Boundaries

Use typed schemas at system boundaries for query requests, retrieval candidates, citations, answer responses, document records, chunks, and evaluation records. Keep these implementations replaceable:

- `DocumentParser`
- `EmbeddingProvider`
- `VectorStore`
- `Retriever`
- `Reranker`
- `LLMProvider`
- `SemanticCache`
- `CitationValidator`

Configuration must supply model names, thresholds, cache TTL, source permissions, and provider credentials. Never hardcode secrets.

## Evaluation Plan

Build a small, expert-reviewed evaluation set of representative supervisor questions. Label each with expected answerability, authoritative sources, supporting passages, and unacceptable/unsafe answer patterns.

### Retrieval evaluation

1. **Recall** — whether the correct source passage appears in the retrieved candidate set and top 3.
2. **Precision** — proportion of retrieved/reranked passages that are relevant.
3. **RRF (optional)** — evaluate reciprocal-rank fusion when combining lexical and vector retrieval.
4. Citation coverage and source-version correctness.
5. Filter accuracy for facility, equipment, role, and document access scope.

### Generation evaluation

1. **Correctness** — expert review of factual accuracy against the source.
2. **Groundedness** — every material claim is supported by a cited chunk.
3. **Citation quality** — citations are present, resolvable, and point to the right section/page.
4. **Abstention quality** — unsupported questions consistently receive the exact unavailable response.
5. **LLM as a judge** — use as a supplementary, calibrated signal; validate it against human labels before relying on it.
6. Safety behavior — measure safe handling of urgent, conflicting, and out-of-corpus questions.
7. Golden Dataset of sample queries for testing the quality of retrieval and generation process
   

### System evaluation

1. End-to-end and per-stage latency (cache, routing, retrieval, reranking, generation).
2. Cost per request and per ingested document.
3. Cache hit rate, invalidation rate, and cache-answer quality.
4. Availability, error rate, retry rate, and timeout behavior.
5. Index freshness and ingestion failure rate.
6. User feedback rate and correction/escalation rate.

Define acceptance thresholds before implementation. For a demo, optimize first for answer grounding and citation correctness; do not trade these away solely for lower latency or cost.

## Suggested Build Sequence

1. Agree on a small approved demo corpus and document metadata standard.
2. Implement and test parsing, chunking, metadata persistence, embeddings, and vector indexing.
3. Build a basic retrieve → top-3 rerank → grounded-answer path with citations and abstention.
4. Add the typed query API and minimal chat interface.
5. Add semantic caching with version-aware invalidation.
6. Add deterministic routing; test whether the optional Intent Agent improves results before keeping it.
7. Add observability and the evaluation harness; evaluate retrieval before tuning generation.
8. Run a safety and failure-mode review before any broader pilot.

## Prototype Acceptance Criteria

- A supervisor can ask a scoped question and receive either a grounded answer with citations or the exact unavailable response.
- Each answer citation resolves to a currently approved source section/page.
- Document updates create a new corpus/index version and invalidate stale cached results.
- Retrieval, reranking, generation, and cache behavior are observable with privacy-safe telemetry.
- The evaluation set includes answerable, unanswerable, conflicting-source, and urgent-safety cases.
- No component requires hardcoded credentials or undocumented provider-specific behavior.

## Open Decisions for Approval

- Initial document corpus, authority hierarchy, and facility/jurisdiction scope.
- Chosen embedding, vector database, reranker, and LLM providers.
- Exact emergency/escalation language and who owns it.
- Access-control model and retention policy for queries, logs, and cached answers.
- Evaluation thresholds that determine whether the prototype may be demonstrated or piloted.
