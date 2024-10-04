table 33019916 "HR Cue"
{
    // version KPI1.00

    Caption = 'HR Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; "User Filter"; Text[250])
        {
            FieldClass = FlowFilter;
        }
        field(3; "To Approve Travel Req"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Request"),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "To Recommend Travel Req"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Request"),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Approved Travel Req"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Request"),
                                                           "Approval Status" = const(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Rejected Travel Req"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Request"),
                                                           "Approval Status" = const(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "To Approve Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Claim"),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "To Recommend Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Claim"),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "To Screen Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Claim"),
                                                           "Approval Status" = const(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Rejected Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Claim"),
                                                           "Approval Status" = const(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "To Approve Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Screened),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "To Recommend  Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Approved  Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Approved),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Rejected  Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "To Approve Overtime"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Overtime),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "To Screen Overtime"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Overtime),
                                                           "Approval Status" = const(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Rejected  Overtime"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Overtime),
                                                           "Approval Status" = const(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "To Approve Bulk Cash"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Bulk Cash"),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Approved  Bulk Cash"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Bulk Cash"),
                                                           "Approval Status" = const(Approved),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Rejected  Bulk Cash"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Bulk Cash"),
                                                           "Approval Status" = const(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Incoming Branch"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Approved),
                                                           "Incoming Supervisior" = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(22; "To Review Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = const("Employee Transfer"),
                                                           "Approval Status" = const(Recommended),
                                                           Reviewer = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(23; "To Recommend Overtime"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = const(Overtime),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(24; "To Recommend Allowance Assig."; Integer)
        {
            CalcFormula = count("Allowance Assignment Header" where("Approval Status" = const("Pending Approval"),
                                                                     "Approver ID" = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(25; "Resignation By Age"; Integer)
        {
            CalcFormula = count(Employee where(Status = filter(Active | Inactive),
                                                Age = filter(>= 60)));
            Description = 'Resignation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Resignation By Service"; Integer)
        {
            CalcFormula = count(Employee where(Status = filter(Active | Inactive),
                                                "Service Period" = filter(>= 30)));
            Description = 'Resignation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "To Screen Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Salary Advance"),
                                                               "Approval Status" = filter(Recommended)));
            Description = 'SalaryAdv';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "To Approve Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Salary Advance"),
                                                               "Approval Status" = filter(Screened),
                                                               Approver = field("Employee Filter")));
            Description = 'SalaryAdv';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Approved Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Salary Advance"),
                                                               "Approval Status" = filter(Approved)));
            Description = 'SalaryAdv';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "To Approve Leave Request"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Leave Request"),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Description = 'Leave request';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "To Recommend Leave Req"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Leave Request"),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Description = 'Leave request';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Approved Leave Request"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Leave Request"),
                                                           "Approval Status" = const(Approved)));
            Description = 'Leave request';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Rejected Leave Request"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Leave Request"),
                                                           "Approval Status" = const(Rejected)));
            Description = 'Leave request';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Employee Filter"; Text[20])
        {
            FieldClass = FlowFilter;
        }
        field(35; "Rejected Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Salary Advance"),
                                                               "Approval Status" = filter(Rejected)));
            Description = 'SalaryAdv';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "To Screen Personal Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Personal Loan"),
                                                               "Approval Status" = filter(Recommended)));
            Description = 'Personal Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "To Approve Persoanl Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Personal Loan"),
                                                               "Approval Status" = filter(Screened),
                                                               Approver = field("Employee Filter")));
            Description = 'Personal Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Approved Persoanl Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Personal Loan"),
                                                               "Approval Status" = filter(Approved)));
            Description = 'Personal Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Rejected Personal Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Personal Loan"),
                                                               "Approval Status" = filter(Rejected)));
            Description = 'Personal Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "To Screen Home Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Home Loan"),
                                                               "Approval Status" = filter(Recommended)));
            Description = 'Home Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "To Approve Home Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Home Loan"),
                                                               "Approval Status" = filter(Screened),
                                                               Approver = field("Employee Filter")));
            Description = 'Home Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Approved Home Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Home Loan"),
                                                               "Approval Status" = filter(Approved)));
            Description = 'Home Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Rejected Home Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Home Loan"),
                                                               "Approval Status" = filter(Rejected)));
            Description = 'Home Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(44; "To Screen Vehicle Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Vehicle Loan"),
                                                               "Approval Status" = filter(Recommended)));
            Description = 'Vehicle Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "To Approve Vehicle Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Vehicle Loan"),
                                                               "Approval Status" = filter(Screened),
                                                               Approver = field("Employee Filter")));
            Description = 'Vehicle Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; "Approved Vehicle Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Vehicle Loan"),
                                                               "Approval Status" = filter(Approved)));
            Description = 'Vehicle Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "Rejected Vehicle Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Vehicle Loan"),
                                                               "Approval Status" = filter(Rejected)));
            Description = 'Vehicle Loan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; "Final Approved Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Travel Claim"),
                                                           "Approval Status" = const("Final Approved & Forwarded to Finance Department")));
            Description = 'travel';
            FieldClass = FlowField;
        }
        field(49; "To Final Approved Travel Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = const("Travel Claim"),
                                                           "Approval Status" = const(Screened),
                                                           "Final Approver" = field("Employee Filter")));
            Description = 'travel';
            FieldClass = FlowField;
        }
        field(50; "To Approve Attendance Missed"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Attendance Missed"),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Description = 'attendance missed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Approved Attendance Missed"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = const("Attendance Missed"),
                                                           "Approval Status" = const(Approved)));
            Description = 'attendance missed';
            FieldClass = FlowField;
        }
        field(52; "To Recommend Attendance Missed"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Attendance Missed"),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Description = 'attendance missed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(54; "Screened Overtime"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Overtime),
                                                           "Approval Status" = const(Screened)));
            FieldClass = FlowField;
        }
        field(55; "To Recommend Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Approval Status" = const("Pending Approval"),
                                                               "Loan Type" = const("Salary Advance"),
                                                               Recommender = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(56; "To Recommend Home Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Approval Status" = const("Pending Approval"),
                                                               "Loan Type" = const("Home Loan"),
                                                               Recommender = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(57; "To Recommend Personal Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Approval Status" = const("Pending Approval"),
                                                               "Loan Type" = const("Personal Loan"),
                                                               Recommender = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(58; "To Recommend Vehicle Loan"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Approval Status" = const("Pending Approval"),
                                                               "Loan Type" = const("Vehicle Loan"),
                                                               Recommender = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(59; "To Screen Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Reviewed)));
            Description = 'transfer';
            FieldClass = FlowField;
        }
        field(60; "Acknowledged Transfer"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Employee Transfer" | "HR Transfer"),
                                                           "Approval Status" = const(Acknowledged)));
            Description = 'transfer';
            FieldClass = FlowField;
        }
        field(61; "Contract Expiry Employees"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active),
                                                "Contract Expiry Date" = field("Contract Expiry Date Filter")));
            FieldClass = FlowField;
        }
        field(62; "Contract Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(63; "Contract Expired Employees"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active),
                                                "Contract Expiry Date" = field("Expiry Check Date")));
            FieldClass = FlowField;
        }
        field(64; "Expiry Check Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(65; "To Recommend Resignation"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Resignation),
                                                           "Approval Status" = const("Pending Approval"),
                                                           "Recommender Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "To Reviews Resignation"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter(Resignation),
                                                           "Approval Status" = const(Recommended),
                                                           "Approver Code" = field("Employee Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Contract Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active)));
            FieldClass = FlowField;
        }
        field(68; "Probation Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Probation),
                                                Status = const(Active)));
            FieldClass = FlowField;
        }
        field(69; "Permanent Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Permanent),
                                                Status = const(Active)));
            FieldClass = FlowField;
        }
        field(70; "To Recommend Transfer Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("HR Transfer" | "Employee Transfer"),
                                                           "Approval Status" = const(Acknowledged),
                                                           "Transfer Allowance Approval" = const("Pending Approval"),
                                                           "Transfer Claim Recommender" = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(71; "To Review Transfer Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("HR Transfer" | "Employee Transfer"),
                                                           "Approval Status" = const(Acknowledged),
                                                           "Transfer Allowance Approval" = const(Recommended),
                                                           "Transfer Claim Reviewer" = field("Employee Filter")));
            FieldClass = FlowField;
        }
        field(72; "To Approve Transfer Claim"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("HR Transfer" | "Employee Transfer"),
                                                           "Approval Status" = const(Acknowledged),
                                                           "Transfer Allowance Approval" = const(Reviewed)));
            FieldClass = FlowField;
        }
        field(73; "Field Name"; Text[50]) { }
        field(74; Value; Integer) { }
        field(75; "To Reviews Appraisal"; Integer)
        {
            CalcFormula = count(Appraisal where(Posted = filter(false),
                                                 Status = const(Submitted),
                                                 Reviewer = field("Employee Filter"),
                                                 Hide = filter(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "To Check Reviews Appraisal"; Integer)
        {
            CalcFormula = count(Appraisal where(Posted = filter(false),
                                                 Status = const(Reviewed),
                                                 "Check Reviewer" = field("Employee Filter"),
                                                 Hide = filter(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "To Screen Cancel Leave"; Integer)
        {
            CalcFormula = count("Employee Activity" where(Type = filter("Leave Request"),
                                                           "Approval Status" = const(Approved),
                                                           Cancelled = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "To Screen Residential Address"; Integer)
        {
            CalcFormula = count("Employee Activity Second" where(Type = const("Residential Address"),
                                                                  Status = const(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "To Check Reviews KPI"; Integer)
        {
            CalcFormula = count("KPI Appraisal Header NIC" where(Status = const("Check Reviewed")));
            Description = 'KPI1.00';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }
}
