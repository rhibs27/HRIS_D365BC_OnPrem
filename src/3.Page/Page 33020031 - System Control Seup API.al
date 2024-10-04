page 33020031 "System Control Seup API"
{
    // version APINICASIA1.00

    EntityName = 'systemAccessControlEntity';
    EntitySetName = 'systemAccessControlEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "System Access Control";
    SourceTableView = where("Type of Masters" = const("System Control Setup"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(systemTypeCode; Rec.Code) { }
                field(systemTypeName; Rec.Name)
                {
                    Editable = false;
                }
                field(systemCategoryCode; Rec."System Category Code")
                {
                    Editable = false;
                }
                field(systemCategoryName; Rec."System Category Name") { }
                field(systemDepartmentOwner; Rec."System Department Owner") { }
                field(departmentName; Rec."Department Name") { }
                field(systemOwnerEmailID; Rec."System Owner Email ID") { }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Type of Masters" := Rec."Type of Masters"::"System Control Setup";
    end;
}
