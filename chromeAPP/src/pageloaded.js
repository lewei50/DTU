
  console.log("page loaded");
  var txtRegCode = ""
  var regCode = document.getElementById('regcode');
  chrome.storage.sync.get("regCode", function(val) {
    regCode.value = val.regCode;
    txtRegCode = val.regCode;
  });
  var txtSvr = "modbus.lewei50.com:9970"
  var svr = document.getElementById('svr');
  chrome.storage.sync.get("svr", function(val) {
    if(val.svr != undefined)
    {
    	svr.value = val.svr;
    	txtSvr = val.svr;
    }
    else svr.value = txtSvr
  });
