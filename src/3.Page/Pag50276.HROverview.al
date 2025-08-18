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

                }
            }
            field("Contract Expiry Employees"; Rec."Contract Expiry Employees")
            {
                Caption = 'Contract Expiring';
                ToolTip = 'Specifies the value of the Expiring field.';
                ApplicationArea = All;
            }

            field("Contract Expired Employees"; Rec."Contract Expired Employees")
            {
                Caption = 'Contract Expired';
                ToolTip = 'Specifies the value of the Expired field.';
                ApplicationArea = All;
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
                }
            }







        }
    }
    var
        usersetup: Record "User Setup";


}
