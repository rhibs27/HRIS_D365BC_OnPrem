# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dynamics365HRMS — a Business Central (D365BC) On-Premises HRIS extension by Agile Solutions Pvt. Ltd. Built with AL language targeting BC platform 25.0.0.0, runtime 14.0. Object ID range: **50000–50999**.

## Build & Run

- **IDE:** VS Code with the AL Language extension
- **Build:** `Ctrl+Shift+B` in VS Code (AL: Package) or use command palette → "AL: Package"
- **Publish:** `Ctrl+F5` to publish without debugging, `F5` to publish with debugging
- **Server:** localhost BC240 (On-Premises, Windows auth)
- **Startup Object:** Page 50400
- **Schema Update Mode:** ForceSync (development)

There is no CLI build tool or test runner outside of VS Code + AL extension. The compiled output is an `.app` file.

## Source Code Organization

All source lives under `src/`, organized by AL object type with numbered prefixes:

```
src/
├── 1.Table/              # 169+ tables (data model)
├── 2.Table Extension/    # Extensions to standard BC tables
├── 3.Page/               # 319+ pages (UI)
├── 3.Page Extension/     # Extensions to standard BC pages
├── 4.CodeUnit/           # 35+ codeunits (business logic)
├── 5.Query/              # 3+ query objects
├── 6.Report/             # 151+ reports + .rdl layout files
├── 7.XMLport/            # 13+ XML ports (import/export)
├── 8.Enum/               # 170+ enumerations
├── 9.Enum Extension/     # Extensions to standard BC enums
└── controladdin/         # Control add-ins
```

## File Naming Convention

`{ObjectTypePrefix}{ID}.{Name}.al`

| Object Type | Prefix | Example |
|-------------|--------|---------|
| Table | `Tab` | `Tab50004.Promotion.al` |
| Table Extension | `Tab-Ext` | `Tab-Ext50000.GLAccountExt.al` |
| Page | `Pag` | `Pag50012.RecruitmentMemoList.al` |
| Page Extension | `Pag-Ext` | `Pag-Ext50010.EmployeeCard.al` |
| CodeUnit | `Cod` | `Cod50001.HRMgt.al` |
| Report | `Rep` | `Rep50023.EmployeeMaster.al` |
| Query | `Que` | `Que50000.PayrollQuery.al` |
| XMLport | `Xml` | `Xml50000.ExportCandidate.al` |
| Enum | `Enum` | `Enum50000.Region.al` |
| Enum Extension | `Enum-Ext` | `Enum-Ext50000.ReportSelectUsageExt.al` |

Reports pair `.al` code with `.rdl` layout files in the same directory.

## Architecture

**Separation pattern:** Tables define data → Pages provide UI → CodeUnits contain business logic → Reports handle output.

**Extension pattern:** Standard BC objects (Employee, GL Account, HR Setup, User Setup) are extended via `Tab-Ext`/`Pag-Ext`/`Enum-Ext` files rather than modified directly.

### Core CodeUnits (Business Logic Entry Points)

| CodeUnit | Domain |
|----------|--------|
| `Cod50001.HRMgt.al` | Core HR management (largest, central logic hub) |
| `Cod50008.PayrollEngine.al` | Payroll calculation engine |
| `Cod50017.ApproverMgt.al` | Approval workflow engine |
| `Cod50000.LeaveMgt.al` | Leave/PTO management |
| `Cod50002.LoanMgt.al` | Employee loan processing |
| `Cod50004.TravelMgt.al` | Travel request/claim processing |
| `Cod50005.TransferMgt.al` | Employee transfers |
| `Cod50006.ResignationMgt.al` | Resignation handling |
| `Cod50009.PayrollJnlPostLine.al` | Payroll journal posting |
| `Cod50010.PayrollPost.al` | Payroll GL posting |
| `Cod50027.PayrollReportMgt.al` | Payroll reporting calculations |
| `Cod50030.AssignmentMemoMgt.al` | Assignment/posting management |

### Functional Modules

- **Recruitment:** Candidates, Vacancies, Interviews, Selection Committees, Offer/Appointment Letters
- **Payroll:** Multi-attribute payroll, tax deduction (Nepal tax rules), salary advance, payslips
- **Leave:** Leave types, balance tracking, approval workflow, encashment
- **Attendance:** Biometric integration, shift assignment, daily attendance tracking
- **Training:** Training calendar, facilitator pools, attendance records
- **Loans:** Personal/Vehicle/Home loans, salary advances, repayment tracking
- **Travel:** Travel requests, claims, settlement, expense tracking
- **Appraisal:** KPI management, performance ratings, evaluation workflows
- **Insurance:** Policy management, medical claim processing

### Approval Workflow

ApproverMgt (`Cod50017`) drives approval across all modules. Document Approver tables define approval chains. Most transactional documents (leave, travel, loans, recruitment) go through an approval status lifecycle.

## Key Configuration Files

- **`app.json`** — App manifest (ID range, platform version, dependencies)
- **`PermissionSet50000.D365HRMSPermission.al`** — RIMD permissions for all HRIS tables
- **`.vscode/launch.json`** — Debug/publish configuration targeting local BC240
- **`Translations/Dynamics365HRMS.g.xlf`** — Auto-generated translation file (do not edit manually; regenerated on build)

## Code Style

VS Code is configured with these AL cleanup actions (applied on save):
- RemoveEmptyLines, TrimTrailingWhitespace, CollapseEmptyBrackets
- MakeFlowFieldsReadOnly, RemoveUnusedVariables

## Git & Source Control

- **Remote:** Azure DevOps (`dev.azure.com/AgileSolutionsNepal/HRIS`)
- **Main branch:** `main`
- The `.g.xlf` translation file changes frequently and is auto-generated — merge conflicts in this file should generally be resolved by accepting the more complete version or regenerating via build.
