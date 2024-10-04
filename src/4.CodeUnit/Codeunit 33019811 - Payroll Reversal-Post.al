codeunit 33019811 "Payroll Reversal-Post"
{
    // version PRM19.01.01

    TableNo = "Reversal Entry";

    trigger OnRun()
    var
        GenJnlPostReverse: Codeunit "Gen. Jnl.-Post Reverse";
        Number: Integer;
    begin
        Rec.Reset;
        if not Rec.FindFirst then
            Error(Text006);

        ReversalEntry := Rec;
        if Rec."Reversal Type" = Rec."Reversal Type"::Transaction then
            ReversalEntry.SetReverseFilter(Rec."Transaction No.", Rec."Reversal Type")
        else
            ReversalEntry.SetReverseFilter(Rec."G/L Register No.", Rec."Reversal Type");
        ReversalEntry.SetPayrollEntry(true);
        ReversalEntry.CheckEntries;
        Rec.Get(1);
        if Rec."Reversal Type" = Rec."Reversal Type"::Register then
            Number := Rec."G/L Register No."
        else
            Number := Rec."Transaction No.";
        if not ReversalEntry.VerifyReversalEntries(Rec, Number, Rec."Reversal Type") then
            Error(Text008);
        GenJnlPostReverse.Reverse(ReversalEntry, Rec);

        Rec.DeleteAll;
    end;

    var
        Text006: Label 'There is nothing to reverse.';
        Text008: Label 'Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
        ReversalEntry: Record "Reversal Entry";
}
