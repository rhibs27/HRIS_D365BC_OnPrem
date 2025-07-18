table 50095 "Posted Employee Journal"
{
    Caption = 'Employee Journal';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Emp Act. No"; Code[20])
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
        field(22; "Line No"; Integer)
        {
            Editable = false;
        }
        field(23; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(24; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        // field(25; "Employee Act Type"; Enum "Employee Activity Type")
        // {
        //     Editable = false;
        // }
        field(26; "Posting Date"; Date)
        {
            Editable = false;
        }

        field(28; "Extension Counter Code"; Code[20])
        {
        }
        field(30; "Province Code"; Code[20])
        {
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
        field(34; "Requester Employee"; Code[20])
        {
            TableRelation = Employee;
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(39; Cancelled; Boolean) //Used in all Employee activity
        {
        }
        //Leave 
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
        field(50; Description; Text[250])
        {
        }
        field(51; "Screener Remarks"; Text[100])
        {
        }
        //Transfer 
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
        }
        field(53; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        field(54; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
            end;
        }
        field(55; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Unit), Blocked = filter(false));
        }
        field(56; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Department), Blocked = filter(false));
        }
        field(57; "Travel Order No"; Code[20])
        {
        }
        field(58; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::"Extension Counter"), Blocked = filter(false));
        }
        field(59; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';
        }
        field(60; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Functional Title";
        }
        field(61; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(62; "Deputation On (To)"; Enum "Deputation Type")
        {
        }

        field(63; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.get("Outgoing Branch Rep. Person") then
                    "Outgoing Reporting Person Name" := Employee."Full Name";
            end;
        }
        field(64; "Outgoing Reporting Person Name"; Text[50])
        {
        }
        field(65; "Incoming Supervisor"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
        }
        field(66; "Incoming Supervisor Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(67; "Reason for Transfer"; Text[100])
        {
            Description = 'Transfer';
        }
        field(68; "Date of Joining Of Transfer"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TestField("Transfer Effective Date");
                if "Date of Joining Of Transfer" < "Transfer Effective Date" then
                    Error('Date of joining of transfer %1 cannot be less than HR Proposed date %2', "Date of Joining Of Transfer", "Transfer Effective Date");
            end;
        }
        field(69; "Transfer Remarks"; Text[50])
        {
            Description = 'Transfer';
        }
        field(70; "Notify to"; Text[200])
        {
            Description = 'Transfer';
            TableRelation = Employee where(Status = filter("Employee Status"::Active));
        }
        field(71; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';
        }
        field(72; "Curr. Placement Period(Month)"; Decimal)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(73; "Reason For Cancel"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(74; "Cancelled Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(75; "Transfer Propose Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(76; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(77; "From Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        field(78; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        field(79; "Deputation On Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Deputation On Code To"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        // OverTime 
        field(90; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Estimated Hours"; Decimal)
        {
        }
        field(92; "Actual OT Hours"; Decimal)
        {
        }
        field(93; "OT Amount"; Decimal)
        {
            Editable = false;
        }
        field(94; "OT Eligible Hours"; Decimal)
        {
            Editable = false;
        }
        field(95; "Morning OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(96; "Evening OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(97; "Total OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(98; "Adjustment Type"; Enum "Leave Earn Type")
        {
            ValuesAllowed = Used, Adjustment;
        }
        field(100; Status; text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
        }
        field(101; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Approver Role (TO)"; code[20])
        {
            TableRelation = "Approval Role";
        }
        field(103; "Approver Role"; code[20])
        {
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
        if "Posting Date" = 0D then
            "Posting Date" := Today;
    end;

    trigger OnDelete()
    begin
        Error('Cannot delete');
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
