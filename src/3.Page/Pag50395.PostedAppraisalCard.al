// page 50395 "Posted Appraisal Card"
// {
//     ApplicationArea = All;
//     Caption = 'Posted Appraisal Card';
//     PageType = Card;
//     SourceTable = Appraisal;
//     Editable = false;

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Caption = 'General';

//                 field("Appraisal Code"; Rec."Appraisal Code")
//                 {
//                     ToolTip = 'Specifies the value of the Appraisal Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Appraisal Template"; Rec."Appraisal Template")
//                 {
//                     ToolTip = 'Specifies the value of the Appraisal Template field.';
//                     ApplicationArea = All;
//                 }
//                 field("Fiscal Year"; Rec."Fiscal Year")
//                 {
//                     ToolTip = 'Specifies the value of the Fiscal Year field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee Code"; Rec."Employee Code")
//                 {
//                     ToolTip = 'Specifies the value of the Employee Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee Name"; Rec."Employee Name")
//                 {
//                     ToolTip = 'Specifies the value of the Employee Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Date of Employement"; Rec."Date of Employement")
//                 {
//                     ToolTip = 'Specifies the value of the Date of Employment field.';
//                     ApplicationArea = All;
//                 }
//                 field("Confirmation Date"; Rec."Confirmation Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("KPI Rating Type"; Rec."KPI Rating Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Appraisal Type"; Rec."Appraisal Type")
//                 {
//                     ToolTip = 'Specifies the value of the Appraisal Type field.';
//                     ApplicationArea = All;
//                 }
//                 field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
//                 {
//                     ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
//                     ApplicationArea = All;
//                 }
//                 field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
//                 {
//                     ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
//                     ApplicationArea = All;
//                 }
//                 field("Province Name"; Rec."Province Name")
//                 {
//                     ToolTip = 'Specifies the value of the Province Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Branch Name"; Rec."Branch Name")
//                 {
//                     ToolTip = 'Specifies the value of the Branch Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Department Name"; Rec."Department Name")
//                 {
//                     ToolTip = 'Specifies the value of the Department Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Extension Counter Name"; Rec."Extension Counter Name")
//                 {
//                     ToolTip = 'Specifies the value of the Extension Counter Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Unit Name"; Rec."Unit Name")
//                 {
//                     ToolTip = 'Specifies the value of the Unit Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Sub-Unit Name"; Rec."Sub-Unit Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Designation"; Rec.Designation)
//                 {
//                     ToolTip = 'Specifies the value of the Designation field.';
//                     ApplicationArea = All;
//                 }
//                 field("Total Final Score"; Rec."Total Final Score")
//                 {
//                     ToolTip = 'Specifies the value of the Total Final Score field.';
//                     ApplicationArea = All;
//                 }
//                 field("Final Grading"; Rec."Final Grading")
//                 {
//                     ToolTip = 'Specifies the value of the Final Grading field.';
//                     ApplicationArea = All;
//                 }
//                 field("Approval Status"; Rec."Approval Status")
//                 {
//                     ToolTip = 'Specifies the value of the Approval Status field.';
//                     ApplicationArea = All;
//                 }
//                 field("Submission Date"; Rec."Submission Date")
//                 {
//                     Caption = 'Initiator Performance Appraisal Submission Date';
//                     ToolTip = 'Specifies the value of the Submission Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("Posting Date"; Rec."Posting Date")
//                 {
//                     ToolTip = 'Specifies the value of the Posting Date field.';
//                     ApplicationArea = All;
//                 }


//             }

//             part("KPI Employee"; "KPI Employee")
//             {
//                 Caption = 'KPI Employee Score';
//                 ApplicationArea = All;
//                 SubPageLink = "Appraisal Code" = field("Appraisal Code"),
//                               "Employee Code" = field("Employee Code");
//                 Editable = false;
//                 Enabled = false;
//             }
//             part("Employee Appraisal Questions"; "Employee Appraisal Questions")
//             {
//                 Caption = 'Employee Appraisal Questions';
//                 ApplicationArea = All;
//                 SubPageLink = "Appraisal Code" = field("Appraisal Code"),
//                               "Employee Code" = field("Employee Code");
//                 Editable = false;
//                 Enabled = false;
//             }
//             part("Score Detail Subform"; "Score Detail Subform")
//             {
//                 Caption = 'Score Details';
//                 ApplicationArea = All;
//                 SubPageLink = "Appraisal Code" = field("Appraisal Code"),
//                               "Appraisal Template" = field("Appraisal Template"),
//                               "Fiscal Year" = field("Fiscal Year");
//                 Editable = false;
//                 Enabled = false;
//             }
//             part("HRMS Approval Entry"; "HRMS Approval Entry")
//             {
//                 Caption = 'Approval History';
//                 SubPageLink = "Document No." = field("Appraisal Code");
//                 ApplicationArea = All;
//                 Editable = false;
//                 Enabled = false;
//             }

//         }
//     }

// }
