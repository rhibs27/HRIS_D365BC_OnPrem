report 33019848 "Emp Loan Outstanding Update"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where("Employment Type" = const(Permanent), Status = const(Active));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                //IF UpdateOutstanding THEN
                //LoanMgt.GetOutstandingEmployeeLoanDetails("No.","CIF ID");
                //UpdateLoanOustanding;

                //LoanMgt.SetJSONAPI("CIF ID", "No.");
                UpdatedEmployee += 1;
                MyDialog.Update;
            end;

            trigger OnPostDataItem()
            begin
                MyDialog.Close;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Status, Status::Active);
                SetFilter("No.", EmployeeFilter);
                UpdatedEmployee := 0;
                TotalEmployee := Employee.Count;
                MyDialog.Open('Updating @1@@@@', UpdatedEmployee, TotalEmployee);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                field("Employee No. Filter"; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        MyDialog: Dialog;
        UpdatedEmployee: Integer;
        EmployeeFilter: Text;
        TotalEmployee: Integer;

    // local procedure UpdateLoanOustanding()
    // var
    //     LoanOutstanding: Record "Loan Outstanding from Finacle";
    // begin
    //     LoanOutstanding.Reset;
    //     LoanOutstanding.SetRange("Employee No.", Employee."No.");
    //     if LoanOutstanding.Find('-') then
    //         repeat
    //             if UpdateLoanLimit then
    //                 LoanMgt.GetEmployeeLoanLimitDetails(LoanOutstanding."Account ID");
    //             if UpdateLoanEMI then
    //                 LoanMgt.GetEmployeeLoanEMIDetails(LoanOutstanding."Account ID");
    //         until LoanOutstanding.Next = 0;
    // end;
}
