report 50081 "Branch Allowance Data"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019882.BranchAllowanceData.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            dataitem("Allowance Assignment Header"; "Allowance Assignment Header")
            {
                column(EntryNo; "No.") { }
                // column("Code"; Code) { }
                // column(Name; Name) { }
                column(EnglishMonth; "English Month") { }
                column(EnglishYear; "English Year") { }
                column(Week; Week) { }
                column(EmailEMECM; EmailEMECM) { }
                column(EmailBM; EmailBM) { }
                dataitem("Allowance Assignment Line"; "Allowance Assignment Line")
                {
                    DataItemLink = "No." = field("No.");
                    column(AllowanceType; "Allowance Type") { }
                    column(Counter; Counter) { }
                }

                // trigger OnAfterGetRecord()
                // begin
                //     Clear(EmailBM);
                //     Clear(EmailEMECM);
                // FunctionalTitle.Reset;
                // FunctionalTitle.SetRange("EM/ECM Identifier", true);
                // if FunctionalTitle.Find('-') then
                //     repeat
                //         Employee.Reset;
                //         Employee.SetRange("Functional Title", FunctionalTitle.Code);
                //         Employee.SetFilter("Deputation on", Format(Type));
                //         if Type = Type::Branch then
                //             Employee.SetRange("Global Dimension 1 Code", Code)
                //         else
                //             Employee.SetRange("Extension Counter Code", Code);
                //         if Employee.Find('-') then
                //             repeat
                //                 if EmailEMECM = '' then
                //                     EmailEMECM := Employee."Company E-Mail"
                //                 else
                //                     EmailEMECM += ', ' + Employee."Company E-Mail";
                //             until Employee.Next = 0;
                //     until FunctionalTitle.Next = 0;

                // FunctionalTitle.Reset;
                // FunctionalTitle.SetRange("BM/OBM", true);
                // if FunctionalTitle.Find('-') then
                //     repeat
                //         Employee.Reset;
                //         Employee.SetRange("Functional Title", FunctionalTitle.Code);
                //         Employee.SetRange("Deputation on", Employee."Deputation on"::Branch);
                //         if Type = Type::Branch then
                //             Employee.SetRange("Global Dimension 1 Code", Code)
                //         else begin
                // EmpHie.Reset;
                // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                // EmpHie.SetRange(Code, Code);
                // EmpHie.SetRange(Blocked, false);

                // if EmpHie.FindFirst then
                //     Employee.SetRange("Global Dimension 1 Code", EmpHie."Shortcut Dimension 1 Code");
                //             end;
                //             // if EmpHie."Shortcut Dimension 1 Code" <> '' then begin
                //             if Employee.Find('-') then
                //                 repeat
                //                     if EmailBM = '' then
                //                         EmailBM := Employee."Company E-Mail"
                //                     else
                //                         EmailBM += ', ' + Employee."Company E-Mail";
                //                 until Employee.Next = 0;
                //         // end;
                //         until FunctionalTitle.Next = 0;
                // end;

                trigger OnPreDataItem()
                begin
                    SetRange("English Month", EnglishMonth);
                    SetRange("English Year", EnglishYear);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter := 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("English Year"; EnglishYear)
                {
                    ToolTip = 'Specifies the value of the EnglishYear field.';
                    ApplicationArea = All;
                }
                field("English Month"; EnglishMonth)
                {
                    ToolTip = 'Specifies the value of the EnglishMonth field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", Today);
        if EngNepDate.FindFirst then begin
            EnglishMonth := EngNepDate."English Month";
            EnglishYear := EngNepDate."English Year";
        end;
    end;

    trigger OnPreReport()
    begin
        if (EnglishMonth = EnglishMonth::" ") or (EnglishYear = 0) then
            Error('Please fill your English Month and english year');
    end;

    var
        Title: Label 'Branch Allowance Data';
        Counter: Integer;
        FunctionalTitle: Record "Functional Title";
        Employee: Record Employee;
        EmailEMECM: Text;
        EmailBM: Text;
        EngNepDate: Record "English-Nepali Date";
        EnglishMonth: Enum "English Month";
        EnglishYear: Integer;
    // EmpHie: Record "Employee Hierarchy Master";
}
