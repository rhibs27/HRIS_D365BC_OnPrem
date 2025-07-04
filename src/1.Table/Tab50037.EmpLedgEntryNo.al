table 50037 "Emp. Ledg. Entry No."
{
    DataClassification = CustomerContent;
    // version PRM19.01.01

    fields
    {
        field(1; "Emp. Ledg. Entry No."; Integer) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Document No."; Code[20])
        {
        }
        field(5; Type; Enum "Emp. Ledg. Type")
        {

        }
        field(6; Description; Text[250]) { }
        field(7; Amount; Decimal) { }
        field(8; "Amount 2"; Decimal) { }
        field(9; "Amount 3"; Decimal) { }
        field(10; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(11; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(12; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(13; "Pay Period Start Date"; Date) { }
        field(14; "Pay Period End Date"; Date) { }
    }

    keys
    {
        key(Key1; "Emp. Ledg. Entry No.", "Line No.") { }
    }

    fieldgroups { }
}
