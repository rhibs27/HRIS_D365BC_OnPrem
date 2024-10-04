page 50026 "Payroll Columns"
{
    // version PRM19.01.01

    Caption = 'Fields';
    Editable = false;
    PageType = List;
    SourceTable = "Field";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(TableNo; Rec.TableNo)
                {
                    Caption = 'TableNo';
                    Visible = false;
                    ToolTip = 'Specifies the value of the TableNo field.';
                    ApplicationArea = All;
                }
                field(TableName; Rec.TableName)
                {
                    Caption = 'TableName';
                    Visible = false;
                    ToolTip = 'Specifies the value of the TableName field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(FieldName; Rec.FieldName)
                {
                    Caption = 'FieldName';
                    ToolTip = 'Specifies the value of the FieldName field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Class; Rec.Class)
                {
                    Caption = 'Class';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Class field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
