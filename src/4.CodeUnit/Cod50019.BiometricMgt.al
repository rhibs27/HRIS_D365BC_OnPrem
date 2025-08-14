codeunit 50019 "Biometric Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        AdmsSetup: Record "Attendance Setup";

    local procedure GetJsonValue(jObj: JsonObject; jKeyName: Text; var jValue: JsonValue): Boolean
    var
        j_token: JsonToken;
    begin
        if not jObj.Get(jKeyName, j_token) then
            exit;
        jValue := j_token.AsValue();
        if jValue.IsNull then
            exit(false);
        if jValue.IsUndefined then
            exit(false);
        exit(true);
    end;

    //attendance Log
    procedure SyncAttendance(fromDate: Date; toDate: Date; SN: text)
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;
    begin
        FromDateText := Format(fromDate, 10, 9);
        TodateText := Format(toDate, 10, 9);
        AdmsSetup.Get();
        header := Client.DefaultRequestHeaders;
        Client.Get(StrSubstNo('%1GetAttendanceLog?fromDate=%2&toDate=%3&DeviceSN=%4', AdmsSetup."Base URL", FromDateText, TodateText, SN), ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        if not Jtoken.IsObject() then
            Error('Expected a JSON object.');
        DownloadAttendanceData(ResponseString);
    end;

    procedure DownloadAttendanceData(JsonText: Text)
    var
        json_array: JsonArray;
        json_object: JsonObject;

        json_value: JsonValue;
        i: Integer;
        AttenLog: Record "Biometric Attendance Log";
        json_Token: JsonToken;
        DTVar: DateTime;
        DateText: text;
        TimeText: text;

        year: text;
        Month: text;
        day: text;

    begin
        if json_Token.ReadFrom(JsonText) then begin
            if json_Token.IsObject then begin
                json_object := json_Token.AsObject();

                if json_object.Get('Data', json_Token) then begin
                    if json_Token.IsArray then begin
                        json_array := json_Token.AsArray();
                        for i := 0 to json_array.Count - 1 do begin

                            json_array.Get(i, json_Token);
                            json_object := json_Token.AsObject();

                            Clear(AttenLog);
                            DTVar := 0DT;
                            AttenLog.Init();
                            if GetJsonValue(json_object, 'BranchCode', json_value) then
                                AttenLog."Branch Code" := json_value.AsCode();
                            if GetJsonValue(json_object, 'CheckTime', json_value) then begin
                                AttenLog."Check Time" := json_value.AsText();

                                DateText := json_value.AsText().Substring(1, 10);
                                year := DateText.Substring(1, 4);
                                Month := DateText.Substring(6, 2);
                                day := DateText.Substring(9, 2);
                                DateText := year + '-' + Month + '-' + day;
                                TimeText := json_value.AsText().Substring(12, 10);
                                Evaluate(AttenLog."Attendance Date", DateText);
                                Evaluate(AttenLog."Attendance Time", TimeText);
                            end;

                            if GetJsonValue(json_object, 'DeviceSN', json_value) then
                                AttenLog."Device SN" := json_value.astext();
                            if GetJsonValue(json_object, 'Id', json_value) then
                                AttenLog."Device Id" := json_value.AsInteger();

                            if GetJsonValue(json_object, 'UserPin', json_value) then
                                AttenLog."User PIN" := json_value.AsInteger();
                            if AttenLog.Insert() then;
                        end;
                    end;
                end;
            end;
        end
        else
            Error('could not read response from json token');
    end;

    //sync device
    procedure SyncDeviceConfig()
    var
        BiometricBranch: Record "Biometric Branch";
    begin
        BiometricBranch.Reset();
        if BiometricBranch.FindSet() then
            repeat
                SyncBranchDevice(BiometricBranch."Branch Code");
            until BiometricBranch.Next() = 0;
    end;

    local procedure SyncBranchDevice(BranchCode: Code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        Jtoken: JsonToken;
    begin
        AdmsSetup.Get();
        Client.Get(StrSubstNo('%1GetDeviceByBranch?Code=%2', AdmsSetup."Base URL", BranchCode), ResponseMessage);

        ResponseMessage.Content.ReadAs(ResponseString);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        if not Jtoken.IsObject() then
            Error('Expected a JSON object.');

        DownloadBiometricConfig(ResponseString);
    end;

    local procedure DownloadBiometricConfig(JsonText: Text)
    var
        json_array: JsonArray;
        json_object: JsonObject;
        json_value: JsonValue;
        i: Integer;
        DeviceConfigSetup: Record "Biometric Device Config.";
        DeviceConfigSetup1: Record "Biometric Device Config.";
        json_Token: JsonToken;
        DTVar: DateTime;
    begin
        if json_Token.ReadFrom(JsonText) then begin
            if json_Token.IsObject then begin
                json_object := json_Token.AsObject();

                if json_object.Get('Data', json_Token) then begin
                    if json_Token.IsArray then begin
                        json_array := json_Token.AsArray();
                        for i := 0 to json_array.Count - 1 do begin

                            json_array.Get(i, json_Token);
                            json_object := json_Token.AsObject();

                            Clear(DeviceConfigSetup);
                            DTVar := 0DT;
                            DeviceConfigSetup.Init();
                            if GetJsonValue(json_object, 'BranchCode', json_value) then
                                DeviceConfigSetup."Branch Code" := json_value.AsCode();
                            // if GetJsonValue(json_object, 'DepartmentCode', json_value) then
                            //     DeviceConfigSetup."Department Code" := json_value.AsText(); works on some device
                            if GetJsonValue(json_object, 'DevFuns', json_value) then
                                DeviceConfigSetup."Dev Funs" := json_value.AsText();
                            if GetJsonValue(json_object, 'DeviceModel', json_value) then
                                DeviceConfigSetup."Device Model" := json_value.AsText();
                            if GetJsonValue(json_object, 'DeviceStatus', json_value) then
                                DeviceConfigSetup."Device Status" := json_value.AsText();
                            if GetJsonValue(json_object, 'DeviceType', json_value) then
                                DeviceConfigSetup."Device Type" := json_value.AsText();

                            if GetJsonValue(json_object, 'FPCount', json_value) then
                                DeviceConfigSetup."FP Count" := json_value.AsInteger();
                            if GetJsonValue(json_object, 'FaceCount', json_value) then
                                DeviceConfigSetup."Face Count" := json_value.AsInteger();
                            if GetJsonValue(json_object, 'FirmwareVersion', json_value) then
                                DeviceConfigSetup."Firmware Version" := json_value.AsText();
                            if GetJsonValue(json_object, 'IP', json_value) then
                                DeviceConfigSetup.IP := json_value.AsText();
                            if GetJsonValue(json_object, 'Id', json_value) then
                                DeviceConfigSetup.Id := json_value.AsInteger();
                            if GetJsonValue(json_object, 'IsAccessDevice', json_value) then
                                DeviceConfigSetup."Is Access Device" := json_value.AsBoolean();
                            if GetJsonValue(json_object, 'IsFaceDevice', json_value) then
                                DeviceConfigSetup."Is Face Device" := json_value.AsBoolean();
                            // if GetJsonValue(json_object, 'LastActivity', json_value) then
                            //     DeviceConfigSetup."Last Activity" := json_value.AsDateTime();
                            // if GetJsonValue(json_object, 'LastActivity', json_value) then
                            //     DeviceConfigSetup."Last Activity Text" := json_value.AsText(); works on some
                            if GetJsonValue(json_object, 'Name', json_value) then
                                DeviceConfigSetup.Name := json_value.astext();
                            if GetJsonValue(json_object, 'SN', json_value) then
                                DeviceConfigSetup.SN := json_value.astext();

                            if GetJsonValue(json_object, 'TransCount', json_value) then
                                DeviceConfigSetup."Trans Count" := json_value.AsInteger();
                            if GetJsonValue(json_object, 'UserCount', json_value) then
                                DeviceConfigSetup."User Count" := json_value.AsInteger();

                            if DeviceConfigSetup1.Get(DeviceConfigSetup.SN, DeviceConfigSetup."Branch Code") then begin
                                DeviceConfigSetup1.IP := DeviceConfigSetup.IP;
                                DeviceConfigSetup1.Name := DeviceConfigSetup.Name;
                                DeviceConfigSetup1."Device Status" := DeviceConfigSetup."Device Status";
                                DeviceConfigSetup1."Last Activity Text" := DeviceConfigSetup."Last Activity Text";
                                DeviceConfigSetup1."FP Count" := DeviceConfigSetup."FP Count";
                                DeviceConfigSetup1."Face Count" := DeviceConfigSetup."Face Count";
                                DeviceConfigSetup1."Trans Count" := DeviceConfigSetup."Trans Count";
                                DeviceConfigSetup1."User Count" := DeviceConfigSetup."User Count";
                                DeviceConfigSetup1.Modify();
                            end
                            else
                                DeviceConfigSetup.Insert();
                        end;
                    end;
                end;
            end;
        end
        else
            Error('could not read response from json token');
    end;

    procedure DeletelogFromDevice(sn: text[100])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1ClearAttLogFromDevice?sn=%2', AdmsSetup."Base URL", sn), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('Device Log cleared sucessfully!');

    end;


    procedure DeleteUserFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserDev?userPin=%2&branchCode=%3', AdmsSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user is deleted sucessfully from the device!');

    end;


    procedure DeleteUserFaceFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1deleteUserFaceDev?userPin=%2&branchCode=%3', AdmsSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user face is deleted sucessfully from the device!');

    end;

    procedure DeleteUserFingerprintFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserFpDev?userPin=%2&branchCode=%3', AdmsSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('user finger print is deleted sucessfully from the device!');

    end;

    procedure DeleteUserPictureFromDevice(UserPin: Integer; BranchCode: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserPicDev?userPin=%2&branchCode=%3', AdmsSetup."Base URL", UserPin, BranchCode), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

    end;


    procedure SendEmployeeDatatoNewDevice(UserPin: Integer; deviceSN: code[20])
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
        header: HttpHeaders;
        Jtoken: JsonToken;
        FromDateText: Text;
        TodateText: Text;

    begin
        AdmsSetup.Get();
        AdmsSetup.TestField("Base URL");
        AdmsSetup.Get();

        Client.Get(StrSubstNo('%1toNewDevice?userPin=%2&destSn=%3', AdmsSetup."Base URL", UserPin, deviceSN), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('User %1 is sucessfully sent to the device!', UserPin);

    end;


    // procedure CheckDeviceConnectivity(var BiometricDevice: Record "Biometric Device Config.")
    // var
    //     TestPing: DotNet ping;
    //     pingReply: DotNet pingreply;
    // begin
    //     Clear(TestPing);
    //     Clear(pingReply);
    //     TestPing := TestPing.Ping();
    //     pingReply := TestPing.Send(BiometricDevice.IP);
    //     if pingReply.Status = pingReply.Status::Success then
    //         BiometricDevice."Connectivity Status" := 'Online'
    //     // BiometricDevice."Connectivity Status" := BiometricDevice."Connectivity Status"::Online
    //     else
    //         BiometricDevice."Connectivity Status" := Format(pingReply.Status);
    //     BiometricDevice.Modify();
    // end;

}
