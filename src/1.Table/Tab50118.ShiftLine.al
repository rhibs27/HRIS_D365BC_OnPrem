table 50118 "Shift Line"
{
    Caption = 'Shift Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(4; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = Employee."No." where("Deputation On Code" = field("Deputation Code"));
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.get("Employee No") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Deputation Type", Employee."Deputation On");
                    Validate("Deputation Code", Employee."Deputation On Code");
                end;
                TestField("Employee No");
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Roster Date"; Date)
        {
            Caption = 'Roster Date';
            trigger OnValidate()
            begin
                ValidateShiftDate(Rec);
            end;
        }
        field(7; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
        }
        field(8; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(9; "Employee Work Shift"; Code[10])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift".Code;
            trigger OnValidate()
            var
            begin
                TestField("Employee Work Shift");
            end;
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(11; "Deputation Code"; Code[20])
        {
            Editable = false;
            Caption = 'Code';
            trigger OnValidate()
            begin
                Clear("Deputation Name");
                if OrganizationStructureList.Get("Deputation Type", "Deputation Code") then
                    "Deputation Name" := OrganizationStructureList.Name
            end;
        }
        field(12; "Deputation Name"; Text[100])
        {
            Editable = false;
        }
        field(13; "Deputation Type"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(14; "Substitute Type"; Enum "Allowance Substitute")
        {
            InitValue = '';
            Editable = false;
        }
        field(15; "Substitute of Line No."; Integer)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Validate("Approval Status", "Approval Status"::Open);

    end;

    var
        OrganizationStructureList: Record "Organization Structure List";
        Employee: Record Employee;

        ShiftMgn: Codeunit "Shift Assignment Mgt";


    local procedure ValidateShiftDate(var LineRec: Record "Shift Line")
    var
        ShiftLine: Record "Shift Line";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if (LineRec."Employee No" = '') or (LineRec."Roster Date" = 0D) then
            exit;

        if not ShiftAssignmentHeader.Get(LineRec."No.") then
            Error('Shift Assignment Header %1 does not exist', LineRec."No.");

        ShiftAssignmentHeader.TestField("From Date");
        ShiftAssignmentHeader.TestField("To Date");

        if (LineRec."Roster Date" < ShiftAssignmentHeader."From Date") or
           (LineRec."Roster Date" > ShiftAssignmentHeader."To Date") then
            Error('Roster Date %1 is not within the allowed period %2 to %3',
                  LineRec."Roster Date",
                  ShiftAssignmentHeader."From Date",
                  ShiftAssignmentHeader."To Date");

        ShiftLine.Reset();
        ShiftLine.SetRange(Type, ShiftLine.Type::"Shift Assignment");
        ShiftLine.SetRange("No.", LineRec."No.");
        ShiftLine.SetRange("Employee No", LineRec."Employee No");
        ShiftLine.SetRange("Roster Date", LineRec."Roster Date");
        ShiftLine.SetFilter("Line No", '<>%1', LineRec."Line No");

        if ShiftLine.FindFirst() then
            Error('Employee %1 is already scheduled on %2 at Line No. %3',
                  LineRec."Employee No",
                  LineRec."Roster Date",
                  ShiftLine."Line No");
    end;
}
