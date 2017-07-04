define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/_base/array",
				"dojox/mobile/ScrollableView", "dojo/dom", "dojo/dom-construct",
				"dojo/dom-style", "dojo/dom-class", "dojo/request", "dojo/topic", 
				"mui/util",  "mui/dialog/Tip" , "mui/iconUtils" ],
		function(declare, WidgetBase,array, ScrollableView,dom, domConstruct, domStyle, domClass,
				request, topic, util, Tip, iconUtils) {
			var selection = declare("mui.category.CategorySelection",[ WidgetBase ],{
				//非必填项,用于初始值
				curIds : null,
				
				curNames : null,
				
				//获取详细信息地址
				detailUrl : '',
				
				baseClass : 'muiCateSec',
				
				//已选列表id, name, icon
				cateSelArr : [],
				
				itemPrefix : '_CateSecItem_',
				
				//对外事件唯一标示
				key : null,

				buildRendering : function() {
					this.inherited(arguments);
					this.cateSelArr = [];
					this.containerNode = domConstruct.create("div" ,{'className':'muiCateSecContainer'},this.domNode);
					this.leftArea = domConstruct.create("div",{'className':'muiCateSecLeft'},this.containerNode);
					this.view = new ScrollableView({scrollBar:false,threshold:100,scrollDir:"h",dirLock:true});
					this.leftArea.appendChild(this.view.domNode);
					
					this.rightArea = domConstruct.create("div",{'className':'muiCateSecRight'},this.containerNode);
					this.buttonNode =  domConstruct.create("span",{'className':'muiCateSecBtn muiCateSecBtnDis','innerHTML':'确定'},this.rightArea);
				},

				postCreate : function() {
					this.inherited(arguments);
					this.subscribe("/mui/category/selected","_addSelItme");
					this.subscribe("/mui/category/unselected","_delSelItem");
				},

				startup : function() {
					if (this._started) {
						return;
					}
					this.inherited(arguments);
					this.view.startup();
					this._initSelection();
				},
				
				destroy:function(){
					this.inherited(arguments);
					if(this.view.destroy){
						this.view.destroy();
						delete this.view;
					}
				},
				
				_subSelItem:function(){
					if(this.cateSelArr.length>0){
						topic.publish("/mui/category/submit" , this, this._calcCurSel());
					}else{
						Tip.tip({icon:'mui mui-warn', text:"请至少选择一项"});
					}
				},
				
				_initSelection:function(){
					if(this.curIds){
						var _url = util.urlResolver(this.detailUrl,this);
						_url = util.formatUrl(_url);
						var promise = request.post(_url, {
							handleAs : 'json'
						});
						var _self = this;
						promise.then(function(items) {
							if(items.length>0){
								array.forEach(items,function(item){
									_self._addSelItme(_self,item);
								});
							}else{
								//错误处理
							}
						}, function(data) {
							//错误处理
						});
					}
				},
				
				_buildSelItem:function(item){
					var selDom = domConstruct.create("div",{'id': this.itemPrefix + item.fdId , 'className':'muiCateSecItem'});
					var iconArea = domConstruct.create("div",{'className':'muiCateSecItemIcon'},selDom);
					var iconNode = domConstruct.create("div",{'className':'muiCateIcon'},iconArea);
					this.buildIcon(iconNode, item);
					domConstruct.create("div",{'className':'muiCateSecItemLabel','innerHTML':item.label},selDom);
					this.connect(selDom,'click',function(evt){
						this._delSelItem(this,item);
						topic.publish("/mui/category/cancelSelected",this,item);
					});
					return selDom;
				},
				
				buildIcon:function(iconNode,item){
					if(item.icon){
						iconUtils.setIcon(item.icon, null, null, null, iconNode);
					}
				},
				
				_addSelItme:function(srcObj,evt){
					if(srcObj.key==this.key){
						if(evt){
							this.cateSelArr.push(evt);
							var selItem = this._buildSelItem(evt);
							if(!this.itemContainer){
								this.itemContainer = domConstruct.create("div",{'className':'muiCateSecItems'},this.view.containerNode);
							}
							this.itemContainer.appendChild(selItem);
						}
						this._resizeSelection();
					}
				},
				
				_delSelItem:function(srcObj,evt){
					if(srcObj.key==this.key){
						if(evt && evt.fdId){
							for ( var i=0;i< this.cateSelArr.length; i++) {
								if(this.cateSelArr[i].fdId==evt.fdId){
									this.cateSelArr.splice(i,1);
									domConstruct.destroy(dom.byId(this.itemPrefix + evt.fdId));
									break;
								}
							}
							this._resizeSelection();
						}
					}
				},
				
				_resizeSelection:function(){
					var xPos = 0;
					if(this.itemContainer){
						var childCount = this.cateSelArr.length;
						if(childCount > 0){
							var oneW = this.itemContainer.children[0].offsetWidth;
							var conW = this.view.domNode.offsetWidth;
							if(oneW * childCount > conW){
								domStyle.set(this.itemContainer,{'width':(oneW * childCount + 10 ) + 'px'});
								xPos = -(oneW * childCount - conW + 10);
							}
							this.buttonNode.innerHTML = '确定('+childCount+')';
							this.buttonNode.className = "muiCateSecBtn";
							if(this.subHandle==null)
								this.subHandle = this.connect(this.buttonNode,'click','_subSelItem');
						}else{
							domStyle.set(this.itemContainer,{'width':'100%'});
							this.buttonNode.innerHTML = '确定';
							this.buttonNode.className = "muiCateSecBtn muiCateSecBtnDis";
							if(this.subHandle){
								this.disconnect(this.subHandle);
								this.subHandle = null;
							}
						}
					}
					if(this.view.resize){
						this.view.resize();
					}
					if(this.view.scrollTo){
						this.view.scrollTo({y:0,x:xPos});
					}
					topic.publish("/mui/category/selChanged" ,this, this._calcCurSel());
				},
				
				_calcCurSel:function(){
					var eCxt = {
						curIds:null,
						curNames:null,
						key: this.key
					};
					if(this.cateSelArr.length>0){
						var ids = '';
						var names = '';
						array.forEach(this.cateSelArr,function(selItem){
							ids += ';' + selItem.fdId;
							names += ';' + selItem.label;
						});
						if(ids!=''){
							ids = ids.substring(1);
							names = names.substring(1);
							eCxt.curIds = ids;
							eCxt.curNames = names;
						}
					}
					return eCxt;
				}
			});
			return selection;
		});