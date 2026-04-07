page 50181 "Request Allowance Subform"
{
    ApplicationArea = All;
    Caption = 'Request Allowance Subform';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line";
    SourceTableView = where("Emp Act Type" = const("Request Allowance"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = FormEditable;

                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
                }
                field("Fuel Claimed (ltr)"; Rec."Fuel Claimed (ltr)")
                {
                    ToolTip = 'Specifies the value of the Fuel Claimed (ltr) field.', Comment = '%';
                }
                field("School Name"; Rec."School Name")
                {
                    ToolTip = 'Specifies the value of the School Name field.', Comment = '%';
                }
                field("Name of Children"; Rec."Name of Children")
                {
                    ToolTip = 'Specifies the value of the Name of Children field.', Comment = '%';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        EmployeeRelative: Record "Employee Relative";
                        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                    begin
                        EmployeeRelative.SetRange("Employee No.", Rec."Employee No.");
                        EmployeeRelative.SetRange(Relationship, EmployeeRelative.Relationship::Children);
                        EmployeeRelative.SetRange(Discontinue, false);
                        if Page.RunModal(Page::"Employee Relatives", EmployeeRelative) = Action::LookupOK then
                            Rec.Validate("Name of Children", EmployeeRelative."Full Name");
                        AssignmentMemoMgt.LookUpNameofChildren(EmployeeRelative, Rec);
                    end;
                }
                field("Grade/Class"; Rec."Grade/Class")
                {
                    ToolTip = 'Specifies the value of the Grade/Class field.', Comment = '%';
                }
                field("Effective Months (Edu.)"; Rec."Effective Months (Edu.)")
                {
                    ToolTip = 'Specifies the value of the Effective Months field.', Comment = '%';
                }
                field("Effective From/To Date"; Rec."Effective From (Edu.)")
                {
                    ToolTip = 'Specifies the value of the Effective From/To Date field.', Comment = '%';
                    Editable = false;
                }
                field(Discontinued; Rec.Discontinued)
                {
                    ToolTip = 'Specifies the value of the Discontinued field.', Comment = '%';
                }
                field("Distance (KM)"; Rec."Distance (KM)")
                {
                    ToolTip = 'Specifies the value of the Distance (KM) field.', Comment = '%';
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                }
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.', Comment = '%';
                }
                field("Claimed as Leave"; Rec."Claimed as Leave")
                {
                    ToolTip = 'Specifies the value of the Claimed as Leave field.', Comment = '%';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ToolTip = 'Specifies the value of the Bill Date field.', Comment = '%';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ToolTip = 'Specifies the value of the Bill No. field.', Comment = '%';
                }
                field("Amount per Ltr."; Rec."Amount per Ltr.")
                {
                    ToolTip = 'Specifies the value of the Amount per Ltr. field.', Comment = '%';
                }
                field("Last Placement Date"; Rec."Last Placement Date")
                {
                    ToolTip = 'Specifies the value of the Date of joining current branch field.', Comment = '%';
                }
                field("Previous Branch Code"; Rec."Previous Branch Code")
                {
                    ToolTip = 'Specifies the value of the Previous Branch Code field.', Comment = '%';
                }
                field("Vault Name"; Rec."Vault Name")
                {
                    ToolTip = 'Specifies the value of the Vault Name field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    Editable = false;
                }
                field("No of Approved Days"; Rec."No of Approved Days")
                {
                    ToolTip = 'Specifies the value of the No of Approved Days field.', Comment = '%';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Emp Act Type" := Rec."Emp Act Type"::"Request Allowance";
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout;
    end;

    var
        ToDateEditable, FormEditable : Boolean;
        DocumentOpen, DocumentApproved, DocumentPending : Boolean;

    local procedure SetLayout()
    var
        AssignmentMemoHeader: Record "Assignment Memo Header";
    begin
        ToDateEditable := true;
        if AssignmentMemoHeader.Get(rec."Document No.") then begin
            DocumentOpen := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Open;
            DocumentPending := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Pending;
            DocumentApproved := AssignmentMemoHeader."Approval Status" = AssignmentMemoHeader."Approval Status"::Approved;
        end;
        FormEditable := DocumentOpen;
    end;
}