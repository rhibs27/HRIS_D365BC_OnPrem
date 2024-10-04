page 33020070 "Candidate Mob App API"
{
    // version HRM1.00,APINICASIA1.00

    EntityName = 'candidateListEntity';
    EntitySetName = 'candidateListEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Candidate;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(No; Rec."No.") { }
                field(FullName; Rec."Full Name") { }
                field(FirstName; Rec."First Name") { }
                field(MiddleName; Rec."Middle Name") { }
                field(LastName; Rec."Last Name") { }
                field(AppliedSalaryLevel; Rec."Applied Salary Level") { }
                field(Status; Rec.Status) { }
                field(Gender; Rec.Gender) { }
                field(PermanentAddress; Rec."Permanent Address") { }
                field(MobileNo; Rec."Mobile No.") { }
                field(Venue; Rec.Venue) { }
                field(AvgInverviewScore; Rec."Avg. Inverview Score") { }
                field(RecommenderRemarks; Rec."Recommender Remarks") { }
                field(CandidateRemarks; Rec."Candidate Remarks") { }
                field(WrittenScore; Rec."Written Score") { }
                field(TotalMarks; Rec."Total Marks") { }
                field(RecommenderCode; Rec."Recommender Code") { }
                field(RecommenderName; Rec."Recommender Name") { }
                field(vacancyCode; Rec."Vacancy Code") { }
                field(VacancyDescription; Rec."Vacancy Description") { }
                field(EmployeeNo; Rec."Employee No.") { }
                field(VacancyType; Rec."Vacancy Type") { }
                field(VacancyExpiryDate; Rec."Vacancy Expiry Date") { }
                field(FunctionalTitle; Rec."Functional Title") { }
                field(EMail; Rec."E-Mail") { }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        //SetControlAppearance;
    end;

    trigger OnOpenPage()
    begin
        //SetControlAppearance;
    end;

    local procedure SetControlAppearance()
    var
        Employee: Record Employee;
        Interviewer: Record Interviewer;
        VacancyNoFiliter: Text;
    begin
        Employee.Reset;
        Clear(VacancyNoFiliter);
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then;
        Interviewer.Reset;
        Interviewer.SetRange(Interviewer, Employee."No.");
        if Interviewer.Find('-') then
            repeat
                if VacancyNoFiliter = '' then
                    VacancyNoFiliter := Interviewer."Vacancy Code"
                else
                    VacancyNoFiliter += '|' + Interviewer."Vacancy Code";
            until Interviewer.Next = 0;
        if VacancyNoFiliter <> '' then
            Rec.SetFilter("Vacancy Code", VacancyNoFiliter)
        else
            Rec.SetRange("Vacancy Code", VacancyNoFiliter);
    end;
}
