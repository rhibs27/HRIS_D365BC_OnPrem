page 50166 "Emp Edit Language Prof Subform"
{
    ApplicationArea = All;
    Caption = 'Emp Edit Language Prof Subform';
    PageType = ListPart;
    SourceTable = "Employee Edit Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.', Comment = '%';
                }
                field(Reading; Rec.Reading)
                {
                    ToolTip = 'Specifies the value of the Reading field.', Comment = '%';
                }
                field(Writing; Rec.Writing)
                {
                    ToolTip = 'Specifies the value of the Writing field.', Comment = '%';
                }
                field(Speaking; Rec.Speaking)
                {
                    ToolTip = 'Specifies the value of the Speaking field.', Comment = '%';
                }
                field(Typing; Rec.Typing)
                {
                    ToolTip = 'Specifies the value of the Typing field.', Comment = '%';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Change in Emp Type" := Rec."Change in Emp Type"::Language;
    end;

    var
        PreviewAttachment: Page "Preview Attachment";

}
