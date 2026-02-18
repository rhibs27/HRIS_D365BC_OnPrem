page 50362 "Grievance Comment Subform"
{
    PageType = ListPart;
    SourceTable = "Grievance Comment";
    ApplicationArea = All;
    Caption = 'Comments';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Comment Date"; Rec."Comment Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date and time the comment was added.';
                    ApplicationArea = All;
                }
                field("Commented By"; Rec."Commented By")
                {
                    Editable = false;
                    ToolTip = 'Specifies the employee who added the comment.';
                    ApplicationArea = All;
                }
                field("Commented By Name"; Rec."Commented By Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee who added the comment.';
                    ApplicationArea = All;
                }
                field(Role; Rec.Role)
                {
                    Editable = false;
                    ToolTip = 'Specifies the role of the person who commented.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    Editable = false;
                    ToolTip = 'Specifies the comment text.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
