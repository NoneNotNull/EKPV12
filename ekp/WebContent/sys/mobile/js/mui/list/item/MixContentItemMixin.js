define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
	"dojo/dom-style",
	"dojo/dom-attr",
    "dojox/mobile/_ItemBase",
   	"mui/util",
	"./_ListLinkItemMixin"
	], function(declare, domConstruct,domClass , domStyle , domAttr , ItemBase , util , _ListLinkItemMixin) {
	var item = declare("mui.list.item.MixContentItemMixin", [ItemBase , _ListLinkItemMixin], {
		
		tag:"li",
		
		//简要信息
		summary:null,
		
		//创建时间
		created:null,
		
		//创建者
		creator:null,
		
		//状态信息
		status:null,
		
		thumbs:null,
		
		buildRendering:function(){
			this.domNode = this.containerNode = this.srcNodeRef
				       || domConstruct.create(this.tag, {className : 'muiMixContentItem'});
			this.inherited(arguments);
			if (!this.templateString){
				this.contentNode = domConstruct.create(
						'div', {className : 'muiListItem'}, this.domNode);
				this.buildInternalRender();
			}
		},

		startup:function(){
			if(this._started){ return; }
			this.inherited(arguments);
		},
	
		buildInternalRender : function() {
			if(this.lock){
				var _lock = domConstruct.toDom("<div class='icoLock'><i class='mui mui-todo_lock'></i></div>");
				domConstruct.place(_lock, this.contentNode);
			}
			var top = domConstruct.create("div",{className:"muiMixContentTop"},this.contentNode);
			this.buildTopRender(top);
			var center = domConstruct.create("a",{className:"muiMixContentMiddle"},this.contentNode);
			this.buildCenterRender(center);
			var bottom = domConstruct.create("div",{className:"muiMixContentBottom"},this.contentNode);
			this.buildBottomRender(bottom);
			if(this.href){
				this.makeLinkNode(center);
			}
		},
		
		buildTopRender:function(top){
			if(this.icon){
				var imgDivNode = domConstruct.create("div",{className:"muiMixContentIcon"}, top);
				this.imgNode = domConstruct.create("img", {src:this.icon }, imgDivNode);
			}
			var topCreate = domConstruct.create("div",{className:"muiMixContentCreate"},top);
			if(this.creator){
				this.CreatorNode=domConstruct.create("div",{className:"muiMixContentCreator",
					innerHTML:"<span>" + this.creator + "</span>"},topCreate);
			}
			if(this.created){
				this.CreatedNode=domConstruct.create("div",{className:"muiMixContentCreated muiListSummary",
					innerHTML:'<i class="mui mui-time"></i><span>' + this.created + "</span>"},topCreate);
			}
		},
		
		buildCenterRender:function(center){
			if(this.label){
				var title = this.label;
				if(this.status){
					title = this.status + title;
				}
				domConstruct.create("h4",{className:"muiMixContentTitle", innerHTML:title},center);
			}
			if(this.summary){
				domConstruct.create("p",{className:"muiMixContentSummary muiListSummary",innerHTML:this.summary},center);
			}
			var thum = domConstruct.create("p",{className:"muiMixThumb"},center);
			if(this.thumbs){
				var thumbDom = domConstruct.create("div",{className:"muiListThumb"},thum);
				var tmpThumbs = this.thumbs.split("|");
				for ( var i = 0; i < tmpThumbs.length; i++) {
					domConstruct.create('p', {
						style : 'background-image: url(' + tmpThumbs[i]
								+ ')'
					}, thumbDom);
				}
			}
		},
		
		buildBottomRender:function(bottom){
		},
		
		_setLabelAttr: function(text){
			if(text)
				this._set("label", text);
		},
		
		hrefTarget: '_self',
		
		_selClass: "mblListItemSelected",
		
		_setSelectedAttr: function(selected){
			this.inherited(arguments);
			domClass.toggle(this.domNode, this._selClass, selected);
		}
	});
	return item;
});