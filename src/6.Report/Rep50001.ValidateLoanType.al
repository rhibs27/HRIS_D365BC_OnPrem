report 50001 "Validate Loan Type"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        LoanOutstanding.Reset;
        if LoanOutstanding.Find('-') then
            repeat
                LoanOutstanding.Validate("Outstanding Amount", Abs(LoanOutstanding."Outstanding Amount"));
                LoanOutstanding.Modify;
            until LoanOutstanding.Next = 0;
        Message('Done');
    end;

    var
        LoanOutstanding: Record "Loan Outstanding from Finacle";
}
