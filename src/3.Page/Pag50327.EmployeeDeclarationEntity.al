page 50327 "Employee Declaration Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ;
    ApplicationArea = All;
    Caption = 'employeeDeclarationEntity';
    DelayedInsert = true;
    EntityName = 'employeeDeclarationEntity';
    EntitySetName = 'employeeDeclarationEntities';
    PageType = API;
    SourceTable = "Employee Declaration";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(salaryLevel; Rec."Salary Level")
                {
                    Caption = 'Salary Level';
                }
                field(functionalTitle; Rec."Functional Title")
                {
                    Caption = 'Functional Title';
                }
                field(deputationOn; Rec."Deputation On")
                {
                    Caption = 'Deputation On';
                }
                field(deputationCode; Rec."Deputation Code")
                {
                    Caption = 'Deputation Code';
                }
                field(deputationValue; Rec."Deputation Value")
                {
                    Caption = 'Deputation Value';
                }
                field(fiscalYear; Rec."Fiscal Year")
                {
                    Caption = 'Fiscal Year';
                }
                field(functionalTitleDescription; Rec."Functional Title Description")
                {
                    Caption = 'Functional Title Description';
                }
                field(codeOfEthics; Rec."Code of Ethics")
                {
                    Caption = 'Code of Ethics';
                }
                field(byLawsPolicies; Rec."By Laws Policies")
                {
                    Caption = 'By Laws Policies';
                }
                field(corporateCommunication; Rec."Corporate Communication")
                {
                    Caption = 'Corporate Communication';
                }
                field(familyAvailedLoan; Rec."Family Availed Loan")
                {
                    Caption = 'Family Availed Loan';
                }
                field(loanBookingBranch; Rec."Loan Booking Branch")
                {
                    Caption = 'Loan Booking Branch';
                }
                field(loanBookingBranchName; Rec."Loan Booking Branch Name")
                {
                    Caption = 'Loan Booking Branch Name';
                }
                field(nameOfBorrower; Rec."Name of Borrower")
                {
                    Caption = 'Name of Borrower';
                }
                field(limit; Rec.Limit)
                {
                    Caption = 'Limit';
                }
                field(relationToStaff; Rec."Relation To staff")
                {
                    Caption = 'Relation To staff';
                }
                field(creditCloseRelativeSubmit; Rec."Credit Close Relative Submit")
                {
                    Caption = 'Credit Close Relative Submit';
                }
                field(havePassport; Rec."Have Passport")
                {
                    Caption = 'Have Passport';
                }
                field(passportNumber; Rec."Passport Number")
                {
                    Caption = 'Passport Number';
                }
                field(passportAttachment; Rec."Passport Attachment")
                {
                    Caption = 'Passport Attachment';
                }
                field(document1UnderCustody; Rec."Document 1 under Custody")
                {
                    Caption = 'Document 1 under Custody';
                }
                field(document2UnderCustody; Rec."Document 2 under Custody")
                {
                    Caption = 'Document 2 under Custody';
                }
                field(document3UnderCustody; Rec."Document 3 under Custody")
                {
                    Caption = 'Document 3 under Custody';
                }
                field(document4UnderCustody; Rec."Document 4 under Custody")
                {
                    Caption = 'Document 4 under Custody';
                }
                field(document5UnderCustody; Rec."Document 5 under Custody")
                {
                    Caption = 'Document 5 under Custody';
                }
                field(document6UnderCustody; Rec."Document 6 under Custody")
                {
                    Caption = 'Document 6 under Custody';
                }
                field(otherDocumentsIfAny; Rec."Other Documents if Any")
                {
                    Caption = 'Other Documents if Any';
                }
                field(ownerOfficialDocumentSubmit; Rec."Owner Official Document Submit")
                {
                    Caption = 'Owner Official Document Submit';
                }
                field(inventory1UnderCustody; Rec."Inventory 1 under Custody")
                {
                    Caption = 'Inventory 1 under Custody';
                }
                field(inventory2UnderCustody; Rec."Inventory 2 under Custody")
                {
                    Caption = 'Inventory 2 under Custody';
                }
                field(inventory3UnderCustody; Rec."Inventory 3 under Custody")
                {
                    Caption = 'Inventory 3 under Custody';
                }
                field(inventory4UnderCustody; Rec."Inventory 4 under Custody")
                {
                    Caption = 'Inventory 4 under Custody';
                }
                field(inventory5UnderCustody; Rec."Inventory 5 under Custody")
                {
                    Caption = 'Inventory 5 under Custody';
                }
                field(inventory6UnderCustody; Rec."Inventory 6 under Custody")
                {
                    Caption = 'Inventory 6 under Custody';
                }
                field(otherInventoryIfAny; Rec."Other Inventory If Any")
                {
                    Caption = 'Other Inventory If Any';
                }
                field(souvenirDeclaration; Rec."Souvenir Declaration")
                {
                    Caption = 'Souvenir Declaration';
                }
                field(involvedInOutsideBusiness; Rec."Involved In Outside Business")
                {
                    Caption = 'Involved In Outside Business';
                }
                field(engageManagingBusinessField; Rec."Engage/Managing Business Field")
                {
                    Caption = 'Engage/Managing Business Field';
                }
                field(nameOfInstitution; Rec."Name of Institution")
                {
                    Caption = 'Name of Institution';
                }
                field(dateOfInvolvement; Rec."Date of Involvement")
                {
                    Caption = 'Date of Involvement';
                }
                field(outsideBusinInterestSubm; Rec."Outside Busin. Interest Subm")
                {
                    Caption = 'Outside Busin. Interest Subm';
                }
                field(souvenirGift; Rec."Souvenir/Gift")
                {
                    Caption = 'Souvenir/Gift';
                }
                field(souvenirGiftFrom; Rec."Souvenir/Gift From")
                {
                    Caption = 'Souvenir/Gift From';
                }
                field(relationWithGiftProvider; Rec."Relation with Gift Provider")
                {
                    Caption = 'Relation with Gift Provider';
                }
                field(salaryLevelDescription; Rec."Salary Level Description")
                {
                    Caption = 'Salary Level Description';
                }
                field(outsideBusinessAttachment; Rec."Outside Business Attachment")
                {
                    Caption = 'Outside Business Attachment';
                }
            }
        }
    }
    trigger OnAfterGetRecord()

    begin
        if Rec."Passport Attachment" <> '' then begin  //Min 6.17.2022
            passportAttachmentExt := returnPassportAttachmentExtBase64(Rec."No.");
            passportAttachment := returnPassportAttachmentBase64(Rec."No.");
        end;
        if Rec."Outside Business Attachment" <> '' then begin //Min 6.17.2022
            outsidebussinessattachmentExt := outsideBusinessAttachmentExt(Rec."No.");
            outsidebussinessattachment := outsideBusinessAttachmentBase64(Rec."No.");
        end;
        if Rec."Property Declaration Attachmen" <> '' then begin //Min 6.17.2022
            propertyDisclosureAttachmentExt := propertyDisclosureAttachmentExt(Rec."No.");
            propertyDisclosure := propertyDisclosureAttachmentBase64(Rec."No.");
        end;
    end;

    procedure returnPassportAttachmentExtBase64(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Passport Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            passportAttachmentExt := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit(passportAttachmentExt);
        end else
            exit('not found');
    end;

    procedure returnPassportAttachmentBase64(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        base64: Codeunit "Base64 Convert";
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Passport Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            exit(base64.ToBase64(TempBlob.CreateInStream()));
        end else
            exit('not found');
    end;

    procedure outsideBusinessAttachmentExt(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Outside Business Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            outsidebussinessattachmentExt := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit(outsidebussinessattachmentExt);
        end else
            exit('not found');
    end;

    procedure outsideBusinessAttachmentBase64(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        base64: Codeunit "Base64 Convert";
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Outside Business Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            exit(base64.ToBase64(TempBlob.CreateInStream()));
        end else
            exit('not found');
    end;

    procedure propertyDisclosureAttachmentExt(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Property Declaration Attachmen";
            FileManagement.BLOBImport(TempBlob, FileName);
            propertyDisclosureExt := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit(propertyDisclosureExt);
        end else
            exit('not found');
    end;

    procedure propertyDisclosureAttachmentBase64(docNo: Code[20]): Text;
    var
        EmployeeDeclaration: Record "Employee Declaration";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        EmployeeDeclaration.Reset;
        if docNo <> '' then
            EmployeeDeclaration.SetRange("No.", docNo);
        if EmployeeDeclaration.FindFirst then begin
            FileName := EmployeeDeclaration."Property Declaration Attachmen";
            FileManagement.BLOBImport(TempBlob, FileName);
            exit(Base64String.ToBase64(docNo));
        end else
            exit('not found');
    end;

    var
        propertyDisclosure: Text;
        passportAttachment: Text;
        outsidebussinessattachment: Text;
        propertyDisclosureExt: Text;
        passportAttachmentExt: Text;
        outsidebussinessattachmentExt: Text;
        FileManagement: Codeunit "File Management";
        Base64String: Codeunit "Base64 Convert";
}
