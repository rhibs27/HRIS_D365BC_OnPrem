page 33019916 "Candidate Card"
{
    PageType = Card;
    SourceTable = Candidate;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    Importance = Promoted;
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ToolTip = 'Specifies the value of the Employment Type field.';
                    ApplicationArea = All;
                }
                field("Candidate Type"; Rec."Candidate Type")
                {
                    ToolTip = 'Specifies the value of the Candidate Type field.';
                    ApplicationArea = All;
                }
                field(Salary; Rec.Salary)
                {
                    ToolTip = 'Specifies the value of the Salary field.';
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Mobile No."; Rec."Mobile No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Birth Date field.';
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
                field("Vacancy Code"; Rec."Vacancy Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vacancy Code field.';
                    ApplicationArea = All;
                }
                field("Applied Salary Level"; Rec."Applied Salary Level")
                {
                    ToolTip = 'Specifies the value of the Applied Salary Level field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    Caption = 'Applied Functional Tiltle';
                    ToolTip = 'Specifies the value of the Applied Functional Tiltle field.';
                    ApplicationArea = All;
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
                {
                    ToolTip = 'Specifies the value of the Venue field.';
                    ApplicationArea = All;
                }
                field(Rank; Rec.Rank)
                {
                    ToolTip = 'Specifies the value of the Rank field.';
                    ApplicationArea = All;
                }
                field("Commercial Banking Experience"; Rec."Commercial Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Commercial Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Development Banking Experience"; Rec."Development Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Development Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Offer Letter Printed"; Rec."Offer Letter Printed")
                {
                    ToolTip = 'Specifies the value of the Offer Letter Printed field.';
                    ApplicationArea = All;
                }
                field("Application Letter Printed"; Rec."Application Letter Printed")
                {
                    ToolTip = 'Specifies the value of the Application Letter Printed field.';
                    ApplicationArea = All;
                }
                field("Avg. Inverview Score"; Rec."Avg. Inverview Score")
                {
                    ToolTip = 'Specifies the value of the Avg. Inverview Score field.';
                    ApplicationArea = All;
                }
            }
            group("Recommender Details")
            {
                field("Recommender Code"; Rec."Recommender Code")
                {
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Recommender Name"; Rec."Recommender Name")
                {
                    ToolTip = 'Specifies the value of the Recommender Name field.';
                    ApplicationArea = All;
                }
            }
            group("Education and work")
            {
                field("Job Grade in Present Company"; Rec."Job Grade in Present Company")
                {
                    ToolTip = 'Specifies the value of the Job Grade in Present Company field.';
                    ApplicationArea = All;
                }
                field("Masters Degree Received"; Rec."Masters Degree Received")
                {
                    ToolTip = 'Specifies the value of the Masters Degree Received field.';
                    ApplicationArea = All;
                }
                field("Possess Masters transcript"; Rec."Possess Masters transcript")
                {
                    ToolTip = 'Specifies the value of the Possess Masters transcript field.';
                    ApplicationArea = All;
                }
                field("Bachelors Degree Received"; Rec."Bachelors Degree Received")
                {
                    ToolTip = 'Specifies the value of the Bachelors Degree Received field.';
                    ApplicationArea = All;
                }
            }
            group("Family Details")
            {
                Visible = false;
                field("Fathers Name"; Rec."Fathers Name")
                {
                    ToolTip = 'Specifies the value of the Fathers Name field.';
                    ApplicationArea = All;
                }
                field("Mothers Name"; Rec."Mothers Name")
                {
                    ToolTip = 'Specifies the value of the Mothers Name field.';
                    ApplicationArea = All;
                }
            }
            group(References)
            {
                field("Reference Full Name"; Rec."Reference Full Name")
                {
                    ToolTip = 'Specifies the value of the Reference Full Name field.';
                    ApplicationArea = All;
                }
                field("Reference Full Address"; Rec."Reference Full Address")
                {
                    ToolTip = 'Specifies the value of the Reference Full Address field.';
                    ApplicationArea = All;
                }
                field("Reference Relation"; Rec."Reference Relation")
                {
                    ToolTip = 'Specifies the value of the Reference Relation field.';
                    ApplicationArea = All;
                }
                field("Tel/Mob. No."; Rec."Tel/Mob. No.")
                {
                    ToolTip = 'Specifies the value of the Tel/Mob. No. field.';
                    ApplicationArea = All;
                }
                field("Refernce Name Of Organization"; Rec."Refernce Name Of Organization")
                {
                    ToolTip = 'Specifies the value of the Refernce Name Of Organization field.';
                    ApplicationArea = All;
                }
                group(Control75)
                {
                    ShowCaption = false;
                }
            }
            group(Interview)
            {
                field("Interview Time"; Rec."Interview Time")
                {
                    ToolTip = 'Specifies the value of the Interview Time field.';
                    ApplicationArea = All;
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ToolTip = 'Specifies the value of the Interview Date field.';
                    ApplicationArea = All;
                }
                field("Offer Date"; Rec."Offer Date")
                {
                    ToolTip = 'Specifies the value of the Offer Date field.';
                    ApplicationArea = All;
                }
            }
            group(Approval) { }
            part(Control11; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
        area(FactBoxes)
        {
            systempart(Control2; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1; Notes)
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
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const(Employee),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
                    ApplicationArea = All;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = page "Default Dimensions";
                    RunPageLink = "Table ID" = const(5200),
                                  "No." = field("No.");
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    ApplicationArea = All;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = page "Employee Picture";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the &Picture action.';
                    ApplicationArea = All;
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = page "Alternative Address List";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the &Alternative Addresses action.';
                    ApplicationArea = All;
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = page "Candidate Relatives";
                    RunPageLink = "Employee No." = field("No."),
                                  "Master Type" = const(Candidate);
                    ToolTip = 'Executes the &Relatives action.';
                    ApplicationArea = All;
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = page "Misc. Article Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Mi&sc. Article Information action.';
                    ApplicationArea = All;
                }
                action("&Confidential Information")
                {
                    Caption = '&Confidential Information';
                    Image = Lock;
                    RunObject = page "Confidential Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the &Confidential Information action.';
                    ApplicationArea = All;
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = page "Employee Absences";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the A&bsences action.';
                    ApplicationArea = All;
                }
                separator(Separator24) { }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = page "Empl. Absences by Categories";
                    RunPageLink = "No." = field("No."),
                                  "Employee No. Filter" = field("No.");
                    ToolTip = 'Executes the Absences by Ca&tegories action.';
                    ApplicationArea = All;
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = page "Misc. Articles Overview";
                    ToolTip = 'Executes the Misc. Articles &Overview action.';
                    ApplicationArea = All;
                }
                action("Co&nfidential Info. Overview")
                {
                    Caption = 'Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = page "Confidential Info. Overview";
                    ToolTip = 'Executes the Co&nfidential Info. Overview action.';
                    ApplicationArea = All;
                }
                separator(Separator19) { }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'Executes the Online Map action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                action("Send Approval")
                {
                    ToolTip = 'Executes the Send Approval action.';
                    ApplicationArea = All;
                }
                action(Post)
                {
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;
                }
            }
            action("Offer Letter Accepted")
            {
                Image = Status;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Offer Letter Accepted action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Did the candidate accepted the offer letter?') then begin
                        Rec.TestField(Status, Rec.Status::"Offer Letter Sent");
                        Rec.Status := Rec.Status::"Offer Letter Accepted";
                        Rec.Modify;
                        Message('Offer letter accepted.');
                    end;
                end;
            }
            action("Show Written Exam Entries")
            {
                Image = WIPEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Written Exam Entries action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.ShowWrittenExamEntries(Rec."Vacancy Code", Rec."No.");
                end;
            }
            action("Show Group Discussion Entires")
            {
                Image = WIPEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Group Discussion Entires action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.ShowGroupDiscussionEntries(Rec."Vacancy Code", Rec."No.");
                end;
            }
            action("Show Interview Entries")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Interview Entries action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.ShowInterviewerEntries(Rec."Vacancy Code", Rec."No.");
                end;
            }
            action("Q&ualifications")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Q&ualifications';
                Image = Certificate;
                RunObject = page "Employee Qualifications";
                RunPageLink = "Employee No." = field("No."),
                              "Emp Qualification Type" = const(Education),
                              "Master Type" = const(Candidate);
                ToolTip = 'Open the list of qualifications that are registered for the employee.';
            }
            action("Employee Work Experience")
            {
                Caption = 'Work Experience';
                Image = Certificate;
                RunObject = page "Employee Work Qualification";
                RunPageLink = "Employee No." = field("No."),
                              "Emp Qualification Type" = const(Work),
                              "Master Type" = const(Candidate);
                ToolTip = 'Executes the Work Experience action.';
                ApplicationArea = All;
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = Reports;
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
                            Report.Run(Report::"Offer Letter2", true, false, CandidateRec);
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
                            Report.Run(Report::"Appointment Letter", true, false, CandidateRec);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GetVacancyCode;
    end;

    trigger OnOpenPage()
    begin
        FieldVisible := Rec."Candidate Type" = Rec."Candidate Type"::Internal;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        FieldVisible: Boolean;
        VacancyVar: Record "Vacancy Header";

    local procedure GetVacancyCode()
    var
        VacancyFilter: Text;
    begin
        Rec.FilterGroup(2);
        VacancyFilter := Rec.GetFilter("Vacancy Code");
        Rec.FilterGroup(0);
        VacancyVar.Get(VacancyFilter);
        VacancyVar.TestField(Status, VacancyVar.Status::Applied);
        Rec."Vacancy Code" := VacancyFilter;
        Rec.Status := Rec.Status::Applied;
    end;
}
