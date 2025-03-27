page 50134 References
{
    ApplicationArea = All;
    Caption = 'References';
    PageType = List;
    SourceTable = References;
    UsageCategory = None;
    AutoSplitKey = true;
    DataCaptionFields = "Employee Code";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reference Name"; Rec."Reference Name")
                {
                    ToolTip = 'Specifies the value of the Reference Name field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Known Since"; Rec."Known Since")
                {
                    Caption = 'Known Since(Years)';
                    ToolTip = 'Specifies the value of the Known Since field.', Comment = '%';
                }
                field(Occupation; Rec.Occupation)
                {
                    ToolTip = 'Specifies the value of the Occupation field.', Comment = '%';
                }
                field("Contact No"; Rec."Contact No")
                {
                    ToolTip = 'Specifies the value of the Contact No field.', Comment = '%';
                }
                field("Email Address"; Rec."Email Address")
                {
                    ToolTip = 'Specifies the value of the Email Address field.', Comment = '%';
                }
            }
        }
    }
}
