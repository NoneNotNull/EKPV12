/**
 * 附件mixin(嵌入rtf用)
 */
define(["dojo/_base/declare",
        "dojo/dom-style",
        "dojo/query",
        "mui/form/editor/plugins/EditorPluginBaseMixin"
       ],function(declare,domStyle,query,EditorPluginBaseMixin){
	
	return declare("mui.form.editor.plugins.face.Plugin",[EditorPluginBaseMixin],{
		
		type : 'attachment',
		
		attachmentView:'#attachmentView',//业务模块,临时写死
		
		_isShow:false,
		
		icon : 'mui-attachEdit',
		
		event:function(evt){
			this._attachmentShow(evt);
		},
		
		_attachmentShow:function(evt){
			this.iconNode = evt.target;
			
			if (this._isShow) {
				this.hide();
				return;
			}
			this._isShow = true;
			this.show();
		},
		
		show:function(){
			this.inherited(arguments);
			if(this.attachmentView){
				domStyle.set(this.attachmentView,'display','block');
			}
		},
		
		hide:function(){
			this.inherited(arguments);
			if(this.attachmentView){
				domStyle.set(this.attachmentView,'display','none');
			}
		},
		
		startup:function(){
			this.inherited(arguments);
			if(typeof (this.attachmentView) == "string"){
				this.attachmentView=query(this.attachmentView)[0];
			}
		}
			
	});
	
	
});