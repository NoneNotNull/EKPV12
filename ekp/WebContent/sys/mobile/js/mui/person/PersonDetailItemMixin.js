define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"mui/i18n/i18n",
   	"mui/list/item/_ListLinkItemMixin",
	"dojo/date/locale"   	
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util,i18n, _ListLinkItemMixin,locale) {
	
	var item = declare("mui.person.PersonDetailItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiListItem muiPerson",
		
		href:'javascript:void(0)',
		
		buildRendering:function(){
			this.inherited(arguments);
			
			this.domNode = this.containerNode= this.srcNodeRef
				|| domConstruct.create(this.tag,{className:this.baseClass});
			
			//左侧头像
			var leftBar=domConstruct.create("div",{className:"muiPersonIcon"},this.containerNode);
			domConstruct.create("img", { className: "muiPersonIconImg",src:this.src}, leftBar);
			
			//右侧内容
			var rightContent=domConstruct.create("div",{className:"muiPersonInfo"},this.containerNode);
			domConstruct.create("div", { className: "muiPersonName",innerHTML:this.name}, rightContent);
		},
		
		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
		},
	
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		}
	});
	return item;
});