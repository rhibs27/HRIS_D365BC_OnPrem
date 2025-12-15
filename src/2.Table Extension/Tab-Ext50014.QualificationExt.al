tableextension 50014 "Qualification Ext" extends Qualification
{
    fields
    {
        field(50000; "Type"; Enum "Emp. document Type")
        {
            DataClassification = CustomerContent;
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
        field(50002; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "GPA Scale"; Decimal)
        {
        }
    }
    trigger OnBeforeInsert()
    begin
        TestField(Code);
    end;

    trigger OnBeforeModify()
    begin
        TestField(Code);
    end;

    // local procedure CheckBlankCode()
    // begin
    //     if Code = '' then
    //         Error('Code cannot be blank.');
    // end;
}
