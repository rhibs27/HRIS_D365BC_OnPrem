report 33019881 "Staff Allowance Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019881.StaffAllowanceDetails.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }

            trigger OnAfterGetRecord()
            begin
                Counter := 1;
            end;
        }
        dataitem("Allowance Assignment Header"; "Allowance Assignment Header")
        {
            column(Type; Type) { }
            column("Code"; Code) { }
            column(Name; Name) { }
            column(Week; Week) { }
            column(EnglishMonth; "English Month") { }
            column(EnglishYear; "English Year") { }
            dataitem("Allowance Assignment Line"; "Allowance Assignment Line")
            {
                DataItemLink = "Entry No." = field("Entry No.");
                column(AllowanceType; StrSubstNo('%1 Days', "Allowance Type")) { }
                column(EmployeeCode; "Employee Code") { }
                column(EmployeeName; "Employee Name") { }
                column(Counter; Counter) { }
                column(AllowanceAmount; "Allowance Amount") { }
                column(AllowanceAmtCaption; AllowanceAmtCaption) { }

                trigger OnAfterGetRecord()
                begin
                    AllowanceAmtCaption := StrSubstNo('%1 %2', "Allowance Type", 'Amount');
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("English Month", EnglishMonth);
                SetRange("English Year", EnglishYear);
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
        Counter: Integer;
        EngNepDate: Record "English-Nepali Date";
        EnglishMonth: Enum "English Month";
        EnglishYear: Integer;
        AllowanceAmtCaption: Text;
        Title: Label 'Staff Allowance Details';
}
