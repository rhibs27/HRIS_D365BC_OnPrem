page 50195 NoticeBulletinsEntity
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
                field(description; ExportDescription)
                {
                    Caption = 'Description';
                }
                field(image; ExportEmpImage)
                {
                    Caption = 'Notice Image';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(noticeTitle; Rec."Notice Title")
                {
                    Caption = 'Notice Title';
                }
            }
        }
    }
    local procedure ExportDescription(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        base64: Codeunit "Base64 Convert";
    begin
        if Rec.Description.HasValue then begin
            Rec.CalcFields(Description);
            TempBlob.FromRecord(Rec, Rec.FieldNo(Description));
            TempBlob.CreateInStream(InStr);
            exit(base64.ToBase64(InStr));
        end;
    end;

    local procedure ExportEmpImage(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
    begin
        if Rec.Notice.HasValue then begin
            if ItemTenantMedia.Get(Rec.Notice.MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;
}
