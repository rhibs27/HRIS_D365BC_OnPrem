page 33020049 "BoDEod Entity"
{
    // version APINICASIA1.00

    EntityName = 'boDEodEntity';
    EntitySetName = 'boDEodEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "BOD-EOD Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EmployeeNo; Rec."Employee No.") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(EODBODDate; Rec."EOD/BOD Date") { }
                field(ReviewerCode; Rec."Reviewer Code") { }
                field(ReviewerName; Rec."Reviewer Name") { }
                field(CreatedDateTime; Rec."Created DateTime") { }
                field(BODStatus; Rec."BOD-Status") { }
                field(EODStatus; Rec."EOD-Status") { }
                field(DeputationOn; Rec."Deputation On") { }
                field(ProvinceName; Rec."Province Name") { }
                field(BranchName; Rec."Branch Name") { }
                field(SubProvinceName; Rec."Sub-Province Name") { }
                field(DepartmentName; Rec."Department Name") { }
                field(FunctionalTitleDescription; Rec."Functional Title Description") { }
                field(UnitName; Rec."Unit Name") { }
                field(ExtensionCounterName; Rec."Extension Counter Name") { }
                field(IsPendingReview; Rec."Is Pending Review") { }
                field(BODRemarks; Rec."BOD Remarks") { }
                field(EODRemarks; Rec."EOD Remarks") { }
                part(boDEodSubforms; "EOD/BOD Subform")
                {
                    EntityName = 'boDEodSubform';
                    EntitySetName = 'boDEodSubforms';
                    SubPageLink = "Entry No" = field("Entry No.");
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Error('EOD/BOD has not been live.Please go to izone to fill EOD/BOD.');
    end;
}
