define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dojo/query",
    "dojo/request",
    "dijit/registry",
    "mui/util",
    "mui/device/device",
    "mui/tabbar/CreateButton",
    "mui/dialog/Tip",
    "km/forum/mobile/resource/js/ForumCategoryMixin",
    "mui/form/editor/EditorUtil",
    "dojo/text!km/forum/mobile/resource/js/layout.html"
	], function(declare, array, query, request, registry, util, device, CreateButton, tip, ForumCategoryMixin, EditorUtil, tmpl) {
	var create = declare("km.forum.mobile.resource.js.ForumTopicCreate", [CreateButton, ForumCategoryMixin], {
		modelName:'com.landray.kmss.km.forum.model.KmForumCategory',
		
		cateId:null,
		
		_createCateId:null,
		
		saveUrl:'/km/forum/mobile/kmForumPost.do?method=save',
		
		categoryDetailUrl:'/km/forum/km_forum_cate/kmForumCategory.do?method=categoryDetail&categoryId=!{cateId}&base=1',
		
		startup:function(){
			this.inherited(arguments);
			if(this.cateId){
				var _self = this;
				request.post(util.formatUrl(util.urlResolver(this.categoryDetailUrl,this)), {
					handleAs : 'json'
				}).then(function(data) {
					if(data['parentId']==null || data['parentId']==''){
						_self._createCateId = null;
					}else{
						_self._createCateId = _self.cateId;
					}
				}, function(data) {
					_self._createCateId = null;
				});
			}
		},
		
		_onClick:function(evt){
			if(this._createCateId!=null && this._createCateId!=''){
				this.curIds = this._createCateId;
				this.newTopic();
			}else{
				this.inherited(arguments);
			}
		},
		
		afterSelectCate: function(evt){
			this.newTopic();
		},
		
		newTopic:function(){
			var _self = this;
			var forumValidates = [];
			if(window.validateCreateTopic){
				forumValidates.push(window.validateCreateTopic);
			}
			EditorUtil.popup(this.saveUrl,{
				name:"docContent",
				subject:"docSubject",
				layout:tmpl,
				placeholder:'发帖',
				validates:forumValidates,
				data:{
					fdIsAnonymous:"false",
					fdPdaType:device.getClientType(),
					fdForumId:this.curIds,
					isNormal:"1"
				}},function(data){
					if (data.status == 200) {
						tip.success({
							text : '操作成功'
						});
						
					} else{
						tip.fail({
							text : '操作失败'
						});
					}
					if(window.refreshList){
						window.refreshList();
					}
				});
		}
	});
	return create;
});