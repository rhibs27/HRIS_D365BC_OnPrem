codeunit 50019 "Biometric Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        AttendanceSetup: Record "Attendance Setup";

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
    procedure SyncAttendance(fromDate: Date; toDate: Date; DeviceId: Integer)
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
        AttendanceSetup.Get();
        header := Client.DefaultRequestHeaders;
        Client.Get(StrSubstNo('%1GetAttendanceLog?fromDate=%2&toDate=%3&DeviceSN=%4', AttendanceSetup."Base URL", FromDateText, TodateText, DeviceId), ResponseMessage);

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
        AttenLog: Record "Attendance Log";
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
                            if GetJsonValue(json_object, 'CheckTime', json_value) then begin
                                Evaluate(AttenLog."Log Time", json_value.AsText());

                                DateText := json_value.AsText().Substring(1, 10);
                                year := DateText.Substring(1, 4);
                                Month := DateText.Substring(6, 2);
                                day := DateText.Substring(9, 2);
                                DateText := year + '-' + Month + '-' + day;
                                TimeText := json_value.AsText().Substring(12, 10);
                                Evaluate(AttenLog.Date, DateText);
                                Evaluate(AttenLog."Log Time", TimeText);
                            end;
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
    begin
        SyncBranchDevice();
    end;

    local procedure SyncBranchDevice()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        Username, Password, AuthHeader, APIUrl, JsonText : Text;
        Content: HttpContent;
        JsonObj, DeviceObject : JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
    begin
        AttendanceSetup.Get();

        APIUrl := AttendanceSetup."Base URL";
        Username := AttendanceSetup."User Name";
        Password := AttendanceSetup.Password;
        AuthHeader := 'Basic ' + EncodeBase64(Username + ':' + Password);

        Request.Method := 'GET';
        Request.SetRequestUri(APIUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Authorization', AuthHeader);
        Headers.Add('Accept', 'application/json');

        if not Client.Send(Request, Response) then
            Error('Failed to send HTTP request.');

        if not Response.IsSuccessStatusCode() then
            Error('Request failed: %1 - %2', Response.HttpStatusCode(), Response.ReasonPhrase());

        Content := Response.Content();
        Content.ReadAs(JsonText);

        if not JsonArray.ReadFrom(JsonText) then
            Error('Failed to parse JSON array.');

        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then begin
                DeviceObject := JsonToken.AsObject();
                InsertDeviceConfig(DeviceObject);
            end
        end;
    end;

    procedure InsertDeviceConfig(DeviceObject: JsonObject)
    var
        DeviceConfigSetup, DeviceConfigSetup1 : Record "Biometric Device Config.";
        json_value: JsonValue;
    begin
        DeviceConfigSetup.Init();
        if GetJsonValue(DeviceObject, 'id', json_value) then
            DeviceConfigSetup.Id := json_value.AsInteger();
        if GetJsonValue(DeviceObject, 'name', json_value) then
            DeviceConfigSetup.Name := json_value.astext();
        if GetJsonValue(DeviceObject, 'ipaddress', json_value) then
            DeviceConfigSetup.IP := json_value.AsText();
        if GetJsonValue(DeviceObject, 'isActive', json_value) then
            DeviceConfigSetup."Is Active" := json_value.AsBoolean();
        if GetJsonValue(DeviceObject, 'lastSyncDate', json_value) then
            DeviceConfigSetup."Last Sync Date" := json_value.AsDateTime();
        if GetJsonValue(DeviceObject, 'serialNumber', json_value) then
            DeviceConfigSetup.SN := json_value.astext();

        if DeviceConfigSetup1.Get(DeviceConfigSetup.SN) then begin
            DeviceConfigSetup1.IP := DeviceConfigSetup.IP;
            DeviceConfigSetup1.Name := DeviceConfigSetup.Name;
            DeviceConfigSetup1."Last Sync Date" := DeviceConfigSetup."Last Sync Date";
            DeviceConfigSetup1."Is Active" := DeviceConfigSetup."Is Active";
            DeviceConfigSetup1.Modify();
        end
        else
            DeviceConfigSetup.Insert();

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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1ClearAttLogFromDevice?sn=%2', AttendanceSetup."Base URL", sn), ResponseMessage);
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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1deleteUserFaceDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserFpDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1DeleteUserPicDev?userPin=%2&branchCode=%3', AttendanceSetup."Base URL", UserPin, BranchCode), ResponseMessage);
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
        AttendanceSetup.Get();
        AttendanceSetup.TestField("Base URL");
        AttendanceSetup.Get();

        Client.Get(StrSubstNo('%1toNewDevice?userPin=%2&destSn=%3', AttendanceSetup."Base URL", UserPin, deviceSN), ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' +
                  'Status code: ' + Format(ResponseMessage.HttpStatusCode()) +
                  'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
        if not Jtoken.ReadFrom(ResponseString) then
            Error('Invalid JSON document.');

        Message('User %1 is sucessfully sent to the device!', UserPin);

    end;

    local procedure EncodeBase64(InputText: Text): Text
    var
        InStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        EncodedText: Text;
    begin
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(InputText);
        TempBlob.CreateInStream(InStream);
        EncodedText := Base64Convert.ToBase64(InStream);
        exit(EncodedText);
    end;

}
