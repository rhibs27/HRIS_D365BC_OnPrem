table 50118 "Attend. Question Answer Log"
{
    DataClassification = CustomerContent;
    // version APINICASIA1.00

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Employee Name"; Text[80])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No.")));
            FieldClass = FlowField;
        }
        field(4; Question; Text[250]) { }
        field(5; "No. of times answered"; Integer) { }
        field(6; "Wrong Answer Count"; Integer) { }
        field(7; "Punch In Date"; Date) { }
        field(8; "Punch In Time"; Time) { }
        field(9; "Puch Out Time"; Time) { }
        field(10; Remarks; Text[250]) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }
}
