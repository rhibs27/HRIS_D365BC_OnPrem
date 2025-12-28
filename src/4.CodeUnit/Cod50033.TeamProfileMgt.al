codeunit 50033 "Team Profile Mgt."
{
    procedure GetFilterParametersForEmployee(EmpNo: Code[20];
                                            ProfileFilterFor: Enum "Profile Filter For";
                                        var ProvinceFilter: text;
                                        var BranchFilter: text;
                                        var DepartmentFilter: text;
                                        var UnitFilter: text;
                                        var ExtensionCounterFilter: text): Boolean
    var
        Employee: Record Employee;
        TeamProfileHeader, TeamProfileHeader2 : Record "Team Profile Header";
        TeamProfileLine: Record "Team Profile Line";
    begin
        Employee.Get(EmpNo);
        TeamProfileHeader2.SetRange("Employee Code", EmpNo);
        if TeamProfileHeader2.FindFirst() then
            TeamProfileHeader := TeamProfileHeader2
        else begin
            TeamProfileHeader.SetRange("Approval Role", Employee."Approver Role");
            if TeamProfileHeader.FindFirst() then;
        end;

        TeamProfileLine.SetRange("Team Code", TeamProfileHeader.Code);
        case ProfileFilterFor of
            ProfileFilterFor::"Employee List":
                begin
                    TeamProfileLine.SetRange("View Employee List", true);
                end;
            ProfileFilterFor::"Birthday View":
                begin
                    TeamProfileLine.SetRange("View Birthday", true);
                end;
            ProfileFilterFor::"Service History View":
                begin
                    TeamProfileLine.SetRange("View Employee History", true);
                end;
            ProfileFilterFor::"Leave View":
                begin
                    TeamProfileLine.SetRange("View Employees Leave", true);
                end;
            ProfileFilterFor::"View Employee Card":
                begin
                    TeamProfileLine.SetRange("View Employee Card", true);
                end;
            ProfileFilterFor::"View Attendance":
                begin
                    TeamProfileLine.SetRange("View Attendance", true);
                end;
        end;
        if TeamProfileLine.FindSet() then begin
            repeat
                case
                    TeamProfileLine.Type of
                    TeamProfileLine.Type::Prov:
                        begin
                            if ProvinceFilter = '' then
                                ProvinceFilter := TeamProfileLine."Org. Structuire Code"
                            else
                                ProvinceFilter := ProvinceFilter + '|' + TeamProfileLine."Org. Structuire Code";
                        end;
                    TeamProfileLine.Type::Dept:
                        begin
                            if DepartmentFilter = '' then
                                DepartmentFilter := TeamProfileLine."Org. Structuire Code"
                            else
                                DepartmentFilter := DepartmentFilter + '|' + TeamProfileLine."Org. Structuire Code";
                        end;
                    TeamProfileLine.Type::Branch:
                        begin
                            if BranchFilter = '' then
                                BranchFilter := TeamProfileLine."Org. Structuire Code"
                            else
                                BranchFilter := BranchFilter + '|' + TeamProfileLine."Org. Structuire Code";
                        end;
                    TeamProfileLine.Type::Unit:
                        begin
                            if UnitFilter = '' then
                                UnitFilter := TeamProfileLine."Org. Structuire Code"
                            else
                                UnitFilter := UnitFilter + '|' + TeamProfileLine."Org. Structuire Code";
                        end;
                    TeamProfileLine.Type::"Ext Counter":
                        begin
                            if ExtensionCounterFilter = '' then
                                ExtensionCounterFilter := TeamProfileLine."Org. Structuire Code"
                            else
                                ExtensionCounterFilter := ExtensionCounterFilter + '|' + TeamProfileLine."Org. Structuire Code";
                        end;

                    TeamProfileLine.Type::"Own Prov":
                        begin
                            if ProvinceFilter = '' then
                                ProvinceFilter := Employee."Province Code"
                            else
                                ProvinceFilter := ProvinceFilter + '|' + Employee."Province Code";
                        end;
                    TeamProfileLine.Type::"Own Branch":
                        begin
                            if BranchFilter = '' then
                                BranchFilter := Employee."Branch Code"
                            else
                                BranchFilter := BranchFilter + '|' + Employee."Branch Code";
                        end;
                    TeamProfileLine.Type::"Own Dept":
                        begin
                            if DepartmentFilter = '' then
                                DepartmentFilter := Employee."Department Code"
                            else
                                DepartmentFilter := DepartmentFilter + '|' + Employee."Department Code";
                        end;
                    TeamProfileLine.Type::"Own Unit":
                        begin
                            if UnitFilter = '' then
                                UnitFilter := Employee."Unit Code"
                            else
                                UnitFilter := UnitFilter + '|' + Employee."Unit Code";
                        end;
                    TeamProfileLine.Type::"Own Ext Counter":
                        begin
                            if ExtensionCounterFilter = '' then
                                ExtensionCounterFilter := Employee."Extension Counter Code"
                            else
                                ExtensionCounterFilter := ExtensionCounterFilter + '|' + Employee."Extension Counter Code";
                        end;
                end;
            until TeamProfileLine.Next() = 0;
            exit(true);  //team profile exist
        end;

        exit(false) //team profile does not exist
    end;

    procedure LookUpOrgStructureCode(DeputationType: Enum "Deputation Type"): Text

    var
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(OrganizationStructureList);
        Clear(OrganizationStructureListPage);
        if DeputationType <> DeputationType::" " then
            OrganizationStructureList.SetRange(Type, DeputationType);
        OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        OrganizationStructureListPage.LookupMode(true);
        if OrganizationStructureListPage.RunModal = ACTION::LookupOK then begin
            OrganizationStructureListPage.SetSelectionFilter(OrganizationStructureList);
            if OrganizationStructureList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += OrganizationStructureList.code;
                until OrganizationStructureList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;
}
