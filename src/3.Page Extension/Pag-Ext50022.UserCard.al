pageextension 50022 "User Card" extends "User Card"
{
    trigger OnNewRecord(BelowxRec: Boolean)

    begin
        Rec.Validate("License Type", Rec."License Type"::"External User");
    end;

    // trigger OnQueryClosePage(CloseAction: Action): Boolean

    // begin
    //     if Rec."User Name" <> '' then begin
    //         UserSetup.Init;
    //         UserSetup.Validate("User ID", Rec."User Name");
    //         UserSetup.Insert;
    //     end;
    // end;
}
