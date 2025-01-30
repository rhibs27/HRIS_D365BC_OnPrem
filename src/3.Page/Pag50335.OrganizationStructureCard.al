page 50335 "Organization Structure Card"
{
    ApplicationArea = All;
    Caption = 'Organization Structure Card';
    PageType = Card;
    SourceTable = "Organization structure";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CaptionHead := Format(rec.Type) + ' Head';
                        CaptionDeputyHead := Format(rec.Type) + ' Deputy Head';
                        CaptionHeadName := Format(rec.Type) + ' Head Name';
                        captionHeadApproverID := Format(rec.Type) + ' Head Approver ID';
                        CaptionDeputyHeadName := 'Deputy ' + Format(Rec.Type) + ' Head Name';
                        CaptionDeputyHeadName := 'Deputy ' + Format(Rec.Type) + ' Head Approver ID';
                    end;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
            group("Hierarchy Type Heads")
            {
                Caption = 'Hierarchy Type Heads';
                field("Head"; Rec."Head")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    CaptionClass = CaptionHead;
                }
                field("Head Name"; Rec."Head Name")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    CaptionClass = CaptionHeadName;
                }
                field("Head Approver ID"; Rec."Head Approver ID")
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                    CaptionClass = captionHeadApproverID;
                }
                field("Deputy Head"; Rec."Deputy Head")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    CaptionClass = CaptionDeputyHead;
                }
                field("Deputy Head Name"; Rec."Deputy Head Name")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    CaptionClass = CaptionDeputyHeadName;
                }
                field("Deputy Head Approver ID"; Rec."Deputy Head Approver ID")
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                    CaptionClass = captionDeputyHeadApproverID;
                }

            }
            part("Reporting Lines"; "Organization Structure Subform")
            {
                SubPageLink = Type = field(Type), Code = field(Code);
            }
        }

    }
    trigger OnOpenPage()
    begin
        CaptionHead := Format(Rec.Type) + ' Head';
        CaptionDeputyHead := 'Deputy ' + Format(Rec.Type) + ' Head';
        CaptionHeadName := Format(rec.Type) + ' Head Name';
        captionHeadApproverID := Format(rec.Type) + ' Head Approver ID';
        CaptionDeputyHeadName := 'Deputy ' + Format(Rec.Type) + ' Head Name';
        CaptionDeputyHeadName := 'Deputy ' + Format(Rec.Type) + ' Head Approver ID';
    end;

    var
        CaptionHead: text;
        CaptionDeputyHead: text;
        CaptionHeadName: text;
        captionHeadApproverID: text;
        CaptionDeputyHeadName: text;
        captionDeputyHeadApproverID: text;

}
