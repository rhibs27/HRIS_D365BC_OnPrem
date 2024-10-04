page 50052 "Attendance Card"
{
    // version ATM.19.01.01

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Attendance Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = ControlEditable;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field("From Date (B.S)"; Rec."From Date (B.S)")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the From Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("To Date (B.S)"; Rec."To Date (B.S)")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the To Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Month field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
            }
            part(Control4; "Attendance Summary")
            {
                Editable = ControlEditable;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Re-Open")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Re-Open action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        AttendanceHeader: Record "Attendance Header";
                    begin
                        CurrPage.SetSelectionFilter(AttendanceHeader);
                        Rec.ReOpenDocument(AttendanceHeader);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'F9';
                    Visible = ControlEditable;
                    ToolTip = 'Executes the P&ost action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.PostDocument;
                    end;
                }
                action("Import Employee")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ControlEditable;
                    ToolTip = 'Executes the Import Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Code Commented because this code is related with report 50110 in table.

                        Rec.ImportEmployee;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ControlEditable := not Rec.Posted;
    end;

    trigger OnOpenPage()
    begin
        ControlEditable := true;
    end;

    var
        [InDataSet]
        ControlEditable: Boolean;
}
