//var offerOptions = {
//  offerToReceiveAudio: 1,
//  offerToReceiveVideo: 1,
//  iceRestart:true
//};
//example: pc.createOffer(offerOptions).then(....
//todo: add a pc.createOffer({iceRestart:true})... in the onicecandidate event while icestatus is failed
var NetConnector = {socket:null};
var userProfiles = {};
var self = {};
var cfg = {"iceServers":[{"url":"stun:stun.voipbuster.com"},
						{"url": "turn:benusying.6655.la?transport=tcp",
						"username": "benus",
						"credential": "123456"}
						]};
	
function generateUUID() {
	var d = new Date().getTime();
	var uuid = 'xxxxxxxx-xxxx'.replace(/[xy]/g, function(c) {
	  var r = (d + Math.random()*16)%16 | 0;
	  d = Math.floor(d/16);
	  return (c=='x' ? r : (r&0x3|0x8)).toString(16);
	});
	return uuid;
};

function writeToChatArea(message) {
	output("chat",message);
};

function writeToMsgArea(message) {
	output("msg",message);
};

function output(type,message) {
	//document.getElementById(type + "Area").innerHTML += "<p>" + message + "</p>";
};

function login() {
	var userName = document.getElementById("userName").value;
	if(userName) {
		self.userName = userName;
		NetConnector.login(userName);
	}
	else {
		console.log("No user name");
	}
};

NetConnector.newPeerConnectionAndOffer = function(userList) {
	//var offers = {};
	for(var key in userList) {
		if(self.peerId != userList[key]) {
			userProfiles[userList[key]] = {};
			var pc = new RTCPeerConnection(cfg);
			pc.remotePeerId = userList[key];console.log("new pc.remotePeerId="+pc.remotePeerId);
			pc.onicecandidate = function(e){NetConnector.onicecandidate(e,userList[key],'offer')};
			pc.onconnecting = NetConnector.handleOnPeerConnecting;
			pc.onconnection = NetConnector.handleOnPeerConnection;
		
			pc.onsignalingstatechange = NetConnector.handleOnSignalingStateChange;
			pc.oniceconnectionstatechange = function(e){NetConnector.handleOnIceConnectionStateChange(e,pc,userList[key])};
			pc.onicegatheringstatechange = NetConnector.handleOnIceGatheringStateChange;
			
			NetConnector.createDataChannel(pc,userList[key]);
			(function(pc,key){NetConnector.createOffer(pc,userList[key],{})})(pc,key);
			
			/*(function(pc,key){pc.createOffer({iceRestart:true}).then(function (desc) {
				console.log("In offer, pc.remotePeerId=", pc.remotePeerId);
				pc.setLocalDescription(desc);
				console.log("Created local offer", desc);
				writeToMsgArea("Created local offer");
				//offers[userList[key]] = JSON.stringify({ "sdp": desc });
				var offer = {};
				offer[userList[key]] = JSON.stringify(desc);
				NetConnector.socket.emit("offer",offer);
			}, function () {console.warn("Couldn't create offer");writeToMsgArea("Couldn't create offer");})})(pc,key);*/
			userProfiles[userList[key]].pc = pc;
			console.log("Created peer connection to user(" + userList[key] + ")");
		}
	}
	//return offers;
};

NetConnector.createOffer = function(pc,remotePeerId,offerOption) {
	pc.createOffer(offerOption).then(function (desc) {
			console.log("In offer, pc.remotePeerId=", remotePeerId);
			pc.setLocalDescription(desc);
			console.log("Created local offer", desc);
			writeToMsgArea("Created local offer");
			//offers[userList[key]] = JSON.stringify({ "sdp": desc });
			var offer = {};
			offer[remotePeerId] = JSON.stringify(desc);
			NetConnector.socket.emit("offer",offer);
		}, function () {console.warn("Couldn't create offer");writeToMsgArea("Couldn't create offer");})
};

NetConnector.newPeerConnectionAndAnswer = function(info) {
	var pc = userProfiles[info.peerId].pc;
	if(!pc) {
		pc = new RTCPeerConnection(cfg);
		pc.onicecandidate = function(e){NetConnector.onicecandidate(e,info.peerId,'answer')};
		pc.ondatachannel = function(e){NetConnector.ondatachannel(e,info.peerId)};
		pc.onconnecting = NetConnector.handleOnPeerConnecting;
		pc.onconnection = NetConnector.handleOnPeerConnection;
		
		pc.onsignalingstatechange = NetConnector.handleOnSignalingStateChange;
		pc.oniceconnectionstatechange = NetConnector.handleOnIceConnectionStateChange;
		pc.onicegatheringstatechange = NetConnector.handleOnIceGatheringStateChange;

		// once remote stream arrives, show it in the remote video element
		pc.onaddstream = function (evt) {
			document.getElementById("audio").src = URL.createObjectURL(evt.stream);
		};
		userProfiles[info.peerId].pc = pc;
	}

	var offerDesc = new RTCSessionDescription(JSON.parse(info.offer));
	//var toRemoteAnswerDesc = null;
	pc.setRemoteDescription(offerDesc);
	pc.createAnswer(function (answerDesc) {
		console.log("Created local answer for user(" + info.peerId + ")",answerDesc);
		writeToMsgArea("Created local answer for user(" + info.peerId + ")");
		pc.setLocalDescription(answerDesc);
		//toRemoteAnswerDesc = answerDesc;
		var answer = {};
		answer[info.peerId] = JSON.stringify(answerDesc);
		NetConnector.socket.emit("answer",answer);
		//document.getElementById(localAnswerDivId).innerHTML = JSON.stringify(answerDesc);
	},function() {console.warn("Couldn't create answer");writeToMsgArea("Couldn't create answer");});
	
	//return toRemoteAnswerDesc;
};

NetConnector.startConnectionWithAnswer = function(info) {
	if(userProfiles[info.peerId]) {
		var answerDesc = new RTCSessionDescription(JSON.parse(info.answer));
		userProfiles[info.peerId].pc.setRemoteDescription(answerDesc);
		console.log("Start a peer connection with user(" + info.peerId + ")");
		writeToMsgArea("Start a peer connection with user(" + info.peerId + ")");
	}
};

NetConnector.createDataChannel = function(pc,remotePeerId) {
	try {
		var dc = pc.createDataChannel("dc from " + self.peerId + " to " + remotePeerId,{reliable:false});
		console.log("Created data channel");
		writeToMsgArea("Created data channel");
		dc.onopen = function(e) {
			console.log('Data channel connected');
			writeToMsgArea('Data channel connected');
			NetConnector.synOnConnection();
		};
		dc.onmessage = function(e){NetConnector.handleOnMessage(e,remotePeerId)};
		dc.onerror = function(e) {
			console.warn('Error happened on Data channel:' + e);
			writeToMsgArea('Error happened on Data channel:' + e);
		};
		userProfiles[remotePeerId].dc = dc;
	}
	catch(e) {
		console.warn("no data");
	}
};

NetConnector.getPeerId = function() {
	var peerId = localStorage.getItem(appName + '.peerId');
	if(!peerId) {
		peerId = generateUUID();
		localStorage.setItem(appName + '.peerId',peerId);
	}
	return peerId;
};

NetConnector.init = function() {
	console.log("Init the network");
	this.socket = io.connect("ws://ADMINIB-G0GH1QP:9000");//benusying.6655.la
	self.peerId = NetConnector.getPeerId();
	console.log("peerId: " + self.peerId);
	this.socket.emit("online",{peerId:self.peerId});
	
	this.socket.on("online",function(info) {
		if(info.peerId != self.peerId) {
			userProfiles[info.peerId] = {};
			console.log("User " + info.peerId + " is online");
			writeToMsgArea("User " + info.peerId + " is online");
		}
	});
	this.socket.on("login",function(info) {
		if(info.peerId != self.peerId) {
			if(info.userName.substring(0,5) == 'Robot') {
				userProfiles[info.peerId][info.userName] = {homeIndex:info.homeIndex};
				writeToMsgArea("Robot " + info.userName + "login");
				console.log("Robot " + info.userName + " login");
			}
			else {
				userProfiles[info.peerId].userName = info.userName;
				userProfiles[info.peerId].homeIndex = info.homeIndex;
				writeToMsgArea("User " + info.userName + "login");
				console.log("User " + info.userName + " login");
			}
			NetConnector.getApp().newRemoteAgent(info.userName,info.homeIndex);//the userName including peerId
		}
	});
	this.socket.on("logout",function(info) {
		if(info.peerId != self.peerId) {
			writeToMsgArea("User " + userProfiles[info.peerId].userName + "logout");
			if(userProfiles[info.peerId]) {
				NetConnector.getApp().destoryRemoteAgent(info.userName);
				if(info.userName.substring(0,5) == 'Robot') {
					delete userProfiles[info.peerId][info.userName];
				}
				else {
					delete userProfiles[info.peerId];
				}
			}
		}
	});
	this.socket.on("env",function(info) {
		console.log("Get Env");
		if(info.peerIdList && info.peerIdList.length > 0) {
			console.log("Totally, " + info.peerIdList.length + " users are online");
			console.log("Online user list: " + info.peerIdList);
			
			//preset user profiles
			var userName;
			var homeIndex;
			for(var key in info.peerIdList) {
				if(info.peerIdList[key] != self.peerId) {
					userProfiles[info.peerIdList[key]] = {};
					if(info.loginedUserNameList[info.peerIdList[key]]) {
						userName = info.loginedUserNameList[info.peerIdList[key]].userName;
						homeIndex = info.loginedUserNameList[info.peerIdList[key]].homeIndex;
						if(userName && homeIndex) {
							userProfiles[info.peerIdList[key]].userName = userName;
							console.log("User " + userName + " existed");
							NetConnector.getApp().newRemoteAgent(userName,homeIndex);
						}
						for(var name in info.loginedUserNameList[info.peerIdList[key]]) {
							if(name.substring(0,5) == 'Robot') {
								console.log("Robot " + name + " existed");
								NetConnector.getApp().newRemoteAgent(name + '_' + info.peerIdList[key],info.loginedUserNameList[info.peerIdList[key]][name].homeIndex);
							}
						}
					}
				}
			}
			
			NetConnector.newPeerConnectionAndOffer(info.peerIdList);
			//console.log("Offer created for Users: " + Object.keys(offers));
			//NetConnector.socket.emit("offer",offers);
		}
		else {
			writeToMsgArea("I am the first one");
		}
		NetConnector.getApp().go();
	});
	this.socket.on("offer",function(info) {
		if(userProfiles[info.peerId]) {
			writeToMsgArea("Get offer from " + info.peerId);
			NetConnector.newPeerConnectionAndAnswer(info);
		}
	});
	this.socket.on("answer",function(info) {
		if(userProfiles[info.peerId]) {
			writeToMsgArea("Get answer from " + info.peerId);
			NetConnector.startConnectionWithAnswer(info);
		}
	});
	this.socket.on("ice",function(info) {
		if(userProfiles[info.peerId]) {
			writeToMsgArea("Get ice from " + info.peerId);
			console.log("Get ice from " + info.peerId + ":" + info.candidate);
			userProfiles[info.peerId].pc.addIceCandidate(new RTCIceCandidate(JSON.parse(info.candidate)));
		}
	});
	this.socket.on("message",function(msg) {
		console.log("Get a msg: " + msg);
		output(msg.type,msg.content);
	});
};

NetConnector.close = function() {
	if(userProfiles) {
		console.log("Ready to close RTC connection");
		for(var peerId in userProfiles) {
			if(userProfiles[peerId].dc) {
				userProfiles[peerId].dc.close();
				console.log("Closed dc(" + userProfiles[peerId].dc.label+ ")");
			}
			if(userProfiles[peerId].pc) {
				userProfiles[peerId].pc.close();
				console.log("Closed pc");
			}
		}
	}
};

NetConnector.login = function(userName,homeNodeIndex) {
	if(NetConnector.socket) {	
		NetConnector.socket.emit("login",{peerId:self.peerId,userName:userName,homeIndex:{x:homeNodeIndex.x,y:homeNodeIndex.y}});
	}
};

NetConnector.logout = function(userName) {
	if(NetConnector.socket) {	
		NetConnector.socket.emit("logout",{peerId:self.peerId,userName:userName});
	}
};

NetConnector.sendToServer = function(type,info) {
	if(NetConnector.socket) {
		NetConnector.socket.emit(type,info);
	}
};
NetConnector.synValue = function(index,value) {//for Cube game
	console.log("syn value" + index + "," + value);
	NetConnector.syn({index:index,value:value});
};

NetConnector.syn = function(data) {console.log("in syn" + data);
	var timestamp = new Date().getTime();
	for(var remotePeerId in userProfiles) {
		if(userProfiles[remotePeerId].dc) {
			if(userProfiles[remotePeerId].dc.readyState == 'open') {
				var synData;
				if(!data) {//if there is no data, just syn timestamp
					synData = JSON.stringify({syn:{timestamp:timestamp}});
				}
				else if(data.echo) {
					synData = JSON.stringify({syn:{echo:data.echo}});
				}
				else if(data.values) {//for Cube game
					synData = JSON.stringify({syn:{values:data.values}});
				}
				else if(data.value) {//for Cube game
					synData = JSON.stringify({syn:{index:data.index,value:data.value}});
				}
				else {
					var latency = NetConnector.getApp().getLatency(remotePeerId);
					synData = JSON.stringify({syn:{latency:latency,timestamp:timestamp,objectName:data.objectName,movement:data.movement,status:data.status,cellIndex:{x:data.cellIndex.x,y:data.cellIndex.y,z:data.cellIndex.z}}});
				}
				console.log("syn: " + synData);
				userProfiles[remotePeerId].dc.send(synData);
			}
			else {
				console.warn("Fail to syn data to user(" + remotePeerId + ") as dc is no open");
			}
		}
	}
};

NetConnector.sendToPeers = function() {
	var input = document.getElementById("myWords").value;
	if(input) {
		for(var remotePeerId in userProfiles) {
			if(userProfiles[remotePeerId].dc) {
				if(userProfiles[remotePeerId].dc.readyState == 'open') {
					userProfiles[remotePeerId].dc.send(JSON.stringify({message:input}));
					console.log("Sent msg to user(" + remotePeerId + ")");
				}
				else {
					console.warn("Fail to send msg to user(" + remotePeerId + ") as dc is not open");
					writeToMsgArea("Fail to send msg to user(" + remotePeerId + ") as dc is not open");
				}
			}
			else {
				console.warn("Fail to send msg to user(" + remotePeerId + ") as dc is not received");
				writeToMsgArea("Fail to send msg to user(" + remotePeerId + ") as dc is not received");
			}
		}
		writeToChatArea(input);
		document.getElementById("myWords").value = "";
	}	
};

NetConnector.ondatachannel = function (e,remotePeerId) {
	var dataChannel = e.channel || e;
	console.log("Received data channel",arguments);
	writeToMsgArea("Received data channel");
	dataChannel.onmessage = function(e){NetConnector.handleOnMessage(e,remotePeerId)};
	userProfiles[remotePeerId].dc = dataChannel;
	NetConnector.synOnConnection();
};

NetConnector.getDataConnectionNum = function() {
	var count = 0;
	for(var remotePeerId in userProfiles) {
		if(userProfiles[remotePeerId].dc) {
			count++;
		}
	}
	return count;
}

NetConnector.synOnConnection = function() {
	if(NetConnector.getApp().getLocalGameCellValues) {//for Cube game
		var count = NetConnector.getDataConnectionNum();
		NetConnector.getApp().updateNetConnectionNum(count);
		//NetConnector.updateNetConnectionNum(count);
		var values = NetConnector.getApp().getLocalGameCellValues();
		NetConnector.syn({values:values});
	}
	else {
		NetConnector.syn();//syn timestamp to all others???
	}
};

NetConnector.handleOnPeerConnecting = function() {
	console.log("data channel connecting");
};
NetConnector.handleOnPeerConnection = function() {
	console.log("data channel connected");
};
NetConnector.handleOnSignalingStateChange = function(state) {
	console.log('signaling state change:', state);
};
NetConnector.handleOnIceConnectionStateChange = function(state,pc,remotePeerId) {
	console.log('ice connection state changed to ' + state.currentTarget.iceConnectionState, state);
	if(state.currentTarget.iceConnectionState == "failed" && pc && remotePeerId) {
		console.log('ice restart');
		NetConnector.createOffer(pc,remotePeerId,{iceRestart:true});
	}
};
NetConnector.handleOnIceGatheringStateChange = function(state) {
	console.log('ice gathering state changed to ' + state.currentTarget.iceGatheringState, state);
};
NetConnector.handleOnMessage = function(e,remotePeerId) {
	var data = JSON.parse(e.data);
	if(data.syn) {console.log(data);
		if(data.syn.timestamp) {
			NetConnector.syn({echo:data.syn.timestamp});//echo the timestamp for calc network delay
		}
		else if(data.syn.echo) {
			var latency = new Date().getTime() - Number(data.syn.echo);
			NetConnector.getApp().setLatency(remotePeerId,latency);
		}
		else if(data.syn.values) {//for Cube game
			NetConnector.getApp().initRemoteGame(remotePeerId,data.syn.values)
		}
		else if(data.syn.value) {//for Cube game
			NetConnector.getApp().updateRemoteGameCellValue(remotePeerId,data.syn.index,data.syn.value)
		}
		if(data.syn.objectName) {	//console.log("Got a message: " + e.data);
			NetConnector.getApp().setSynData(data.syn.objectName,data.syn);
		}
	}
	else if(data.message) {
		writeToChatArea(data.message,"text-info");
	}
};

NetConnector.onicecandidate = function(e,remotePeerId,type) {
	if(e.candidate) {
		writeToMsgArea("Sent ice to user(" + remotePeerId + ")");
		NetConnector.sendToServer("ice",{peerId:remotePeerId, candidate:JSON.stringify( e.candidate )});
	}
	/*else { //The idea of this code block is to send offer/answer with icd candidate, which is referenced from serverless-webrtc.js
		console.log("Get latest desc with ice candidate and send to user(" + remotePeerId + ")");
		var desc = {};
		desc[remotePeerId] = JSON.stringify(userProfiles[remotePeerId].pc.localDescription);
		NetConnector.socket.emit(type,desc);
	}*/
};

NetConnector.getApp = function() {
	return Processing.getInstanceById(appName);
}

//it is a temp function
NetConnector.updateNetConnectionNum = function(count) {
	var context = NetConnector.getApp.externals.context;
	if(context) {
		context.fillStyle = "blue";
		context.fillText("peers: " + count,5,5);
	}
};

window.onload = function() {
	//NetConnector.init();
	/*
	document.getElementById("userName").onkeydown = function(e) {
		e = e || event;
		if (e.keyCode === 13) {
			login();
		}
	};

	document.getElementById("myWords").onkeydown = function(e) {
		e = e || event;
		if (e.keyCode === 13) {
			NetConnector.sendToPeers();
		}
	};*/
}

window.onunload = function() {
	NetConnector.close();
	return "Close";
};