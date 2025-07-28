codeunit 50011 "Payroll Reversal-Post"
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

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnBeforeCheckGLEntry', '', false, false)]
    local procedure OnBeforeCheckGLEntry(ReversalEntry: Record "Reversal Entry"; GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    var
        SourcCodeSetup: Record "Source Code Setup";
    begin
        SourcCodeSetup.Get();
        if SourcCodeSetup."Payroll Journal" = GLEntry."Source Code" then
            IsHandled := true;
    end;

    var
        Text006: Label 'There is nothing to reverse.';
        Text008: Label 'Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
        ReversalEntry: Record "Reversal Entry";
}
