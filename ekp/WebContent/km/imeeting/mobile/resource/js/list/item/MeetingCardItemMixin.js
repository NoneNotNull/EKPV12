define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
   	"dojo/on",
   	"mui/dialog/Tip", 
   	"mui/list/item/_ListLinkItemMixin"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util,on,Tip, _ListLinkItemMixin) {
	var item = declare("mui.list.item.CardItemMixin", [ItemBase, _ListLinkItemMixin], {
		tag:"li",
		
		baseClass:"muiCardItem muiListItem muiMeetingCardItem",

		buildRendering:function(){
			this.domNode = domConstruct.create('li', {className : ''}, this.containerNode);
			this.inherited(arguments);
			this.buildInternalRender();
		},
		buildInternalRender : function() {
			var itemClass = this.href ? {}:{className:'lock'};
			this.contentNode = domConstruct.create('a', itemClass, this.domNode);
			
			var head = domConstruct.create("div",{className:"figure"},this.contentNode);
			//Personal picture
			if(this.icon){
				var span = domConstruct.create("span",{className:"figureImgW"},head);
				domConstruct.create("img", { className: "muiProcessImg",src:this.icon}, span);
			}else{
				var span = domConstruct.create("span",{className:"figureImgW"},head);
				var imgBox = domConstruct.create("div",{className:"imgBox"},span);
				domConstruct.create("i", { className: "mui mui-bookLogo"}, imgBox);
			}
			
			var subject = domConstruct.create("span",{className:"title muiSubject",innerHTML:this.label},head);
			if(this.href){
				this.makeLinkNode(this.contentNode);
			}else{
				//tip
				lock = domConstruct.toDom("<div class='icoLock'><i class='mui mui-todo_lock'></i></div>");
				domConstruct.place(lock, this.contentNode);
				this.makeLockLinkTip(this.contentNode);
			}
			var subhead = domConstruct.create("p",{className:"muiCardSummary muiListSummary"},this.contentNode);
			var ul = domConstruct.create("ul",{className:"muiCardIcoList"},subhead);
			if(this.created){
				var li = domConstruct.toDom("<li><i class='mui mui-meeting_date'></i>" + this.created + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.host){
				var li = domConstruct.toDom("<li><i class='mui mui-person'></i>" + this.host + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.place){
				var li = domConstruct.toDom("<li><i class='mui mui-meeting_path'></i>" + this.place + "</li>");
				domConstruct.place(li, ul);
			}
			
			//状态
			if(this.status){
				var __div = domConstruct.toDom(this.status);
				domConstruct.place(__div,this.contentNode);
			}else{
				domClass.add(head,'noStatusFigure')
			}
			
		},
		
		makeLockLinkTip:function(linkNode){
			this.href='javascript:void(0);';
			on(linkNode,'click',function(evt){
				Tip.tip({icon:'mui mui-warn', text:'暂不支持移动访问'});
			});
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