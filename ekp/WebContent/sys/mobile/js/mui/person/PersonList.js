/**人员列表(简单形式,只显示一排,多余的用省略号替代) **/
define([
    "dojo/_base/declare", 
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dojo/_base/array",
    "dojo/text!./person_list.html",
    "dojo/request",
    'dojo/query',
    'dojo/dom-geometry',
    'dojo/dom-construct',
    'dojo/dom-style',
    "dojox/mobile/TransitionEvent",
    'mui/util',
    'mui/person/PersonDetailMixin'
    ],function(declare,WidgetBase,_TemplatedMixin,array,template,request,query,domGeometry,domConstruct,domStyle,TransitionEvent,util,PersonDetailMixin){
	
	return declare("mui.person.PersonList", [WidgetBase,_TemplatedMixin,PersonDetailMixin], {
		
		personId:null,
		defaultUrl:'/sys/organization/mobile/address.do?method=personList',
		
		//简要列表属性
		title:'',
		url:'',
		templateString:template,
		
		total:0,
		
		buildRendering : function(){
			this.inherited(arguments);
			if(this.personId && !this.url){
				this.url=this.defaultUrl+'&personId='+this.personId;
			}
		},
		
		startup:function(){
			this._request({});
			this._bindEvent();
			if(!this.title) {
				domConstruct.destroy(this.personListTitleNode);
			}
		},
		
		//请求
		_request:function(queryData){
			var self=this;
			if(this.url){
				var _allWidth=query('.personList',this.domNode)[0].offsetWidth,
				_itemWidth=domGeometry.getMarginSize(query('.personMore',this.domNode)[0]).w;
				var count = parseInt(_allWidth/_itemWidth) - 1;
				queryData.count = count;
				queryData.rowsize = count;
				request
					.post(util.formatUrl(this.url), {handleAs : 'json',data : queryData})
					.response
					.then(function(datas) {
						if(datas.status=='200'){
							self._render(datas);
						}
				});
			}
		},
		
		//渲染
		_render:function(datas){
			var data=datas.data;
			var more = 0;
			if(data && data.list){
				this._buildingDom(data.list);
				if(data.total){
					this.total=data.total;
				}
				more=this.total-data.list.length;
			} else if(data && data.page) {
				this.total = data.page.totalSize;
				var dataList =  this.formatDatas(data.datas);
				this._buildingDom(dataList);
				more= this.total - dataList.length;
			}
			if(more> 0){
				query('.personMore',this.domNode)[0].style.display='';
			}else{
				query('.personMore',this.domNode)[0].style.display='none';
			}
			if(this.title) {
				query('.personTotal',this.domNode)[0].innerHTML=this.total;
			}
		},
		
		//生成人物头像节点
		_buildingDom:function(list){
			for(var i=0;i<list.length;i++){
				var staffCell=domConstruct.create('div',{className:'staffCell'},this.personListNode);
				domConstruct.create('img',{src:list[i].src},staffCell);
				domConstruct.create('span',{className:'name',innerHTML:list[i].name},staffCell);
			}
		},
		
		_bindEvent:function(){
			//更多按钮事件绑定
			if(this.personMoreNode)
				this.connect(this.personMoreNode, 'click','onMoreClick');
		},
		
		onMoreClick:function(){
			if(this.moveTo){//切换到指定view页面
				var opts = {
					transition : 'slide',
					moveTo:this.moveTo
				};
				new TransitionEvent(this.personMoreNode,  opts ).dispatch();
			}else if(this.href){//跳到自定义页面或者 javascript:
				location.href = util.formatUrl(this.href);
			}else if(this.detailUrl){//切换到默认人员详情页面
				this.openDeatailView();
			}
		},
		
		
		formatDatas : function(datas) {
			var dataed = [];
			for (var i = 0; i < datas.length; i++) {
				var datasi = datas[i];
				dataed[i] = {};
				for (var j = 0; j < datasi.length; j++) {
					dataed[i][datasi[j].col] = datasi[j].value;
				}
			}
			return dataed;
		}
		
	});
	
});