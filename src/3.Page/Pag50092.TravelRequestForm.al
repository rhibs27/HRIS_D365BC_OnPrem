page 50092 "Travel Request Form"
{
    PageType = Card;
    SourceTable = "Travel Request";
    // SourceTableTemporary = true;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = (rec."Travel Order No." = '');
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Departure Time"; Rec."Departure Time")
                {
                    ToolTip = 'Specifies the value of the Departure Time field.';
                    ApplicationArea = All;
                }
                field("Arrival Time"; Rec."Arrival Time")
                {
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Travel Order No."; Rec."Travel Order No.")
                {
                    ToolTip = 'Specifies the value of the Travel Order No. field.';
                    ApplicationArea = All;
                }
                field("Total No. of Days"; Rec."Total No. of Days")
                {
                    ToolTip = 'Specifies the value of the Total No. of Days field.';
                    ApplicationArea = All;
                }
                field("Travel With"; Rec."Travel With")
                {
                    ToolTip = 'Specifies the value of the Travel With field.';
                    ApplicationArea = All;
                    Editable = extendedEdit;
                }
            }
            group(Travel)
            {
                field("Travel Countries"; Rec."Travel Countries")
                {
                    Caption = 'Travel Country';
                    ToolTip = 'Specifies the value of the Travel Country field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        EstimatedFieldEditable := Rec."Travel Countries" = Rec."Travel Countries"::"Other Countries";
                        CurrPage.Update;
                    end;
                }
                field("Type Of Visit"; Rec."Type Of Visit")
                {
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field("Mode Of Travel"; Rec."Mode Of Travel")
                {
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Payment From"; Rec."Payment From")
                {
                    ToolTip = 'Specifies the value of the Payment From field.';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Departure From"; Rec."Departure From")
                {
                    ToolTip = 'Specifies the value of the Departure From field.';
                    ApplicationArea = All;
                }
                field(Destination; Rec.Destination)
                {
                    Editable = not (Rec.Extended and (rec."Travel Countries" <> Rec."Travel Countries"::Nepal));
                    ToolTip = 'Specifies the value of the Destination field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
                field("Estimated Transportation Cost"; Rec."Estimated Transportation Cost")
                {
                    ToolTip = 'Specifies the value of the Estimated Transportation Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Lodging Cost"; Rec."Estimated Lodging Cost")
                {
                    Editable = EstimatedFieldEditable;
                    ToolTip = 'Specifies the value of the Estimated Lodging Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Fooding Cost"; Rec."Estimated Fooding Cost")
                {
                    Editable = EstimatedFieldEditable;
                    ToolTip = 'Specifies the value of the Estimated Fooding Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Conveyance Expense"; Rec."Estimated Conveyance Expense")
                {
                    ToolTip = 'Specifies the value of the Estimated Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Other Estimated Cost"; Rec."Other Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Other Estimated Cost field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency Code';
                    ApplicationArea = All;
                    // Editable = ((Rec."Approval Status" = Rec."Approval Status"::Open) and (rec."Travel Countries" <> rec."Travel Countries"::Nepal));
                }
                field("Advance Cash Required"; Rec."Advance Cash Required")
                {
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Total Estimated Cost"; Rec."Total Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Total Estimated Cost field.';
                    ApplicationArea = All;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    Editable = Rec."Advance Cash Required";
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Auth. Account No."; Rec."Auth. Account No.")
                {
                    ToolTip = 'Specifies the value of the Auth. Account No. field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No.");
                Editable = false;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Apply Travel Request")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Apply Travel Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TravelMgt.ApplyForTravel(Rec);
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        FieldEditable := Rec."Payment From" = Rec."Payment From"::Self;
    end;

    trigger OnOpenPage()
    var
    begin
        if rec."Travel Order No." = '' then
            extendedEdit := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Travel Request";
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        IsApplied: Boolean;
        FieldEditable: Boolean;
        EstimatedFieldEditable: Boolean;
        extendedEdit: Boolean;
}
