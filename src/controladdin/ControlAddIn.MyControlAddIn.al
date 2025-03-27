controladdin MyControlAddIn
{
    RequestedHeight = 400;
    MinimumHeight = 300;
    MaximumHeight = 1000;
    RequestedWidth = 700;
    MinimumWidth = 700;
    MaximumWidth = 900;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts = './javaScript.js';
    StartupScript = './src/controladdin/preview.html';
    StyleSheets = './src/controladdin/preview.css';
    procedure GetAttachment(Base64Text: Text)
}