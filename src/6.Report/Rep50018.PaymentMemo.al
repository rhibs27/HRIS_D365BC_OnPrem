report 50018 "Payment Memo"
{


    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019819.PaymentMemo.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Training Header"; "Training Header")
        {
            column(No_TrainingHeader; "Training Header"."No.") { }
            column(Description_TrainingHeader; "Training Header".Description) { }
            column(StartDate_TrainingHeader; Format("Training Header"."Start Date")) { }
            column(EndDate_TrainingHeader; Format("Training Header"."End Date")) { }
            column(Venue_TrainingHeader; "Training Header".Venue) { }
            column(Vendor_TrainingHeader; "Training Header".Vendor) { }
            column(VendorName_TrainingHeader; "Training Header"."Vendor Name") { }
            column(TotalNoofParticipant_TrainingHeader; "Training Header"."Total No. of Participant") { }
            column(ActualTrainerCost_TrainingHeader; "Training Header"."Actual Trainer Cost") { }
            column(ActualOtherCost_TrainingHeader; "Training Header"."Actual Other Cost") { }
            column(ActualTrainingCost_TrainingHeader; "Training Header"."Actual Training Cost") { }
            column(ActualTotalBudget_TrainingHeader; "Training Header"."Actual Total Budget") { }
            column(FunctionalTitle; NewFunctionalTitle) { }
            column(ApprovedDate; Format(NewApprovedDate)) { }
            column(TrainerName; NewTrainerName) { }
            column(Text1; Text1) { }
            column(ROCECode_TrainingHeader; "Training Header"."ROCE Code") { }
            column(Text002; Text002) { }
            column(Text003; Text003) { }
            column(YTDAmount_TrainingHeader; "Training Header"."YTD Amount") { }
            column(MTDAmount_TrainingHeader; "Training Header"."MTD Amount") { }
            column(YTDExpense_TrainingHeader; "Training Header"."YTD Expense") { }
            column(MTDExpense_TrainingHeader; "Training Header"."MTD Expense") { }
            column(EmployeeName; NewEmployeeName) { }
            column(PrepName; PrepName) { }
            column(PrepFntitle; PrepFntitle) { }
            column(ReviewName; ReviewName) { }
            column(ReviewFnTitle; ReviewFnTitle) { }
            column(SuppName; SuppName) { }
            column(SupportedFnTitle; SupportedFnTitle) { }
            column(SuppName1; SuppName1) { }
            column(SuppFnTitle; SuppFnTitle) { }
            dataitem("Training Line"; "Training Line")
            {
                DataItemLink = "Training No." = field("No.");
                DataItemTableView = where(Type = filter(Vendor));
                column(SN; SN) { }
                column(PaymentMode_TrainingLine; "Training Line"."Payment Mode") { }
                column(Amount_TrainingLine; "Training Line".Amount) { }
                column(VendorInvoiceNo_TrainingLine; "Training Line"."Vendor Invoice No.") { }
                column(Name_TrainingLine; "Training Line".Name) { }
                column(Type_TrainingLine; "Training Line".Type) { }

                trigger OnAfterGetRecord()
                begin
                    if "Training Line"."Vendor Invoice No." <> '' then
                        SN += 1;
                end;

                trigger OnPreDataItem()
                begin
                    SN := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Training Header".CalcFields("Training Header"."Total No. of Participant");

                //initialize variable
                FunctionalTitle := '';
                EmployeeName := '';
                ApprovedDate := '';
                TrainerName := '';
                NewApprovedDate := '';
                NewEmployeeName := '';
                NewFunctionalTitle := '';
                NewTrainerName := '';
                PrepName := '';
                PrepFntitle := '';
                ReviewName := '';
                ReviewFnTitle := '';
                SuppName := '';
                SupportedFnTitle := '';

                ApprovalEntries.Reset;
                ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                ApprovalEntries.SetRange("Document No.", "Training Header"."No.");
                if ApprovalEntries.FindSet then
                    repeat
                        Employee.Reset;
                        Employee.SetRange("NAV Login ID", ApprovalEntries."Approver ID");
                        if Employee.FindFirst then begin
                            FunctionalTitle += Employee."Functional Title" + ',';
                            EmployeeName += Employee."Full Name";
                        end;
                        ApprovedDate += Format(ApprovalEntries."Last Date-Time Modified") + ',';
                    until ApprovalEntries.Next = 0;

                TrainingLine.Reset;
                TrainingLine.SetRange("Training No.", "Training Header"."No.");
                TrainingLine.SetRange(Type, TrainingLine.Type::Trainer);
                if TrainingLine.FindFirst then
                    repeat
                        TrainerName += TrainingLine.Name + ',';
                    until TrainingLine.Next = 0;

                if StrLen(FunctionalTitle) > 0 then
                    NewFunctionalTitle := DelStr(FunctionalTitle, StrLen(FunctionalTitle), 1)
                else
                    NewFunctionalTitle := FunctionalTitle;
                if StrLen(ApprovedDate) > 0 then
                    NewApprovedDate := DelStr(ApprovedDate, StrLen(ApprovedDate), 1)
                else
                    NewApprovedDate := ApprovedDate;
                if StrLen(TrainerName) > 0 then
                    NewTrainerName := DelStr(TrainerName, StrLen(TrainerName), 1)
                else
                    NewTrainerName := TrainerName;
                if StrLen(EmployeeName) > 0 then
                    NewEmployeeName := DelStr(EmployeeName, StrLen(EmployeeName), 1)
                else
                    NewEmployeeName := EmployeeName;

                Text1 := StrSubstNo(Text001, NewFunctionalTitle, NewApprovedDate, "Training Header".Venue, NewTrainerName);

                Employee.Reset;
                Employee.SetRange("No.", "Training Header"."Prepared By");
                if Employee.FindFirst then begin
                    PrepName := Employee."Full Name";
                    PrepFntitle := Employee."Functional Title";
                end;

                Employee.Reset;
                Employee.SetRange("No.", "Training Header"."Reviewed By");
                if Employee.FindFirst then begin
                    ReviewName := Employee."Full Name";
                    ReviewFnTitle := Employee."Functional Title";
                end;

                Employee.Reset;
                Employee.SetRange("No.", "Training Header"."Supported By");
                if Employee.FindFirst then begin
                    SuppName := Employee."Full Name";
                    SupportedFnTitle := Employee."Functional Title";
                end;

                HRSetup.Get;
                Employee.Reset;
                Employee.SetRange("No.", HRSetup."HR Head Functional Title");
                if Employee.FindFirst then begin
                    SuppName1 := Employee."Full Name";
                    SuppFnTitle := Employee."Functional Title";
                end;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        ApprovalEntries: Record "Approval Entry";
        FunctionalTitle: Text;
        ApprovedDate: Text;
        Text1: Text;
        Employee: Record Employee;
        TrainingLine: Record "Training Line";
        TrainerName: Text;
        Text001: Label 'This has reference to the Training approved by %1 on %2. The program was organized at %3 and facilitated by %4.<br> The details of the training are as under:';
        EmployeeName: Text;
        NewFunctionalTitle: Text;
        NewTrainerName: Text;
        NewApprovedDate: Text;
        NewEmployeeName: Text;
        Text002: Label 'The mode of payment, name of payee and amount are given below:';
        Text003: Label 'A copy of the approval along with the Invoice of the vendor is attached herewith.';
        PrepFntitle: Text;
        ReviewFnTitle: Text;
        SupportedFnTitle: Text;
        PrepName: Text;
        ReviewName: Text;
        SuppName: Text;
        SN: Integer;
        HRSetup: Record "Human Resources Setup";
        SuppName1: Text;
        SuppFnTitle: Text;
}
