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
		baseClass:"muiCardItem muiListItem",

		//消息来源
		modelNameText:"",
		//创建时间
		created:"",
		//创建者
		creator:"",
		//创建人图像
		icon:"",
		//链接
		href:"",
		//当前节点
		lbpmCurrNodeValue:"",
		//调查结束
		docFinishedTimeValue:"",
		//摘要
		summary:"",
		//发布时间
		docPublishTime:"",
		//所属部门
		docDeptName:"",
		//摘要
		summary:"",
		//阅读数
		docReadCount:"",
		//标签
		tagNames:"",
		
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
				//用户头像
				var span = domConstruct.create("span",{className:"figureImgW"},head);
				domConstruct.create("img", { className: "muiProcessImg",src:this.icon}, span);
			}else{
				var span = domConstruct.create("span",{className:"figureImgW"},head);
				var imgBox = domConstruct.create("div",{className:"imgBox"},span);
				//自定义列表图标
				var listIcon = this.listIcon? this.listIcon : "mui-bookLogo";
				domConstruct.create("i", { className: "mui " + listIcon}, imgBox);
			}
			

			var subject = domConstruct.create("span",{className:"title muiSubject",innerHTML:this.label},head);
			if(this.href){
				this.makeLinkNode(this.contentNode);
			}else{
				lock = domConstruct.toDom("<div class='icoLock'><i class='mui mui-todo_lock'></i></div>");
				domConstruct.place(lock, this.contentNode);
				//tip
				this.makeLockLinkTip(this.contentNode);
			}
			//subhead
			var subhead = domConstruct.create("p",{className:"muiCardSummary muiListSummary"},this.contentNode);
			//summary
			if(this.summary){
				domConstruct.create("div",{className:'summary muiListSummary',innerHTML:this.summary},subhead);
			}
			var ul = domConstruct.create("ul",{className:"muiCardIcoList"},subhead);
			if(this.creator){
				var li = domConstruct.toDom("<li><i class='mui mui-todo_person'></i>" + this.creator + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.docDeptName){
				var li = domConstruct.toDom("<li><i class='mui mui-depart'></i>" + this.docDeptName + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.created){
				var li = domConstruct.toDom("<li><i class='mui mui-todo_date'></i>" + this.created + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.docPublishTime){
				var li = domConstruct.toDom("<li><i class='mui mui-todo_date'></i>" + this.docPublishTime + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.modelNameText){
				var li = domConstruct.toDom("<li><i class='mui mui-todo_module'></i>" + this.modelNameText + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.lbpmCurrNodeValue){
				var li = domConstruct.toDom("<li><i class='mui mui-todo_template'></i>" + this.lbpmCurrNodeValue + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.docReadCount){
				var li = domConstruct.toDom("<li><i class='mui mui-eyes'></i>" + this.docReadCount + "</li>");
				domConstruct.place(li, ul);
			}
			if(this.tagNames){
				var li = domConstruct.toDom("<li><i class='mui mui-label'></i>" + this.tagNames + "</li>");
				domConstruct.place(li, ul);
			}
			//自定义参数,后期改成无限参数形式
			if(this.arg0){
				var li = domConstruct.toDom(this.arg0);
				domConstruct.place(li, ul);
			}
			if(this.arg1){
				var li = domConstruct.toDom(this.arg1);
				domConstruct.place(li, ul);
			}
			if(this.arg2){
				var li = domConstruct.toDom(this.arg2);
				domConstruct.place(li, ul);
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