define(["dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/on", "dijit/_WidgetBase", 
        "dojo/dom-style", "dojo/dom-construct", "dojo/query", "dojo/touch", "dojo/dom-attr", 
        "mui/device/device", "mui/device/adapter","sys/lbpmservice/mobile/audit_note_ext/_CanvasView"], 
		function(declare, lang, array, on, WidgetBase, domStyle, domConstruct, query, touch, domAttr, device, adapter, _CanvasView) {

	return declare("sys.lbpmservice.mobile.audit_note_ext.sign.AuditNoteSign", [_CanvasView], {
		
		descriptionDiv: null,
		
		buttonDiv: null,
		
		backTo:null,
		
		startup : function() {
			this.inherited(arguments);
			this.createBtn();
			this.bindEvents();
		},
		
		bindEvents: function() {
			this.inherited(arguments);
			var seachArea = query(this.descriptionDiv).parent()[0];
			on(seachArea, on.selector("#signDiv li i.signClose", touch.press), lang.hitch(this, this.signDelete));
			on(seachArea, on.selector("#signDiv li i.signIcon", touch.press), lang.hitch(this, this.signModify));
			on(seachArea, on.selector("#signDiv li span.signName", touch.press), lang.hitch(this, this.signModify));
		},
		
		createBtn: function() {
			var obj = query(this.buttonDiv);
			var html = '<div class="handingWay" id="digitalSignature">';
				html +='<div class="iconArea"><i class="mui mui-sign"></i></div><span class="iconTitle">批注</span></div>';
			obj.append(html);
			query("#digitalSignature").on(touch.press, lang.hitch(this, this.showSign));
		},
		
		showSign:function(){
			if(device.getClientType()>6 && device.getClientType()<11){
				var optDiv = query("#signOptBar");
				if(this.backTo)
					this.showViewById(this.backTo);
				if(optDiv.length>0){
					domStyle.set(optDiv[0],{'display':'block'});
				}else{
					var signOptHtml = "<div id='signOptBar'><i class='signOptIcon mui mui-capture'></i></div>";
					optDiv = domConstruct.toDom(signOptHtml);
					domConstruct.place(optDiv, document.body, 'last');
					var self = this;
					this.connect(optDiv, touch.press , function(){
						self.defer(function(){
							domStyle.set(optDiv,{'display':'none'});
							adapter.captureScreen(function(imageInfo){
								self.drawImage(imageInfo);
							});
						},350);
					});
				}
			}else{
				adapter.captureScreen(this.drawImage);//弹出非kk不支持
			}
		},
		
		drawImage:function(base64Info){
			this.showAuditNoteHandlerView();
			var self = this;
			this.curImg = new Image();
			this.curImg.onload = function(){
				self.canvas.drawImage(self.curImg);
			};
			this.curImg.src = base64Info;
		},
		
		hideAuditNoteHandlerView:function(){
			this.inherited(arguments);
			this.canvas.clearRect();
		},
		
		auditNoteViewClear:function(){
			this.inherited(arguments);
			this.canvas.drawImage(this.curImg);
		},
		
		UploadSuccessed:function(srcObj , evt){
			var file = evt.file;
			var signDiv = query("#signDiv");
			var signHtml = "<li imgHref='" + file.href + "'><div>";
			//signHtml += "<img src='"+ file.href + "'></img>";
			signHtml += "<i class='signIcon mui mui-sign'></i>";
			signHtml += "<span class='signName'>" + file.name + "</span>";
			signHtml += "<i class='signClose mui mui-close'></i>";
			signHtml += "</div></li>";
			if(signDiv.length>0){
				if(signDiv.innerHTML() == ""){
					signDiv.innerHTML(signHtml);
				}else{
					signDiv.append(signHtml);
				}
			}else{
				var signArea = "<div class='signArea'><ul id='signDiv'>" + signHtml + "</ul></div>";
				query(this.descriptionDiv).after(signArea);
			}
		},
		
		signDelete:function(evt){
			var obj = evt.target;
			if (obj && obj.tagName=='I' ) {
				this.files = array.filter(this.files, function(file) {
					return file.filekey != obj.id;
				});
				var voiceList = query("#signDiv > li");
				if(voiceList.length>1){
					query(obj).parents("#signDiv > li").remove();
				}else{
					query("#signDiv").parents("div.signArea").remove(); 
				}
			}
		},
		
		signModify:function(evt){
			/*var obj = evt.target;
			if(obj && (obj.tagName=='I' || obj.tagName=='SPAN')){
				var liObjs =  query(obj).parents("#signDiv > li");
				if(liObjs.length>0){
					this.drawImage(domAttr.get(liObjs[0],"imgHref"));
				}
			}*/
		}
	});
});