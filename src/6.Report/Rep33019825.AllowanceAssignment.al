report 33019825 "Allowance Assignment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019825.AllowanceAssignment.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Allowance Assignment Header"; "Allowance Assignment Header")
        {
            dataitem("Allowance Assignment Line"; "Allowance Assignment Line")
            {
                DataItemLink = "Entry No." = field("Entry No.");
                column(BranchCode_AllowanceAssignmentLine; "Allowance Assignment Line".Code)
                {
                    IncludeCaption = true;
                }
                column(BranchName_AllowanceAssignmentLine; "Allowance Assignment Line".Name)
                {
                    IncludeCaption = true;
                }
                column(EmployeeCode_AllowanceAssignmentLine; "Allowance Assignment Line"."Employee Code")
                {
                    IncludeCaption = true;
                }
                column(EmployeeName_AllowanceAssignmentLine; "Allowance Assignment Line"."Employee Name")
                {
                    IncludeCaption = true;
                }
                column(AllowanceType_AllowanceAssignmentLine; "Allowance Assignment Line"."Allowance Type")
                {
                    IncludeCaption = true;
                }
                column(NoofDays_AllowanceAssignmentLine; "Allowance Assignment Line"."No. of Days")
                {
                    IncludeCaption = true;
                }
                column(ReportTitle; ReportTitle) { }
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        ReportTitle: Label 'Allowance Assignment Report';
}
