table 33019891 "Branchwise/Extension Allowance"
{
    DataCaptionFields = "Code", "Allowance Type";
    DrillDownPageId = "Branchwise/Extension Counter";
    LookupPageId = "Branchwise/Extension Counter";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = if (Type = const(Branch)) "Dimension Value".Code where("Dimension Code" = const('BRANCH'))
            else if (Type = const("Extension Counter")) "Employee Hierarchy Master".Code where(Type = const("Extension Counter"));

            trigger OnValidate()
            begin
                Clear(Name);
                if Type = Type::Branch then begin
                    if DimensionValue.Get('BRANCH', Code) then
                        Name := DimensionValue.Name;
                end else if Type = Type::"Extension Counter" then begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, Code);
                    if EmpHie.FindFirst then
                        Validate(Name, EmpHie.Description);
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Editable = false;
        }
        field(3; "Allowance Type"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(4; "Max. No. of Staffs"; Integer)
        {
            MinValue = 0;
        }
        field(5; Type; Option)
        {
            OptionCaption = ' ,Branch,Extension Counter';
            OptionMembers = " ",Branch,"Extension Counter";
        }
        field(6; Disabled; Boolean) { }
    }

    keys
    {
        key(Key1; Type, "Code", "Allowance Type") { }
    }

    fieldgroups { }

    var
        DimensionValue: Record "Dimension Value";
        EmpHie: Record "Employee Hierarchy Master";
}
