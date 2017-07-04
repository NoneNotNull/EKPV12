define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/list/item/_ListLinkItemMixin",
	"dojo/date/locale",
	"mui/i18n/i18n!sys-mobile" 	
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util, _ListLinkItemMixin,locale,msg) {
	
	var item = declare("sys.task.list.item.EvaluateItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"taskCommonListItem muiEvaluateListItem",
		 
		href : 'javascript:void(0);',
		
		buildRendering:function(){
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//上方信息
			var info=domConstruct.create("div",{className:"info"},this.containerNode);
			domConstruct.create("img", { className: "infoImg",src:this.icon}, info);//评价人头像
			var h4= domConstruct.create("h4", { innerHTML:this.creator}, info);//评价人名字
			var __p=domConstruct.create("p", { className:"infoApprove mui mui-editor-face"}, h4);//评价满意度
			domConstruct.create("span", { innerHTML:this.fdApprove }, __p);
			
			
			var __p=domConstruct.create("p", { className:"infoDate mui mui-time"}, info);//评价日期
			domConstruct.create("span", { innerHTML:this.created }, __p);
			if(this.clientType)
				domConstruct.create("span", { innerHTML:"来自"+msg['mui.comefrom.'+this.clientType] }, __p);//来自XX客户端
			
			//下方反馈内容
			if(this.title){
				var content=domConstruct.create("div",{className:"content"},info);
				domConstruct.create("p",{innerHTML:this.title},content);
			}
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
			//new RtfResizeUtil({
			//	channel:this.fdId,
			//	containerNode:this.containerNode
			//});
		},
	
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		}
		
		
	});
	return item;
});