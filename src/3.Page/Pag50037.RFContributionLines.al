page 50037 "RF Contribution Lines"
{
    ApplicationArea = All;
    Caption = 'RF Contribution Lines';
    PageType = ListPart;
    SourceTable = "RF Contribution";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = IsCreated;
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Editable = false;
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field(type; Rec."Type")
                {
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(attributeCode; Rec."Attribute Code")
                {
                    Caption = 'Attribute Code';
                    ToolTip = 'Specifies the value of the Attribute Code field.', Comment = '%';
                }
                field(payCyclePeriod; Rec."Pay Cycle Period")
                {
                    Caption = 'Pay Cycle Period';
                    Editable = SelectMonth;
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SelectMonth := Rec.Type = Rec.Type::Manual;
    end;

    trigger OnOpenPage()
    begin
        IsCreated := (Rec."Approval Status" = rec."Approval Status"::Created) or (Rec."Approval Status" = rec."Approval Status"::Open);
    end;

    var
        SelectMonth: Boolean;
        IsCreated: Boolean;
}
