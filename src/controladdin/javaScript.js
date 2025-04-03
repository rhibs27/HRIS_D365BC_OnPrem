
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
        img.style.width = '50%';
        img.style.height='100%';
        img.style.display = 'block';  // Make the image a block element
        img.style.marginLeft = 'auto'; // Center horizontally
        img.style.marginRight = 'auto';
        previewElement.appendChild(img);
    } else if (mimeType === 'application/pdf') {
        // Display PDF if it's a PDF file
        var iframe = document.createElement('iframe');
        iframe.src = 'data:' + mimeType + ';base64,' + base64data;
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.display = 'block';  // Make the image a block element
        iframe.style.margin = 'auto'; // Center horizontally
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

