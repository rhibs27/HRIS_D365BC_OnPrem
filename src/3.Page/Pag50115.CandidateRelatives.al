page 50115 "Candidate Relatives"
{
    AutoSplitKey = true;
    Caption = 'Employee Relatives';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Employee Relative";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Relative Code"; Rec."Relative Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a relative code for the employee.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first name of the employee''s relative.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the middle name of the employee''s relative.';
                    Visible = true;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the relative''s date of birth.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the relative''s telephone number.';
                }
                // field(Relation; Rec.Relation)
                // {
                //     ToolTip = 'Specifies the value of the Relation field.';
                //     ApplicationArea = All;
                // }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies if a comment was entered for this entry.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Relative")
            {
                Caption = '&Relative';
                Image = Relatives;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Employee Relative"),
                                  "No." = field("Employee No."),
                                  "Table Line No." = field("Line No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Validate("Master Type", Rec."Master Type"::Candidate);
    end;
}
