page 50007 "Functional Title List"
{
    // version KPI1.00

    // Pradhan
    //     //Inserting to temp table     12th Jan 2020
    //     //Deleting from temp table    12th Jan 2020
    //     //Checking if selected        12th Jan 2020

    CardPageId = "Functional Title Card";
    PageType = List;
    SourceTable = "Functional Title";
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
                            InsertFunctTitle(Rec.Code)      //Inserting to temp table
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
                field("COPO/COSPO Allowance"; Rec."COPO/COSPO Allowance")
                {
                    ToolTip = 'Specifies the value of the COPO/COSPO Allowance field.';
                    Caption = 'PH/ DPH Allowance';
                    ApplicationArea = All;
                }
                field("BM Alllowance"; Rec."BM Allowance")
                {
                    ToolTip = 'Specifies the value of the BM Allowance field';
                    Caption = 'BM Allowance';
                    ApplicationArea = All;
                }
                field(Locationwise; Rec.Locationwise)
                {
                    ToolTip = 'Specifies the value of the Locationwise field.';
                    ApplicationArea = All;
                }
                field("Communication Rein."; Rec."Communication Rein.")
                {
                    Caption = 'Communication Reimbursement';
                    ToolTip = 'Specifies the value of the Communication Reimbursement field.';
                    ApplicationArea = All;
                }
                field("Rank Value"; Rec."Rank Value")
                {
                    ToolTip = 'Specifies the value of the Rank Value field.';
                    ApplicationArea = All;
                }
                field("Rank Check Range"; Rec."Rank Check Range")
                {
                    ToolTip = 'Specifies the value of the Rank Check Range field.';
                    ApplicationArea = All;
                }
                field("Check Branchwise Only"; Rec."Check Branchwise Only")
                {
                    ToolTip = 'Specifies the value of the Check Branchwise Only field.';
                    ApplicationArea = All;
                }
                field("Risk Title"; Rec."Risk Title")
                {
                    ToolTip = 'Specifies the value of the Risk Title field.';
                    ApplicationArea = All;
                }
                field("Written Exam"; Rec."Written Exam")
                {
                    ToolTip = 'Specifies the value of the Written Exam field.';
                    ApplicationArea = All;
                }
                field("Group Discussion"; Rec."Group Discussion")
                {
                    ToolTip = 'Specifies the value of the Group Discussion field.';
                    ApplicationArea = All;
                }
                field("Evening Counter Eligible"; Rec."Evening Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Evening Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("Holiday Counter Eligible"; Rec."Holiday Counter Eligible")
                {
                    ToolTip = 'Specifies the value of the Holiday Counter Eligible field.';
                    ApplicationArea = All;
                }
                field("Allowance Reminder Mail"; Rec."Allowance Reminder Mail")
                {
                    ToolTip = 'Specifies the value of the Allowance Reminder Mail field.';
                    ApplicationArea = All;
                }
                field("Allow AllowanceAssignment"; Rec."Allow AllowanceAssignment")
                {
                    ToolTip = 'Specifies the value of the Is Allow AllowanceAssignment field.';
                    ApplicationArea = All;
                }
                field("EM/ECM Identifier"; Rec."EM/ECM Identifier")
                {
                    ToolTip = 'Specifies the value of the EM/ECM Identifier field.';
                    ApplicationArea = All;
                }
                field("BM/OBM"; Rec."BM/OBM")
                {
                    ToolTip = 'Specifies the value of the BM/OBM field.';
                    ApplicationArea = All;
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    Caption = 'Role Incentive %';
                    ToolTip = 'Specifies the value of the Role Incentive % field.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
                field("Is Specific Functional"; Rec."Is Specific Functional")
                {
                    ToolTip = 'Specifies the value of the Is Specific Functional field.';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("KPI Setup")
            {
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "KPI Setup Functional Bank";
                RunPageLink = Code = field(Code);
                ToolTip = 'Executes the KPI Setup action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*FunctionalTitle := GETFILTER(Code);//KPI1.00
                    IF FunctionalTitle <> '' THEN
                      Code := FunctionalTitle;*/
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Selected := CheckSelected(Rec.Code);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ShowSelected then begin
            Clear(FunctionalTitleText);
            TempFunctTitle.Reset;
            if TempFunctTitle.Find('-') then
                repeat
                    if FunctionalTitleText = '' then
                        FunctionalTitleText := TempFunctTitle.Code
                    else
                        FunctionalTitleText += '|' + TempFunctTitle.Code;
                until TempFunctTitle.Next = 0;
        end;
    end;

    var
        Selected: Boolean;

        ShowSelected: Boolean;
        FunctTitle: Record "Functional Title";
        TempFunctTitle: Record "Functional Title" temporary;
        FunctionalTitleText: Text;

    procedure AssignShowSelected()
    begin
        ShowSelected := true;
    end;

    procedure InsertFunctTitle(FunctTitleText: Text)
    begin
        //Inserting to temp table
        if FunctTitleText = '' then
            exit;
        FunctTitle.Reset;
        FunctTitle.SetFilter(Code, FunctTitleText);
        if FunctTitle.Find('-') then
            repeat
                TempFunctTitle.Init;
                TempFunctTitle.Validate(Code, FunctTitle.Code);
                TempFunctTitle.Insert;
            until FunctTitle.Next = 0;
    end;

    local procedure CheckSelected(FunctTitleText: Text): Boolean
    begin
        //Checking if selected
        TempFunctTitle.Reset;
        TempFunctTitle.SetRange(Code, FunctTitleText);
        if TempFunctTitle.FindFirst then
            exit(true);
    end;

    local procedure DeleteUnselected(FunctTitleText: Text)
    begin
        //Deleting from temp table
        TempFunctTitle.Reset;
        TempFunctTitle.SetRange(Code, FunctTitleText);
        TempFunctTitle.Delete;
    end;

    procedure ReturnFunctTitleText(): Text
    begin
        exit(FunctionalTitleText);
    end;
}
