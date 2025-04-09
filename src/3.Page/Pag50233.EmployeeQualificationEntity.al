page 50233 "Employee Qualification Entity"
{
    PageType = API;
    SourceTable = "Employee Qualification";
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    Caption = 'employeeEntity';
    DelayedInsert = true;
    EntityName = 'employeeQualifications';
    EntitySetName = 'employeeQualificationEntity';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(employeeNo; Rec."Employee No.")
                {
                }
                field(empDocumentType; Rec."Emp Qualification Type")
                {
                }
                field(qualificationType; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                    ApplicationArea = All;
                }
                field(qualificationCode; Rec."Qualification Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a qualification code for the employee.';
                }
                field(fromDate; Rec."From Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee started working on obtaining this qualification.';
                }
                field(toDate; Rec."To Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee is considered to have obtained this qualification.';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a description of the qualification.';
                }
                field(institutionCompany; Rec."Institution/Company")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the institution from which the employee obtained the qualification.';
                }
                field(cGPA; CGPA)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the grade that the employee received for the course, specified by the qualification on this line.';
                }
                field(percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.';
                    ApplicationArea = All;
                }
                field(stream; Rec.Stream)
                {
                    ToolTip = 'Specifies the value of the Stream field.';
                    ApplicationArea = All;
                }
                field(year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    ApplicationArea = All;
                }
                field(designation; Rec.Designation)
                {
                }
                field(timePeriod; Rec."Time Period")
                {
                }
                field(remuneration; Rec.Remuneration)
                {
                }
                field(attachment; ExportAttachment)
                {
                }
                field(ext; ext)
                {
                }
            }
        }

    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
    end;


    var
        HrMgt: Codeunit "HR Mgt.";
        ext: text;

    local procedure ExportAttachment(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
        FileMgt: Codeunit "File Management";
    begin
        if Rec.Attachment.HasValue then begin
            if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                ext := FileMgt.GetExtension(ItemTenantMedia.Description);
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

}
