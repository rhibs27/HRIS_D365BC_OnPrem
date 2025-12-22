page 50378 "Request Allowance Subform Copy"
{
    ApplicationArea = All;
    Caption = 'Request Allowance Subform Copy';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line Copy";
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

                field("Fuel Claimed (ltr)"; Rec."Fuel Claimed (ltr)")
                {
                    ToolTip = 'Specifies the value of the Fuel Claimed (ltr) field.', Comment = '%';
                }
                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
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
                    Editable = false;
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
        AllowanceTypeFilter: Code[20];
        ToDateEditable, FormEditable, AllowanceClaim : Boolean;
        DocumentOpen, DocumentApproved, DocumentPending : Boolean;
        Typefilter: Text;


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
