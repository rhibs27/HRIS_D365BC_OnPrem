page 33019928 "Evaluation Attributes"
{
    // version HRM1.00

    DelayedInsert = true;
    PageType = List;
    SourceTable = "Evaluation Attribute";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Attribute Type"; Rec."Attribute Type")
                {
                    ToolTip = 'Specifies the value of the Attribute Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = All;
                }
                field("Full Marks"; Rec."Full Marks")
                {
                    ToolTip = 'Specifies the value of the Full Marks field.';
                    ApplicationArea = All;
                }
                field(PassMarks; Rec.PassMarks)
                {
                    ToolTip = 'Specifies the value of the PassMarks field.';
                    ApplicationArea = All;
                }
                field("Is Remarks"; Rec."Is Remarks")
                {
                    ToolTip = 'Specifies the value of the Is Remarks field.';
                    ApplicationArea = All;
                }
                field("Is Remarks Options"; Rec."Is Remarks Options")
                {
                    ToolTip = 'Specifies the value of the Is Remarks Options field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
