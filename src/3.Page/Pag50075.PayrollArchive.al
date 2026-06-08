page 50075 "Payroll Archive"
{
    ApplicationArea = All;
    Caption = 'Payroll Archive';
    PageType = List;
    SourceTable = "Payroll Archive";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                }
                field(Allowances; Rec.Allowances)
                {
                    ToolTip = 'Specifies the value of the Allowances field.', Comment = '%';
                }
                field("Archive Version"; Rec."Archive Version")
                {
                    ToolTip = 'Specifies the value of the Archive Version field.', Comment = '%';
                }
                field("Attribute Amount"; Rec."Attribute Amount")
                {
                    ToolTip = 'Specifies the value of the Attribute Amount field.', Comment = '%';
                }
                field("BM Accomodation Amount"; Rec."BM Accomodation Amount")
                {
                    ToolTip = 'Specifies the value of the BM Accomodation Amount field.', Comment = '%';
                }
                field("Basic Salary"; Rec."Basic Salary")
                {
                    ToolTip = 'Specifies the value of the Basic Salary field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("EV Allowance"; Rec."EV Allowance")
                {
                    ToolTip = 'Specifies the value of the EV Allowance field.', Comment = '%';
                }
                field("Earning Cycle"; Rec."Earning Cycle")
                {
                    ToolTip = 'Specifies the value of the Earning Cycle field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("Employee Maintenence Allowance"; Rec."Employee Maintenence Allowance")
                {
                    ToolTip = 'Specifies the value of the Employee Maintenence Allowance field.', Comment = '%';
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ToolTip = 'Specifies the value of the Employment Type field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Expire Date"; Rec."Expire Date")
                {
                    ToolTip = 'Specifies the value of the Expire Date field.', Comment = '%';
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.', Comment = '%';
                }
                field("Fuel Limit (Ltrs)"; Rec."Fuel Limit (Ltrs)")
                {
                    ToolTip = 'Specifies the value of the Fuel Limit (Ltrs) field.', Comment = '%';
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.', Comment = '%';
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.', Comment = '%';
                }
                field("Grade Code"; Rec."Grade Code")
                {
                    ToolTip = 'Specifies the value of the Grade Code field.', Comment = '%';
                }
                field("Is AM"; Rec."Is AM")
                {
                    ToolTip = 'Specifies the value of the Is AM field.', Comment = '%';
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    ToolTip = 'Specifies the value of the KPI Incentive % field.', Comment = '%';
                }
                field("Min Service Yr. Eligibility"; Rec."Min Service Yr. Eligibility")
                {
                    ToolTip = 'Specifies the value of the Min Service Yr. Eligibility field.', Comment = '%';
                }
                field("No. of grade"; Rec."No. of grade")
                {
                    ToolTip = 'Specifies the value of the No. of grade field.', Comment = '%';
                }
                field("Outside/Inside Valley"; Rec."Outside/Inside Valley")
                {
                    ToolTip = 'Specifies the value of the Outside/Inside Valley field.', Comment = '%';
                }
                field("Payroll Attribute"; Rec."Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field(Rank; Rec.Rank)
                {
                    ToolTip = 'Specifies the value of the Rank field.', Comment = '%';
                }
                field(Region; Rec.Region)
                {
                    ToolTip = 'Specifies the value of the Region field.', Comment = '%';
                }
                field("Remote Allowance Amount"; Rec."Remote Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Remote Allowance Amount field.', Comment = '%';
                }
                field("Remote Area Category"; Rec."Remote Area Category")
                {
                    ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
                }
                field("Remote Area Deduction"; Rec."Remote Area Deduction")
                {
                    ToolTip = 'Specifies the value of the Remote Area Deduction field.', Comment = '%';
                }
                field("Remote allowance Percentage"; Rec."Remote allowance Percentage")
                {
                    ToolTip = 'Specifies the value of the Remote allowance Percentage field.', Comment = '%';
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.', Comment = '%';
                }
                field("Specific Payroll Attribute"; Rec."Specific Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Specific Payroll Attribute field.', Comment = '%';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = '%';
                }
                field("Transportation Allowance"; Rec."Transportation Allowance")
                {
                    ToolTip = 'Specifies the value of the Transportation Allowance field.', Comment = '%';
                }
                field("Vehicle Maintenence Allowance"; Rec."Vehicle Maintenence Allowance")
                {
                    ToolTip = 'Specifies the value of the Vehicle Maintenence Allowance field.', Comment = '%';
                }
            }
        }
    }
}
