report 50074 "Recruitment Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019875.RecruitmentMemo.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Recruitement Memo"; "Recruitment Memo")
        {
            column(ReferenceNo_RecruitementMemo; "Reference No.") { }
            column(Subject_RecruitementMemo; Subject) { }
            column(HRSCMeetingNo_RecruitementMemo; "HRSC Meeting No.") { }
            column(BodyText2; BodyText2) { }
            column(Body001; Body001) { }
            column(Body002; Body002) { }
            column(Body003; Body003) { }
            column(Body004; Body004) { }
            column(Body005; Body005) { }
            column(Body006; Body006) { }
            column(Body007; Body007) { }
            column(Body008; Body008) { }
            column(Body009; Body009) { }
            column(Body010; Body010) { }
            column(Body011; Body011) { }
            column(Body012; Body012) { }
            column(Body013; Body013) { }
            column(Body014; Body014) { }
            column(Body015; Body015) { }
            column(Body016; Body016) { }
            column(BodyText1; BodyText1) { }
            dataitem("Recruitement Memo Line"; "Recruitement Memo Line")
            {
                DataItemLink = "Memo No." = field("Memo No.");
                column(MemoNo_RecruitementMemoLine; "Memo No.") { }
                column(FunctionalTitle_RecruitementMemoLine; "Functional Title") { }
                column(SalaryLevelCode_RecruitementMemoLine; "Salary Level Code") { }
                column(SalaryLevelDescription_RecruitementMemoLine; "Salary Level Description") { }
                column(Location_RecruitementMemoLine; Location) { }
                column(RequiredNo_RecruitementMemoLine; "Required No.") { }
                column(FunctionalTitleDescription_RecruitementMemoLine; "Functional Title Description") { }
                column(VacancyNo_RecruitementMemoLine; "Vacancy No.") { }
            }

            trigger OnAfterGetRecord()
            begin
                /*IF Employee.Salutation = Employee.Salutation::"Mr." THEN begin
                  Pronoun1 := 'he';
                  Pronoun2 := 'his';
                  Pronoun3 := 'him';
                END
                ELSE IF Employee.Salutation = Employee.Salutation::"Ms." THEN begin
                  Pronoun1 := 'she';
                  Pronoun2 := 'her';
                  Pronoun3 := 'her';
                end;*/

                NL := '  ';
                NL[1] := 13;
                NL[2] := 10;

                BodyText1 := StrSubstNo(Background, "HRSC Meeting No.", "Posting Date");
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        Background: Label 'The %1 Meeting of Human Resource Staffing Committee was held on %2.Key highlights of the deliberations and decisions made during the meeting are as follows:';
        NL: Text;
        Body001: Label 'Deliberations was regarding the requirement of additional manpower in line with the increasing footprints of the Bank and ensure the effective achievements of the targets as spelled out by the long term vision of the Bank. With a view to recruit the staff possessing required potentials and key competencies to fulfill the need for additional headcount requirement created due to increase in size, transaction/business volume and additional functions, the committee deliber ted on the need to hunt for required Talents from the Market. Regarding the same, the committee deliberated on the Clause No. 7(2) of Section of Staff Service Bylaws, 2073 which states,';
        BodyText1: Text;
        Body002: Label '-@_ a}+snfO{ cfjZos sd{rf/Lsf] gofF lgo''lQm, cfGtl/s k|ltof]lutfTds k/LIffaf6 lgo''lQm, cfGtl/s a9''jf k|ls|ofÙf/f a9''jfsf] nflu l;kmfl/; ug{ ljlgod !)-!_ adf]lhd Ps kbk"lt{ ;ldltsf] u7g x''g]5 . kbk"lt{ ;ldltn] o; ljlgodfjnL adf]lhd cfjZos k|ls|of k"/f u/L sd{rf/Lsf] gofF lgo''lQm, cfGtl/s k|ltof]lutfTds k/LIffaf6 lgo''lQm jf cfGtl/s a9''jf k|s[ofÙf/f x''g] a9''jfsf] gfdfjnL lgo''lQm lbg] clwsf/L ;dIf l;kmfl/; ug]{5 .Ù';
        Body003: Label 'After due deliberation, the committee recommended to opted for Appointment through External Vacancy and recommended to announce the vacancy for the various positions as stated below for various locations located inside and outside the valley. ';
        Body004: Label 'Similarly, the committee deliberated on the Clause No. 15 of Staff Service Bylaws, 2073 regarding the age criteria, which states,';
        BodyText2: Text;
        Body005: Label 'Ù-!_ a}+sdf l/Qm kb gofF lgo''lQmÙf/f k"lt{ ubf{ b]xfosf >]0fLx?sf sd{rf/Lsf nflu pd]/sf] tNnf] / dflyNnf] xb b]xfo adf]lhd x''g]5 M--s_ Joj:yfksLo >]0fL M@% jif{ k''/f eO{ %) jif{ ggf3]sf] .-v_ clws[t >]0fLM @! jif{ k''/f eO{ $) jif{ ggf3]sf] .-u_ ;xfos >]0fL M !* jif{ k''/f eO{ #% jif{ ggf3]sf] .-3_ ;xof]uL >]0fL M @! jif{ k''/f eO{ $) jif{ ggf3]sf] .Ù';
        Body006: Label 'Similarly, the committee deliberated on the Annexure 2 of Staff Service Bylaws, 2073 regarding education and experience requirement, that states,';
        Body007: Label 'Ù-!_ z}lIfs of]Uotf M';
        Body008: Label '-s_  Joj:yfksLo >]0fL M';
        Body009: Label 'gfoa k|d''v sfo{sf/L clws[t, ;xfos k|d''v sfo{sf/L clws[t, jl/i7 k|aGws, k|aGws, gfoa k|aGws tyf ;xfos k|aGwssf] nflu :gftsf]Q/ pQL0f{ u/L slDtdf kfFr jif{sf] ;DalGwt If]qsf] sfo{ cg''ej ePsf] jf :gfts pQL0f{ u/L slDtdf bz jif{sf] ;DalGwt If]qsf] sfo{ cg''ej ePsf] x''g'' kg]{5 .';
        Body010: Label '-v_  clws[t >]0fLM';
        Body011: Label 'jl/i7 clws[t, clws[t tyf slgi7 clws[tsf] nflu :gftsf]Q/ ptL0f{ u/]sf] jf :gfts pQL0f{ u/L slDtdf kfFr jif{sf] ;DalGwt If]qsf] sfo{ cg''ej ePsf] x''g'' kg]{5 .';
        Body012: Label '-u_  ;xfos >]0fL M';
        Body013: Label ';''k/efOh/, jl/i7 ;xfos / ;xfossf] nflu :gfts jf ;f] ;/xsf] k/LIff pQL0f{ ePsf] x''g'' kg]{5 .Ù';
        Body014: Label 'Considering the same, the committee recommended to define the minimum eligible criteria for different positions in line with aforementioned provisions of Staff Service Bylaws, 2073. In addition, the committee recommended to allocate 15 days for collection of applications to cover a large mass of candidates in line with Clause No. 13 of Staff Service Bylaws, 2073, that states, ';
        Body015: Label 'Ù!#= lj1fkg M';
        Body016: Label '-!_ a}+sdf l/Qm /x]sf] kbdf v''nf k|ltof]lutfÙf/f kbk"lt{ ubf{ /fli6"o:t/sf b}lgs klqsf tyf a}+ssf] j]a;fO6df slDtdf kGw| lbgsf] cjlw tf]sL cfj]bgsf nflu lj1fkg k|sfzg ug''{ kg]{5 . Ù';
}
