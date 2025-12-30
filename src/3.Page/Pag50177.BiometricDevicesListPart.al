page 50177 "Biometric Devices ListPart"
{
    ApplicationArea = All;
    Caption = 'Biometric Devices';
    PageType = ListPart;
    SourceTable = "Biometric Device Config.";
    layout
    {
        area(Content)
        {
            repeater(conrol1)
            {
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(IP; Rec.IP)
                {
                    ToolTip = 'Specifies the value of the IP field.';
                }
                field("Is Active"; Rec."Is Active")
                {
                    ToolTip = 'Specifies the value of the Is Active field.', Comment = '%';
                }
                field("Last Sync Date"; Rec."Last Sync Date")
                {
                    ToolTip = 'Specifies the value of the Last Activity field.';
                }
                field(SN; Rec.SN)
                {
                    ToolTip = 'Specifies the value of the SN field.';
                }
            }
        }
    }
}
