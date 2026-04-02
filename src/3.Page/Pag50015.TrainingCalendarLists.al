page 50015 "Training Calendar Lists"
{
    PageType = List;
    SourceTable = "Training Calendar";
    CardPageId = "Training Calendar Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Training Master code"; Rec."Master Code")
                {
                    ToolTip = 'Specifies the value of the Training Master code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec."Master Description")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ToolTip = 'Specifies the value of the Quarter field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("Coverage Branch"; Rec."Coverage Branch")
                {
                    ToolTip = 'Specifies the value of the Coverage Branch field.';
                    ApplicationArea = All;
                }
                field("Coverage Department"; Rec."Coverage Department")
                {
                    ToolTip = 'Specifies the value of the Coverage Department field.';
                    ApplicationArea = All;
                }
                field("Coverage Functional Title"; Rec."Coverage Functional Title")
                {
                    ToolTip = 'Specifies the value of the Coverage Functional Title field.';
                    ApplicationArea = All;
                }
                field(Valley; Rec.Valley)
                {
                    ToolTip = 'Specifies the value of the Valley field.';
                    ApplicationArea = All;
                }
                field("Resource person"; Rec."Resource person")
                {
                    ToolTip = 'Specifies the value of the Resouce person field.';
                    ApplicationArea = All;
                }
                field(District; Rec.District)
                {
                    Caption = 'Expected Venue';
                    ToolTip = 'Specifies the value of the Expected Venue field.';
                    ApplicationArea = All;
                }
                field("Minimum Participant"; Rec."Minimum Participant")
                {
                    ToolTip = 'Specifies the value of the Minimum Participant field.';
                    ApplicationArea = All;
                }
                field("Maximum Participant"; Rec."Maximum Participant")
                {
                    ToolTip = 'Specifies the value of the Maximum Participant field.';
                    ApplicationArea = All;
                }
                field("Function"; Rec."Function")
                {
                    ToolTip = 'Specifies the value of the Function field.';
                    ApplicationArea = All;
                }
                field("Training Cost"; Rec."Training Cost")
                {
                    ToolTip = 'Specifies the value of the Training Cost field.';
                    ApplicationArea = All;
                }
                field("Trainer Cost"; Rec."Trainer Cost")
                {
                    ToolTip = 'Specifies the value of the Trainer Cost field.';
                    ApplicationArea = All;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                    ApplicationArea = All;
                }
                field("Training Nature"; Rec."Training Nature")
                {
                    ToolTip = 'Specifies the value of the Training Nature field.';
                    ApplicationArea = All;
                }
                field("Training Institute Name"; Rec."Training Institute Name")
                {
                    ToolTip = 'Specifies the Training Institute Name.';
                    ApplicationArea = All;
                }
                field("Training Category"; Rec."Training Category")
                {
                    ToolTip = 'Specifies the Training Category.';
                    ApplicationArea = All;
                }
                field("Training Module"; Rec."Training Module")
                {
                    ToolTip = 'Specifies the Training Module.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Type")
                {
                    ToolTip = 'Specifies the Training Type.';
                    ApplicationArea = All;
                }
                field("Training Mode"; Rec."Training Mode")
                {
                    ToolTip = 'Specifies the Training Mode.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
