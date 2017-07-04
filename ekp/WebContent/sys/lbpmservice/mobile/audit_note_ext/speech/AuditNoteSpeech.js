define(["dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/on", "dijit/_WidgetBase",  "mui/dialog/Tip",
        "dojo/dom-style", "dojo/dom-attr", "dojo/query", "dojo/touch", "mui/device/device", "mui/device/adapter"], 
		function(declare, lang, array, on, WidgetBase, tip, domStyle, domAttr, query, touch, device, adapter) {

	return declare("sys.lbpmservice.mobile.audit_note_ext.speech.AuditNoteSpeech", [WidgetBase], {
		
		descriptionDiv: null,
		
		buttonDiv: null,
		
		fdKey: "",
		
		fdAttType: "byte",
		
		fdModelId: "",
		
		fdModelName: "",
		
		fdMulti:true,
		
		editMode:true,
		
		files:[],
		
		startup : function() {
			this.inherited(arguments);
			//if(device.getClientType()==7 || device.getClientType()==8){
				this.createBtn();
				this.bindEvents();
			//}
		},
		
		bindEvents: function() {
			var eventPrefix = "attachmentObject_" + this.fdKey + "_";
			this.subscribe(eventPrefix + "success","speechSuccess");
			this.subscribe(eventPrefix + "fail","speechError");
			var seachArea = query(this.descriptionDiv).parent()[0];
			on(seachArea, on.selector("#speechDiv li i.speechClose", touch.press), lang.hitch(this, this.speechDelete));
			on(seachArea, on.selector("#speechDiv li i.speechIcon", touch.press), lang.hitch(this, this.playSpeech));
			on(seachArea, on.selector("#speechDiv li span.speechName", touch.press), lang.hitch(this, this.playSpeech));
			Com_Parameter.event["submit"].push(lang.hitch(this, this.submitEvent));
		},
		
		submitEvent: function() {
			if (this.files.length > 0) {
				var attachmentObj = window.AttachmentList[this.fdKey];
				if(attachmentObj!=null){
					return array.every(this.files, function(file) {
						var fdid = attachmentObj.registFile({'filekey':file.filekey,
							'name':file.name});
						return fdid!=null;
					},this);
				}
			}
			return true;
		},
		
		createBtn: function() {
			var obj = query(this.buttonDiv);
			var html = '<div class="handingWay" id="voiceHanding">';
				html +='<div class="iconArea"><i class="mui mui-voice"></i></div><span class="iconTitle">语音</span></div>';
			obj.append(html);
			query("#voiceHanding").on(touch.press, lang.hitch(this, this.showSpeech));
		},
		
		showSpeech:function(evt){
			adapter.openSpeech({options:this,evt:evt});
			//this.speechSuccess(null,{file:{name:'测试.wav',fullpath:'//asdhkhk/adlasd/avm.mav'}});
		},
		
		speechDelete:function(evt){
			var obj = evt.target;
			if (obj && obj.tagName=='I' ) {
				this.files = array.filter(this.files, function(file) {
					return file.filekey != obj.id;
				});
				var voiceList = query("#speechDiv > li");
				if(voiceList.length>1){
					query(obj).parents("#speechDiv > li").remove();
				}else{
					query("#speechDiv").parents("div.speechArea").remove(); 
				}
			}
		},
		
		playSpeech:function(evt){
			var obj = evt.target;
			if(obj && (obj.tagName=='I' || obj.tagName=='SPAN')){
				var liObjs =  query(obj).parents("#speechDiv > li");
				if(liObjs.length>0){
					var downloadUrl =  domAttr.get(liObjs[0],"playHref");
					if(downloadUrl!=null && downloadUrl!=''){
						adapter.playSpeech(downloadUrl);
					}
				}
			}
		},
		
		speechSuccess:function(srcobj , evt){
			if (evt == null || evt.file==null) {
				return;
			}
			var file = evt.file;
			this.files.push(file);
			var speechDiv = query("#speechDiv");
			var speechHtml = "<li playHref='" + (file.fullpath||file.fullPath) + "' id='li_" + file.filekey + "'><div>";
			speechHtml += "<i class='speechIcon mui mui-play'></i>";
			speechHtml += "<span class='speechName'>" +  file.name + "</span><i id='" + file.filekey + "' class='speechClose mui mui-close'></i>";
			speechHtml += "</div></li>";
			if(speechDiv.length>0){
				if(speechDiv.innerHTML() == ""){
					speechDiv.innerHTML(speechHtml);
				}else{
					speechDiv.append(speechHtml);
				}
			}else{
				var speechArea = "<div class='speechArea'><ul id='speechDiv'>"+speechHtml+"</ul></div>";
				query(this.descriptionDiv).after(speechArea);
			}
		},
		
		speechError:function(srcobj , evt){
			if(evt && evt.rtn && evt.rtn.msg ){
				tip.fail({text: evt.rtn.msg });
			}
		}
	});
});