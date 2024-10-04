page 33019975 "Employee Training API"
{
    // version NIC Asia1.00,Training,APINICASIA1.00

    //The property 'EntityName' can only be set if the property 'PageType' is set to 'API'
    //EntityName = 'employeeTrainingEntity';
    //The property 'EntitySetName' can only be set if the property 'PageType' is set to 'API'
    //EntitySetName = 'employeeTrainingEntities';
    PageType = ListPart;
    SourceTable = "Employee Feedback";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(lineNo; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field(employeeCode; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(subType; Rec."Sub Type")
                {
                    ToolTip = 'Specifies the value of the Sub Type field.';
                    ApplicationArea = All;
                }
                field(question; Rec.Question)
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Question field.';
                    ApplicationArea = All;
                }
                field(answer; Rec.Answer)
                {
                    ToolTip = 'Specifies the value of the Answer field.';
                    ApplicationArea = All;
                }
                field(marks; Rec.Marks)
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Marks field.';
                    ApplicationArea = All;
                }
                field(answerII; Rec."Answer II")
                {
                    ToolTip = 'Specifies the value of the Answer II field.';
                    ApplicationArea = All;
                }
                field(posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Training;
    end;
}
