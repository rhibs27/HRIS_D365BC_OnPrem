page 50176 "Biometric Attendance Log"
{
    ApplicationArea = All;
    Caption = 'Biometric Attendance Log';
    PageType = List;
    SourceTable = "Biometric Attendance Log";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Device Id"; Rec."Device Id")
                {
                    ToolTip = 'Specifies the value of the Device Id field.';
                    ApplicationArea = all;
                }
                field("Device SN"; Rec."Device SN")
                {
                    ApplicationArea = all;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = all;
                }
                field("User PIN"; Rec."User PIN")
                {
                    ToolTip = 'Specifies the value of the User PIN field.';
                    ApplicationArea = all;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                    ApplicationArea = all;
                }
                field("Attendance Date"; Rec."Attendance Date")
                {
                    ApplicationArea = all;
                }
                field("Attendance Time"; Rec."Attendance Time")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Sync Log")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = Transactions;
                trigger OnAction()
                var
                    DeviceConfig: Record "Biometric Device Config.";
                    AdmsMgt: Codeunit "Biometric Mgt.";
                begin

                    Report.Run(Report::"Biometric Log Sync");
                end;
            }
        }
    }

}
