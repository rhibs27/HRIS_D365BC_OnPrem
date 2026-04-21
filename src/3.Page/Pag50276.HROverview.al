page 50276 "HR Overview"
{
    ApplicationArea = All;
    Caption = 'HR Overview';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            grid("Active Employees")
            {
                group("Active Employee")
                {
                    field("Permanent Staff"; Rec."Permanent Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Permanent Staff field.';
                        ApplicationArea = All;
                    }
                    field("Probation Staff"; Rec."Probation Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Probation Staff field.';
                        ApplicationArea = All;
                    }
                    field("Contract Staff"; Rec."Contract Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Contract Staff field.';
                        ApplicationArea = All;
                    }
                    field("Temporary Staff"; Rec."Temporary Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Temporary Staff field.';
                        ApplicationArea = All;
                    }
                    field("Outsource Staff"; Rec."Outsource Staff")
                    {
                        ToolTip = 'Specifies the value of the Outsource Staff field.', Comment = '%';
                    }
                }
                group("To Review")
                {
                    field("Contract Expiry Staff"; Rec."Contract Expiry Staff")
                    {
                        ToolTip = 'Specifies the value of the Expiring field.';
                        ApplicationArea = All;
                    }
                    field("Contract Expired Staff"; Rec."Contract Expired Staff")
                    {
                        ToolTip = 'Specifies the value of the Expired field.';
                        ApplicationArea = All;
                    }
                    field("Probation Ending Staff"; Rec."Probation Ending Staff")
                    {
                        ToolTip = 'Specifies the value of the Probation Ending field.';
                        ApplicationArea = All;
                    }
                    field("Probation Ended Staff"; Rec."Probation Ended Staff")
                    {
                        ToolTip = 'Specifies the value of the Probation Ended Staff field.', Comment = '%';
                    }
                    field("Temporary Ending Staff"; Rec."Temporary Ending Staff")
                    {
                        ToolTip = 'Specifies the value of the Temporary Ending field.';
                        ApplicationArea = All;
                    }
                    field("Temporary Ended Staff"; Rec."Temporary Ended Staff")
                    {
                        ToolTip = 'Specifies the value of the Temporary Ended Staff field.', Comment = '%';
                    }
                }
            }

            grid("RequestToApprove")
            {
                group("Request To Approve")
                {
                    field("Leave Request"; Rec."Leave Request")
                    {
                        ToolTip = 'Specifies the value of the Leave Request field.';
                        ApplicationArea = All;
                    }
                    field("Travel Request"; Rec."Travel Request")
                    {
                        ToolTip = 'Specifies the value of the Travel Request field.';
                        ApplicationArea = All;
                    }
                    field("Travel Claim"; Rec."Travel Claim")
                    {
                        ToolTip = 'Specifies the value of the Travel Claim field.';
                        ApplicationArea = All;
                    }
                    field("Update Attendance"; Rec."Update Attendance")
                    {
                        ToolTip = 'Specifies the value of the Update Attendance field.';
                        ApplicationArea = All;
                    }
                    field("Late Attendance"; Rec."Late Attendance")
                    {
                        ToolTip = 'Specifies the value of the Late Attendance field.';
                        ApplicationArea = All;
                    }
                    field("Allowance Assignment"; Rec."Allowance Assignment")
                    {
                        ToolTip = 'Specifies the value of the Allowance Assignment field.';
                        ApplicationArea = All;
                    }
                    field("Allowance Assignment Claim"; Rec."Allowance Assignment Claim")
                    {
                        ToolTip = 'Specifies the value of the Allowance Assignment Claim field.';
                        ApplicationArea = All;
                    }
                    field("Shift Assignment"; Rec."Shift Assignment")
                    {
                        ToolTip = 'Specifies the value of the Shift Assignment field.';
                        ApplicationArea = All;
                    }
                    field("Overtime"; Rec."Overtime")
                    {
                        ToolTip = 'Specifies the value of the Overtime field.';
                        ApplicationArea = All;
                    }
                    field("Bulk Overtime"; Rec."Bulk Overtime")
                    {
                        ToolTip = 'Specifies the value of the Bulk Overtime field.';
                        ApplicationArea = All;
                    }
                    field("Update Profile"; Rec."Update Profile")
                    {
                        ToolTip = 'Specifies the value of the Bulk Overtime field.';
                        ApplicationArea = All;
                    }
                    field("Transfer"; Rec."Transfer")
                    {
                        ToolTip = 'Specifies the value of the Transfer field.';
                        ApplicationArea = All;
                    }
                    field("Transfer Claim"; Rec."Transfer Claim")
                    {
                        ToolTip = 'Specifies the value of the Transfer Claim field.';
                        ApplicationArea = All;
                    }
                    field("Insurance"; Rec."Insurance")
                    {
                        ToolTip = 'Specifies the value of the Insurance field.';
                        ApplicationArea = All;
                    }
                    field("Retirement Fund"; Rec."Retirement Fund")
                    {
                        ToolTip = 'Specifies the value of the Retirement Fund field.';
                        ApplicationArea = All;
                    }
                    field(Resignation; Rec.Resignation)
                    {
                        ToolTip = 'Specifies the value of the Resignation field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        HrSetup.Get();
        Rec.SetFilter("Contract Expiry Date Filter", '%1..%2', today, CalcDate(HrSetup."Contract Expiry Days", Today));
        Rec.SetFilter("Expiry Check Date", '..%1&<>%2', Today, 0D);
        Rec.SetRange("Employee Filter", HrMgt.GetEmployeeNo());
        Rec.SetFilter("Zero Date Filter", '%1', 0D);
    end;

    var
        HrSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
}
