page 50121 "Vacancy Lines"
{
    // version HRM1.00

    InsertAllowed = true;
    PageType = ListPart;
    SourceTable = Candidate;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vacancy Code"; Rec."Vacancy Code")
                {
                    ToolTip = 'Specifies the value of the Vacancy Code field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.';
                    ApplicationArea = All;
                }
                field("Job Position Type"; Rec."Job Position Type")
                {
                    ToolTip = 'Specifies the value of the Job Position Type field.';
                    ApplicationArea = All;
                }
                field("Recruitement Status"; Rec."Recruitement Status")
                {
                    ToolTip = 'Specifies the value of the Recruitement Status field.';
                    ApplicationArea = All;
                }
                field("Applied Salary Level"; Rec."Applied Salary Level")
                {
                    ToolTip = 'Specifies the value of the Applied Salary Level field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Convert To Employee")
            {
                Image = AddContacts;
                ToolTip = 'Executes the Convert To Employee action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ConvertToEmployee;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Vacancy Code", '<>%1', '');
    end;
}
