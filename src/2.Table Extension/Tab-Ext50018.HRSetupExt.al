tableextension 50018 "HR Setup Ext" extends "Human Resources Setup"
{
    fields
    {
        field(50000; "Employee Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(50001; "Half Limit (out expense)"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Out of expense';
        }
        field(50002; "Full Limit (out expense)"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Out of expense';
        }
        field(50003; "Half Limit Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Out of expense';
        }
        field(50004; "Full Limit Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Out of expense';
        }
        field(50005; "Max Adv. Salary Payback Month"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Employee Advance Salary';
        }
        field(50006; "Retirement Age"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Loan,Resignation';
        }
        field(50007; "DBR Ratio"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Loan';
        }
        field(50008; "V.loan Repay. Limit above SO"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Loan';
        }
        field(50009; "Transfer Claim Approver"; Code[20])
        {
            TableRelation = "Functional Title".Code;
            DataClassification = CustomerContent;
            Description = 'Transfer';
        }
        field(50010; "Max. no. of Salary Adv. in FY"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Loan';
        }
        field(50011; "Relocation Dist. Criteria (T)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Outstation Dist. Criteria (T)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "BMAF Dist. Criteria (T)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Relocation Dist. Criteria (H)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Outstation Dist. Criteria (H)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50016; "BMAF Dist. Criteria (H)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Feedback Attach. Location"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Service History No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50019; "Base Interest Rate"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50021; "No Leave Approved Days"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Transfer';
        }
        field(50022; "Transfer No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Transfer No. Series';
        }
        field(50023; "OT No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'OT No. Series';
        }
        field(50024; "Out of office No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Out of Office No. Series';
        }
        field(50025; "Bulk Cash No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Bulk Cash No. Series';
        }
        field(50026; "OT eligible hour"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "HR Head Functional Title"; Code[20])
        {
            TableRelation = "Functional Title".Code;
            DataClassification = CustomerContent;
        }
        field(50028; "HR Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            DataClassification = CustomerContent;
        }
        field(50029; "Resignation No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(50030; "Resignation Period Contract"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(50031; "Resignation Period Probation"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(50032; "Resignation Period Permanent"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(50033; "Vehicle Loan Eligible Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible vehicle loan amount';
        }
        field(50034; "Home Loan Eligible Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible home loan amount';
        }
        field(50035; "Max. Service Period"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(50036; "Personal Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(50037; "Home Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(50038; "Vehicle Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(50041; "Promotion No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50042; "Resignation Approver"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(50043; "Cancel Document No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50044; "V.loan Repay. Limit SO or less"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Loan Limit';
        }
        field(50045; "Portal Feedback No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50046; "Clearance Statement I"; Text[250])
        {
            DataClassification = CustomerContent;
            Description = 'resignation';
        }
        field(50047; "Clearance Statement II"; Text[250])
        {
            DataClassification = CustomerContent;
            Description = 'resignation';
        }
        field(50048; "Home/Persona Loan Repay Period"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Home Loan';
        }
        field(50049; "Home Loan Confirmation Period"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50050; "Attendance Missed No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Attendane Missed';
        }
        field(50051; "Spouse Code"; Code[20])
        {
            TableRelation = Relative;
            DataClassification = CustomerContent;
        }
        field(50052; "Access Control No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50053; "Finacle URL"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(50054; "Employee Change No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50055; "Evening Counter Eligible Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(50056; "Morning Counter Eligible Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(50057; "No of risk employee in Evening"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50058; "Json Token"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50063; "Employee Insurance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50064; "Employee Declaration No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50065; "Below SO DBR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50066; "Loan Eligible Month Below SO"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50067; "Resignation Submit Email Temp"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(50069; "Attendance Email"; Code[80])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(50070; "Residential No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50071; "Salary Advance Apply Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50072; "Resignation Reject Email Temp"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(50086; "Attachment Storage Location"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50097; "Salary Advance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50106; "Leave No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50107; "Travel Request No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50108; "Travel Claimed No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50110; "Experience No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50111; "Medical Insurance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50112; "Gratuity Level 1"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50113; "Gratuity Level 2"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50114; "Gratuity Level 3"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50115; "Gratuity Level 4"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50116; "Gratuity Rate for Level 1"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50117; "Gratuity Rate for Level 2"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50118; "Gratuity Rate for Level 3"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50119; "Gratuity Rate for Level 4"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50120; "Medical Insurance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
            DataClassification = CustomerContent;
        }
        field(50121; "Policy Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50122; "Policy End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50123; "Medical Insurance Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50124; "Grade Adjustment Period"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50125; "APR Grade 2 Increment"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50126; "APR Grade 1 Increment"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50127; "Offer No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50128; "Email Appraisal"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(50130; "Loan Disbursement Email"; Code[80])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(50131; "Portal Server"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50132; "Portal Database"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50133; "Portal SQL User"; Text[10]) { DataClassification = CustomerContent; }
        field(50134; "Portal SQL Password"; Text[20])
        {
            ExtendedDatatype = Masked;
            DataClassification = CustomerContent;
        }
        field(50135; "Max. Veh. Loan Repay Period"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50136; "Contract Expiry Days"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50137; "Retirement Fund Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50143; "Cancel Document Upto (Days)"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Cancel allowed upto how many days from approved date';
        }
        field(50144; "Allowance Assignment Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50145; "SQL Table Name"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(50146; "Employee Act. Journal Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50147; "Shift Assignment Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50148; "Calculate Age using Nepali C."; Boolean)
        {
            Caption = 'Calculate Age using Nepali Calender';
        }
        field(50149; "Leave Rounding Precision"; Decimal) { }
        field(50150; "Leave Encashment Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50151; "Skip Approval On HR Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50152; "Home Loan Insur. TieUp No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50153; "Attribute Adjustment Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Attribute Adjustment No. Series';
        }
        field(50154; "Outstation Dist. Crit. (Himal)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50155; "Validate Permanent Address"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'Validate Permanent Address as per the province and district master. The main reason to add this setup is to allow user to input as per citizenship address which may not be in the master.';
        }
        field(50156; "Validate Temporary Address"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50158; "Hide Clearance Approver"; Boolean) { }
        field(50159; "Apply Resign Waiver"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50160; "Service Day without Last Date"; Boolean)
        {
            Caption = 'Service Day without Last Date';
        }
        field(50161; "Grievance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Grievance No. Series';
        }
        field(50162; "No of Salary Advance"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'No of Salary Advance Allowed in single Fiscal year.';
        }
        field(50163; "HL Eligibility Service Years"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible home loan Request';
        }
        field(50164; "HL Minimum Road Access OutV."; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible home loan Request Minimum Road Access Outside valley';
        }
        field(50165; "HL Minmum Road Access InV."; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible home loan Request Minimum Road Access Inside valley';
        }
        field(50166; "Staff Social Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(50167; "Max Staff Social Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For Max Staff Social Loan Amount';
        }
        field(50168; "Get Loan Table Balance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50169; "Loan Settlement No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series for Loan Settlement documents (all loan types)';
        }
        field(50170; "Skip Medical Approval Setup"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'Skip Medical Approval Setup';
        }
        field(50171; "CBS GL Code"; Code[20])
        {
            Caption = 'CBS G\L Code';
            DataClassification = CustomerContent;
            Description = 'Parking G\L';
        }
        field(50172; "CBS GL Name"; Text[100])
        {
            Caption = 'CBS G\L Name';
            DataClassification = CustomerContent;
            Description = 'Parking G\L';
        }
    }
    trigger onAfterInsert()
    begin
        "Validate Permanent Address" := true;
        "Validate Temporary Address" := true;
    end;
}
