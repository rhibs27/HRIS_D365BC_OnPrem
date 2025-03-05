page 50166 "Leave Type Entity"
{
    // version APINICASIA1.00

    DeleteAllowed = false;
    EntityName = 'leavetypesetup';
    EntitySetName = 'leavetypesetups';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Leave Type Setup";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("code"; Rec.Code) { }
                field(description; Rec.Description) { }
                field(payType; Rec."Pay Type") { }
                field(EmployeeNoFilter; Rec."Employee No. Filter") { }
                field(RemainingDays; Rec."Remaining Days") { }
                field(noOfDaysForAttachment; Rec."No. of Days for Attachment")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        Hrmgt: Codeunit "HR Mgt.";
    begin
        rec.SetFilter("Employee No. Filter", Hrmgt.GetEmployeeNo());
    end;

}
