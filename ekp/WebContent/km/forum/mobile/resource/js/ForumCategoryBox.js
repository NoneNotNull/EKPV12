define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dojo/dom-class",
    "dojo/request",
    "mui/util",
    "dijit/_WidgetBase"
	], function(declare, domConstruct, domClass, request, util, _WidgetBase) {
	var catebox = declare("km.forum.mobile.resource.js.ForumCategoryBox", [_WidgetBase], {
		//论坛板块id
		categoryId:null,
		
		categoryName:'',
		
		baseClass:"muiForumCategory",
		
		categoryUrl:'/km/forum/km_forum_cate/kmForumCategory.do?method=categoryDetail&categoryId=!{categoryId}',
		
		cateListDataUrl: null,
		
		buildRendering : function() {
			this.inherited(arguments);
			domConstruct.create("i", {'className':'mui mui-loading mui-spin'}, this.domNode);
		},
		postCreate : function() {
			this.inherited(arguments);
		},
		
		startup:function(){
			this.inherited(arguments);
			var _self = this;
			request.post(util.formatUrl(util.urlResolver(this.categoryUrl,this)), {
				handleAs : 'json'
			}).then(function(data) {
				_self.buildCateInfo(data);
			}, function(data) {
				_self.buildErrorInfo(data);
			});
		},
		
		buildCateInfo:function(data){
			this.buildBaseFrame();
			if(data['name'] && data['name']!=''){
				this.titleNode.innerHTML = data['name'];
			}
			if(data['description'] && data['description']!=''){
				domConstruct.create("div", {'className':'muiForumCateDesc',innerHTML:data['description']}, this.detailNode);
			}
			var topicCount = 0;
			if(data['topicCount']){
				topicCount = data['topicCount'];
			}
			var postCount = 0;
			if(data['postCount']){
				postCount = data['postCount'];
			}
			var countNode = domConstruct.create("div", {'className':'muiForumCateCount'}, this.detailNode);
			domConstruct.create("span", {'className':'muiForumCateNum',innerHTML:'发帖数<span>' + topicCount + '</span>'}, countNode);
			domConstruct.create("span", {'className':'muiForumCateNum',innerHTML:'回帖数<span>' + postCount + '</span>'}, countNode);
			if(data['parentId'] && data['parentId']!=null){
				var parentNode = domConstruct.create("div", {'className':'muiForumCateParent'}, this.contentNode);
				var tmpNode= domConstruct.create("div", {'className':'muiForumCateParentInfo',innerHTML:data['parentName']}, parentNode);
				var _self = this;
				this.connect(tmpNode,"click",function(){
					_self.gotoParent(data['parentId'], data['parentName']);
				});
			}
		},
		
		gotoParent:function(id, name){
			var url = "/km/forum/mobile/index.jsp";
			url = util.setUrlParameter(url,"moduleName",name);
			url = util.setUrlParameter(url,"filter","1");
			url = util.setUrlParameter(url,"queryStr",util.setUrlParameter(this.cateListDataUrl,"q.categoryId",id));
			location = util.formatUrl(url);
		},
		
		buildErrorInfo:function(data){
			this.buildBaseFrame();
			domConstruct.create("div", {'className':'muiForumCateDesc',innerHTML:'<span>板块信息获取错误。</span>'}, this.detailNode);
		},
		
		buildBaseFrame:function(){
			domConstruct.empty(this.domNode);
			this.contentNode = domConstruct.create("div", {'className':'muiForumCateInfo'}, this.domNode);
			this.iconNode = domConstruct.create("div", {'className':'muiForumCateIcon'}, this.contentNode);
			var icon = domConstruct.create("span", {'className':'muiForumCateImg'}, this.iconNode);
			domConstruct.create("i", {'className':'mui mui-evaluation'}, icon);
			this.detailNode = domConstruct.create("div", {'className':'muiForumCateContent'}, this.contentNode);
			this.titleNode = domConstruct.create("div", {'className':'muiForumCateTitle',innerHTML:this.categoryName}, this.detailNode);
		}
	});
	return catebox;
});