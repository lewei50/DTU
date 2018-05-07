chrome.app.runtime.onLaunched.addListener(function() {
    chrome.app.window.create('window.html', {
      'bounds': {
        'width': 400,
        'height': 500
      }
    });
  });
  chrome.runtime.onSuspend.addListener( function ()
  {
    if(sp!=null)
    {
      chrome.serial.disconnect(connectionId, callback);
    }
  });
