xmlport 50004 "Export Payroll"
{
    Caption = 'Export Payroll';
    Direction = Export;
    TextEncoding = UTF8;
    Format = VariableText;
    TableSeparator = '<<NewLine>>';

    schema
    {
        textelement(Root)
        {
            tableelement("Employee Ledger Entry"; "Employee Ledger Entry")
            {
                AutoReplace = true;
                XmlName = 'EmpLedgerEntry';
                fieldelement(EmpNo; "Employee Ledger Entry"."Employee No.") { }
                fieldelement(EmpPostingDate; "Employee Ledger Entry"."Posting Date") { }
                textelement(EmpBlank) { }
                fieldelement(EmpDocNo; "Employee Ledger Entry"."Document No.") { }
                fieldelement(EmpDesc; "Employee Ledger Entry".Description) { }
                fieldelement(EmpAmount; "Employee Ledger Entry".Amount) { }
                fieldelement(EmpBranchCode; "Employee Ledger Entry"."Global Dimension 1 Code") { }
                fieldelement(EmpUserID; "Employee Ledger Entry"."User ID") { }
                fieldelement(EmpDebit; "Employee Ledger Entry"."Debit Amount (LCY)") { }
                fieldelement(EmpCredit; "Employee Ledger Entry"."Credit Amount (LCY)") { }
                fieldelement(EmpCurrencyCode; "Employee Ledger Entry"."Currency Code") { }

                trigger OnAfterInitRecord()
                begin
                    if CheckFirstLine then
                        currXMLport.Skip;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //Candidate.Status:= Candidate.Status::Applied;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    trigger OnPreXmlPort()
    begin
        FirstLine := true;
    end;

    var
        FirstLine: Boolean;

    local procedure CheckFirstLine(): Boolean
    begin
        if FirstLine then begin
            FirstLine := false;
            exit(true);
        end;
    end;
}
