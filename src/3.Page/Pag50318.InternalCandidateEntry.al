page 50318 "Internal Candidate Entry"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'internalCandidateEntry';
    DelayedInsert = true;
    EntityName = 'internalCandidateList';
    EntitySetName = 'internalCandidateLists';
    PageType = API;
    SourceTable = Candidate;
    SourceTableView = where("Candidate Type" = const(Internal));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(fullName; Rec."Full Name")
                {
                    Caption = 'Full Name';
                }
                field(appliedSalaryLevel; Rec."Applied Salary Level")
                {
                    Caption = 'Applied Salary Level';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(gender; Rec.Gender)
                {
                    Caption = 'Gender';
                }
                field(permanentAddress; Rec."Permanent Address")
                {
                    Caption = 'Address';
                }
                field(mobileNo; Rec."Mobile No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                field(venue; Rec.Venue)
                {
                    Caption = 'Venue';
                }
                field(avgInverviewScore; Rec."Avg. Inverview Score")
                {
                    Caption = 'Avg. Inverview Score';
                }
                field(recommenderRemarks; Rec."Recommender Remarks")
                {
                    Caption = 'Recommender Remarks';
                }
                field(candidateRemarks; Rec."Candidate Remarks")
                {
                    Caption = 'Candidate Remarks';
                }
                field(writtenScore; Rec."Written Score")
                {
                    Caption = 'Written Score';
                }
                field(totalMarks; Rec."Total Marks")
                {
                    Caption = 'Total Marks';
                }
                field(recommenderCode; Rec."Recommender Code")
                {
                    Caption = 'Recommender Code';
                }
                field(recommenderName; Rec."Recommender Name")
                {
                    Caption = 'Recommender Name';
                }
                field(vacancyCode; Rec."Vacancy Code")
                {
                    Caption = 'Vacancy Code';
                }
                field(vacancyDescription; Rec."Vacancy Description")
                {
                    Caption = 'Vacancy Description';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(vacancyType; Rec."Vacancy Type")
                {
                    Caption = 'Vacancy Type';
                }
                field(vacancyExpiryDate; Rec."Vacancy Expiry Date")
                {
                    Caption = 'Vacancy Expiry Date';
                }
                field(functionalTitle; Rec."Functional Title")
                {
                    Caption = 'Functional Title';
                }
            }
        }
    }
}
