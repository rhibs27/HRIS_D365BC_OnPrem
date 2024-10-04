pageextension 50013 "Employee Qualifications" extends "Employee Qualifications"
{
    layout
    {
        addbefore(Description)
        {
            field("Qualification Type"; Rec."Qualification Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qualification Type field.';
            }
        }
        addafter(Comment)
        {
            field(Percentage; Rec.Percentage)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Percentage field.';
            }
            field(CGPA; Rec.CGPA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CGPA field.';
            }
            field(Stream; Rec.Stream)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Stream field.';
            }
            field(Year; Rec.Year)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Year field.';
            }
            field("Emp Qualification Type"; Rec."Emp Qualification Type")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
                ToolTip = 'Specifies the value of the Emp Qualification Type field.';
                trigger OnValidate()
                begin
                    Rec."Emp Qualification Type" := Rec."Emp Qualification Type"::" ";
                end;
            }
        }
    }
    actions
    {
        addafter("Q&ualification Overview")
        {
            action("Preview Attachment")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintCover;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Executes the Preview Attachment action.';
                trigger OnAction()
                begin
                    DocuAttach.Reset;
                    DocuAttach.SetRange("Table ID", Database::Employee);
                    DocuAttach.SetRange("No.", Rec."Employee No.");
                    DocuAttach.SetRange("Qualification Doc. Type", Rec."Emp Qualification Type");
                    DocuAttach.SetRange("Qualification Level", Rec."Qualification Type");
                    DocuAttach.SetRange("Qualification Doc. No.", Rec."Qualification Code");
                    if DocuAttach.FindFirst then
                        DocuAttach.Export(true);
                end;
            }
        }
    }
    trigger OnClosePage()
    begin
        Clear(EmployeeQualification);
        EmployeeQualification.Reset;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Emp Qualification Type" := Rec."Emp Qualification Type"::Education;
        MasterFilter := Rec.GetFilter("Master Type");
        if MasterFilter <> '' then begin
            if MasterFilter = Format(Rec."Master Type"::Candidate) then
                Rec."Master Type" := Rec."Master Type"::Candidate
            else
                Rec."Master Type" := Rec."Master Type"::Employee;
        end;
    end;

    var
        EmployeeQualification: Record "Employee Qualification";
        DocuAttach: Record "Document Attachment";
        MasterFilter: Text;
}
