page 50015 "Training Calendar Lists"
{
    // version NIC Asia1.00,Training

    PageType = List;
    SourceTable = "Training Calendar";
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Training Master code"; Rec."Training Master code")
                {
                    ToolTip = 'Specifies the value of the Training Master code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("Sub-Province"; Rec."Sub-Province")
                {
                    ToolTip = 'Specifies the value of the Sub-Province field.';
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
                field("Resouce person"; Rec."Resouce person")
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
                field("Training Type"; Rec."Training Type")
                {
                    ToolTip = 'Specifies the value of the Training Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
