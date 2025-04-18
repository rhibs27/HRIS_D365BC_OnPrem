page 50132 "Language Proficiency"
{
    ApplicationArea = All;
    Caption = 'Language Proficiency';
    DataCaptionFields = "Employee Code";
    PageType = List;
    SourceTable = "Language Proficiency";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
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
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Language: Record "Language Proficiency";
    begin
        Language.Reset();
        Language.SetRange("Employee Code", Rec."Employee Code");
        Language.SetRange(Language, '');
        if Language.FindFirst() then
            Error('Language is blank for %1 in %2 Line.Delete This Line First', Language."Employee Code", Language."Line No.");
    end;
}