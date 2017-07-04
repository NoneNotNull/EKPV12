define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
    "mui/util",
    "mui/list/item/MixContentItemMixin"
	], function(declare, domConstruct, domClass, util, MixContentItemMixin) {
	var item = declare("km.forum.mobile.resource.js.ForumTopicItemMixin", [MixContentItemMixin], {
		//回复数
		replay:0,
		
		//阅读数
		count:0,
		
		//是否为置顶帖
		isTop:"0",
		
		//点赞数
		supportCount:0,
		
		buildInternalRender:function(){
			if(this.isTop=="1"){
				this.buildTopicItemRender();
			}else{
				this.inherited(arguments);
			}
		},
		
		//绘制置顶帖子
		buildTopicItemRender:function(){
			domClass.add(this.domNode,"muiMixContentTopItem");
			var topArea = domConstruct.create("div",{className:"muiMixContentTopInfo"},this.contentNode);
			domConstruct.create("span",{className:"muiTopicHeadSign muiTopicHeadTop",innerHTML: "置顶"},topArea);
			var cate = domConstruct.create("span",{className:"muiMixContentTopCate",innerHTML: '[' + this.category + ']'},topArea);
			this.connect(cate,'click','gotoCate');
			domConstruct.create("span",{className:"muiMixContentTopTitle", innerHTML:this.label},topArea);
		},
		
		gotoCate:function(evt){
			var url = "/km/forum/mobile/index.jsp";
			var dataUrl = '/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.categoryId=!{categoryId}&orderby=fdLastPostTime&ordertype=down';
			url = util.setUrlParameter(url,"moduleName",this.category);
			url = util.setUrlParameter(url,"filter","1");
			url = util.setUrlParameter(url,"queryStr",util.setUrlParameter(dataUrl,"q.categoryId",this.categoryId));
			location = util.formatUrl(url);
		},
		
		replayPost:function(evt){
			if(window.replayPost)
				window.replayPost(this);
		},
		
		buildBottomRender:function(bottom){
			if(this.supportCount)
				var parise = domConstruct.create("div",{className:"muiMixContentNum",
					innerHTML:"<i class='mui mui-praise'></i><span class='muiNumber'>"+(this.supportCount==0?'':this.supportCount)+'</span>'},bottom);
			//this.connect(parise,'click','parisePost');
			if(this.replay){
				var replayDiv = domConstruct.create("div",{className:"muiMixContentNum",
					innerHTML: "<i class='mui mui-msg'></i><span class='muiNumber'>"+(this.replay==0?'':this.replay)+'</span>'},bottom);
				//this.connect(replayDiv,'click','replayPost');
			}
			if(this.count){
				domConstruct.create("div",{className:"muiMixContentNum",
					innerHTML: "<i class='mui mui-eyes'></i><span class='muiNumber'>"+(this.count==0?'':this.count)+'</span>'},bottom,'last');
			}
		}
	});
	return item;
});