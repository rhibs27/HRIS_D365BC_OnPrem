pageextension 33019816 "Employee Relatives" extends "Employee Relatives"
{
    layout
    {
        addafter("Relative's Employee No.")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address field.';
            }
            field("Name(Nepali)"; Rec."Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name(Nepali) field.';
            }
            field("Fathers Name(Nepali)"; Rec."Fathers Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fathers Name(Nepali) field.';
            }
            field("GrandFather Name(Nepali)"; Rec."GrandFather Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GrandFather Name(Nepali) field.';
            }
            field(District; Rec.District)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the District field.';
            }
            field("VDC/Municipality"; Rec."VDC/Municipality")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VDC/Municipality field.';
            }
            field("Ward No"; Rec."Ward No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ward No field.';
            }
            field("Citizenship No."; Rec."Citizenship No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship No. field.';
            }
            field(Age; Rec.Age)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Age field.';
            }
            field("Citizenship Date"; Rec."Citizenship Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Date field.';
            }
            field("Citizenship Issued District"; Rec."Citizenship Issued District")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Issued District field.';
            }
            field("Citizenship Date (Nepali)"; Rec."Citizenship Date (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Date (Nepali) field.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Validate("Master Type", Rec."Master Type"::Employee);
    end;
}
