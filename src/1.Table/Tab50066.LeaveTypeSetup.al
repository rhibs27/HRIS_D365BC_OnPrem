table 50066 "Leave Type Setup"
{
    LookupPageId = "Leave Type Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; "Carry Forwardable"; Boolean) { }
        field(4; "Employee No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Employee."No.";
        }
        field(5; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(6; "Days Earned Per Year"; Decimal) { }
        field(7; "Times Per Service Period"; Integer)
        {
            Description = 'Paternity & Maternity';
        }
        field(8; "Maximum Leave at once"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Maximum Leave at once" > "Days Earned Per Year" then
                    Error(ErrorMaxDays);
            end;
        }
        field(9; "Pay Type"; Enum "Leave Pay Type")
        {

        }
        field(10; "Remaining Days"; Decimal)
        {
            CalcFormula = sum("Leave Earn"."Balancing Days" where("Leave Code" = field(Code),
                                                                   "Employee No." = field("Employee No. Filter"),
                                                                   Closed = const(false)));
            FieldClass = FlowField;
        }
        field(11; "Exclude Non Working Days"; Boolean) { }
        field(12; "Disable Multiple Leave Request"; Boolean)
        {
            Description = 'Cannot send leave request unitl previous leave request is approved.';
        }
        field(13; "Leave For Employee Type"; enum "Employee Type")
        {

        }
        field(14; "Encashable Limit"; Decimal) { }
        field(15; "Payroll Attribute"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(16; Gender; Enum "Employee Gender")
        {

        }
        field(17; "Leave at Once"; Boolean) { }
        field(18; "Services Period"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Times Per Service Period");
            end;
        }
        field(19; "Limit Max. Leave at Once"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Maximum Leave at once");
            end;
        }
        field(20; "Depending Leave"; Code[100])
        {
            trigger OnLookup()
            begin
                Validate("Depending Leave", leaveMgt.LookupDependability(Code));
            end;
        }
        field(21; "Min. Service Year Eligibility"; Decimal)
        {
            Caption = 'Min. Service Year for Eligibility';
        }
        field(22; "Calculate Proratawise"; Boolean)
        {
        }
        field(23; "Marital Status"; Enum "Marital Status")
        {

        }
        field(25; "Needed HR Permission"; Boolean) { }

        field(29; "No. of Days for Attachment"; Integer) { }
        field(30; Approved; Integer)
        {
            CalcFormula = count("Employee Activity" where("Leave Code" = field(Code),
                                                           Type = filter("Leave Request"),
                                                           "Approval Status" = filter(Approved),
                                                           "Start Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(31; Requested; Integer)
        {
            CalcFormula = count("Employee Activity" where("Leave Code" = field(Code),
                                                           Type = filter("Leave Request"),
                                                           "Approval Status" = filter(Pending),
                                                           "Start Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(32; Recommended; Integer)
        {
            CalcFormula = count("Employee Activity" where("Leave Code" = field(Code),
                                                           Type = filter("Leave Request"),
                                                           "Approval Status" = filter(Recommended),
                                                           "Start Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(33; "Skip Balance Check"; Boolean) { }
        field(34; Email; Text[80]) { }
        field(35; "AML Eligible"; Boolean)
        {
            Description = 'This leave is generated only if the employee is permanent before the fiscal year start date or is permanent on the first day of new fiscal year';
        }
        field(36; "Check Balance for Payroll"; Boolean) { }
        field(37; "Adjustment Sequence"; Integer)
        {
            Description = 'Leave Adjusted sequentially for absent days in Settlement';
        }
        field(38; "Half Leave Allowed"; Boolean)
        {
        }
        field(40; "Minimum Leave at once"; Decimal)
        {
        }
        field(41; "Exclude in Service Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Credit Method"; Option)
        {
            OptionMembers = " ",Attendance,Automatic,"On Approval";
            Caption = 'Credit Method';
        }

        field(103; "Max. Eligible Age"; Decimal)
        {
            Caption = 'Max. Eligible Age';
        }
        field(104; "Credit Frequency"; Option)
        {
            OptionMembers = Annual,Monthly,Occasional,Quarterly;
        }
        field(106; "Credit At"; Option)
        {
            OptionMembers = Beginning,"End";
        }
        field(107; "Display in Portal"; Boolean) { }

        field(108; "Back Date Allowed UpTo"; DateFormula) { }
        field(109; "Leave Category"; Enum "Leave Category") { }
        field(110; "Emplymt. Contract Code"; Code[200])
        {
            // TableRelation = "Employment Contract";
        }
        field(111; "Attendance Days"; Decimal) { }
        field(112; Encashable; Boolean) { }
        field(114; "Service Period Calc On"; Option)
        {
            OptionMembers = "Employment Date","Confirmation Date";
        }
        field(500; Blocked; Boolean) { }

        field(502; "Used Days"; Decimal)
        {
            Caption = 'Used Days';
            FieldClass = FlowField;
            CalcFormula = sum("Leave Earn"."Balancing Days" where("Employee No." = field("Employee No. Filter"), "Leave Code" = field(Code), Type = const(Used), "Posted Date" = field("Date Filter")));
            Editable = false;
        }
        field(503; "Earned Days"; Decimal)
        {
            Caption = 'Earned Days';
            FieldClass = FlowField;
            CalcFormula = sum("Leave Earn"."Balancing Days" where("Employee No." = field("Employee No. Filter"), "Leave Code" = field(Code), Type = const(Earned), "Posted Date" = field("Date Filter")));
            Editable = false;
        }
        field(504; "Encash Date"; Date) { }
        field(505; "Encash Remarks"; Text[100]) { }


    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        ErrorMaxDays: Label 'Maximum leave at once cannot be greater than days earned per year.';
        leaveMgt: Codeunit "Leave Mgt.";
}
