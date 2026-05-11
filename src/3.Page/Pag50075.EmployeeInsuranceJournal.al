page 50075 "Employee Insurance Journal"
{
    ApplicationArea = All;
    Caption = 'Employee Insurance Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"Attendance Missed"));
    UsageCategory = Tasks;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Insurance Type"; rec."Insurance Type")
                {

                }
                field("Insurance Company Code"; rec."Insurance Company Code")
                {

                }
                field("Insurance Company Name"; rec."Insurance Company Name")
                {

                }
                field("Insurance Start Date (AD)"; rec."Insurance Start Date (AD)")
                {

                }
                field("Insurance Start Date (BS)"; rec."Insurance Start Date (BS)")
                {
                    Editable = false;
                }
                field("Insurance Expiry Date (AD)"; rec."Insurance Expiry Date (AD)")
                {

                }
                field("Insurance Expiry Date (BS)"; rec."Insurance Expiry Date (BS)")
                {
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Emp Act. No"), "Document Type" = field(Type);
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Insurance";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        CurrPage.Update();
    end;

    procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
    end;

    var
        StatusView, ApprovalStatusView : Boolean;
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
        ExcelImportMgt: Codeunit "Excel Import";
        ListOfDocNo: List of [code[20]];
        i: Integer;
}
