page 50001 "Employee Work Qualification"
{
    // Pradhan modification
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Employee Qualification";
    SourceTableView = where("Emp Qualification Type" = const(Work));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                    ApplicationArea = All;
                    Caption = 'Experience Code';
                    trigger OnLookup(var
                                         Text: Text): Boolean
                    var
                        QualificationRec: Record "Qualification";
                    begin
                        QualificationRec.Reset();
                        QualificationRec.SetFilter(Type, '<>%1', QualificationRec.type::Education);
                        if Page.RunModal(Page::Qualifications, QualificationRec) = Action::LookupOK then
                            Rec."Qualification Code" := QualificationRec.Code;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                    ToolTip = 'Specifies the value of the Institution/Company field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                }
                field(Designation; Rec.Designation)
                {
                    ToolTip = 'Specifies the value of the Designation field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field("Time Period"; Rec."Time Period")
                {
                    ToolTip = 'Specifies the value of the Time Period field.';
                    ApplicationArea = All;
                }
                field(Remuneration; Rec.Remuneration)
                {
                    ToolTip = 'Specifies the value of the Remuneration field.';
                    ApplicationArea = All;
                }
                field("Emp Qualification Type"; Rec."Emp Qualification Type")
                {
                    Editable = false;
                    TableRelation = Qualification.Code where(Type = filter(Work));
                    Visible = false;
                    ToolTip = 'Specifies the value of the Emp Qualification Type field.';
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            part(Attachment; "Qualification Attachment")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "Employee No." = field("Employee No."), "Line No." = field("Line No.");
            }
            systempart(Control12; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control11; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("Preview Attachment")
            // {
            //     Image = PrintCover;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Preview Attachment action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         DocuAttach.Reset;
            //         DocuAttach.SetRange("Table ID", Database::Employee);
            //         DocuAttach.SetRange("No.", Rec."Employee No.");
            //         DocuAttach.SetRange("Qualification Doc. Type", Rec."Emp Qualification Type");
            //         DocuAttach.SetRange("Qualification Level", Rec."Qualification Type");
            //         DocuAttach.SetRange("Qualification Doc. No.", Rec."Qualification Code");
            //         if DocuAttach.FindFirst then
            //             DocuAttach.Export(true);
            //     end;
            // }
        }
    }

    trigger OnClosePage()
    begin
        EmployeeQualification.Reset;
        Clear(EmployeeQualification);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Making Default Value for Qualification type as Work
        Rec."Emp Qualification Type" := Rec."Emp Qualification Type"::Work;
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
