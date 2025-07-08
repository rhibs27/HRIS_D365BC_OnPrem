codeunit 50013 "KPI Setup Indent"
{
    // version KPI1.00

    trigger OnRun()
    begin
        if not
           Confirm(
             Text000 +
             Text001 +
             Text003, true)
        then
            exit;
        //KPISetup.SETRANGE("KPI Code","KPI Code");
        Indent;
    end;

    var
        Text000: Label 'This function updates the indentation of all the KPI''s Having KRA Category. ';
        Text001: Label 'KRA Are indented according to the category and subcategory';
        Text003: Label '\\Do you want to indent KPI Setup?';
        Text004: Label 'Indenting the KPI''s Setup #1##########';
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        Window: Dialog;
        AccNo: array[10] of Code[20];
        i: Integer;
        KPISetup: Record "KPI Setup Bank";

    //[Scope('Personalization')]
    procedure Indent()
    begin
        Window.Open(Text004);

        if KPISetup.Find('-') then
            repeat
                Window.Update(1, KPISetup."KPI Code");

                if KPISetup."Account Type" = KPISetup."Account Type"::"End-Total" then begin
                    if i < 1 then
                        Error(
                          Text005,
                          KPISetup."KPI Code");
                    if KPISetup.Totaling = '' then
                        KPISetup.Totaling := AccNo[i] + '..' + KPISetup."KPI Code";
                    i := i - 1;
                end;

                //VALIDATE(Intendation,i);
                KPISetup.Modify;

                if KPISetup."Account Type" = KPISetup."Account Type"::"Begin-Total" then begin
                    i := i + 1;
                    AccNo[i] := KPISetup."KPI Code";
                end;
                if KPISetup."Account Type" = KPISetup."Account Type"::Total then begin
                    i := i + 2;
                    AccNo[i] := KPISetup."KPI Code";
                end;
            until KPISetup.Next = 0;
        Window.Close;

        OnAfterIndent;
    end;

    //[Scope('Personalization')]
    procedure RunICAccountIndent()
    begin
        if not
           Confirm(
             Text000 +
             Text001 +
             Text003, true)
        then
            exit;

        //IndentICAccount;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIndent()
    begin
    end;
}
