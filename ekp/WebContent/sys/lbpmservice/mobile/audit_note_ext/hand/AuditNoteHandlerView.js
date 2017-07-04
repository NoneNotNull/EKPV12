define(["dojo/_base/declare",
        "dojo/query", 
        "dojo/touch",
        "mui/util",
        "dojo/_base/lang",
        "dojo/_base/array",
        "dojo/on",
        "sys/lbpmservice/mobile/audit_note_ext/_CanvasView",
        "dojo/NodeList-manipulate"], 
        function(declare, query, touch, util, lang, array, on, _CanvasView) {

	return declare("sys.lbpmservice.mobile.audit_note_ext.hand.AuditNoteHandlerView", [_CanvasView], {
		
		descriptionDiv: null,
		
		buttonDiv: null,
	
		startup : function() {
			this.inherited(arguments);
			this.createBtn();
			this.bindEvents();
		},
		
		createBtn: function() {
			var obj = query(this.buttonDiv);
			var html = '<div class="handingWay" id="handwriting">';
			html +='<div class="iconArea"><i class="mui mui-write"></i></div><span class="iconTitle">手写</span></div>';
			obj.append(html);
			query("#handwriting").on(touch.press, lang.hitch(this, this.showAuditNoteHandlerView));
		},
		
		bindEvents: function() {
			lbpm.events.addListener(lbpm.constant.EVENT_validateMustSignYourSuggestion,function() {
				var imageDiv = query(".auditNoteHandlerImgUl");
				return (imageDiv.children().length > 0 );
			});
			on(query(this.descriptionDiv).parent()[0], on.selector("#imgUl li .btn_canncel_img", touch.press), lang.hitch(this, this.auditNoteViewDelete));
			this.inherited(arguments);
		},
		
		auditNoteViewDelete : function(evt){
			if (evt.target) {
				var obj = evt.target.tagName == "SPAN" ? evt.target : query(evt.target).parent("span")[0];
				if (obj == null)
					return;
				this.fileIds = array.filter(this.fileIds, function(fileId) {
					return fileId != obj.id;
				});
		        query("#" + obj.id + "_li").remove();
			}
		},
		
		UploadSuccessed:function(srcObj , evt){
			var file = evt.file;
			var imageDiv = query("#imgUl");
			var html = '<li id="'+file.filekey+'_li"><div class="img_wrapper">';
			    html +='<span class="btn_canncel_img" id="'+file.filekey+'"><i class="mui mui-close"></i></span>';
				html +='<div class="img_content"><img width="100" height="75" src="'+file.href+'"></div></div></li>';
			if(imageDiv.length > 0){
				if(imageDiv.innerHTML() == ""){
					 imageDiv.innerHTML(html);
				}else{
					 imageDiv.append(html);
				}
		    }else{
			    var rowhtml = '<div class="tab_img"><ul id="imgUl" class="auditNoteHandlerImgUl">'+html+'</tr></ul></div>';
			    query(this.descriptionDiv).after(rowhtml);
		    }
		}
	});
});