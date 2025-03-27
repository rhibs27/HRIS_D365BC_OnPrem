page 50167 "Wrtitten/Group Dis. Marks"
{
    PageType = List;
    SourceTable = "Evaluation Entry";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Candidate No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                field("Attribute Description"; Rec."Attribute Description")
                {
                    ToolTip = 'Specifies the value of the Attribute Description field.';
                    ApplicationArea = All;
                }
                field(Marks; Rec.Marks)
                {
                    ToolTip = 'Specifies the value of the Marks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Entries")
            {
                Image = Entries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Generate Entries action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    VacancyCodeFilter := Rec.GetFilter("Vacancy Code");
                    TypeFilter := Rec.GetFilter(Type);
                    CandidateFilter := Rec.GetFilter("No.");
                    Rec.FilterGroup(0);
                    if TypeFilter = Format(Rec.Type::"Written Exam") then
                        HRMgt.GenerateWrittenExamEntries(VacancyCodeFilter, CandidateFilter)
                    else if TypeFilter = Format(Rec.Type::"Group Discussion") then
                        HRMgt.GenerateGroupDiscussionEntries(VacancyCodeFilter, CandidateFilter);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.FilterGroup(2);
        VacancyCodeFilter := Rec.GetFilter("Vacancy Code");
        TypeFilter := Rec.GetFilter(Type);
        CandidateFilter := Rec.GetFilter("No.");
        Rec.FilterGroup(0);
        if VacancyCodeFilter <> '' then
            Rec."Vacancy Code" := VacancyCodeFilter;
        if TypeFilter = Format(Rec.Type::"Group Discussion") then
            Rec.Type := Rec.Type::"Group Discussion"
        else if TypeFilter = Format(Rec.Type::"Written Exam") then
            Rec.Type := Rec.Type::"Written Exam";
        if CandidateFilter <> '' then
            Rec."No." := CandidateFilter;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        VacancyCodeFilter: Text;
        TypeFilter: Text;
        CandidateFilter: Text;
}
