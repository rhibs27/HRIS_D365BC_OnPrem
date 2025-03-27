page 50349 "Notice Card"
{
    ApplicationArea = All;
    Caption = 'Notice Card';
    PageType = Card;
    SourceTable = "Notice Bulletin";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("Notice End Date"; Rec."Notice End Date")
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }

                field("Notice Title"; Rec."Notice Title")
                {
                    Editable = EditableField;
                    ToolTip = 'Specifies the value of the Notice field.';
                    ApplicationArea = All;
                }
                field(Description; LargeText)
                {
                    Editable = EditableField;
                    Caption = 'Notice Description';
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowCaption = true;

                    trigger OnValidate()
                    begin
                        SetLargeText(LargeText);
                    end;
                }

            }
        }
        area(factboxes)
        {
            part(Control3; "Notice Picture")
            {
                Editable = EditableField;
                ApplicationArea = BasicHR;
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LargeText := GetLargeText();
    end;

    trigger OnOpenPage()
    begin
        if rec."Notice End Date" = 0D then
            EditableField := true
        else if Rec."Notice End Date" >= Today then
            EditableField := true
        else
            EditableField := false;

    end;

    var
        LargeText: text;
        EditableField: Boolean;

    procedure GetLargeText() NewLargeText: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields(Description);
        Rec.Description.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName(Description)));
    end;

    procedure SetLargeText(NewLargeText: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Description);
        Rec.Description.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(LargeText);
        Rec.Modify();
    end;
}
