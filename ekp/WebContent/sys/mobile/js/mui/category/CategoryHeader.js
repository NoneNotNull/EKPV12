define( [ "dojo/_base/declare", "dijit/_WidgetBase" , "dojo/dom-construct" ,
          "dojo/dom-style" , "dojo/request" , "dojo/topic" , "mui/util"], function(declare,
		WidgetBase, domConstruct, domStyle, request, topic, util) {
		var header = declare("mui.category.CategoryHeader", [ WidgetBase], {
				//标示
				key : null,
				
				//父分类ID
				_parentId : null,
				
				//当前分类id,可不填写,无此属性,则不需和后台交互
				curId : null,
				
				//必填属性
				curName : null,
				
				height: "inherit",
				
				title: "请选择",
				
				baseClass:"muiCateHeader",
				
				//获取详细信息地址
				detailUrl : null,
				
				buildRendering : function() {
					this.inherited(arguments);
					this.contentNode = domConstruct.create('div',{"className":"muiCateHeaderContent"},this.domNode);
					this.returnDom = domConstruct.create('div',{"className":"muiCateHeaderReturn"},this.contentNode);
					this.titleDom = domConstruct.create('div',{"className":"muiCateHeaderTitle",innerHTML:this.curName},this.contentNode);
					this.cancelNode = domConstruct.create('div',{"className":"muiCateHeaderCancel",innerHTML:'取消'},this.contentNode);
				},

				postCreate : function() {
					this.inherited(arguments);
					this.subscribe("/mui/category/changed","_chgHeaderInfo");
					this.subscribe("/mui/search/submit","_hideHeader");
					this.subscribe("/mui/search/cancel","_showHeader");
					this.connect(this.returnDom,'click', function(){
						this.defer(function(){
							this._gotoParent();
						},350);
					});
					this.connect(this.cancelNode,'click', function(){
						this.defer(function(){
							this._goBack();
						},350);
					});
				},
				
				startup : function() {
					if (this._started) {
						return;
					}
					this.inherited(arguments);
					if (this.domNode.parentNode) {
						var h;
						if (this.height === "inherit") {
							if (this.domNode.parentNode) {
								h = this.domNode.parentNode.offsetHeight + "px";
							}
						} else if (this.height) {
							h = this.height;
						}
						domStyle.set(this.domNode,{'height':h,'line-height':h});
					}
					this._chgHeaderInfo(this,{fdId:this.curId});
					topic.publish("/mui/category/changed",this,{fdId:this.curId});
				},
				
				_showHeader : function(srcObj){
					if(srcObj.key == this.key){
						domStyle.set(this.domNode,{display:'block'});
					}
				},
				
				_hideHeader : function(srcObj){
					if(srcObj.key==this.key){
						domStyle.set(this.domNode,{display:'none'});
					}
				},
				
				_refreshHeader : function(){
					this._buildReturn();
					this.titleDom.innerHTML = this.curName;
				},
				
				_buildReturn : function(){
					if(this.curId){
						if(!this.returnIcon){
							this.returnIcon = domConstruct.create('i',{"className":"mui mui-back"},this.returnDom);
							this.returnText = domConstruct.create('span',{"className":"muiCateHeaderReturnTxt",innerHTML:' 上一级'},this.returnDom);
						}
					}else{
						domConstruct.empty(this.returnDom);
						this.returnIcon = null;
						this.returnText = null;
					}
				},
				
				_gotoParent : function(){
					var argu={};
					if(this._parentId){
						argu.fdId = this._parentId;
					}
					topic.publish("/mui/category/changed" , this , argu);
				},
				
				_goBack : function(){
					topic.publish("/mui/category/cancel" , this);
				},
				
				_chgHeaderInfo : function(srcObj,evt){
					if(srcObj.key==this.key){
						if(evt){
							if(evt.fdId && this.titleDom){
								this.curId = evt.fdId;
								var _url = util.urlResolver(this.detailUrl,this);
								_url = util.formatUrl(_url);
								var promise = request.post(_url, {
									handleAs : 'json'
								});
								var _self = this;
								promise.then(function(items) {
									if(items.length>0){
										var cateData = items[0];
										_self.curId = cateData.fdId;
										_self.curName = cateData.label;
										_self._parentId = cateData.parentId;
										_self._refreshHeader();
									}else{
										//错误处理
									}
								}, function(data) {
									//错误处理
								});
							}else{
								this.curId = null;
								this.curName = this.title;
								this._parentId = null;
								this._refreshHeader();
							}
						}
					}
				}
			});
			return header;
});