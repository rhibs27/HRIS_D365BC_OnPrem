page 50322 "Maker Checker Subform"
{
    ApplicationArea = All;
    Caption = 'Maker Checker Subform';
    PageType = ListPart;
    SourceTable = "Change Log Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Primary Key Field 1 Value"; Rec."Primary Key Field 1 Value")
                {
                    ToolTip = 'Specifies the value of the first primary key for the changed field.';
                    ApplicationArea = All;
                }
                field("Primary Key Field 2 Value"; Rec."Primary Key Field 2 Value")
                {
                    ToolTip = 'Specifies the value of the second primary key for the changed field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the field number of the changed field.';
                    ApplicationArea = All;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the field caption of the changed field.';
                    ApplicationArea = All;
                }
                field("Type of Change"; Rec."Type of Change")
                {
                    ToolTip = 'Specifies the type of change made to the field.';
                    ApplicationArea = All;
                }
                field("Old Value"; Rec."Old Value")
                {
                    ToolTip = 'Specifies the value that the field had before a user made changes to the field.';
                    ApplicationArea = All;
                }
                field("New Value"; Rec."New Value")
                {
                    ToolTip = 'Specifies the value that the field had after a user made changes to the field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    local procedure GetCaption(PrimaryKeyNo: Integer): Text;
    begin
        case PrimaryKeyNo of
            1:
                begin
                    Rec.CalcFields("Primary Key Field 1 Caption");
                    exit(Rec."Primary Key Field 1 Caption");
                end;
            2:
                begin
                    Rec.CalcFields("Primary Key Field 2 Caption");
                    exit(Rec."Primary Key Field 2 Caption");
                end;
            3:
                begin
                    Rec.CalcFields("Primary Key Field 3 Caption");
                    exit(Rec."Primary Key Field 3 Caption");
                end;
        end;
    end;
}
