pageextension 50007 "Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        modify("County Name")
        {
            Visible = false;
        }
        modify("Intrastat Code")
        {
            Visible = false;
        }
        modify("ISO Code")
        {
            Visible = false;
        }
        modify("ISO Numeric Code")
        {
            Visible = false;
        }
        modify("EU Country/Region Code")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("Is SAARC"; Rec."Is SAARC")
            {
                ApplicationArea = all;
            }
            field("Is Nepal"; Rec."Is Nepal")
            {
                ApplicationArea = all;
            }
        }
    }
}
