page 50243 "KRA Subform Entity"
{
    // version APINICASIA1.00

    EntityName = 'kRASubformEntity';
    EntitySetName = 'kRASubformEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KRA Subform List";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(kRACategory; Rec."KRA Category") { }
                field(description; Rec.Description) { }
                field(keyResultArea; Rec."Key Result Area") { }
                field(weightage; Rec."Weightage (%)") { }
                field(appraisalCode; Rec."Appraisal Code") { }
                field(finalScore; Rec."Final Score") { }
                field(employeeCode; Rec."Employee Code") { }
                field(remarks; Rec.Remarks) { }
                field(reviewersScore; Rec."Reviewers Score") { }
                field(reviewersRemarks; Rec."Reviewers Remarks") { }
                field(checkReviewersScore; Rec."Check Reviewers Score") { }
                field(checkReviewersRemarks; Rec."Check Reviewers Remarks") { }
                field(score; Rec.Score) { }
                field(hRScore; Rec."HR Score") { }
                field(hRRemarks; Rec."HR Remarks") { }
                part(kPIEmployeeEntities; "KPI Employee")
                {
                    EntityName = 'kPIEmployeeEntity';
                    EntitySetName = 'kPIEmployeeEntities';
                    SubPageLink = "Appraisal Code" = field("Appraisal Code"),
                                  "Key Result Area" = field("Key Result Area"),
                                  "KRA Category" = field("KRA Category");
                }
            }
        }
    }

    actions { }
}
