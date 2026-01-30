table 50116 "HR Cue"
{
    Caption = 'HR Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(2; "User Filter"; Text[250])
        {
            FieldClass = FlowFilter;
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
        field(29; "Approved Salary Advance"; Integer)
        {
            CalcFormula = count("Employee Loan/Advance" where("Loan Type" = filter("Salary Advance"),
                                                               "Approval Status" = filter(Approved)));
            Description = 'SalaryAdv';
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
        field(53; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(61; "Contract Expiry Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active),
                                                "Contract Expiry Date" = field("Contract Expiry Date Filter")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(62; "Contract Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(63; "Contract Expired Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active),
                                                "Contract Expiry Date" = field("Expiry Check Date")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(64; "Expiry Check Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(67; "Contract Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Contract),
                                                Status = const(Active)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(68; "Probation Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Probation),
                                                Status = const(Active)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(69; "Permanent Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Permanent),
                                                Status = const(Active)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(73; "Field Name"; Text[50]) { }
        field(74; Value; Integer) { }
        field(75; "To Reviews Appraisal"; Integer)
        {
            CalcFormula = count(Appraisal where(Posted = filter(false),
                                                 Status = const(Submitted)
                                                 //"Immediate Supervisor" = field("Employee Filter")
                                                 ));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "To Check Reviews Appraisal"; Integer)
        {
            CalcFormula = count(Appraisal where(Posted = filter(false),
                                                 Status = const(Reviewed)
                                                 //"Reviewer" = field("Employee Filter")
                                                 ));
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Temporary Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Temporary),
                                                Status = const(Active)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(79; "To Check Reviews KPI"; Integer)
        {
            CalcFormula = count("KPI Appraisal Header Bank" where(Status = const("Check Reviewed")));
            Description = 'KPI1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Leave Request"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Leave Request"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(81; "Travel Request"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Travel Request"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(82; "Travel Claim"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Travel Claim"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(83; "Update Attendance"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Attendance Missed"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(84; "Late Attendance"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Late Attendance"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(85; "Allowance Assignment"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Allowance Assignment"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(86; "Allowance Assignment Claim"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Allowance Assignment Claim"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(87; "Shift Assignment"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Shift Assignment"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(88; "Overtime"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Overtime"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(89; "Bulk Overtime"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Overtime Bulk"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(90; "Update Profile"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Employee Edit"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(91; "Transfer"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Employee Transfer" | "HR Transfer"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(92; "Transfer Claim"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Transfer Claim"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(93; "Insurance"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Insurance"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(94; "Outsource Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Outsource),
                                                Status = const(Active)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(95; "Probation Ending Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Probation),
                                                Status = const(Active),
                                                "Trainee/Probation End date" = field("Contract Expiry Date Filter")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(96; "Temporary Ending Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Temporary),
                                                Status = const(Active),
                                                "Trainee/Probation End date" = field("Contract Expiry Date Filter")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(97; "Probation Ended Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Probation),
                                                Status = const(Active),
                                                "Resignation Date" = field("Zero Date Filter"),
                                                "Trainee/Probation End date" = field("Expiry Check Date")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(98; "Temporary Ended Staff"; Integer)
        {
            CalcFormula = count(Employee where("Employment Type" = const(Temporary),
                                                Status = const(Active),
                                                "Resignation Date" = field("Zero Date Filter"),
                                                "Trainee/Probation End date" = field("Expiry Check Date")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(99; "Zero Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(100; "Allowance Assignment Memo"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Allowance Assignment Memo"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(101; "Request Allowance"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Request Allowance"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
        field(102; "Shift Assignment Memo"; Integer)
        {
            CalcFormula = count("Approval HRMS" where("Document Type" = filter("Shift Assignment Memo"), "Approval Status" = const(Open), "Approver No" = field("Employee Filter")));
            Description = 'Request To Approve';
            FieldClass = FlowField;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }
}
