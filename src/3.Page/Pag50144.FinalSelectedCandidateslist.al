page 50144 "Final Selected Candidates list"
{
    PageType = List;
    SourceTable = Candidate;
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
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the value of the Initials field.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Permanent Address"; Rec."Permanent Address")
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the value of the County field.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.';
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Vacancy Code"; Rec."Vacancy Code")
                {
                    ToolTip = 'Specifies the value of the Vacancy Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Offer_Letter)
            {
                Caption = 'Offer Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Offer Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    CandidateRec: Record Candidate;
                begin
                    CandidateRec.Reset;
                    CandidateRec.SetRange("No.", Rec."No.");
                    if CandidateRec.FindFirst then
                        Report.Run(70003, true, false, CandidateRec);
                end;
            }
            action(Appointment_Letter)
            {
                Caption = 'Appointment Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Appointment Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    CandidateRec: Record Candidate;
                begin
                    CandidateRec.Reset;
                    CandidateRec.SetRange("No.", Rec."No.");
                    if CandidateRec.FindFirst then
                        Report.Run(70004, true, false, CandidateRec);
                end;
            }
            action("Send Offer Letter")
            {
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Send Offer Letter action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Candidate: Record Candidate;
                begin
                    Candidate.Reset;
                    CurrPage.SetSelectionFilter(Candidate);
                    if Candidate.FindFirst then
                        repeat
                            HRMgt.SendOfferLetter(Rec."Vacancy Code", Candidate);
                        until Candidate.Next = 0;
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
