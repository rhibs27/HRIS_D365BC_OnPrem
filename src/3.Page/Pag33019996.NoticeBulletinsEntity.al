page 33019996 NoticeBulletinsEntity
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'noticeBulletinsEntity';
    DelayedInsert = true;
    EntityName = 'noticeBulletinsEntity';
    EntitySetName = 'noticeBulletinsEntities';
    PageType = API;
    SourceTable = "Notice Bulletin";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(imageFilePath; Rec."Image File Path")
                {
                    Caption = 'Image File Path';
                }
                field(notice; Rec.Notice)
                {
                    Caption = 'Notice';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }
}
