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
	var item = declare("mui.list.item.ComplexRItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		//简要信息
		summary:"",
		//创建时间
		created:"",
		//创建者
		creator:"",
		// 状态
		status:"",
		
		buildRendering:function(){
			this._templated = !!this.templateString;
			if (!this._templated) {
				this.domNode = this.containerNode = this.srcNodeRef
						|| domConstruct.create(this.tag, {
									className : 'muiComplexrItem'
								});
				this.contentNode = domConstruct.create(
										'div', {
											className : 'muiListItem'
										}, this.domNode);
			}
			this.inherited(arguments);
			if (!this._templated)
				this.buildInternalRender();
		},
		buildInternalRender : function() {
			var top = domConstruct.create("a",{className:"muiComplexrTop"},this.contentNode);
			var bottom = domConstruct.create("div",{className:"muiComplexrBottom muiListInfo"},this.contentNode);
			if(this.icon){
				var imgDivNode = domConstruct.create("div",{className:"muiComplexrIcon"},top);
				this.imgNode = domConstruct.create("img", { className: "muiComplexrImg",src:this.icon}, imgDivNode);
			}
			if(this.label){
				this.labelNode = domConstruct.create("h4",{className:"muiComplexrTitle muiSubject",innerHTML:this.label},top);
			}
			if(this.summary){
				this.summaryNode = domConstruct.create("p",{className:"muiComplexrSummary muiListSummary",innerHTML:this.summary},top);
			}
			if(this.href){
				this.makeLinkNode(top);
			}
			if(this.creator){
				this.createdNode = domConstruct.create("div",{className:"muiComplexrCreator muiAuthor",innerHTML:this.creator},bottom);
			}
			if(this.created){
				this.createdNode = domConstruct.create("div",{className:"muiComplexrCreated",
					innerHTML:'<i class="mui mui-todo_date"></i>' + this.created},bottom);
			}
			if(this.count){
				this.countNode = domConstruct.create("div",{className:"mui mui-eyes mui-2x muiComplexrRead",innerHTML: "&nbsp;<span class='muiNumber'>"+(this.count?this.count:0)+'</span>'},bottom);
			}
			this.statusNode = domConstruct.create("div",{className:'muiComplexrStatus'},bottom);
			if(this.status){
				this.statusNode.innerHTML = this.status;
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