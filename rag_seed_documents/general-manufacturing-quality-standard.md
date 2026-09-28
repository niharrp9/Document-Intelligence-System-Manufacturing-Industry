# General Manufacturing Quality Standard

**Status:** Prototype internal standard for the RAG demo corpus  
**Industry:** General discrete manufacturing and assembly  
**Version:** 0.1  
**Owner:** Quality Manager (prototype role)  
**Important:** This is not an ISO 9001 certification standard and does not replace customer, regulatory, contractual, or facility-specific requirements.

## 1. Purpose

Establish a minimal, auditable quality-management baseline for manufacturing and assembly work. The standard ensures that current instructions are used, requirements are verified, nonconforming output is controlled, and records support traceability and improvement.

## 2. Scope

This standard applies to production planning, material receipt, manufacturing/assembly, inspection and test, calibration, nonconformance handling, corrective action, release, and associated records. The stricter requirement controls when customer specifications, regulations, approved work instructions, or supplier agreements differ.

## 3. Quality principles

- Build to approved requirements.
- Prevent defects before relying on final inspection.
- Keep objective evidence of material, process, inspection, and release decisions.
- Identify and contain nonconforming product promptly.
- Use corrective action to address root causes and verify effectiveness.
- Continually improve processes using reliable quality data.

## 4. Document and change control

1. Work may be performed only to the current approved revision of specifications, drawings, work instructions, inspection plans, and forms.
2. Each controlled document must show a title, identifier, revision, effective date, owner, and approval status.
3. Obsolete versions must be removed from points of use or clearly marked as reference-only.
4. Changes affecting product, process, inspection, safety, or customer requirements require review and approval before release.
5. Change records must describe the reason, impact, affected products/processes, approver, and effective date.

## 5. Material, supplier, and traceability control

1. Verify received material against the purchase requirement and applicable acceptance criteria.
2. Identify material and product status as accepted, pending inspection, hold, rejected, or rework as applicable.
3. Maintain lot, batch, serial, or other traceability required by the product specification, customer, or regulation.
4. Do not substitute material, supplier, or critical process without approved change control.

## 6. Production and process control

1. Use approved work instructions and the required tools, fixtures, process settings, and training/authorization.
2. Perform defined in-process checks at the required point of production.
3. Record critical process parameters when required by the control plan or work instruction.
4. Stop work and notify the supervisor or quality representative when the process is outside an approved limit, the instruction is unclear, or the required record is missing.
5. Maintain equipment in a condition suitable for its intended use. Follow applicable manufacturer and local maintenance procedures; the vehicle reference in this corpus is not a universal maintenance procedure.

## 7. Inspection, test, and calibration

1. Verify product against approved acceptance criteria before release.
2. Use inspection and test equipment that is suitable for its measurement purpose and is within required calibration/verification status.
3. Identify measurement equipment with its status and remove or control equipment that is overdue, damaged, or otherwise unreliable.
4. Record inspection/test results, including product identifier, characteristic checked, result, date, and responsible person or system.

## 8. Nonconforming product

1. Identify, segregate or otherwise control, and document nonconforming material or product immediately.
2. Prevent unintended use, shipment, or further processing until disposition is approved.
3. Permitted dispositions are rework, repair when approved, return to supplier, scrap, or use-as-is concession when authorized by the required authority.
4. Reworked or repaired product must be reinspected to the applicable acceptance criteria.

## 9. Corrective action and continuous improvement

1. Initiate corrective action for significant, recurring, customer-reported, or systemic quality issues.
2. Define the problem, contain the affected output, investigate the cause, implement corrective action, and verify effectiveness.
3. Retain objective evidence for each corrective-action stage.
4. Review quality data at planned intervals to identify trends, risks, and improvement opportunities.

## 10. Product release

Release product only when required inspections, tests, records, and approvals are complete and acceptance criteria are met. The release record must identify the product, applicable revision, verification evidence, release decision, date, and authorized releaser.

## 11. Records and retention

Maintain legible, retrievable, protected records for document changes, material acceptance, production checks, inspections/tests, calibration, nonconformance, corrective action, maintenance where applicable, and release. Define retention periods based on customer, regulatory, legal, and business requirements.

## 12. RAG answer rules

- Cite the numbered section supporting each material answer.
- Do not imply certification, regulatory compliance, or customer approval from this prototype standard alone.
- If a query needs product-specific acceptance criteria, a customer requirement, or a regulated-industry rule that is not in the corpus, return `Not available in the documents.`

## Related prototype sources

- `calpia-iso-9001-quality-manual-2023.pdf` - external reference for quality-management concepts; it is not the facility's quality manual.
- `vehicle-safety-and-maintenance-reference.md` - limited external reference for the stated vehicle categories and source chapters.
