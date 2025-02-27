
// Detect file type by checking the MIME type from the Base64 data
function GetAttachment(base64data) {
    var previewElement = document.querySelector(".previewArea");  
    if (!previewElement) {
        console.error('Preview area element not found.');
        return;
    }
    // First, determine the MIME type of the file
    var mimeType = getMimeType(base64data);

    // Depending on the file type, display the preview
    if (mimeType.startsWith('image/')) {
        // Display image if it's an image file
        var img = document.createElement('img');
        img.src = 'data:' + mimeType + ';base64,' + base64data;
        img.style.width = '100%';
        previewElement.appendChild(img);
    } else if (mimeType === 'application/pdf') {
        // Display PDF if it's a PDF file
        var iframe = document.createElement('iframe');
        iframe.src = 'data:' + mimeType + ';base64,' + base64data;
        iframe.style.width = '100%';
        iframe.style.height = '600px';  // You can adjust this height based on your needs
        previewElement.appendChild(iframe);
    } else {
        // For unsupported file types, show a message
        previewElement.innerHTML = 'Unsupported file type';
    }
}

//Function to detect MIME type based on Base64 signature
function getMimeType(base64) {
    // Simple checks for common file types. You can extend this based on your needs.
    if (base64.startsWith('iVBOR')) return 'image/png';  // PNG file signature
    if (base64.startsWith('/9j/')) return 'image/jpeg';  // JPEG file signature
    if (base64.startsWith('JVBER')) return 'application/pdf';  // PDF file signature
    return 'application/octet-stream'; // Default for unknown types
}

