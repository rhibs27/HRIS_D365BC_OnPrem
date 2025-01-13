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
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("Notice Title"; Rec."Notice Title")
                {
                    ToolTip = 'Specifies the value of the Notice field.';
                    ApplicationArea = All;
                }
                field(Description; LargeText)
                {
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
                ApplicationArea = BasicHR;
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LargeText := GetLargeText();
    end;

    var
        LargeText: text;

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
