define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "mui/util",
    "dojo/html",
    "dojo/touch",
    "dojo/query",
    "dijit/_WidgetBase",
    "mui/rtf/RtfResize",
    "mui/iconUtils",
    "mui/dialog/OperaTip",
    "dojo/dom-class",
    "sys/praise/mobile/import/js/_PraiseInformationMixin"
	], function(declare, domConstruct, util, html, touch, query, WidgetBase, RtfResize, iconUtils, OperaTip, domClass, _PraiseInformationMixin) {
	var item = declare("km.forum.mobile.resource.js.ForumPostItemMixin", [WidgetBase, _PraiseInformationMixin], {
		
		fdId : null,
		
		rowIndex: null ,
		
		tmplURL : null,
		
		//发帖人图像
		icon:null,
		
		//发帖、回复人
		creator:null,
		
		//创建时间
		created:null,
		
		//楼层
		floor:null,
		
		//积分等级
		score:null,
		
		//说明信息，如：楼主
		extendInfo:null,
		
		//来自信息
		from:'',
		
		//是否可以评论
		optFlag:null,
		
		//帖子内容
		content:null,
		
		//引用帖id
		parentId:null,
		
		//引用帖起草人
		parentPoster:null,
		
		//引用贴创建时间
		parentCreated:null,
		
		//引用帖信息
		parentSummary:null,
		
		baseClass:'muiForumPostItem',
		
		buildRendering : function() {
			this.inherited(arguments);
			this.contentNode = domConstruct.create("div",{className:'muiForumPostContent'},this.domNode);
			this.buildItem();
		},
		
		buildItem:function(){
			var contentArea =  domConstruct.create("div",{className:'muiPostContentArea'},this.contentNode);
			this.contentTop =  domConstruct.create("div",{className:'muiPostContentT'},contentArea);
			this.buildTop();
			this.contentMiddle =  domConstruct.create("div",{className:'muiPostContentC'},contentArea);
			this.buildMiddle();
			if(this.optFlag){
				this.contentBottom =  domConstruct.create("div",{className:'muiPostContentB'},contentArea);
				this.buildBootom();
			}
		},
		
		buildTop:function(){
			var head = domConstruct.create("div",{className:'muiPostHead'},this.contentTop);
			var iconNode = domConstruct.create("div",{className:'muiPostIcon'},head);
			if(this.icon)
				iconUtils.setIcon(this.icon, null, this._posterIcon, null, iconNode);
			
			var createDiv = domConstruct.create("div", {className:'muiPostCreate'}, head);
			var tmpHtml = '';  
			if(this.creator){
				tmpHtml = tmpHtml + this.creator;
			}
			if(this.score){
				tmpHtml = tmpHtml + '<span class="muiPostFloor muiPostFloorLevel">' + this.score + '</span>';
			}
			if(this.extendInfo){
				tmpHtml = tmpHtml + '<span class="muiPostFloor muiPostFloor1">' + this.extendInfo + '</span>';
			}
			if(tmpHtml!=''){
				domConstruct.create("div", {className:'muiPostCreator',innerHTML : tmpHtml}, createDiv);
			}
			
			tmpHtml = '';
			if(this.created){
				tmpHtml = tmpHtml + '<i class="mui mui-time"></i><span>' + this.created +'</span>';
			}
			if(this.from){
				tmpHtml = tmpHtml + '<span>' + this.from + '</span>';
			}
			if(tmpHtml!='')
				domConstruct.create("div", {className:'muiPostCreated',innerHTML:tmpHtml}, createDiv);
			
			if(this.floor && this.floor!=null){
				tmpHtml='';
				var florInt = parseInt(this.floor, 10);
				switch (florInt) {
				case 1:
					break;
				case 2:
					tmpHtml='<span class="muiPostFloor muiPostFloor2">沙发</span>';
					break;
				case 3:
					tmpHtml='<span class="muiPostFloor muiPostFloor3">板凳</span>';
					break;
				case 4:
					tmpHtml='<span class="muiPostFloor muiPostFloor4">地板</span>';
					break;
				default:
					tmpHtml='<span class="muiPostFloorX">'+(florInt-1)+'&nbsp;楼</span>';
					break;
				}
				if(tmpHtml!='')
					domConstruct.create("div", {className:'muiPostFloorInfo',innerHTML:tmpHtml}, head);
			}
		},

		buildMiddle:function(){
			if(this.parentId){
				var parentDiv = domConstruct.create("div", {className:'muiPostParent'}, this.contentMiddle);
				domConstruct.create("div", {className:'muiPostParentV'}, parentDiv);
				var parentInfo = domConstruct.create("div", {className:'muiPostParentC'}, parentDiv);
				var tmpHtml = '';
				if(this.parentPoster)
					tmpHtml = tmpHtml + '<span>'+ this.parentPoster +'</span>';
				if(this.parentCreated)
					tmpHtml = tmpHtml + '<span>发表于</span><span>'+ this.parentCreated +'</span>';
				if(tmpHtml!='')
					domConstruct.create("div", {className:'muiPostParentReplay', innerHTML:tmpHtml}, parentInfo);
				if(this.parentSummary){
					tmpHtml = '<span class="muiPostQuoteL"><i class="mui mui-quoteL"></i></span>';
					tmpHtml = tmpHtml + this.parentSummary +'<span class="muiPostQuoteR"><i class="mui mui-quoteR"></i></span>';
					if(tmpHtml!='')
						domConstruct.create("div", {className:'muiPostParentContent', innerHTML:tmpHtml}, parentInfo);
				}
			}
			if(this.content){
				domConstruct.create("div", {className:'muiFieldRtf',
					id:'__RTF_' + this.fdId + '_docContent',innerHTML:this.content}, this.contentMiddle);
			}
			if(this.tmplURL){
				this.attachmentDiv = domConstruct.create("div", {className:'muiPostAttchment'}, this.contentMiddle);
			}
		},
	
		buildBootom:function(){
			var optDiv = domConstruct.create("div", {className:'muiPostContentOpt'}, this.contentBottom);
			var optExpand = domConstruct.create("div", {className:'muiTopicReplyOperation',
				innerHTML:'<span class="l"></span><span class="f"></span><i class="mui mui-more"></i>'}, optDiv);
			var self = this;
			this.connect(optExpand, touch.press, function(){
				this.defer(function(){
					this.expandFun(optExpand);
				},350);
			});
		},
		
		expandFun:function(optExpand){
			if(!this.dialog || this.dialog.domNode==null){
				var self = this;
				this.modelId = this.fdId;
				this.modelName = "com.landray.kmss.km.forum.model.KmForumPost";
				this.dialog = OperaTip.tip({refNode:optExpand, 
					operas:[
				      {'icon':'muiForumPraiseSign mui-praise','text':'赞','func':function(evt){self.parisePost(evt);}},
				      {'icon':'mui-msg','text':'回复','func':function(){self.replayPost();}}
					]});
				this.defer(function(){
					if(this.hasPraised){
						this.hasPraised();
					}
				},220);
			}
		},
		
		postCreate : function() {
			this.inherited(arguments);
		},
		
		startup:function(){
			this.inherited(arguments);
			if(this.tmplURL){
				var _self = this;
				require(["dojo/text!" + util.formatUrl(util.urlResolver(this.tmplURL , this))], function(tmplStr){
					domConstruct.empty(_self.attachmentDiv);
					var dhs = new html._ContentSetter({
						node:_self.attachmentDiv,
						parseContent : true,
						cleanContent : true
					});
					dhs.set(tmplStr);
					dhs.parseDeferred.then(function(results) {
						_self.parseResults = results;
						_self.addtionOpt();
						
					});
					dhs.tearDown();
				});
			}
		},
		parisePost:function(evt){
			this.doPraised();
		},
		
		togglePraised:function(isInit){
			var icons = query(".muiDialogOperationTip .muiDialogOperationButton .muiForumPraiseSign");
			if(icons.length>0){
				var onClass='mui-scaleX mui-praise-on';
				var outClass='mui-scaleX mui-praise';
				if(this.isPraised){
					domClass.replace(icons[0], onClass, outClass);
				}else{
					domClass.replace(icons[0], outClass, onClass);
				}
				this.defer(function(){
					domClass.remove(icons[0],'mui-scaleX');
				},300)
			}
		},
		
		replayPost:function(evt){
			if(window.replayPost){
				if(this.rowIndex==0){
					window.replayPost();
				}else{
					window.replayPost(this);
				}
			}
		},
		
		addtionOpt : function(){
			var rtfName = "#__RTF_" + this.fdId + "_docContent";
			var rtfDom = query(rtfName,this.domNode);
			if(rtfDom.length>0){
				new RtfResize({containerNode:rtfDom[0]});
			}
		}		
	});
	return item;
});