
  console.log("page loaded");
  var txtRegCode = ""
  var regCode = document.getElementById('regcode');
  chrome.storage.sync.get("regCode", function(val) {
    regCode.value = val.regCode;
    txtRegCode = val.regCode;
  });
