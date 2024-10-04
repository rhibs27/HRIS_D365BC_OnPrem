tableextension 33019814 "Qualification Ext" extends Qualification
{
    fields
    {
        field(33019800; "Type"; Option)
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
        field(33019801; Rank; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(33019802; "Qualification Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",SLC,"+2",Bachelor,Master;
            OptionCaption = ' ,SLC,+2,Bachelor,Master';
        }
    }
}
