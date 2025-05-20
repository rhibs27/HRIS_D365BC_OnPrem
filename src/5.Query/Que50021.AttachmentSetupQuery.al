query 50021 "Attachment Setup Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'attachmentSetup';
    EntitySetName = 'attachmentSetups';
    QueryType = API;
    elements
    {
        dataitem(AttachmentSetup; "Attachment Setup")
        {
            column(attachmentCode; "Attachment Code")
            {
            }
            column(type; Type)
            {

            }
            column(leaveTypeCode; "Leave Type Code")
            {


            }
            column(purposeOfHousingLoan; "Purpose of Housing Loan")
            {

            }
            column(mandatory; Mandatory)
            {
            }
            column(qualificationType; "Qualification Type")
            {

            }
            column(enhancement; Enhancement)
            {

            }
            column(boardApproval; "Board Approval")
            {

            }
            column(maxFileSize; "Max File Size")
            {

            }
        }
    }
}
