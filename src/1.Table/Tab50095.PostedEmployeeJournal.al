table 50095 "Posted Employee Journal"
{
    Caption = 'Employee Journal';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {
        }
        field(8; "End Date"; Date)
        {
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

        }
        field(10; "Requested Date"; Date)
        {
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            // trigger OnValidate()
            // begin
            //     GLSetup.Get;
            //     if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
            //         Validate("Branch Name", DimValue.Name)
            //     else
            //         Validate("Branch Name", '');
            // end;
        }
        field(18; Department; Code[20])
        {
            Editable = false;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        // field(22; "Recommender Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Recommender Code", EmpVar."No.") = 0 then
        //                 Validate("Recommender Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Recommender Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Recommender.');
        //         HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
        //         if "Recommender Code" = '' then
        //             Validate("Approver Type", "Approver Type"::Direct)
        //         else
        //             Validate("Approver Type", "Approver Type"::"With Recommendation");
        //         //requirement not fixed
        //         if "Recommender Code" <> '' then begin
        //             if Type <> Type::Overtime then //Min 8.25.2022
        //                 if "Recommender Code" = "Approver Code" then
        //                     Error('Recommender and Approver cannot be same person.');
        //             EmployeeRec.Get("Recommender Code");
        //             if SalaryLevel.Get("Salary Level Code") then;
        //             if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //             if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                 Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
        //         end;
        //     end;
        // }
        // field(23; "Approver Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Approver Code", EmpVar."No.") = 0 then
        //                 Validate("Approver Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Approver Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Approver.');
        //         //requirement not fixed
        //         HRMgt.GetEmployeeName("Approver Code", "Approver Name");
        //         if "Approver Code" <> '' then begin
        //             HRSetup.Get;
        //             if EmployeeRec.Get("Recommender Code") then;
        //             if Type = Type::Resignation then begin
        //                 if not (EmployeeRec."Functional Title" = HRSetup."HR Head Functional Title") then
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');
        //             end else
        //                 if Type <> Type::Overtime then //Min 8.25.2022
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');

        //             EmployeeRec.Get("Approver Code");
        //             HRSetup.Get;
        //             if EmployeeRec."Functional Title" <> HRSetup."HR Head Functional Title" then begin
        //                 if SalaryLevel.Get("Salary Level Code") then;
        //                 if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //                 if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                     Error('Salary level of approver (%1) must be greater than salary level of employee (%2).', EmployeeRec."Full Name", "Employee Name");
        //             end;
        //         end;
        //     end;
        // }
        field(23; "Travel Order No"; Code[20])
        {
        }
        field(24; "Employee Work Shift"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        // field(26; "Recommender Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(27; "Approver Name"; Text[50])
        // {
        //     Editable = false;
        // }
        field(28; "Extension Counter Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
        }
        field(32; "Compensatory Days"; Decimal)
        {
        }
        field(33; "Payroll No."; Code[20])
        {
        }
        // field(34; Ecosystem; Code[20])
        // {
        // }
        // field(35; "Office Code"; Code[20])
        // {
        // }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        // field(38; "Approver Type"; Enum "Approver Type")
        // {
        //     Editable = false;
        // }
        field(39; Cancelled; Boolean) //Used in all Employee activity
        {
        }
        field(40; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
        }
        field(41; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(42; "Leave Type"; Enum "Leave Type")
        {
        }
        field(43; "Pay Type"; Enum "Leave Pay Type")
        {
            Editable = false;
        }
        field(44; "Start Time"; Time)
        {
            Description = 'also used for OT';
        }
        field(45; "End Time"; Time)
        {
            Description = 'also used for OT';
        }
        field(46; "Compensatory Date"; Date)
        {
        }
        field(47; "For Death Of"; Enum "For Death Of")
        {
        }
        field(48; "Child's Gender"; Enum Gender)
        {
        }
        // field(40; "Cancelled No."; Code[20])
        // {
        // }
        // field(41; "Cancelled Document No."; Code[20])
        // {
        //     Editable = false;
        // }
        // field(42; "Screener ID"; Code[20])
        // {
        //     Editable = false;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Screener ID") then
        //             Validate("Screener Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Screener Name");
        //     end;
        // }
        // field(43; "Screener Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(44; "Screener Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(45; "Final Approver"; Code[20])
        // {
        //     Editable = false;
        //     TableRelation = Employee;
        // }
        // field(46; "Final Approver Name"; Text[50])
        // {
        //     Description = 'S';
        //     Editable = false;
        // }
        // field(47; "Final Approver Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(48; "Reason Code"; Code[20])
        // {
        //     TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

        //     trigger OnValidate()
        //     begin
        //         if Standardtext.Get("Reason Code") then
        //             Validate("Reason Description", Standardtext.Description)
        //         else
        //             Clear("Reason Description");
        //     end;
        // // }
        // field(49; "Reason Description"; Text[50])
        // {
        // }
        field(50; Description; Text[250])
        {
        }
        field(51; "Screener Remarks"; Text[100])
        {
        }
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
        }
        field(53; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Organization Structure list"::Branch), Blocked = filter(false));
        }
        field(55; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            // TableRelation = Province;
            // Editable = false;
        }
        field(56; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Organization Structure list"::Unit), Blocked = filter(false));
        }
        field(57; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Organization Structure list"::Department), Blocked = filter(false));
        }
        // field(58; "Reporting Line 1 (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Reporting Line 1"));
        // }
        // field(59; "Reporting Line 2 (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Reporting Line 2"));
        // }
        // field(60; "Eco-System (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Eco-System"));
        // }
        // field(61; "Office (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST(Office));
        // }
        field(62; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Organization Structure list"::"Extension Counter"), Blocked = filter(false));
        }
        field(63; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';
        }
        field(64; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Functional Title";
        }
        field(65; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(66; "Deputation On (To)"; Enum "Deputation Type")
        {
        }
        field(67; "Relocation Allow."; Decimal)
        {
            Description = 'Transfer';
        }
        field(68; "Outstation/Discomfort Allow."; Decimal)
        {
            Description = 'Transfer';
        }
        field(69; "BM Accomodation Allow."; Decimal)
        {
            Description = 'Transfer';
        }
        field(70; "Remote Area Allow."; Decimal)
        {
            Description = 'Transfer';
        }
        field(71; "Officiating Allow."; Decimal)
        {
            Description = 'Transfer';
        }
        field(72; "Relocation Distance"; Decimal)
        {
            Description = 'Transfer';
        }
        field(73; "Outstation Distance"; Decimal)
        {
            Description = 'Transfer';
        }
        field(74; "BMAF Distance"; Decimal)
        {
            Description = 'Transfer';
        }
        // field(75; "Transfer Allowance Approval"; Enum "Transfer Allowance Approval")
        // {
        //     Description = 'Transfer';
        // }
        // field(76; "Transfer Claim Recommender"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;
        // }
        field(77; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
        }
        // field(78; "Transfer Claim Reviewer"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;
        // }
        field(79; "Acknowledged Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        // field(80; "Transfer Claim Reviewer Name"; Text[30])
        // {
        //     CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Transfer Claim Reviewer")));
        //     Description = 'Transfer';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(81; "Outgoing Reporting Person Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Outgoing Branch Rep. Person")));
            Description = 'Transfer';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(82; Reviewer; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if EmpVar.Get(Reviewer) then
        //             Validate("Reviewer Name", EmpVar."Full Name")
        //         else
        //             Clear("Reviewer Name");
        //     end;
        // }
        // field(83; "Reviewer Name"; Text[50])
        // {
        //     Description = 'Transfer';
        //     Editable = false;
        // }
        field(84; "Incoming Supervisior"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
        }
        field(85; "Incoming Supervisior Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        // field(86; "Reviewer Remarks"; Text[50])
        // {
        // }
        field(87; "Reason for Transfer"; Text[100])
        {
            Description = 'Transfer';
        }
        field(88; "Date of Joining Of Transfer"; Date)
        {
            Description = 'Transfer';
        }
        field(89; "Transfer Remarks"; Text[50])
        {
            Description = 'Transfer';
        }
        field(90; "Temporary Address"; Text[65])
        {
        }
        field(91; "Temporary Province"; Text[30])
        {
        }
        field(92; "Temporary District"; Text[30])
        {
        }
        field(93; "Notify to"; Text[200])
        {
            Description = 'Transfer';
            TableRelation = Employee where(Status = filter("Employee Status"::Active));
        }
        field(94; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';
        }
        field(95; "Curr. Placement Period(Month)"; Decimal)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(96; "Reason For Hold"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(97; "On Hold Date"; Date)
        {
            Description = 'Transfer';
        }
        field(98; "Reason For Cancel"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(99; "Cancelled Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(100; Status; text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "Transfer Propose Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Is Transfer Details Added"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(104; "Transfer Claim"; Boolean)
        {
            Editable = false;
        }

        field(198; "From Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(199; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
    }
    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        GetEntryNo;
        if "Requested Date" = 0D then
            "Requested Date" := Today;
    end;

    local procedure GetEntryNo()
    var
        PostedEmployeeJournal: Record "Posted Employee Journal";

    begin
        if PostedEmployeeJournal.FindLast() then
            "Entry No" := PostedEmployeeJournal."Entry No" + 1
        else
            "Entry No" := 1;
    end;
}
