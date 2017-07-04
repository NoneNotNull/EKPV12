define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"./_ListLinkItemMixin"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util, _ListLinkItemMixin) {
	var item = declare("mui.list.item.ProcessItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiProcessItem",
		
		//流程简要信息
		summary:"",
		
		//创建时间
		created:"",
		
		//创建者
		creator:"",
		
		//创建人图像
		icon:"",
		
		//状态
		status:"",
		
		buildRendering:function(){
			this.inherited(arguments);
			this.contentNode = domConstruct.create(
					this.tag, {
						className : 'muiListItem'
					}, this.containerNode);
			this.buildInternalRender();
		},
		buildInternalRender : function() {
			var rightArea = domConstruct.create("div",{className:"muiProcessRight"},this.contentNode);
			domConstruct.create("img", { className: "muiProcessImg",src:this.icon}, rightArea);
			domConstruct.create("a", { className: "muiProcessCreator muiAuthor",innerHTML:this.creator}, rightArea);
			domConstruct.create("span", { className: "muiProcessCreated muiListSummary", 
				innerHTML:this.created}, rightArea);
			
			var leftArea = domConstruct.create("a",{className:"muiProcessLeft"},this.contentNode);
			var title = domConstruct.create("h3",{className:"muiProcessTitle muiSubject"},leftArea);
			if(this.status){
				title.appendChild(domConstruct.toDom(this.status));
			}
			if(this.label){
				title.appendChild(domConstruct.toDom(this.label));
			}
			if(this.summary){
				var summary = domConstruct.create("p",{className:"muiProcessSummary muiListSummary",innerHTML:this.summary},leftArea);
				domConstruct.create("i",{className:"muiProcessSign mui mui-flowlist"},summary,"first");
			}
			if(this.href){
				this.makeLinkNode(leftArea);
			}
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