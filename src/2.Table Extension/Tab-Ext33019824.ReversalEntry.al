tableextension 33019824 "Reversal Entry" extends "Reversal Entry"
{
    fields { }
    procedure SetPayrollEntry(NewIsPayrollEntry: Boolean)
    begin
        IsPayrollEntry := NewIsPayrollEntry;
    end;

    var
        IsPayrollEntry: Boolean;
}
