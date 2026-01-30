page 50385 "Eligible Appraisal Employee"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Appraisal Employee";
    UsageCategory = Administration;
    Caption = 'Eligible Appraisal Employee';
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;

                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sub-Unit Code"; Rec."Sub-Unit Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Employee No.");
    end;
}