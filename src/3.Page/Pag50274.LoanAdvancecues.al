page 50274 "Loan & Advance cues"
{
    ApplicationArea = All;
    Caption = 'Loan & Advance Details';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            grid("Salary Advances")
            {
                group("Salary Advance")
                {
                    Visible = SalaryAdvVisibility;
                    // field("To Screen Salary Advance"; Rec."To Screen Salary Advance")
                    // {
                    //     Caption = 'To Screen';
                    //     DrillDownPageID = "Employee Salary Advance List";
                    //     ToolTip = 'Specifies the value of the To Screen field.';
                    //     ApplicationArea = All;
                    // }
                    // field("To Approve Salary Advance"; Rec."To Approve Salary Advance")
                    // {
                    //     Caption = 'To Approve';
                    //     DrillDownPageID = "Employee Salary Advance List";
                    //     ToolTip = 'Specifies the value of the To Approve field.';
                    //     ApplicationArea = All;
                    // }
                    field("Approved Salary Advance"; Rec."Approved Salary Advance")
                    {
                        Caption = 'Approved';
                        DrillDownPageID = "Employee Salary Advance List";
                        ToolTip = 'Specifies the value of the Approved field.';
                        ApplicationArea = All;
                    }
                    field("Rejected Salary Advance"; Rec."Rejected Salary Advance")
                    {
                        Caption = 'Rejected';
                        DrillDownPageID = "Employee Salary Advance List";
                        ToolTip = 'Specifies the value of the Rejected field.';
                        ApplicationArea = All;
                    }
                }
            }
            grid("Personal Loans")
            {
                group("Personal Loan")
                {
                    Visible = SalaryAdvVisibility;
                    // field("To Screen Personal Loan"; Rec."To Screen Personal Loan")
                    // {
                    //     Caption = 'To Screen';
                    //     DrillDownPageID = "Employee Personal Loan List";
                    //     ToolTip = 'Specifies the value of the To Screen field.';
                    //     ApplicationArea = All;
                    // }
                    // field("To Approve Persoanl Loan"; Rec."To Approve Persoanl Loan")
                    // {
                    //     Caption = 'To Approve';
                    //     DrillDownPageID = "Employee Personal Loan List";
                    //     ToolTip = 'Specifies the value of the To Approve field.';
                    //     ApplicationArea = All;
                    // }
                    field("Approved Persoanl Loan"; Rec."Approved Persoanl Loan")
                    {
                        Caption = 'Approved';
                        DrillDownPageID = "Employee Personal Loan List";
                        ToolTip = 'Specifies the value of the Approved field.';
                        ApplicationArea = All;
                    }
                    field("Rejected Personal Loan"; Rec."Rejected Personal Loan")
                    {
                        Caption = 'Rejected';
                        DrillDownPageID = "Employee Personal Loan List";
                        ToolTip = 'Specifies the value of the Rejected field.';
                        ApplicationArea = All;
                    }
                }
            }
            grid("Home Loans")
            {

                group("Home Loan")
                {
                    Visible = SalaryAdvVisibility;
                    // field("To Screen Home Loan"; Rec."To Screen Home Loan")
                    // {
                    //     Caption = 'To Screen';
                    //     DrillDownPageID = "Employee Home Loan List";
                    //     ToolTip = 'Specifies the value of the To Screen field.';
                    //     ApplicationArea = All;
                    // }
                    // field("To Approve Home Loan"; Rec."To Approve Home Loan")
                    // {
                    //     Caption = 'To Approve';
                    //     DrillDownPageID = "Employee Home Loan List";
                    //     ToolTip = 'Specifies the value of the To Approve field.';
                    //     ApplicationArea = All;
                    // }
                    field("Approved Home Loan"; Rec."Approved Home Loan")
                    {
                        Caption = 'Approved';
                        DrillDownPageID = "Employee Home Loan List";
                        ToolTip = 'Specifies the value of the Approved field.';
                        ApplicationArea = All;
                    }
                    field("Rejected Home Loan"; Rec."Rejected Home Loan")
                    {
                        Caption = 'Rejected';
                        DrillDownPageID = "Employee Home Loan List";
                        ToolTip = 'Specifies the value of the Rejected field.';
                        ApplicationArea = All;
                    }
                }
            }
            grid("Vehicle Loans")
            {
                Visible = SalaryAdvVisibility;
                group("Vehicle Loan")
                {

                    // field("To Screen Vehicle Loan"; Rec."To Screen Vehicle Loan")
                    // {
                    //     Caption = 'To Screen';
                    //     DrillDownPageId = "Employee Vehicle Loan List";
                    //     ToolTip = 'Specifies the value of the To Screen field.';
                    //     ApplicationArea = All;
                    // }
                    // field("To Approve Vehicle Loan"; Rec."To Approve Vehicle Loan")
                    // {
                    //     Caption = 'To Approve';
                    //     DrillDownPageId = "Employee Vehicle Loan List";
                    //     ToolTip = 'Specifies the value of the To Approve field.';
                    //     ApplicationArea = All;
                    // }
                    field("Approved Vehicle Loan"; Rec."Approved Vehicle Loan")
                    {
                        Caption = 'Approved';
                        DrillDownPageId = "Employee Vehicle Loan List";
                        ToolTip = 'Specifies the value of the Approved field.';
                        ApplicationArea = All;
                    }
                    field("Rejected Vehicle Loan"; Rec."Rejected Vehicle Loan")
                    {
                        Caption = 'Rejected';
                        DrillDownPageId = "Employee Vehicle Loan List";
                        ToolTip = 'Specifies the value of the Rejected field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Reset;
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst then begin
            SalaryAdvVisibility := UserSetup."For Salary Advance";
        end;
    end;

    var
        UserSetup: Record "User Setup";
        SalaryAdvVisibility: Boolean;
}
