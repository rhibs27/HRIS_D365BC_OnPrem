tableextension 33019809 "Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50000; "Posting Region"; Enum Region)
        {
            DataClassification = CustomerContent;
        }
        field(50001; Province; Code[20])
        {
            // TableRelation = Province;todo
            DataClassification = CustomerContent;
        }
        field(50002; "Sub-Province"; Code[20])
        {
            TableRelation = "Sub Province";
            DataClassification = CustomerContent;
        }
        field(50003; Cluster; Code[20])
        {
            TableRelation = "Employee Hierarchy Master" where("Sub-Province" = field("Sub-Province"));
            DataClassification = CustomerContent;
        }
        field(50004; "Distance Criteria"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50005; District; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                // VALIDATE(District, HRMgt.LookupDistrict(Province, "Sub-Province", District)); todo
            end;
        }
        field(50006; Address; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Inside/Outisde Valley"; enum "Outside/Inside Valley")
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Remote Area Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(50009; "Reporting Category"; Code[20])
        {
            TableRelation = "Reporting Category";
            DataClassification = CustomerContent;
        }
        field(50010; "Sol ID"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(50011; "BM Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(50012; "Remote Area Reduction"; Code[10])
        {
            TableRelation = "Remote Area Category";
            DataClassification = CustomerContent;
        }
        field(50013; Municipality; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                // VALIDATE(Municipality, HRMgt.LookUpMunicipalityKPI(Municipality));todo
                //VALIDATE(Municipality,HRMgt.LookupVDC(Municipality));
            end;
        }
    }
}
