page 50174 "Biometric Device Config."
{
    ApplicationArea = All;
    Caption = 'Biometric Device Config.';
    PageType = List;
    SourceTable = "Biometric Device Config.";
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(IP; Rec.IP)
                {
                    ToolTip = 'Specifies the value of the IP field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field(SN; Rec.SN)
                {
                    ToolTip = 'Specifies the value of the SN field.';
                }
                field("Device Status"; Rec."Device Status")
                {
                    ToolTip = 'Specifies the value of the Device Status field.';
                }
                field("Connectivity Status"; Rec."Connectivity Status")
                {
                    ApplicationArea = all;
                }
                field("Last Activity"; Rec."Last Activity")
                {
                    ToolTip = 'Specifies the value of the Last Activity field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }

                field("Dev Funs"; Rec."Dev Funs")
                {
                    ToolTip = 'Specifies the value of the Dev Funs field.';
                }
                field("Device Model"; Rec."Device Model")
                {
                    ToolTip = 'Specifies the value of the Device Model field.';
                }

                field("FP Count"; Rec."FP Count")
                {
                    ToolTip = 'Specifies the value of the FP Count field.';
                }
                field("Face Count"; Rec."Face Count")
                {
                    ToolTip = 'Specifies the value of the Face Count field.';
                }
                field("Firmware Version"; Rec."Firmware Version")
                {
                    ToolTip = 'Specifies the value of the Firmware Version field.';
                }
                field("Is Access Device"; Rec."Is Access Device")
                {
                    ToolTip = 'Specifies the value of the Is Access Device field.';
                }
                field("Is Face Device"; Rec."Is Face Device")
                {
                    ToolTip = 'Specifies the value of the Is Face Device field.';
                }

                field("Trans Count"; Rec."Trans Count")
                {
                    ToolTip = 'Specifies the value of the Trans Count field.';
                }
                field("User Count"; Rec."User Count")
                {
                    ToolTip = 'Specifies the value of the User Count field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Sync Device Config")
            {
                Image = OutlookSyncFields;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    AdmsMgt: Codeunit "Biometric Mgt.";
                begin
                    AdmsMgt.SyncDeviceConfig();
                end;
            }
            action("Sync Log")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = Transactions;
                trigger OnAction()
                var
                    ADMSMgt: Codeunit "Biometric Mgt.";
                    DeviceCongig: Record "Biometric Device Config.";
                begin
                    DeviceCongig.Reset();
                    DeviceCongig.SetRange(SN, rec.SN);
                    DeviceCongig.SetFilter("Date Filter", '%1..%2', Today - 30, Today);
                    if DeviceCongig.FindSet() then
                        Report.Run(Report::"Biometric Log Sync", true, false, DeviceCongig);
                end;
            }
            action(Refresh)
            {
                ToolTip = 'Get current connectivity status';
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                trigger OnAction()
                var
                    ADMSMgt: Codeunit "Biometric Mgt.";
                    DeviceCongig: Record "Biometric Device Config.";

                begin
                    // CurrPage.SetSelectionFilter(Rec);
                    // if Rec.FindSet() then
                    //     repeat
                    //         ADMSMgt.CheckDeviceConnectivity(Rec);
                    //     until Rec.Next() = 0;

                    // Message('Connectivity Status updated sucessfully!');

                end;

            }
            // action("Clear Log from device")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin
            //         AdmsMgt.DeletelogFromDevice(Rec.SN);
            //     end;
            // }
            // action("delete user from device")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin

            //         AdmsMgt.DeleteUserFromDevice(1000007, Rec."Branch Code");
            //     end;
            // }

            // action("delete face from device")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin

            //         AdmsMgt.DeleteUserfaceFromDevice(1000007, Rec."Branch Code");
            //     end;
            // }
            // action("delete finger print device")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin

            //         AdmsMgt.DeleteUserFingerprintFromDevice(1000007, Rec."Branch Code");
            //     end;
            // }
            // action("delete Picture from device")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin

            //         AdmsMgt.DeleteUserPictureFromDevice(1000007, Rec."Branch Code");
            //     end;
            // }
            // action("send new employee to dev")
            // {
            //     Image = OutlookSyncFields;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         AdmsMgt: Codeunit "Biometric Mgt.";
            //     begin

            //         AdmsMgt.SendEmployeeDatatoNewDevice(1000007, Rec.SN);
            //     end;
            // }
        }

    }
}
