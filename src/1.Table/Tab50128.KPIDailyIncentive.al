table 50128 "KPI Daily Incentive"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee Code"; Code[20]) { }
        field(3; "Location Incentive"; Decimal) { }
        field(4; "Role Incentive"; Decimal) { }
        field(5; "Entry Date"; Date)
        {
            trigger OnValidate()
            begin
                if EmpRec.Get("Employee Code") then begin
                    if EmpRec."Probation Period" in [EmpRec."Probation Period"::"12 Month", EmpRec."Probation Period"::"12 Month"] then begin
                        Quarter := '';
                        "Fiscal Year" := '';
                    end else begin
                        Quarter := KPIMgt.GetQuarter("Entry Date");//KPI1.00
                                                                   //Quarter := KPIMgt.GetQuarter("Entry Date");//KPI1.00
                        "Fiscal Year" := KPIMgt.CalculateFiscalYear("Entry Date");
                    end;
                end;
            end;
        }
        field(6; Quarter; Text[10]) { }
        field(7; "Net KPI Score"; Decimal)
        {
            trigger OnValidate()
            begin
                KPIRatingSetup.Reset;//KPI1.00
                KPIRatingSetup.SetFilter("Min Score", '<=%1', "Net KPI Score");
                KPIRatingSetup.SetFilter("Max Score", '>=%1', "Net KPI Score");
                if KPIRatingSetup.FindFirst then begin
                    Rating := KPIRatingSetup.Rating;
                end;
            end;
        }
        field(8; Rating; Enum "Appraisal Rating") { }
        field(9; Type; Enum EmployeeDepartment) { }
        field(10; Department; Code[20]) { }
        field(11; "Department Name"; Text[50]) { }
        field(12; "Fiscal Year"; Text[10]) { }
        field(13; "KPI Score"; Decimal) { }
        field(14; "Functional Title"; Code[20]) { }
        field(15; Calculated; Boolean) { }
    }

    keys
    {
        key(Key1; "Line No.") { }
    }

    fieldgroups { }

    var
        KPIMgt: Codeunit "KPI Mgt.";
        KPIRatingSetup: Record "KPI Rating Setup";
        EmpRec: Record Employee;
}
