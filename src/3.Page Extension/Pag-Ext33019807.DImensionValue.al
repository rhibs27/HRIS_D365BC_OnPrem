pageextension 33019807 DImensionValue extends "Dimension Values"
{
    layout
    {
        addfirst(content)
        {
            field(Selected; Selected)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Selected field.';
            }
        }
        addafter("Consolidation Code")
        {
            field("Posting Region"; Rec."Posting Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Region field.', Comment = '%';
            }
            field(Province; Rec.Province)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Province field.', Comment = '%';
            }
            field("Sub-Province"; Rec."Sub-Province")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sub-Province field.', Comment = '%';
            }
            field(Cluster; Rec.Cluster)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cluster field.', Comment = '%';
            }
            field("Distance Criteria"; Rec."Distance Criteria")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distance Criteria field.', Comment = '%';
            }
            field(District; Rec.District)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the District field.', Comment = '%';
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address field.', Comment = '%';
            }
            field("Inside/Outisde Valley"; Rec."Inside/Outisde Valley")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inside/Outisde Valley field.', Comment = '%';
            }
            field("Remote Area Category"; Rec."Remote Area Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
            }
            field("Reporting Category"; Rec."Reporting Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reporting Category field.', Comment = '%';
            }
            field("Sol ID"; Rec."Sol ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sol ID field.', Comment = '%';
            }
            field("BM Category"; Rec."BM Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BM Category field.', Comment = '%';
            }
            field("Remote Area Reduction"; Rec."Remote Area Reduction")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remote Area Reduction field.', Comment = '%';
            }
            field(Municipality; Rec.Municipality)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Municipality field.', Comment = '%';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean

    begin
        if ShowSelected then begin
            Clear(DimText);
            TempDimValue.Reset;
            if TempDimValue.Find('-') then
                repeat
                    if DimText = '' then
                        DimText := TempDimValue.Code
                    else
                        DimText += '|' + TempDimValue.Code;
                until TempDimValue.Next = 0;
        end;
    end;

    var
        Selected: Boolean;
        ShowSelected: Boolean;
        TempDimValue: Record "Dimension Value" temporary;
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        DimText: Text;

    procedure AssignShowSelected();
    begin
        ShowSelected := true;
    end;

    procedure InsertTempDimValue(DimValueText: Text);
    begin
        //Inserting to temp table
        if DimValueText = '' then
            exit;
        GLSetup.Get;
        DimValue.Reset;
        DimValue.SetFilter("Dimension Code", GLSetup."Global Dimension 1 Code");
        DimValue.SetFilter(Code, DimValueText);
        if DimValue.Find('-') then
            repeat
                TempDimValue.Init;
                TempDimValue.Validate("Dimension Code", DimValue."Dimension Code");
                TempDimValue.Validate(Code, DimValue.Code);
                TempDimValue.Insert;
            until DimValue.Next = 0;
    end;

    local procedure CheckSelected(DimValueCode: Text): Boolean;
    begin
        //Checking if selected
        TempDimValue.Reset;
        TempDimValue.SetRange(Code, DimValueCode);
        if TempDimValue.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(DimvalueCode: Text);
    begin
        //Deleting from temp table
        TempDimValue.Reset;
        TempDimValue.SetRange(Code, DimvalueCode);
        if TempDimValue.FindFirst then
            TempDimValue.Delete;
    end;

    procedure ReturnDimText(): Text;
    begin
        exit(DimText);
    end;
}
