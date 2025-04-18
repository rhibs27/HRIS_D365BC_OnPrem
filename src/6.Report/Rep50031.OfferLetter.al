report 50031 "Offer Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019832.OfferLetter.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            column(No_Candidate; Candidate."No.") { }
            column(FirstName_Candidate; Candidate."First Name") { }
            column(MiddleName_Candidate; Candidate."Middle Name") { }
            column(LastName_Candidate; Candidate."Last Name") { }
            column(Initials_Candidate; Candidate.Initials) { }
            column(JobGrade; Candidate."Job Title") { }
            column(OfferNo_Candidate; ReportNo) { }
            column(OfferDate_Candidate; OfferDate) { }
            column(EmploymentType_Candidate; Candidate."Employment Type") { }
            column(Address_Candidate; Candidate."Address 2") { }
            column(BasicSalary; SalaryLevelRec."Basic Salary") { }
            column(Allowance; SalaryLevelRec.Allowance) { }
            column(RefNo; VacancyRec."Reference No.") { }
            column(FullName; CandidateFullName) { }
            column(AmountInTextSalary; AmountInText[1] + '  ' + AmountInText[2]) { }
            column(Salary; Salary) { }
            column(FoodingAmt; SalaryLevelRec."Nepal Fooding Allowance") { }
            column(LodgingAmt; SalaryLevelRec."Nepal Lodging Allowance") { }
            column(OutOfPocket; SalaryLevelRec."Out of Pocket Expense(Nepal)") { }
            column(TotalAmoutnInTxt; TotalAmtInTxt[1] + ' ' + TotalAmtInTxt[2]) { }
            column(CEOName; EmpVar."Full Name") { }

            trigger OnAfterGetRecord()
            begin
                Clear(SalaryLevelRec);
                SalaryLevelRec.Get(Candidate."Applied Salary Level");
                VacancyRec.Get("Vacancy Code");
                //CLEAR(FullName);
                CandidateFullName := GetCandidateFullName();
                InitTextVariable;
                FormatNoText(AmountInText, Candidate.Salary, '');
                FormatNoText(TotalAmtInTxt, SalaryLevelRec."Basic Salary" + SalaryLevelRec.Allowance, '');
                /*
                IF NOT CurrReport.PREVIEW THEN BEGIN
                  IF NOT Candidate."Offer Letter Printed" THEN BEGIN
                    HRSetup.TESTFIELD("Offer No.");
                    ReportNo := NoSeries.GetNextNo(HRSetup."Offer No.", TODAY, TRUE);
                    OfferDate := TODAY;
                    Candidate."Offer No." := ReportNo;
                    Candidate."Offer Letter Printed" := TRUE;
                    Candidate.MODIFY;
                  END
                  ELSE BEGIN
                    ReportNo := Candidate."Offer No.";
                    OfferDate := Candidate."Offer Date";
                  END;
                END;
                */
            end;

            trigger OnPreDataItem()
            begin
                HRSetup.Get;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        EmpVar.Reset;
        EmpVar.SetRange("Salary Level", 'CEO');
        if EmpVar.FindFirst then;
    end;

    var
        SalaryLevelRec: Record "Salary Level";
        ReportNo: Code[20];
        OfferDate: Date;
        HRSetup: Record "Human Resources Setup";
        VacancyRec: Record "Vacancy Header";
        CandidateFullName: Text;
        Text026: Label 'Zero';
        Text027: Label 'Hundred';
        Text028: Label 'And';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'One';
        Text033: Label 'Two';
        Text034: Label 'Three';
        Text035: Label 'Four';
        Text036: Label 'Five';
        Text037: Label 'Six';
        Text038: Label 'Seven';
        Text039: Label 'Eight';
        Text040: Label 'Nine';
        Text041: Label 'Ten';
        Text042: Label 'Eleven';
        Text043: Label 'Twelve';
        Text044: Label 'Thirteen';
        Text045: Label 'Fourteen';
        Text046: Label 'Fifteen';
        Text047: Label 'Sixteen';
        Text048: Label 'Seventeen';
        Text049: Label 'Eighteen';
        Text050: Label 'Nineteen';
        Text051: Label 'Twenty';
        Text052: Label 'Thirty';
        Text053: Label 'Forty';
        Text054: Label 'Fifty';
        Text055: Label 'Sixty';
        Text056: Label 'Seventy';
        Text057: Label 'Eighty';
        Text058: Label 'Ninety';
        Text1280000: Label 'Lakh';
        Text1280001: Label 'Crore';
        Text059: Label 'Thousand';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        AmountInText: array[2] of Text;
        TotalAmtInTxt: array[2] of Text;
        EmpVar: Record Employee;

    local procedure GetCandidateFullName(): Text
    begin
        if Candidate."Middle Name" = '' then
            exit(Candidate."First Name" + ' ' + Candidate."Last Name")
        else
            exit(Candidate."First Name" + ' ' + Candidate."Middle Name" + ' ' + Candidate."Last Name");
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No div (Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No div Power(1000, Exponent - 1);
                    Hundreds := Ones div 100;
                end;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Ruppes');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        // AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10 div 1;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, '')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' Paisa Only');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text1280000;
        ExponentText[4] := Text1280001;
    end;
}
