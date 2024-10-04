page 33020034 "Employee Qualification Entity"
{
    // version APINICASIA1.00

    PageType = ListPart;
    SourceTable = "Employee Qualification";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                    ApplicationArea = All;
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ApplicationArea = BasicHR;
                    TableRelation = Qualification.Code where(Type = field("Emp Qualification Type"),
                                                              "Qualification Type" = field("Qualification Type"));
                    ToolTip = 'Specifies a qualification code for the employee.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee started working on obtaining this qualification.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee is considered to have obtained this qualification.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a type for the qualification, which specifies where the qualification was obtained.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a description of the qualification.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the qualification on this line expires.';
                    Visible = false;
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the institution from which the employee obtained the qualification.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the cost of the qualification.';
                    Visible = false;
                }
                field("Course Grade"; Rec."Course Grade")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the grade that the employee received for the course, specified by the qualification on this line.';
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies whether a comment was entered for this entry.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.';
                    ApplicationArea = All;
                }
                field(Stream; Rec.Stream)
                {
                    ToolTip = 'Specifies the value of the Stream field.';
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    ApplicationArea = All;
                }
                field("Emp Qualification Type"; Rec."Emp Qualification Type")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Emp Qualification Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."Emp Qualification Type" := Rec."Emp Qualification Type"::" ";
                    end;
                }
            }
        }
    }

    actions { }
}
