# RAG Seed Corpus — Source Register

This directory contains a small external-reference demo corpus selected under the source policy in [`BUILD.md`](../BUILD.md). These are public documents for prototyping only. They are **not facility-specific procedures** and must not replace approved local documents, manufacturer instructions, or emergency processes.

| Local file | Document type | Authority and published version | Original source | Intended prototype use |
| --- | --- | --- | --- | --- |
| `osha-lockout-tagout-fact-sheet-2022.pdf` | Safety procedure/reference | OSHA FS-3529, December 2022 | https://www.osha.gov/sites/default/files/publications/OSHAFS3529.pdf | Hazardous-energy-control and lockout/tagout queries. |
| `osha-machine-guarding-checklist.pdf` | Safety checklist/reference | OSHA Machine Guarding Checklist, May 2020 | https://osha.gov/sites/default/files/2020-05/Machine%20Guarding%20Checklist.pdf | Machine safeguarding inspection queries. |
| `calpia-iso-9001-quality-manual-2023.pdf` | Quality standard/manual | CALPIA ISO 9001 Quality Management System Quality Manual, September 2023 | https://www.calctra.ca.gov/wp-content/uploads/calpia/about/iso_certificate/ISO%209001%20Quality%20Management%20System-CALPIA%20Quality%20Manual%20(%2323-150)%20092223-PIA.pdf | Quality-management, document-control, audit, corrective-action, and continuous-improvement queries. |
| `us-forest-service-heavy-equipment-guide-2007.pdf` | Maintenance manual/reference | U.S. Forest Service Heavy Equipment Guide, 2007 | https://www.fs.usda.gov/t-d/pubs/pdfpubs/pdf07713801/pdf07713801dpi300.pdf | Preventive-maintenance, inspection, lubrication, and operator-maintenance questions. |
| `vehicle-safety-and-maintenance-reference.md` | Source-controlled safety/maintenance reference | Derived from U.S. Forest Service *Driver-Operator Guide* EM-7130-2, July 2005 revised, Chapters 1-3 | https://www.fs.usda.gov/t-d/pubs/pdfpubs/pdf07713801/pdf07713801dpi300.pdf | Vehicle safety and preventive-maintenance questions limited to the source's first three chapters. |
| `general-manufacturing-quality-standard.md` | Prototype quality standard | Project-authored version 0.1 | Local document | General manufacturing quality, inspection, nonconformance, corrective action, and release questions. |

## Ingestion requirements

- Assign every chunk the source URL, local filename, title, issuing organization, publication/version date, page number, and `external_reference` authority tag.
- Keep each file’s original checksum in the document registry and record the retrieval date.
- Maintain document-level access and corpus-version fields; invalidate semantic-cache entries when a source changes or is removed.
- Preserve the safety boundary in `BUILD.md`: if the retrieved source does not support the answer, return `Not available in the documents.`
- Before a pilot, replace or supplement this demo corpus with organization-approved, facility-specific procedures and OEM manuals.
