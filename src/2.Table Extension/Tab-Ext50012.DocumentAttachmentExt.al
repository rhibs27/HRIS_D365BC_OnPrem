tableextension 50012 "Document Attachment Ext" extends "Document Attachment"
{
    fields
    {
        field(50000; "Qualification Doc. Type"; Enum "Emp. Document Type")
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //>>clearing the related field on validation
                if not ("Qualification Doc. Type" = xRec."Qualification Doc. Type") then begin
                    // Clear("Qualification Doc. No.");
                    Clear("Qualification Level");
                end;
            end;
        }
        // field(50001; "Qualification Doc. No."; Code[20])
        // {
        //     TableRelation = Qualification WHERE("Type" = FIELD("Qualification Doc. Type"), "Qualification Type" = FIELD("Qualification Level"));
        //     DataClassification = ToBeClassified;
        // }
        field(50002; "Qualification Level"; Enum "Qualification Type")
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                //>>clearing the related field on validation
                // if not ("Qualification Level" = xRec."Qualification Level") then
                //     Clear("Qualification Doc. No.");
            end;
        }
    }
}
