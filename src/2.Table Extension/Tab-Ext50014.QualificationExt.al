tableextension 50014 "Qualification Ext" extends Qualification
{
    fields
    {
        field(50000; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Education,Work;
            OptionCaption = ' ,Education,Work';
            trigger OnValidate()
            begin
                if not (Type = xRec.Type) then
                    Clear("Qualification Type");
            end;
        }
        field(50001; Rank; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Qualification Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",SLC,"+2",Bachelor,Master;
            OptionCaption = ' ,SLC,+2,Bachelor,Master';
        }
    }
}
