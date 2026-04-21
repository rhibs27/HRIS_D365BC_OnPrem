pageextension 50015 "Employee Relatives" extends "Employee Relatives"
{
    layout
    {
        modify("Relative's Employee No.")
        {
            Visible = true;
            Editable = rec.Employee_BOD = rec.Employee_BOD::Employee;
        }
        modify("First Name")
        {
            Caption = 'Full Name';
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        addbefore("Relative's Employee No.")
        {
            field(Employee_BOD; Rec.Employee_BOD)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee_BOD Relation field.';
                trigger OnValidate()
                begin
                    if Rec.Employee_BOD <> xRec.Employee_BOD then
                        Clear(REC."Relative's Employee No.");
                end;
            }
        }
        addbefore("Birth Date")
        {
            field("Full Name"; Rec."Full Name")
            {
                ApplicationArea = All;
            }

            field("E-mail"; Rec."E-mail")
            {
                ApplicationArea = All;
            }
            field("Set Emergency Contact"; Rec."Set Emergency Contact")
            {
                ApplicationArea = All;
            }
            field("Set Nominee"; Rec."Set Nominee")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Full Name")
        {
            field("Lt."; Rec."Lt.")
            {
                Caption = 'Late';
                ApplicationArea = all;
            }
        }
        moveafter("Relative Code"; "Phone No.")
        addafter("Relative's Employee No.")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address field.';
                Visible = false;
            }
            field("Name(Nepali)"; Rec."Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name(Nepali) field.';
            }
            field("Citizenship No."; Rec."Citizenship No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship No. field.';
            }
            field("Fathers Name(Nepali)"; Rec."Fathers Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fathers Name(Nepali) field.';
                Visible = false;
            }

            field("GrandFather Name(Nepali)"; Rec."GrandFather Name(Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GrandFather Name(Nepali) field.';
                Visible = false;
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
            field(Discontinue; Rec.Discontinue)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Discontinue field.';
            }

            field(Age; Rec.Age)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Age field.';
                Visible = false;
            }
            field("Citizenship Date"; Rec."Citizenship Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Date field.';
                Visible = false;
            }
            field("Citizenship Issued District"; Rec."Citizenship Issued District")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Issued District field.';
                Visible = false;
            }
            field("Citizenship Date (Nepali)"; Rec."Citizenship Date (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Citizenship Date (Nepali) field.';
                Visible = false;
            }

        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Validate("Master Type", Rec."Master Type"::Employee);
    end;
}
