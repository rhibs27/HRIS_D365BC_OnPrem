table 50046 "Employee Leave Type"
{
    // version ATM19.01.01

    DrillDownPageId = "Employee Leave Type";
    LookupPageId = "Employee Leave Type";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Standard Level Code"; Code[10])
        {
            trigger OnLookup()
            begin
                Clear(SalaryLevel);
                Clear(SalaryLevelList);
                SalaryLevelList.SetTableView(SalaryLevel);
                SalaryLevelList.LookupMode(true);
                if SalaryLevelList.RunModal = Action::LookupOK then begin
                    SalaryLevelList.GetRecord(SalaryLevel);
                    Validate("Standard Level Code", SalaryLevel."Standard Step");
                end;
            end;

            trigger OnValidate()
            begin
                if "Standard Level Code" <> '' then begin
                    SalaryLevel.Reset;
                    SalaryLevel.SetRange("Standard Step", "Standard Level Code");
                    SalaryLevel.FindFirst;
                end;
            end;
        }
        field(4; "Max. Allowable Limit Per Year"; Decimal) { }
        field(5; "Carry Forward"; Boolean) { }
        field(6; "Min. Balance Days for Encash"; Decimal) { }
        field(7; "Employee Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(8; "Leave Balance"; Decimal)
        {
            CalcFormula = sum("Employee Activity Details"."Total Days" where("Employee No." = field("Employee Filter"),
                                                                              Type = filter("Full Day Leave" | "Half Day Leave"),
                                                                              "Leave Type" = field(Code),
                                                                              Posted = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Standard Level Code") { }
    }

    fieldgroups { }

    var
        SalaryLevel: Record "Salary Grade";
        SalaryLevelList: Page "Posted Attendance List";
}
