page 33019825 "Salary Levels"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Salary Level";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Selected; Selected)
                {
                    Visible = ShowSelected;
                    ToolTip = 'Specifies the value of the Selected field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Selected then
                            InsertSalLevel(Rec.Code)      //Inserting to temp table
                        else
                            DeleteUnselected(Rec.Code);       //Deleting from temp table
                    end;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Rank; Rec.Rank)
                {
                    ToolTip = 'Specifies the value of the Rank field.';
                    ApplicationArea = All;
                }
                field("Basic Salary"; Rec."Basic Salary")
                {
                    Editable = true;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Basic Salary field.';
                    ApplicationArea = All;
                }
                field(Allowance; Rec.Allowance)
                {
                    ToolTip = 'Specifies the value of the Allowance field.';
                    ApplicationArea = All;
                }
                field("Nepal Fooding Allowance"; Rec."Nepal Fooding Allowance")
                {
                    ToolTip = 'Specifies the value of the Nepal Fooding Allowance field.';
                    ApplicationArea = All;
                }
                field("Nepal Lodging Allowance"; Rec."Nepal Lodging Allowance")
                {
                    ToolTip = 'Specifies the value of the Nepal Lodging Allowance field.';
                    ApplicationArea = All;
                }
                field("India Fooding Allowance"; Rec."India Fooding Allowance")
                {
                    ToolTip = 'Specifies the value of the India Fooding Allowance field.';
                    ApplicationArea = All;
                }
                field("India Lodging Allowance"; Rec."India Lodging Allowance")
                {
                    ToolTip = 'Specifies the value of the India Lodging Allowance field.';
                    ApplicationArea = All;
                }
                field("Out of Pocket Expense"; Rec."Out of Pocket Expense")
                {
                    ToolTip = 'Specifies the value of the Out of Pocket Expense field.';
                    ApplicationArea = All;
                }
                field("Vehicle Allowance"; Rec."Vehicle Allowance")
                {
                    ToolTip = 'Specifies the value of the Vehicle Allowance field.';
                    ApplicationArea = All;
                }
                field("Net Learning"; Rec."Net Learning")
                {
                    ToolTip = 'Specifies the value of the Net Learning field.';
                    ApplicationArea = All;
                }
                field("Friday Allowance"; Rec."Friday Allowance")
                {
                    Caption = 'Friday ALlowance Per Day';
                    ToolTip = 'Specifies the value of the Friday ALlowance Per Day field.';
                    ApplicationArea = All;
                }
                field("Vehicle Loan Limit"; Rec."Vehicle Loan Limit")
                {
                    ToolTip = 'Specifies the value of the Vehicle Loan Limit field.';
                    ApplicationArea = All;
                }
                field("Housing Loan Limit"; Rec."Housing Loan Limit")
                {
                    ToolTip = 'Specifies the value of the Housing Loan Limit field.';
                    ApplicationArea = All;
                }
                field("Reapply Year (Vehicle Loan)"; Rec."Reapply Year (Vehicle Loan)")
                {
                    ToolTip = 'Specifies the value of the Reapply Year (Vehicle Loan) field.';
                    ApplicationArea = All;
                }
                field(Darbandi; Rec.Darbandi)
                {
                    ToolTip = 'Specifies the value of the Darbandi field.';
                    ApplicationArea = All;
                }
                field("Banking Experience"; Rec."Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Non-Banking Experience"; Rec."Non-Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Non-Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Vault Key Eligible"; Rec."Vault Key Eligible")
                {
                    ToolTip = 'Specifies the value of the Vault Key Eligible field.';
                    ApplicationArea = All;
                }
                field("Minimum Age"; Rec."Minimum Age")
                {
                    ToolTip = 'Specifies the value of the Minimum Age field.';
                    ApplicationArea = All;
                }
                field("Maximum Age"; Rec."Maximum Age")
                {
                    ToolTip = 'Specifies the value of the Maximum Age field.';
                    ApplicationArea = All;
                }
                field("Senior Officer Level"; Rec."Senior Officer Level")
                {
                    ToolTip = 'Specifies the value of the Senior Officer Level field.';
                    ApplicationArea = All;
                }
                field("Leave Balance (Contract Staff)"; Rec."Leave Balance (Contract Staff)")
                {
                    ToolTip = 'Specifies the value of the Leave Balance (Contract Staff) field.';
                    ApplicationArea = All;
                }
                field("OT Attachment Mandatory"; Rec."OT Attachment Mandatory")
                {
                    ToolTip = 'Specifies the value of the OT Attachment Mandatory field.';
                    ApplicationArea = All;
                }
                field("Travel With Not Eligible"; Rec."Travel With Not Eligible")
                {
                    ToolTip = 'Specifies the value of the Travel With Not Eligible field.';
                    ApplicationArea = All;
                }
                field("Good Service Period"; Rec."Good Service Period")
                {
                    ToolTip = 'Specifies the value of the Good Service Period field.';
                    ApplicationArea = All;
                }
                field("Is AM"; Rec."Is AM")
                {
                    ToolTip = 'Specifies the value of the Is AM field.';
                    ApplicationArea = All;
                }
                field("OT Eligible"; Rec."OT Eligible")
                {
                    ToolTip = 'Specifies the value of the OT Eligible field.';
                    ApplicationArea = All;
                }
                field("Extra Mileage Eligible"; Rec."Extra Mileage Eligible")
                {
                    ToolTip = 'Specifies the value of the Extra Mileage Eligible field.';
                    ApplicationArea = All;
                }
                field("Compensatory Leave"; Rec."Compensatory Leave")
                {
                    ToolTip = 'Specifies the value of the Compensatory Leave field.';
                    ApplicationArea = All;
                }
                field("Year End Encashment"; Rec."Year End Encashment")
                {
                    ToolTip = 'Specifies the value of the Year End Encashment field.';
                    ApplicationArea = All;
                }
                field("Holiday Counter Eligible"; Rec."Holiday Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Holiday Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("Festive Counter Eligible"; Rec."Festive Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Festive Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("TA OT Basic Salary"; Rec."TA OT Basic Salary")
                {
                    ToolTip = 'Specifies the value of the TA OT Basic Salary field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Promotion Eligibilty Criteria")
            {
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Promotion Eligibilty Criteria";
                RunPageLink = "Salary Level" = field(Code);
                ToolTip = 'Executes the Promotion Eligibilty Criteria action.';
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ShowSelected then begin
            Clear(SalaryLevelText);
            TempSalaryLevel.Reset;
            if TempSalaryLevel.Find('-') then
                repeat
                    if SalaryLevelText = '' then
                        SalaryLevelText := TempSalaryLevel.Code
                    else
                        SalaryLevelText += '|' + TempSalaryLevel.Code;
                until TempSalaryLevel.Next = 0;
        end;
    end;

    var
        Selected: Boolean;
        [InDataSet]
        ShowSelected: Boolean;
        SalaryLevel: Record "Salary Level";
        TempSalaryLevel: Record "Salary Level" temporary;
        SalaryLevelText: Text;

    procedure AssignShowSelected()
    begin
        ShowSelected := true;
    end;

    procedure InsertSalLevel(SalLevelText: Text)
    begin
        //Inserting to temp table
        if SalLevelText = '' then
            exit;
        SalaryLevel.Reset;
        SalaryLevel.SetFilter(Code, SalLevelText);
        if SalaryLevel.Find('-') then
            repeat
                TempSalaryLevel.Init;
                TempSalaryLevel.Validate(Code, SalaryLevel.Code);
                TempSalaryLevel.Insert;
            until SalaryLevel.Next = 0;
    end;

    local procedure CheckSelected(SalLevelText: Text): Boolean
    begin
        //Checking if selected
        TempSalaryLevel.Reset;
        TempSalaryLevel.SetRange(Code, SalLevelText);
        if TempSalaryLevel.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(SalLevelText: Text)
    begin
        //Deleting from temp table
        TempSalaryLevel.Reset;
        TempSalaryLevel.SetRange(Code, SalLevelText);
        TempSalaryLevel.Delete;
    end;

    procedure ReturnSalLevelText(): Text
    begin
        exit(SalaryLevelText);
    end;
}
