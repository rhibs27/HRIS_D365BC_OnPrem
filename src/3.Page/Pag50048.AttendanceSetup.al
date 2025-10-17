page 50048 "Attendance Setup"
{
    // version ATM.19.01.01

    PageType = Card;
    SourceTable = "Attendance Setup";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Attendance Document No. Series"; Rec."Attendance Document No. Series")
                {
                    ToolTip = 'Specifies the value of the Attendance Document No. Series field.';
                    ApplicationArea = All;
                }
                field("Base Calender"; Rec."Base Calender")
                {
                    ToolTip = 'Specifies the value of the Base Calender field.';
                    ApplicationArea = All;
                }
                field("Type of Integration"; Rec."Type of Integration")
                {
                    ToolTip = 'Specifies the value of the Type of Integration field.';
                    ApplicationArea = All;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ToolTip = 'Specifies the value of the Calculation Method field.';
                    ApplicationArea = All;
                }
                field("Attendance Line No. Series"; Rec."Attendance Line No. Series")
                {
                    ToolTip = 'Specifies the value of the Attendance Line No. Series field.';
                    ApplicationArea = All;
                }
                field("Working Hour per day"; Rec."Working Hour per day")
                {
                    ToolTip = 'Specifies the value of the Working Hour per day field.';
                    ApplicationArea = All;
                }
                field("Deactivate Punch in Count"; Rec."Deactivate Punch in Count")
                {
                    ToolTip = 'Specifies the value of the Deactivate Punch in Count field.';
                    ApplicationArea = All;
                }
                field("Activate Punch in Date"; Rec."Activate Punch in Date")
                {
                    ToolTip = 'Specifies the value of the Activate Punch in Date field.';
                    ApplicationArea = All;
                }
                field("Sync Attendance From"; Rec."Sync Attendance From")
                {
                    ToolTip = 'Specifies the value of the Sync Attendance From field.';
                    ApplicationArea = All;
                }
                field("Half Substitute Leave Hrs"; Rec."Half Substitute Leave Hrs")
                {
                    ToolTip = 'Specifies the value of the Half Substitute Leave Hrs field.';
                    ApplicationArea = All;
                }
                field("Full Substitute Leave Hrs"; Rec."Full Substitute Leave Hrs")
                {
                    ToolTip = 'Specifies the value of the Full Substitute Leave Hrs field.';
                    ApplicationArea = All;
                }
                field("Max Overtime In Week"; Rec."Max Overtime In Week")
                {
                    ToolTip = 'Specifies the value of the Max Overtime In Week field.';
                    ApplicationArea = All;
                }
                field("Check Out From"; Rec."Check Out From")
                {
                    ToolTip = 'Specifies the value of the Check Out From field(Hrs).';
                    ApplicationArea = All;
                    Caption = 'Check Out From(Hrs)';
                }
                field("Overtime Claim Type"; Rec."Overtime Claim Type")
                {
                    ToolTip = 'Specifies the value of the Overtime Claim Type';
                    ApplicationArea = All;
                    Caption = 'Overtime Claim Type';
                }

            }
            group(Integration)
            {
                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the URL field.';
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ExtendedDatatype = Masked;
                }
            }
            group("Sp")
            {
                Caption = 'Run Attendance Sync form Procedure';
                field("Store Procedure Name"; Rec."Store Procedure Name")
                {
                    ToolTip = 'Specifies the value of the Store Procedure Name field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Run Attendance Sync")
            {
                Caption = 'Run Attendance Sync';
                ApplicationArea = All;
                ToolTip = 'Sync Attendance From Biometric Device';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BiometricMgt: Codeunit "Biometric Mgt.";
                begin
                    Rec.TestField("Store Procedure Name");
                    Rec.TestField("Base URL");
                    BiometricMgt.ExecuteStoredProcedure(Rec."Store Procedure Name");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

}
