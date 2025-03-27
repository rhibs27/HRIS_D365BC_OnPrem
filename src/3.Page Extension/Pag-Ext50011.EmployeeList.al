pageextension 50011 "Employee List" extends "Employee List"
{
    layout
    {
        addafter("No.")
        {
            field("Full Name"; Rec."Full Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Name field.';
            }
            field("Contract Expiry Date"; Rec."Contract Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contract Expiry Date field.';
            }
            field("Contract Expiry Remaining Days"; Rec."Contract Expiry Remaining Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contract Expiry Remaining Days field.';
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field("Resignation Date"; Rec."Resignation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Resignation Date field.';
            }
            field("Deputation on"; Rec."Deputation on")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deputation on field.';
            }
            field("Province Name"; Rec."Province Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Province Name field.';
            }
            field("Sub Province Name"; Rec."Sub Province Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sub Province Name field.';
            }
            field("Eco-System"; Rec."Eco-System")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Eco-System field.';
            }
            field(Cluster; Rec.Cluster)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cluster field.';
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Branch Name"; Rec."Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch Name field.';
            }
            field("Department Name"; Rec."Department Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Department Name field.';
            }
            field("Functional Title Desc"; Rec."Functional Title Desc")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Functional Title Desc field.';
            }
            field("Employment Type"; Rec."Employment Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employment Type field.';
            }
            field("Salary Level"; Rec."Salary Level")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Salary Level field.';
            }
            field("Employment Date"; Rec."Employment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employment Date field.';
            }
            field("Confirmation Date"; Rec."Confirmation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Confirmation Date field.';
            }
            field("Promotion Date"; Rec."Promotion Date")
            {
                ApplicationArea = All;
                Caption = 'Last Promotion Date';
                ToolTip = 'Specifies the value of the Last Promotion Date field.';
            }
            field("Contract Expiry Month"; Rec."Contract Expiry Month")
            {
                ApplicationArea = All;
                Caption = 'Contract Period';
                ToolTip = 'Specifies the value of the Contract Period field.';
            }
            field("Birth Date"; Rec."Birth Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Birth Date field.';
            }
            field("Company E-Mail"; Rec."Company E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Email field.';
            }
            field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';
            }
            field("NAV Login ID"; Rec."NAV Login ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NAV Login ID field.';
            }
            field("Salary Grade"; Rec."Salary Grade")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salary Grade field.';
            }
            field("GrandFather's Name (Nepali)"; Rec."GrandFather's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GrandFather''s Name (Nepali) field.';
            }
            field("Father's Name (Nepali)"; Rec."Father's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Father''s Name (Nepali) field.';
            }
            field("Mother's Name (Nepali)"; Rec."Mother's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mother''s Name (Nepali) field.';
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account No. field.';
            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Marital Status field.';
            }
            field("Attendance Missed Count"; Rec."Attendance Missed Count")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attendance Missed Count field.';
            }
            field("Attendance Missed On"; Rec."Attendance Missed On")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attendance Missed On field.';
            }
        }
    }
    actions
    {
        // addafter("E&mployee")
        // {
        //     action("Payroll Attributes Usage")
        //     {
        //         ApplicationArea = All;
        //         RunObject = page "Payroll Attributes Usage";
        //         RunPageLink = "Employee Code" = field("No.");
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = Components;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Payroll Attributes Usage action.';
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        //     action("KPI Setup")
        //     {
        //         ApplicationArea = All;
        //         RunObject = page "KPI Setup Functional Bank";
        //         RunPageLink = Type = const("Department Central & Province Level"), Code = field("No.");
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = Components;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the KPI Setup action.';
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        // }
        // addafter("Q&ualifications")
        // {
        //     action("Employee Work Experience")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Work Experience';
        //         RunObject = page "Employee Work Qualification";
        //         RunPageLink = "Employee No." = field("No."), "Emp Qualification Type" = filter(Education);
        //         Image = Certificate;
        //         ToolTip = 'Executes the Work Experience action.';
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        // }
        // addafter(PayEmployee)
        // {
        //     action("Generate New Employee Card")
        //     {
        //         // ApplicationArea = All;
        //         Caption = 'Generate New Employee Card';
        //         ApplicationArea = Basic, Suite;
        //         Promoted = true;
        //         Image = Archive;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Generate New Employee Card action.';
        //         trigger OnAction()
        //         begin
        //             if not Confirm('Do you want to create new employee card?', false) then
        //                 exit;
        //             Employee.GenerateNewEmployeeCard(Rec);
        //         end;
        //     }
        //     action("Test Approval")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Executes the Test Approval action.';

        //         trigger OnAction()
        //         var
        //             LoanMgt: Codeunit "Loan Mgt.";
        //             Temp1: Code[150];
        //             Temp2: Code[150];
        //             Temp3: Text;
        //             Temp4: Text;
        //         begin
        //             LoanMgt.UpdateApproval(Rec, Temp1, Temp2, Temp3, Temp4, true);
        //         end;
        //     }
        //     action("Generate Leave Balance")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = GiroPlus;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Generate Leave Balance action.';
        //         trigger OnAction()
        //         begin
        //             Employee.Reset;
        //             Employee.SetRange("No.", Rec."No.");
        //             Report.RunModal(REPORT::"Generate Leave Balance", true, false, Employee);
        //         end;
        //     }
        //     action("Update Approval Code")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = CoupledUser;
        //         PromotedCategory = Category4;
        //         ToolTip = 'Executes the Update Approval Code action.';
        //         trigger OnAction()
        //         begin
        //             Employee.Reset;
        //             Employee.SetRange("No.", Rec."No.");
        //             Report.Run(Report::"Employee Approval Report", true, true, Employee);
        //         end;
        //     }
        //     // action(Temp)
        //     // {
        //     //     ApplicationArea = All;
        //     //     ToolTip = 'Executes the Temp action.';

        //     //     trigger OnAction()
        //     //     begin
        //     //         Employee.Reset;
        //     //         if Employee.FindFirst then
        //     //             repeat
        //     //                 Employee.Validate("Recommender Name");
        //     //                 Employee.Validate("Approver Code");
        //     //                 Employee.Modify;
        //     //             until Employee.Next = 0;

        //     //         Message('done.');
        //     //     end;
        //     // }
        //     action("Leave Earn (Contract)")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         Image = EditFilter;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Leave Earn (Contract) action.';
        //         trigger OnAction()
        //         begin
        //             LeaveMgt.CreateLeaveEarnContract(Rec);
        //         end;
        //     }
        //     action("Attendance & Activities")
        //     {
        //         ApplicationArea = All;
        //         RunObject = page "Employee Attendance & Activity";
        //         RunPageLink = "Employee No." = field("No.");
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = BookingsLogo;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Attendance & Activities action.';
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        //     action("Portal Attendance")
        //     {
        //         ApplicationArea = All;
        //         RunObject = page "Attendance Logs";
        //         RunPageLink = "Employee ID" = field("No.");
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = BulletList;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Portal Attendance action.';
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        //     action("Resign Employee")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = VoidCheck;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Resign Employee action.';
        //         trigger OnAction()
        //         begin
        //             IF CONFIRM('Do you want to terminate %1 ?', FALSE, Rec."Full Name") THEN
        //                 ResignationMgt.UpdateResign(Rec."No.");
        //         end;
        //     }
        //     action("Insert Payroll Attributes")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = AddContacts;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Insert Payroll Attributes action.';
        //         trigger OnAction()
        //         begin
        //             if Confirm('Do you want to update payroll attributes usage ?', false) then
        //                 PayrollEngine.InsertPayrollAttributes;
        //         end;
        //     }
        //     action(SycnEmployeesToPortal)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Sync Employees To Portal';
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = AddWatch;
        //         PromotedCategory = Process;
        //         ToolTip = 'Executes the Sync Employees To Portal action.';
        //         trigger OnAction()
        //         begin
        //             if Confirm('Do you want to sync employees to portal?', false) then begin
        //                 HRMgt.SyncEmployee();
        //                 Message('Success');
        //             end;
        //         end;
        //     }
        //     action("Request Retirement Fund")
        //     {
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = Allocate;
        //         PromotedCategory = Category8;
        //         ToolTip = 'Executes the Request Retirement Fund action.';
        //         trigger OnAction()
        //         begin
        //             Rec.RFRequest;
        //         end;
        //     }
        // }
    }
    trigger OnOpenPage()

    begin
        Usersetup.Get(UserId);
        payrollFieldsVisible := Usersetup."Can View Payroll Fields";
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."Contract Expiry Remaining Days" := 0;
        if Rec."Contract Expiry Date" > Today then
            Rec."Contract Expiry Remaining Days" := Rec."Contract Expiry Date" - Today;
    end;

    var
        payrollFieldsVisible: Boolean;
        Usersetup: Record "User Setup";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        PayrollEngine: Codeunit "Payroll Engine";
}
