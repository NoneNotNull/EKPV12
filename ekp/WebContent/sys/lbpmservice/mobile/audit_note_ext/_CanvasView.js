define(["dojo/_base/declare",
        "dojox/mobile/View",
        "dojo/query", 
        "dojox/mobile/TransitionEvent", 
        "dijit/registry", 
        "dojo/_base/window", 
        "dojo/touch",
        "mui/util",
        "dojo/_base/lang",
        "dojo/_base/array",
        "dojo/dom-style",
        "dojo/on",
        "mui/dialog/Tip",
        "mui/device/webapi",
        "sys/lbpmservice/mobile/audit_note_ext/Canvas",
        "dojo/NodeList-manipulate"], 
        function(declare, View, query, TransitionEvent, registry, 
        		win, touch, util, lang, array, domStyle, on, Tip, webApi, Canvas) {

	return declare("sys.lbpmservice.mobile.audit_note_ext._CanvasView", [View], {
		
		fdKey: "",
		
		fdAttType: "pic",
		
		fdModelId: "",
		
		fdModelName: "",
		
		uploadStream:true,
		
		canvas: null,
		
		fileIds: [],
		
		_working:false,
		
		_resizeTimer: null,
		
		startup : function() {
			this.inherited(arguments);
			this.fileIds = [];
			query(this.domNode).style("display", "none");
			util.addTopView(this.domNode);
		},
		
		bindEvents: function() {
			var eventPrefix = "attachmentObject_" + this.fdKey + "_";
			this.subscribe(eventPrefix + "success", "AttUploadSuccess");
			this.subscribe(eventPrefix + "fail", "AttUploadError");
			query("[name='selectPenWidth']", this.domNode).on("change", lang.hitch(this, this.dowidthchange));
			query("[name='selectPenColor']", this.domNode).on("change", lang.hitch(this, this.docolorchange));
			registry.byNode(query(".auditNoteHandlerCancel", this.domNode)[0]).on("click", lang.hitch(this, this.hideAuditNoteHandlerView));
			registry.byNode(query(".auditNoteHandlerClear", this.domNode)[0]).on("click", lang.hitch(this, this.auditNoteViewClear));
			registry.byNode(query(".auditNoteHandlerSave", this.domNode)[0]).on("click", lang.hitch(this, this.auditNoteViewSave));
			Com_Parameter.event["submit"].push(lang.hitch(this, this.submitEvent));
		},
		
		submitEvent: function() {
			if (this.fileIds.length > 0) {
				var attachmentObj = window.AttachmentList[this.fdKey];
				if(attachmentObj!=null){
					return array.every(this.fileIds, function(fileId) {
						var fdid = attachmentObj.registFile({'filekey':fileId,'name':"image.png"});
						return fdid!=null;
					},this);
				}
			}
			return true;
		},
		
		resize: function() {
			this.inherited(arguments);
			this.resizeCanvas();
		},
		
		releaseCanvas: function() {
			this.canvas = null;
			query(".canvasDiv", this.domNode).empty();
		},
		
		resizeCanvas: function() {
			if (this._resizeTimer) {
				this._resizeTimer.remove();
				this._resizeTimer = null;
			}
			var canvasDiv = query(".canvasDiv", this.domNode)[0];
			var auditNoteHandlerToolbar = query(".auditNoteHandlerToolbar", this.domNode)[0];
			var auditNoteHandlerHeader = query(".auditNoteHandlerHeader", this.domNode)[0];
			var screensize = util.getScreenSize();
			var h = screensize.h - auditNoteHandlerToolbar.offsetHeight - auditNoteHandlerHeader.offsetHeight;
			canvasDiv.style.height = h + "px";
			var doResize = false;
			var tmpCanvas = document.createElement('canvas');
			if(this.canvas){
				tmpCanvas = this.canvas.getDomCanvas();
			}else{
				canvasDiv.appendChild(tmpCanvas);
				domStyle.set(tmpCanvas,{width:'100%',height:'100%'});
			}
			var width = canvasDiv.offsetWidth;
			var height = canvasDiv.offsetHeight;
			var canvasWidth = tmpCanvas.width, canvasHeight = tmpCanvas.height;
			if (canvasWidth != width || canvasHeight != height) {
				tmpCanvas.width = width;
				tmpCanvas.height = height;
				doResize = true;
			}
			if (!this.canvas) {
				this.canvas = new Canvas(tmpCanvas); 
			}
			if (doResize) {
				this.dowidthchange();
				this.docolorchange();
			}
			//this._resizeTimer = this.defer("resizeCanvas", 2000);
		},
		
		getLineWidth: function() {
		    var lbxPenWidth = query("[name='selectPenWidth']", this.domNode)[0];
		    var penWidth = lbxPenWidth.options[lbxPenWidth.selectedIndex].getAttribute("value");
		    return penWidth;
		},
		
		getStrokeStyle: function() {
			var lbxPenColor = query("[name='selectPenColor']", this.domNode)[0];
		    var color = lbxPenColor.options[lbxPenColor.selectedIndex].getAttribute("value");
		    return color;
		},
		
		dowidthchange: function() {
		    this.canvas.getContext().lineWidth = this.getLineWidth();
		},
		
		docolorchange: function() {
			this.canvas.getContext().strokeStyle = this.getStrokeStyle();
		},
		
		auditNoteViewClear: function() {
			this.canvas.clearRect();
		},
		
		showAuditNoteHandlerView: function() {
			new TransitionEvent(win.body(), {moveTo: this.id, transition: "flip"}).dispatch();
			this.dowidthchange();
			this.docolorchange();
		},
		
		hideAuditNoteHandlerView : function() {
			new TransitionEvent(win.body(), {moveTo: 'lbpmView', transition: "flip", transitionDir: -1}).dispatch();
		},
		
		showViewById:function(id){
			new TransitionEvent(win.body(), {moveTo: id, transition: "flip", transitionDir: -1}).dispatch();
		},
		
		getResult: function(result) {
			var rtn = {};
			array.forEach(result.firstChild.childNodes, function(child) {
				if (child.nodeType == 1) {
					rtn[child.nodeName] = child.firstChild.nodeValue;
				}
			});
			return rtn;
		},
		
		workDone:function(){
			this.defer(function(){
				this._working = false;
				if(this.process){
					this.process.hide();
				}
			},300);
		},
		
		auditNoteViewSave: function() {
			if (this._working)
				return;
			this._working = true;
			this.process = Tip.processing().show();
			webApi.uploadFile({options:this,evt:{'dataURL':this.canvas.toDataURL("image/png")}});
		},
		
		AttUploadSuccess:function(srcObj , evt){
			if (evt == null || evt.file==null) {
				this.workDone();
				return;
			}
			var file = evt.file;
			this.fileIds.push(file.filekey);
			this.UploadSuccessed(srcObj , evt);
			this.hideAuditNoteHandlerView();
			this.auditNoteViewClear();
			this.workDone();
		},
		
		UploadSuccessed:function(srcObj , evt){
			
		},
		
		AttUploadError:function(){
			this.workDone();
		}
	});
});