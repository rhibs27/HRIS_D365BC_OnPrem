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
                field(commentDate; Rec."Comment Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date and time the comment was added.';
                    ApplicationArea = All;
                    Caption = 'Comment Date';
                }
                field(commentedBy; Rec."Commented By")
                {
                    Editable = false;
                    ToolTip = 'Specifies the employee who added the comment.';
                    ApplicationArea = All;
                    Caption = 'Commented By';
                }
                field(commentedByName; Rec."Commented By Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee who added the comment.';
                    ApplicationArea = All;
                    Caption = 'Commented By Name';
                }
                field(role; Rec.Role)
                {
                    Editable = false;
                    ToolTip = 'Specifies the role of the person who commented.';
                    ApplicationArea = All;
                    Caption = 'Role';
                }
                field(comment; Rec.Comment)
                {
                    Editable = false;
                    ToolTip = 'Specifies the comment text.';
                    ApplicationArea = All;
                    Caption = 'Comment';
                }
            }
        }
    }
}
