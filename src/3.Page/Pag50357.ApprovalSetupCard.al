page 50357 "Approval Setup Card"
{
    ApplicationArea = All;
    Caption = 'Approval Setup Card';
    PageType = Card;
    SourceTable = "Approval Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Request Type"; Rec."Request Type")
                {
                    ToolTip = 'Specifies the value of the Request Type field.', Comment = '%';
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the value of the Deputation On field.', Comment = '%';
                }
                field("Approval Sending Policy"; Rec."Approval Sending Policy")
                {
                    ToolTip = 'Specifies the value of the Approval Sending Policy field.', Comment = '%';
                }
                field("Approval Entry Creation Policy"; Rec."Approval Entry Creation Policy")
                {
                    ToolTip = 'Specifies the value of the Approval Entry Creation Policy field.', Comment = '%';
                }
            }
            part("Approval Setup Lines"; "Approval Setup Subform")
            {
                Caption = 'Approval Setup Lines';
                ApplicationArea = all;
                SubPageLink = "Request Type" = field("Request Type"), "Deputation On" = field("Deputation On");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            // action("Import Setup")
            // {
            //     Image = ImportExcel;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Import Setup action.';
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     begin
            //         Rec.TestField("Request Type");
            //         Rec.TestField("Deputation On");
            //         if Confirm('Do you want to import Approval Setup line From Excel?', false) then
            //             ExcelImport.ImportFromExcelSheet(Database::"Approval Setup Line", '', false);
            //     end;
            // }
            // action("Export Setup")
            // {
            //     Image = ExportFile;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Export Setup in Excel action.';
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want to Export Approval Setup line?', false) then begin
            //             ApprovalSetupLine.SetRange("Request Type", Rec."Request Type");
            //             ApprovalSetupLine.SetRange("Deputation On", Rec."Deputation On");
            //             RecRef.GetTable(ApprovalSetupLine);
            //             // ExcelImport.ExportDataInExcel(RecRef);
            //         end;
            //     end;
            // }
        }
    }
    var
        ExcelImport: Codeunit "Excel Import";
        RecRef: RecordRef;
        ApprovalSetupLine: Record "Approval Setup Line";
}
