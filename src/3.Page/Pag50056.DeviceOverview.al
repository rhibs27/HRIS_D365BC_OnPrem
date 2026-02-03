page 50056 "Device Overview"
{
    ApplicationArea = All;
    Caption = 'Device Overview';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            Grid(General)
            {
                ShowCaption = false;
                group(BiometricDevices)
                {
                    Caption = 'Biometric Devices';

                    field("Active Biometric Device"; Rec."Active Biometric Device")
                    {
                        Caption = 'Active';
                        ToolTip = 'Specifies the value of the Active Biometric Device field.', Comment = '%';
                    }
                    field("Inactive Biometric Device"; Rec."Inactive Biometric Device")
                    {
                        Caption = 'Inactive';
                        ToolTip = 'Specifies the value of the Inactive Biometric Device field.', Comment = '%';
                    }
                    field("Total Biometric Device"; Rec."Total Biometric Device")
                    {
                        Caption = 'Total';
                        ToolTip = 'Specifies the value of the Total Biometric Device field.', Comment = '%';
                        StyleExpr = TRUE;
                        Style = Strong;
                    }
                }
            }
        }
    }
}
