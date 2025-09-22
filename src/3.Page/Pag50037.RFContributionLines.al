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

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.', Comment = '%';
                }
                field("Nepali Month "; Rec."Nepali Month ")
                {
                    Editable = SelectMonth;
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SelectMonth := Rec.Type = Rec.Type::Manual;
    end;

    var
        SelectMonth: Boolean;
}
