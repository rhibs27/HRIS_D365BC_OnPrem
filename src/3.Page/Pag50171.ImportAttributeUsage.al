page 50171 "Import Attribute Usage"
{
    ApplicationArea = All;
    Caption = 'Import Attribute Usage';
    PageType = List;
    SourceTable = "Import Attribute Usage";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Editable = Rec.Posted = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.', Comment = '%';
                    Editable = Rec.Posted = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Editable = Rec.Posted = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                    Editable = Rec.Posted = false;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                    Editable = Rec.Posted = false;
                }
                field("Posted"; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(ExcelImport; "Import From Excel") { }
            actionref(PostLines; Post) { }
            actionref(ShowPosted; "Posted Data") { }
            actionref(ShowUnPostedData; "UnPosted Data") { }
        }
        area(Processing)
        {
            action("Import From Excel")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = ImportExcel;
                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import";
                begin
                    ExcelImport.ImportFromExcelSheet(Database::"Import Attribute Usage", '', false);
                end;
            }
            action("Post")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = Post;
                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to post the selected data?', false) then
                        exit;
                    Rec.Reset();
                    Rec.SetRange(Posted, false);
                    if Rec.FindSet() then
                        repeat
                            Rec.PostAttributeUsage(Rec);
                        until Rec.Next() = 0;
                end;
            }
            action("Posted Data")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = PostedTaxInvoice;
                Caption = 'Show Posted Data';
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetRange(Posted, true);
                    Rec.FilterGroup(0);
                end;
            }
            action("UnPosted Data")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = Open;
                Caption = 'UnPosted Data';
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetRange(Posted, false);
                    Rec.FilterGroup(0);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if not Rec.Posted then
            EditableControl := true;
    end;

    var
        EditableControl: Boolean;
}
