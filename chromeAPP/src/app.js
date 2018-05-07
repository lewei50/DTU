var clientId;
var leweiUrl = "modbus.lewei50.com";
var leweiPort = 9970;

function connectLewei()
{
  console.log("connecting to lewei50.com RegCode:"+txtRegCode);
  if(clientId!=undefined)
  {
    chrome.sockets.tcp.close(clientId);
  }
  $('#nwk_switch').attr('src',"icon_switch_on.jpg");
  chrome.sockets.tcp.create({}, function (createInfo) {
      chrome.sockets.tcp.connect(createInfo.socketId,
          leweiUrl, leweiPort, onConnectedCallback);
      clientId = createInfo.socketId;
  });
}

function netSend(pl)
{
  try
  {
    chrome.sockets.tcp.send(clientId, pl, function (d) {
        console.log(d.resultCode);
        if(d.resultCode!= 0)
        {
          connectLewei();
        }
    });
  }
  catch(err)
  {
    console.log(err);
  }
}

var onConnectedCallback = function (r) {

    var buf = str2ab(txtRegCode);
    console.log(chrome.sockets.tcp.onReceive);
    function serSend(d) {
        //need to send to serial port
        serialSend(d.data);
    }
    chrome.sockets.tcp.send(clientId, buf, function (d) {
        console.log(d);
    })
    if(!chrome.sockets.tcp.onReceive.hasListeners())
    chrome.sockets.tcp.onReceive.addListener(serSend);
};

function serialSend(pl)
{
	try
  {
		sp.write(pl);
	}
	catch(err)
	{
		console.log(err);
	}
}

function ab2str(buf) {
    return String.fromCharCode.apply(null, new Uint16Array(buf));
}

function str2ab(str) {
    var buf = new ArrayBuffer(str.length); // 2 bytes for each char
    var bufView = new Uint8Array(buf);
    for (var i = 0, strLen = str.length; i < strLen; i++) {
        bufView[i] = str.charCodeAt(i);
    }
    return buf;
}
