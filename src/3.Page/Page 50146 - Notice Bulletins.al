page 50146 "Notice Bulletins"
{
    PageType = List;
    SourceTable = "Notice Bulletin";
    ApplicationArea = All;
    UsageCategory = History;
    CardPageId = "Notice Card";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Notice Create Date"; Rec."Notice Create Date")
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of the Create ssDate field.';
                    ApplicationArea = All;
                }
                field("Notice End Date"; Rec."Notice End Date")
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of Notice End Date field.';
                    ApplicationArea = All;
                }
                field("Notice Title"; Rec."Notice Title")
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of the Notice field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        if rec."Notice End Date" >= Today then
            EditableField := true;
    end;

    var
        EditableField: Boolean;
}
