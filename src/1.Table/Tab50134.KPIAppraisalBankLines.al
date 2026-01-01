table 50134 "KPI Appraisal Bank Lines"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "Appraisal Code"; Code[20])
        {
            trigger OnValidate()
            begin
                /*AppriasalHdr.Reset();//KPI1.00
                AppriasalHdr.SetRange("Appraisal Code","Appraisal Code");
                IF AppriasalHdr.FindFirst() THEN begin
                  "Employee Code" := AppriasalHdr."Employee Code";
                  Quarter := AppriasalHdr.Quarter;
                end;*/
            end;
        }
        field(3; "KPI Code"; Code[20]) { }
        field(4; "KPI Description"; Text[250]) { }
        field(5; "Weightage %"; Decimal) { }
        field(6; Type; Enum "KPI Setup Type") { }
        field(7; Target; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."Target Per Day" where("Employee Code" = field("Employee Code"),
                                                                            Quarter = field(Quarter),
                                                                            "KPI Code" = field("KPI Code"),
                                                                            "Fiscal Year" = field("Fiscal Year"),
                                                                            Type = const(Employee),
                                                                            "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; Actual; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."Actual Score Per Day" where("Employee Code" = field("Employee Code"),
                                                                                  Quarter = field(Quarter),
                                                                                  "KPI Code" = field("KPI Code"),
                                                                                  "Fiscal Year" = field("Fiscal Year"),
                                                                                  Type = const(Employee),
                                                                                  "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Score; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."KPI Score" where("KPI Code" = field("KPI Code"),
                                                                       "Employee Code" = field("Employee Code"),
                                                                       Quarter = field(Quarter),
                                                                       "Fiscal Year" = field("Fiscal Year"),
                                                                       Type = const(Employee),
                                                                       "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; Quarter; Text[10]) { }
        field(11; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(12; "Fiscal Year"; Text[20]) { }
        field(13; "Department Code"; Code[20]) { }
        field(14; "Reviewer's Score"; Decimal) { }
        field(15; "Check Reviewer's Score"; Decimal) { }
        field(16; "Target Dept"; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."Target Per Day" where(Department = field("Department Code"),
                                                                            Quarter = field(Quarter),
                                                                            "KPI Code" = field("KPI Code"),
                                                                            "Fiscal Year" = field("Fiscal Year"),
                                                                            Type = const(Department),
                                                                            "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Actual Dept"; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."Actual Score Per Day" where(Department = field("Department Code"),
                                                                                  Quarter = field(Quarter),
                                                                                  "KPI Code" = field("KPI Code"),
                                                                                  "Fiscal Year" = field("Fiscal Year"),
                                                                                  Type = const(Department),
                                                                                  "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Score Dept"; Decimal)
        {
            CalcFormula = average("KPI Daily Score"."KPI Score" where("KPI Code" = field("KPI Code"),
                                                                       Department = field("Department Code"),
                                                                       Quarter = field(Quarter),
                                                                       "Fiscal Year" = field("Fiscal Year"),
                                                                       Type = const(Department),
                                                                       "Entry Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(20; "KPI Type"; Enum "KPI Master Type") { }
        field(21; "Final Reviewer's Score"; Decimal) { }
        field(22; "KPI Category"; Code[20])
        {
            TableRelation = "KPI Category";
        }
        field(23; "Probation Employee Score"; Decimal) { }
    }

    keys
    {
        key(Key1; "Line No.", "Appraisal Code") { }
        key(Key2; "Employee Code", "KPI Code") { }
    }

    fieldgroups { }
}
