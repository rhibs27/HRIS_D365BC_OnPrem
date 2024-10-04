report 50006 "Appointment/Offer Letter"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            trigger OnAfterGetRecord()
            begin
                if IsforAppointmentLetter then begin
                    Status := Status::"Appointment Letter Sent";
                    EmailTemplate.Reset;
                    EmailTemplate.SetRange("Document Type", EmailTemplate."Document Type"::"Candiadte offer letter");
                    HRMgt.SendMailFromTemplate(Database::Candidate, EmailTemplate."Document Type"::"Candiadte offer letter", 0, Candidate."Vacancy Code", '', Candidate."No.", 0);
                end;
                if IsforOfferLetter then begin
                    Status := Status::"Offer Letter Sent";
                end;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                if IsforAppointmentLetter then
                    SetRange(Status, Status::"Offer Letter Accepted");
                if IsforOfferLetter then
                    SetRange(Status, Status::Interviewed);
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        IsforOfferLetter: Boolean;
        IsforAppointmentLetter: Boolean;
        EmailTemplate: Record "Email Template";
        HRMgt: Codeunit "HR Mgt.";

    procedure ForOfferLetter()
    begin
        IsforOfferLetter := true;
        IsforAppointmentLetter := false;
    end;

    procedure ForAppointmentLetter()
    begin
        IsforAppointmentLetter := true;
        IsforOfferLetter := false;
    end;
}
