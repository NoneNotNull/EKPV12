define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
    "dojo/touch",
    "dijit/_WidgetBase",
    "mui/util"
	], function(declare, domConstruct, domClass, touch, WidgetBase, util) {
	var item = declare("km.forum.mobile.resource.js.ForumTopicHead", [WidgetBase], {
		created:'',
		
		//阅读数
		count:0,
		
		//回复数
		replyCount:0,
		
		//标题
		label:null,
		
		//所属板块
		cateName:null,
		
		cateId:null,
		
		//置顶
		top:false,
		
		//火
		hot:false,
		
		//精华
		pinked:false,
		
		//结贴
		closed:false,
		
		baseClass:'muiTopicHead',
		
		buildRendering : function() {
			this.inherited(arguments);
			this.contendNode = domConstruct.create('div',{className:'muiTopicContent'},this.domNode);
			this.buildInternalRender();
		},
		
		postCreate : function() {
			this.inherited(arguments);
			this.subscribe("/km/forum/replaySuccess",'changeReplayCount');
		},
		
		startup:function(){
			this.inherited(arguments);
		},
		
		buildInternalRender:function(){
			this.topNode = domConstruct.create('div',{className:'muiTopicHeadT'},this.contendNode);
			if(this.label){
				
				var headTitle=domConstruct.create('span',{className:'muiTopicHeadTitle'},this.topNode);
				
				if(this.top){
					domConstruct.create('span',{className:'muiTopicHeadSign muiTopicHeadTop',innerHTML:"顶"},headTitle);
				}
				if(this.hot){
					domConstruct.create('i',{className:'mui-hotPost mui'},headTitle);
				}
				if(this.pinked){
					domConstruct.create('span',{className:'muiTopicHeadSign muiTopicHeadPink',innerHTML:"精"},headTitle);
				}
				if(this.closed){
					domConstruct.create('i',{className:'mui mui-todo_lock'},headTitle);
				}
				domConstruct.create('span',{innerHTML:this.label},headTitle);
				
			}
			var tmpNode = domConstruct.create('div',{className:'muiTopicHeadB'},this.contendNode);
			this.bottomNode = domConstruct.create('div',{className:'muiTopicHeadSummary'},tmpNode);
			

			//版块名称
			if(this.cateName){
				var cate = domConstruct.create('div',{className:'muiTopicHeadCate',
					innerHTML:"<span>" + this.cateName+"&nbsp;<i class='mui mui-Cforward'></i></span>"},this.bottomNode);
				this.connect(cate,touch.press,'gotoCate');
			}
			
			//阅读数、回复数
			var numInfo = domConstruct.create('div',{className:'muiTopicHeadNumInfo'},this.bottomNode);
			//domConstruct.create('span',{className:'muiTopicHeadNum mui mui-meeting_date', 
			//	innerHTML:'<span>' + this.created + '</span>'},numInfo);
			var replaySpan = domConstruct.create('span',{className:'muiTopicHeadNum mui mui-msg'},numInfo);
			this.replayNode = domConstruct.create('span',{innerHTML: this.replyCount},replaySpan);
			domConstruct.create('span',{className:'muiTopicHeadNum mui mui-eyes', 
				innerHTML:'<span>' + this.count + '</span>'},numInfo);
			
			
		},
		changeReplayCount:function(){
			if(this.replayNode)
				this.replayNode.innerHTML = '<span>' + (this.replyCount + 1) + '</span>';
		},
		
		gotoCate:function(evt){
			var url = "/km/forum/mobile/index.jsp";
			var dataUrl = '/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.categoryId=!{cateId}&orderby=fdLastPostTime&ordertype=down';
			url = util.setUrlParameter(url,"moduleName",this.cateName);
			url = util.setUrlParameter(url,"filter","1");
			url = util.setUrlParameter(url,"queryStr",util.setUrlParameter(dataUrl,"q.categoryId",this.cateId));
			location = util.formatUrl(url);
		}
	});
	return item;
});