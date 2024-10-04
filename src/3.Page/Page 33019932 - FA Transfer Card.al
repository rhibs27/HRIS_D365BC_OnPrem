page 33019932 "FA Transfer Card"
{
    // version IME Remit

    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Posting';
    SourceTable = "FA Transfer";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("FA No."; Rec."FA No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the FA No. field.';
                    ApplicationArea = All;
                }
                field("FA Description"; Rec."FA Description")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the FA Description field.';
                    ApplicationArea = All;
                }
                field("FA Description2"; Rec."FA Description2")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the FA Description2 field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("From Branch Code"; FixedAssests."Global Dimension 1 Code")
                {
                    Caption = 'From Branch Code';
                    ToolTip = 'Specifies the value of the From Branch Code field.';
                    ApplicationArea = All;
                }
                field("From Location"; Rec."From Location Code")
                {
                    Editable = false;
                    TableRelation = "FA Location".Code;
                    ToolTip = 'Specifies the value of the From Location Code field.';
                    ApplicationArea = All;
                }
                field("To Location"; Rec."To Location Code")
                {
                    MultiLine = true;
                    TableRelation = "FA Location".Code;
                    ToolTip = 'Specifies the value of the To Location Code field.';
                    ApplicationArea = All;
                }
                field("From Emp"; Rec."From Resposible Emp")
                {
                    Caption = 'From Resposible Employee';
                    Editable = false;
                    TableRelation = Employee."No.";
                    ToolTip = 'Specifies the value of the From Resposible Employee field.';
                    ApplicationArea = All;
                }
                field("To Emp"; Rec."To Resposible Emp")
                {
                    Caption = 'To Resposible Employee';
                    TableRelation = Employee."No.";
                    ToolTip = 'Specifies the value of the To Resposible Employee field.';
                    ApplicationArea = All;
                }
                field(Reason; Rec.Reason)
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Reason field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1102159016; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            group("<Action1102159019>")
            {
                Caption = 'Post Action';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Message('123');
                        ConfirmPost := Dialog.Confirm(text001, true);
                        if ConfirmPost then begin
                            FATransfer_Post;
                            Message(text003);
                        end
                        else
                            Message(text002, Rec.UserID);
                    end;
                }
                action("<Action1102159021>")
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post and Print action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Message('123');

                        ConfirmPost := Dialog.Confirm(text001, true);
                        if ConfirmPost then begin
                            FATransfer_Post;
                            // to print
                            FATransfer.Reset;
                            FATransfer.SetRange(FATransfer."FA No.", Rec."FA No.");
                            FATransfer.SetRange(FATransfer."From Location Code", Rec."From Location Code");
                            Report.Run(70028, false, true, FATransfer);
                            Commit;
                            Message(text003)
                        end
                        else
                            Message(text002, Rec.UserID);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        /*
         FixedAssests.GET("FA No.");
        MESSAGE('%1',FixedAssests."No.");
       MESSAGE('%1',FixedAssests."FA Location Code");
        FALocation := FixedAssests."FA Location Code";
        MESSAGE('%1',FALocation);
        "From Location Code" := FALocation;
         */
    end;

    var
        FixedAssests: Record "Fixed Asset";
        FATransfer: Record "FA Transfer Register";
        FAT: Record "FA Transfer";
        FixAsset: Record "Fixed Asset";
        ConfirmPost: Boolean;
        text001: Label 'Do you want to post - FA Transfer?';
        text002: Label 'Aborted by user - %1!';
        text003: Label 'FA Transfer is done successfully!';

    procedure FATransfer_Post()
    begin
        // code to insert in FA Transfer Register table
        FATransfer.Init;
        FATransfer."FA No." := Rec."FA No.";
        FATransfer.Date := Rec.Date;
        FATransfer."From Location Code" := Rec."From Location Code";
        FATransfer."To Location Code" := Rec."To Location Code";
        FATransfer.Reason := Rec.Reason;
        FATransfer.Remarks := Rec.Remarks;
        FATransfer."From Responsible Emp" := Rec."From Resposible Emp";
        FATransfer."To Responsible Emp" := Rec."To Resposible Emp";
        FATransfer."FA Description" := Rec."FA Description";
        FATransfer."FA Description2" := Rec."FA Description2";

        FATransfer.TestField(FATransfer."To Location Code");
        FATransfer.TestField(FATransfer."To Responsible Emp");
        FATransfer.Insert(true);

        //To delete from FA Transfer
        FAT.DeleteAll;

        // To Update in Fixed Asset
        FixAsset.SetRange(FixAsset."No.", Rec."FA No.");
        if FixAsset.FindFirst then begin
            FixAsset."FA Location Code" := Rec."To Location Code";
            FixAsset."Responsible Employee" := Rec."To Resposible Emp";
            FixAsset.Modify;
        end;

        Commit;
    end;
}
