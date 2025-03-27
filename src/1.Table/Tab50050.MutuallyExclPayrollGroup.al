table 50050 "Mutually Excl. Payroll Group"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; Type; Code[20]) { }
        field(2; "Payroll Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(3; Priority; Integer)
        {
            trigger OnValidate()
            begin
                /*IF xRec.Priority <> Rec.Priority THEN BEGIN
                  MutuallyExl.RESET;
                  MutuallyExl.SETRANGE(Type,Type);
                  MutuallyExl.SETRANGE(Priority,Priority);
                  IF MutuallyExl.FINDFIRST THEN
                    ERROR(ErrorText,Priority,Type);
                END;
                */
            end;
        }
        field(4; dura; Duration) { }
        field(5; "start time"; Time) { }
        field(6; "end time"; Time) { }
        field(7; Dec; Decimal) { }
    }

    keys
    {
        key(Key1; Type, "Payroll Code") { }
    }

    fieldgroups { }
}
