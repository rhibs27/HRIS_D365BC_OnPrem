codeunit 50019 "SQL Connection Attendance"
{
    // trigger OnRun();
    // begin
    //     GetEmpRecords;
    // end;

    var
        SQLUserID: Text;
        SQLPassword: Text;
        CompInfo: Record "Company Information";
        CommandText: Text;
        SqlConnectionMgt: Codeunit "SQL Connection Mgt";
        SQLCommandType: Option StoredProcedure,TableDirect,Text;
        NoServerInfoError: Label 'Either server or database information not found.';
        ReadCommandTxt: Label 'Select * from ';
        FromDate: Date;
        ToDate: Date;
        DeviceID: Integer;
    // SQLConnection: DotNet SqlConnection;
    // SQLCommand: DotNet SqlCommand;
    // SQLParameter: DotNet SqlParameter;
    // SQLDataReader: DotNet SqlDataReader;

    // procedure SetupSQLConnection(var SQLConnection: DotNet SqlConnectionVar);
    // begin
    //     SQLConnection := SQLConnection.SqlConnection(GetConnectionString);
    //     SQLConnection.Open;
    // end;

    // procedure CloseSQLConnection(var SQLConnection: DotNet SqlConnectionVar);
    // begin
    //     SQLConnection.Close;
    //     // SQLConnection.Dispose;
    // end;

    // procedure GetConnectionString() ConnStr: Text[250];
    // var
    //     ServerName: Text;
    //     DatabaseName: Text;
    // begin
    //     GetServerInformation(ServerName, DatabaseName);
    //     if (ServerName = '') or (DatabaseName = '') then
    //         exit(NoServerInfoError);

    //     if not IsServiceTier then
    //         ConnStr := 'Provider=SQLOLEDB;' +
    //             'Initial Catalog=' + UpperCase(DatabaseName) +
    //             ';Data Source=' + UpperCase(ServerName) +
    //             ';User ID=' + SQLUserID + ';Password=' + SQLPassword
    //     else
    //         ConnStr :=
    //             'Server=' + ServerName + ';' +
    //             'Database="' + DatabaseName + '";' +
    //             'Uid=' + SQLUserID + ';' +
    //             'Pwd=' + SQLPassword + ';';

    //     exit(ConnStr);
    // end;

    // procedure GetServerInformation(var ServerName: Text; var DatabaseName: Text);
    // begin
    //     Clear(ServerName);
    //     Clear(DatabaseName);
    //     Clear(SQLUserID);
    //     Clear(SQLPassword);

    //     ServerName := '10.100.30.219';
    //     DatabaseName := 'AttendanceDB';
    //     SQLUserID := 'sa';
    //     SQLPassword := 'Agile@123';
    // end;

    // procedure SetupSQLCommand(SQLConnection: DotNet SqlConnection; SQLCommand: DotNet SqlCommand; commandtext: Text; SQLCommandType: Option StoredProcedure,TableDirect,Text);
    // begin
    //     SQLCommand := SQLConnection.CreateCommand;
    //     SQLCommand.CommandText := commandtext;
    //     SQLCommand.CommandTimeout := 15;
    // end;

    // local procedure ReadRecords(TableName: Text);
    // begin
    //     Clear(commandtext);
    //     commandtext := ReadCommandTxt + TableName;
    //     SqlConnectionMgt.SetupSQLCommand(SQLConnection, SQLCommand, commandtext, SQLCommandType::Text);
    //     SQLDataReader := SQLCommand.ExecuteReader;
    // end;

    // procedure GetEmpRecords();
    // begin
    //     SyncEmployeeAttendance;
    // end;

    // procedure SyncEmployeeAttendance();
    // var
    //     AttenSetup: Record "Attendance Setup";
    //     HRSetup: Record "Human Resources Setup";
    // begin
    //     AttenSetup.Get();
    //     HRSetup.Get();
    //     CompInfo.Get;
    //     SqlConnectionMgt.SetupSQLConnection(SQLConnection);

    //     if FromDate = 0D then
    //         FromDate := CalcDate(format(AttenSetup."Sync Attendance From"), Today);
    //     if (ToDate = 0D) and (DeviceID = 0) then
    //         ReadRecords(StrSubstNo('%1 where %2 >= ''%3''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate))
    //     else
    //         if (ToDate <> 0D) and (DeviceID = 0) then
    //             ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate))
    //         else
    //             if (ToDate = 0D) and (DeviceID <> 0) then
    //                 ReadRecords(StrSubstNo('%1 where %2 >= ''%3'' and %4 = ''%5''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, 'DeviceID', DeviceID))
    //             else
    //                 if (ToDate <> 0D) and (DeviceID <> 0) then
    //                     ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4'' and %5 = ''%6''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate, 'DeviceID', DeviceID));

    //     InsertEmpAttendance;
    //     SqlConnectionMgt.CloseSQLConnection(SQLConnection);
    //     Message('Attendance Sync Completed.');
    // end;

    // local procedure InsertEmpAttendance();
    // var
    //     AttendanceLog: Record "Attendance Log";
    //     AttendanceLog1: Record "Attendance Log";
    //     MachineId: Integer;
    //     MachineIdCode: Text[50];
    //     mode: Integer;
    // begin
    //     while SQLDataReader.Read do begin
    //         MachineId := SQLDataReader.GetValue(1);
    //         mode := SQLDataReader.GetValue(6);
    //         // MachineId := 0;
    //         // Evaluate(MachineId, MachineIdCode);
    //         AttendanceLog1.Reset();
    //         AttendanceLog1.SetRange("Machine Code", MachineId);
    //         AttendanceLog1.SetRange("Machine Emp. Code", (SQLDataReader.GetValue(2)));
    //         AttendanceLog1.SetRange(Date, DT2Date(SQLDataReader.GetValue(3)));
    //         //AttendanceLog1.SetRange("Check In Time", DT2Time(SQLDataReader.GetValue(3)));
    //         if not AttendanceLog1.FindFirst() then begin
    //             // if not AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then
    //             AttendanceLog.Reset();
    //             AttendanceLog.Init;
    //             AttendanceLog.Validate("Machine Code", MachineId);
    //             AttendanceLog.Validate("Date", DT2DATE(SQLDataReader.GetValue(3)));
    //             case mode of
    //                 0:
    //                     begin
    //                         AttendanceLog.Validate("Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                     end;
    //                 1:
    //                     begin
    //                         AttendanceLog.Validate("Check Out Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                     end;
    //                 4:
    //                     begin
    //                         AttendanceLog.Validate("Training Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                     end;
    //                 5:
    //                     begin
    //                         AttendanceLog.Validate("Training Check Out Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                     end;
    //             end;
    //             AttendanceLog.Validate("Machine Emp. Code", (SQLDataReader.GetValue(2)));
    //             AttendanceLog."Biometrics Attendance" := true;
    //             if AttendanceLog.Insert(true) then;
    //         end else begin
    //             case mode of
    //                 0:
    //                     begin
    //                         AttendanceLog1.SetRange("Check In Time", DT2Time(SQLDataReader.GetValue(3)));
    //                         if not AttendanceLog1.FindFirst() then begin
    //                             AttendanceLog1.Validate("Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                             AttendanceLog1.Modify();
    //                         end;
    //                     end;
    //                 1:
    //                     begin
    //                         AttendanceLog1.SetRange("Check Out Time", DT2Time(SQLDataReader.GetValue(3)));
    //                         if not AttendanceLog1.FindFirst() then begin
    //                             AttendanceLog1.Validate("Check Out Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                             AttendanceLog1.Modify();
    //                         end;
    //                     end;
    //                 4:
    //                     begin
    //                         AttendanceLog1.Validate("Training Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                         AttendanceLog1.Modify();
    //                     end;
    //                 5:
    //                     begin
    //                         AttendanceLog1.Validate("Training Check Out Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                         AttendanceLog1.Modify();
    //                     end;
    //             end;
    //         end;
    //     end;
    //     Commit;
    // end;
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<AUTO GENERATED BY CONFLICT EXTENSION<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< main
    local procedure InsertEmpAttendance();
    var
        AttendanceLog: Record "Attendance Log";
        AttendanceLog1: Record "Attendance Log";
        MachineId: Integer;
        MachineIdCode: Text[50];
        mode: Integer;
        DateTimeLog: DateTime;
        CheckInOutTime: Time; // Variable to store the time from SQL
    begin
        while SQLDataReader.Read do begin
            MachineId := SQLDataReader.GetValue(1);
            // mode := SQLDataReader.GetValue(6);
            DateTimeLog := SQLDataReader.GetValue(3);

            // Get the check-in/check-out time from SQL data

            CheckInOutTime := DT2Time(SQLDataReader.GetValue(3));
            // CheckInOutTime := Round(CheckInOutTime, 10000);
            // Reset and filter the AttendanceLog1
            AttendanceLog1.Reset();
            AttendanceLog1.SetRange("Machine Code", MachineId);
            AttendanceLog1.SetRange("Machine Emp. Code", SQLDataReader.GetValue(2));
            AttendanceLog1.SetRange("Date Time Log", DateTimeLog);
            // If no record exists, insert a new one
            if not AttendanceLog1.FindFirst() then begin
                AttendanceLog.Reset();
                AttendanceLog.Init;
                AttendanceLog.Validate("Machine Code", MachineId);
                AttendanceLog.Validate("Date", DT2DATE(SQLDataReader.GetValue(3)));
                AttendanceLog.Validate("Date Time Log", DateTimeLog);
                AttendanceLog.Validate("Log Time", CheckInOutTime);
                // case mode of
                //     0: // Check-In
                //         begin
                //             AttendanceLog.Validate("Check In Time", CheckInOutTime);
====================================AUTO GENERATED BY CONFLICT EXTENSION====================================
//     local procedure InsertEmpAttendance();
//     var
//         AttendanceLog: Record "Attendance Log";
//         AttendanceLog1: Record "Attendance Log";
//         MachineId: Integer;
//         MachineIdCode: Text[50];
//         mode: Integer;
//         DateTimeLog: DateTime;
//         CheckInOutTime: Time; // Variable to store the time from SQL
//     begin
//         while SQLDataReader.Read do begin
//             MachineId := SQLDataReader.GetValue(1);
//             // mode := SQLDataReader.GetValue(6);
//             DateTimeLog := SQLDataReader.GetValue(3);

//             // Get the check-in/check-out time from SQL data

//             CheckInOutTime := DT2Time(SQLDataReader.GetValue(3));
//             // CheckInOutTime := Round(CheckInOutTime, 10000);
//             // Reset and filter the AttendanceLog1
//             AttendanceLog1.Reset();
//             AttendanceLog1.SetRange("Machine Code", MachineId);
//             AttendanceLog1.SetRange("Machine Emp. Code", SQLDataReader.GetValue(2));
//             AttendanceLog1.SetRange("Date Time Log", DateTimeLog);
//             // If no record exists, insert a new one
//             if not AttendanceLog1.FindFirst() then begin
//                 AttendanceLog.Reset();
//                 AttendanceLog.Init;
//                 AttendanceLog.Validate("Machine Code", MachineId);
//                 AttendanceLog.Validate("Date", DT2DATE(SQLDataReader.GetValue(3)));
//                 AttendanceLog.Validate("Date Time Log", DateTimeLog);
//                 AttendanceLog.Validate("Check In Time", CheckInOutTime);
//                 // case mode of
//                 //     0: // Check-In
//                 //         begin
//                 //             AttendanceLog.Validate("Check In Time", CheckInOutTime);
//                 //         end;
//                 //     1: // Check-Out
//                 //         begin
//                 //             AttendanceLog.Validate("Check Out Time", CheckInOutTime);
//                 //         end;
//                 //     4: // Training Check-In
//                 //         begin
//                 //             AttendanceLog.Validate("Training Check In Time", CheckInOutTime);
//                 //         end;
//                 //     5: // Training Check-Out
//                 //         begin
//                 //             AttendanceLog.Validate("Training Check Out Time", CheckInOutTime);
//                 //         end;
//                 // end;

//                 AttendanceLog.Validate("Machine Emp. Code", SQLDataReader.GetValue(2));
//                 AttendanceLog."Biometrics Attendance" := true;
//                 if AttendanceLog.Insert(true) then;
//                 // end else begin
//                 //     // If a record exists, modify it based on mode
//                 //     case mode of
//                 //         0: // Check-In
//                 //             begin
//                 //                 AttendanceLog1.Validate("Check In Time", CheckInOutTime);
//                 //                 AttendanceLog1.Modify();
//                 //             end;
//                 //         1: // Check-Out
//                 //             begin
//                 //                 AttendanceLog1.Validate("Check Out Time", CheckInOutTime);
//                 //                 AttendanceLog1.Modify();
//                 //             end;
//                 //         4: // Training Check-In
//                 //             begin
//                 //                 AttendanceLog1.Validate("Training Check In Time", CheckInOutTime);
//                 //                 AttendanceLog1.Modify();
//                 //             end;
//                 //         5: // Training Check-Out
//                 //             begin
//                 //                 AttendanceLog1.Validate("Training Check Out Time", CheckInOutTime);
//                 //                 AttendanceLog1.Modify();
//                 //             end;
//                 //     end;
//             end;
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>AUTO GENERATED BY CONFLICT EXTENSION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Cloud-Approach
//         end;
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<AUTO GENERATED BY CONFLICT EXTENSION<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< main
                //     1: // Check-Out
                //         begin
                //             AttendanceLog.Validate("Check Out Time", CheckInOutTime);
                //         end;
                //     4: // Training Check-In
                //         begin
                //             AttendanceLog.Validate("Training Check In Time", CheckInOutTime);
                //         end;
                //     5: // Training Check-Out
                //         begin
                //             AttendanceLog.Validate("Training Check Out Time", CheckInOutTime);
                //         end;
                // end;

                AttendanceLog.Validate("Machine Emp. Code", SQLDataReader.GetValue(2));
                AttendanceLog."Biometric Attendance" := true;
                if AttendanceLog.Insert(true) then;
                // end else begin
                //     // If a record exists, modify it based on mode
                //     case mode of
                //         0: // Check-In
                //             begin
                //                 AttendanceLog1.Validate("Check In Time", CheckInOutTime);
                //                 AttendanceLog1.Modify();
                //             end;
                //         1: // Check-Out
                //             begin
                //                 AttendanceLog1.Validate("Check Out Time", CheckInOutTime);
                //                 AttendanceLog1.Modify();
                //             end;
                //         4: // Training Check-In
                //             begin
                //                 AttendanceLog1.Validate("Training Check In Time", CheckInOutTime);
                //                 AttendanceLog1.Modify();
                //             end;
                //         5: // Training Check-Out
                //             begin
                //                 AttendanceLog1.Validate("Training Check Out Time", CheckInOutTime);
                //                 AttendanceLog1.Modify();
                //             end;
====================================AUTO GENERATED BY CONFLICT EXTENSION====================================
//         Commit;
//     end;

//     procedure SetFilterParameter(PFromDate: Date; PTOdate: Date; PDeviceID: Integer)
//     begin
//         FromDate := PFromDate;
//         ToDate := PTOdate;
//         DeviceID := PDeviceID;
//     end;

//     procedure SyncAttendanceDevice()
//     var
//         AttenSetup: Record "Attendance Setup";
//     begin
//         AttenSetup.Get();
//         CompInfo.Get;
//         SqlConnectionMgt.SetupSQLConnection(SQLConnection);
//         ReadRecords(StrSubstNo('%1', '[DeviceConfigs]'));
//         // InsertAttenDeviceConfig();
//         SqlConnectionMgt.CloseSQLConnection(SQLConnection);
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>AUTO GENERATED BY CONFLICT EXTENSION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Cloud-Approach
//     end;

//     // local procedure InsertAttenDeviceConfig();
//     // var
//     //     AttendanceDevice: Record "Attendance Devices";
//     //     AttendanceDevice1: Record "Attendance Devices";
//     //     deviceID: Integer;
//     // begin
//     //     while SQLDataReader.Read do begin
//     //         deviceID := 0;
//     //         deviceID := SQLDataReader.GetValue(0);
//     //         if deviceID <> 0 then
//     //             if not AttendanceDevice1.Get(deviceID) then begin
//     //                 Clear(AttendanceDevice);
//     //                 AttendanceDevice.Init;
//     //                 AttendanceDevice.Validate(ID, deviceID);
//     //                 AttendanceDevice.Validate(Name, SQLDataReader.GetValue(1));
//     //                 AttendanceDevice.Validate(IPAddress, SQLDataReader.GetValue(2));
//     //                 AttendanceDevice.Validate(Port, SQLDataReader.GetValue(3));
//     //                 AttendanceDevice.Validate(DeviceID, SQLDataReader.GetValue(4));
//     //                 AttendanceDevice.Validate(IsActive, SQLDataReader.GetValue(5));
//     //                 AttendanceDevice.Validate(LastSyncDate, SQLDataReader.GetValue(6));
//     //                 if AttendanceDevice.Insert then;
//     //             end
//     //             else
//     //                 if AttendanceDevice1.Get(deviceID) then begin
//     //                     AttendanceDevice1.Validate(LastSyncDate, SQLDataReader.GetValue(6));
//     //                     AttendanceDevice1.Modify();
//     //                 end;
//     //     end;
//     //     Commit;
//     // end;

//     procedure SyncUpdateEmployeeAttendance();
//     var
//         AttenSetup: Record "Attendance Setup";
//         HRSetup: Record "Human Resources Setup";
//     begin
//         AttenSetup.Get();
//         HRSetup.Get();
//         CompInfo.Get;
//         SqlConnectionMgt.SetupSQLConnection(SQLConnection);

//         if FromDate = 0D then
//             FromDate := CalcDate(format(AttenSetup."Sync Attendance From"), Today);
//         if (ToDate = 0D) and (DeviceID = 0) then
//             ReadRecords(StrSubstNo('%1 where %2 >= ''%3''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate))
//         else
//             if (ToDate <> 0D) and (DeviceID = 0) then
//                 ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate))
//             else
//                 if (ToDate = 0D) and (DeviceID <> 0) then
//                     ReadRecords(StrSubstNo('%1 where %2 >= ''%3'' and %4 = ''%5''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, 'DeviceID', DeviceID))
//                 else
//                     if (ToDate <> 0D) and (DeviceID <> 0) then
//                         ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4'' and %5 = ''%6''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate, 'DeviceID', DeviceID));

//         InsertUpdateEmpAttendance;
//         SqlConnectionMgt.CloseSQLConnection(SQLConnection);
//     end;

//     local procedure InsertUpdateEmpAttendance();
//     var
//         AttendanceLog: Record "Attendance Log";
//         AttendanceLog1: Record "Attendance Log";
//         MachineId: Integer;
//         MachineIdCode: Text;
//     begin
//         while SQLDataReader.Read do begin
//             MachineIdCode := SQLDataReader.GetValue(1);
//             MachineId := 0;
//             Evaluate(MachineId, MachineIdCode);
//             if not AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then
//                 if MachineId <> 0 then begin
//                     Clear(AttendanceLog);
//                     AttendanceLog.Init;
//                     AttendanceLog.Validate("Machine Emp. Code", format(MachineId));
//                     AttendanceLog.Validate(Date, DT2DATE(SQLDataReader.GetValue(3)));
//                     AttendanceLog.Validate("Employee ID", (SQLDataReader.GetValue(2)));
//                     AttendanceLog.Validate("Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
//                     // AttendanceLog.Validate("Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
//                     // AttendanceLog.Validate("Device ID", SQLDataReader.GetValue(1));
//                     // AttendanceLog."Biometrics Attendance" := true;
//                     if AttendanceLog.Insert then;
//                 end

//                 else
//                     if AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then begin

//                         AttendanceLog1.Validate("Machine Emp. Code", SQLDataReader.GetValue(1));
//                         AttendanceLog1.Modify();
//                     end;
//         end;
//         Commit;
//     end;
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<AUTO GENERATED BY CONFLICT EXTENSION<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< main
    //     Commit;
    // end;

    procedure SyncUpdateEmployeeAttendance();
    var
        AttenSetup: Record "Attendance Setup";
        HRSetup: Record "Human Resources Setup";
    begin
        AttenSetup.Get();
        HRSetup.Get();
        CompInfo.Get;
        SqlConnectionMgt.SetupSQLConnection(SQLConnection);

        if FromDate = 0D then
            FromDate := CalcDate(format(AttenSetup."Sync Attendance From"), Today);
        if (ToDate = 0D) and (DeviceID = 0) then
            ReadRecords(StrSubstNo('%1 where %2 >= ''%3''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate))
        else
            if (ToDate <> 0D) and (DeviceID = 0) then
                ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate))
            else
                if (ToDate = 0D) and (DeviceID <> 0) then
                    ReadRecords(StrSubstNo('%1 where %2 >= ''%3'' and %4 = ''%5''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, 'DeviceID', DeviceID))
                else
                    if (ToDate <> 0D) and (DeviceID <> 0) then
                        ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4'' and %5 = ''%6''', '[' + Format(HRSetup."SQL Table Name") + ']', 'InputDate', FromDate, ToDate, 'DeviceID', DeviceID));

        InsertUpdateEmpAttendance;
        SqlConnectionMgt.CloseSQLConnection(SQLConnection);
    end;

    local procedure InsertUpdateEmpAttendance();
    var
        AttendanceLog: Record "Attendance Log";
        AttendanceLog1: Record "Attendance Log";
        MachineId: Integer;
        MachineIdCode: Text;
    begin
        while SQLDataReader.Read do begin
            MachineIdCode := SQLDataReader.GetValue(1);
            MachineId := 0;
            Evaluate(MachineId, MachineIdCode);
            if not AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then
                if MachineId <> 0 then begin
                    Clear(AttendanceLog);
                    AttendanceLog.Init;
                    AttendanceLog.Validate("Machine Emp. Code", format(MachineId));
                    AttendanceLog.Validate(Date, DT2DATE(SQLDataReader.GetValue(3)));
                    AttendanceLog.Validate("Employee ID", (SQLDataReader.GetValue(2)));
                    AttendanceLog.Validate("Log Time", DT2TIME(SQLDataReader.GetValue(3)));
                    // AttendanceLog.Validate("Check In Time", DT2TIME(SQLDataReader.GetValue(3)));
                    // AttendanceLog.Validate("Device ID", SQLDataReader.GetValue(1));
                    // AttendanceLog."Biometrics Attendance" := true;
                    if AttendanceLog.Insert then;
                end

                else
                    if AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then begin

                        AttendanceLog1.Validate("Machine Emp. Code", SQLDataReader.GetValue(1));
                        AttendanceLog1.Modify();
                    end;
        end;
        Commit;
    end;
====================================AUTO GENERATED BY CONFLICT EXTENSION====================================
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>AUTO GENERATED BY CONFLICT EXTENSION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Cloud-Approach
 }