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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(SN; Rec.SN)
                {
                    ToolTip = 'Specifies the value of the SN field.';
                }
                field("Is Active"; Rec."Is Active")
                {
                    ToolTip = 'Specifies the value of the Is Active field.', Comment = '%';
                }
                field("Connectivity Status"; Rec."Connectivity Status")
                {
                    ApplicationArea = all;
                }
                field("Last Activity"; Rec."Last Sync Date")
                {
                    ToolTip = 'Specifies the value of the Last Activity field.';
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
                    DeviceCongig.SetRange(id, rec.Id);
                    DeviceCongig.SetFilter("Date Filter", '%1..%2', Today - 30, Today);
                    if DeviceCongig.FindSet() then
                        Report.Run(Report::"Biometric Log Sync", true, false, DeviceCongig);
                end;
            }
        }

    }
}
