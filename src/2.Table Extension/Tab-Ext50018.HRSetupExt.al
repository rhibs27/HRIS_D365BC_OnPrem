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
        field(50083; "Base Interest Rate";
        Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60000; "Training Question"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Training Question No series';
        }
        field(60001; "No Leave Approved Days";
        Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Transfer';
        }
        field(60002; "Transfer No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Transfer No. Series';
        }
        field(60003; "OT No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'OT No. Series';
        }
        field(60004; "Out of office No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Out of Office No. Series';
        }
        field(60005; "Bulk Cash No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Bulk Cash No. Series';
        }
        field(60006; "OT eligible hour"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60007; "HR Head Functional Title"; Code[20])
        {
            TableRelation = "Functional Title".Code;
            DataClassification = CustomerContent;
        }
        field(60008; "HR Department Code"; Code[20])
        {
            TableRelation = Department.Code;
            DataClassification = CustomerContent;
        }
        field(60009; "Resignation No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(60010; "Resignation Period Contract"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(60011; "Resignation Period Probation"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(60012; "Resignation Period Permanent"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(60013; "Vehicle Loan Eligible Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible vehicle loan amount';
        }
        field(60014; "Home Loan Eligible Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For eligible home loan amount';
        }
        field(60015; "Max. Service Period"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Resignation';
        }
        field(60017; "Personal Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(60018; "Home Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(60019; "Vehicle Loan No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'No. series';
        }
        field(60020; "Written Exam Weightage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60021; "Interview Weightage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60022; "Promotion No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60023; "Resignation Approver"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(60024; "Cancel Document No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60025; "V.loan Repay. Limit SO or less"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Loan Limit';
        }
        field(60026; "Portal Feedback No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60027; "Clearance Statement I"; Text[250])
        {
            DataClassification = CustomerContent;
            Description = 'resignation';
        }
        field(60028; "Clearance Statement II"; Text[250])
        {
            DataClassification = CustomerContent;
            Description = 'resignation';
        }
        field(60029; "Home/Persona Loan Repay Period"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Home Loan';
        }
        field(60030; "Home Loan Confirmation Period"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60031; "Attendance Missed No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Attendane Missed';
        }
        field(60032; "Spouse Code"; Code[10])
        {
            TableRelation = Relative;
            DataClassification = CustomerContent;
        }
        field(60033; "Access Control No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60034; "Finacle URL"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(60035; "Employee Change No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60036; "Evening Counter Eligible Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(60037; "Morning Counter Eligible Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(60038; "No of risk employee in Evening"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60039; "Json Token"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(60040; "Reschedule Vacancy Mail Cand."; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(60041; "ReSchedule Vancacy Mail Int."; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(60042; "Excellent Serivce Period"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Promotion';
        }
        field(60043; "Very Good Service Period"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'Promotion';
        }
        field(60044; "Employee Insurance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(60046; "Employee Declaration No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60047; "Below SO DBR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60048; "Loan Eligible Month Below SO"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60049; "Resignation Submit Email Temp"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(60050; "KRA Setup No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60051; "Attendance Email"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(60052; "Residential No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60053; "Salary Advance Apply Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60054; "Resignation Reject Email Temp"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020300; "Use Additional Date"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33020301; "Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020302; "Automatic Shortlisting"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33020303; "Apply System Restriction"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33020304; "Vacancy Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020305; "Leave Request No."; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'not in use';
        }
        field(33020306; "Grace Period"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(33020307; "Office Start Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(33020308; "Office End Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(33020309; "Maximum Leave Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33020310; "Training Request No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020311; "Applicant No."; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020312; "Attachment Storage Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Embedded,"Disk File";
        }
        field(33020313; "Attachment Storage Location"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(33020314; "Incident No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020315; "Appraisal No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020316; "Employee Req. No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020317; "HR Approver Email I"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(33020318; "HR Approver Email II"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(33020319; "HR Approver Email III"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(33020320; "HR Start From Month"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(33020322; "Leave Earn No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020323; "EmpActivity No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020344; "Training No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020345; "Salary Advance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020346; "No. of days to hire"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33020347; "Candidate Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020360; "Punctuality Tolerance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33020361; "Recruitment No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020362; "KPI No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020363; "Interview Schedule Candidate"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020364; "Interview Schedule Interviewer"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020365; "Offer Letter Sent"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020366; "Leave No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020369; "Travel Request No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020370; "Travel Claimed No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020371; "Training Calendar No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020372; "Experience No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020373; "Medical Insurance No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020374; "Gratuity Level 1"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020375; "Gratuity Level 2"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020376; "Gratuity Level 3"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020377; "Gratuity Level 4"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020378; "Gratuity Rate for Level 1"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020379; "Gratuity Rate for Level 2"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020380; "Gratuity Rate for Level 3"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020381; "Gratuity Rate for Level 4"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020384; "Medical Insurance"; Code[20])
        {
            TableRelation = "Payroll Attributes";
            DataClassification = CustomerContent;
        }
        field(33020385; "Policy Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(33020386; "Policy End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(33020387; "Medical Insurance Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020388; "Grade Adjustment Period"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(33020389; "APR Grade 2 Increment"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(33020390; "APR Grade 1 Increment"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(33020391; "Offer No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020392; "Email Appraisal"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020393; "Appointment Letter Sent"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020394; "Loan Disbursement Email"; Code[20])
        {
            TableRelation = "Email Template";
            DataClassification = CustomerContent;
        }
        field(33020395; "Portal Server"; Code[25])
        {
            DataClassification = CustomerContent;
        }
        field(33020396; "Portal Database"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33020397; "Portal SQL User"; Text[4]) { DataClassification = CustomerContent; }
        field(33020398; "Portal SQL Password"; Text[20])
        {
            // ExtendedDatatype = Masked;
            DataClassification = CustomerContent;
        }
        field(33020399; "Max. Veh. Loan Repay Period"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33020400; "Contract Expiry Days"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(33020401; "Retirement Fund Nos."; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(33020402; "Employment Before (Grade Incre"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(33020403; "Location Incentive 1"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'KPI1.00';
        }
        field(33020404; "Location Incentive 2"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'KPI1.00';
        }
        field(33020405; "Location Incentive 3"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'KPI1.00';
        }
        field(33020406; "KPI Appriasal No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}
