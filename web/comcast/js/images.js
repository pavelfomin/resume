//////////////////////////////////////////////////////
//Java Script Imaging related functions
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
//Shows image in the pre-defined originalImageObject image object
//////////////////////////////////////////////////////
function showImage(imgObject, width, height, originalImageObject){
  originalImageObject.width = width;
  originalImageObject.height = height;
  originalImageObject.src = imgObject.src;
}

//////////////////////////////////////////////////////
//Shows image in a new window called imageWindow
//////////////////////////////////////////////////////
function showImageInNewWindow(imgObject, width, height){
  var windowWidth  = width + 10;
  var windowHeight = height + 15;
  var imageWindow = window.open("", "imageWindow", "height="+ windowHeight +",width="+ windowWidth +",dependent=yes,menubar=no,resizable=no,scrollbars=no,status=yes,titlebar=yes");
  imageWindow.focus();
  imageWindow.location = imgObject.src;
}

//////////////////////////////////////////////////////
//Does not work !!
//////////////////////////////////////////////////////
function showImage1(imgObject, width, height){
  var windowWidth  = width + 10;
  var windowHeight = height + 30;
  var imageWindow = window.open("", "imageWindow", "height="+ windowHeight +",width="+ windowWidth +",dependent=yes,menubar=no,resizable=no,scrollbars=no,status=yes,titlebar=yes");
  imageWindow.document.writeln("<html><head><title>Report</title></head><body>");
  imageWindow.document.writeln('<a href="javascript:window.opener.focus()">Back to the list</a>');
  imageWindow.document.writeln(imgObject);
  imageWindow.document.writeln("</body></html>");
  imageWindow.focus();
}

