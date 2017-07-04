define( [ 'dojo/_base/declare', 'dojo/_base/lang', 'dojo/topic',
		'dojo/_base/array', "dojo/query", 'dojox/mobile/View', 'dojo/request',"dojo/request/script",
		"mui/util", 'dojox/mobile/viewRegistry', 'dojo/dom-construct',
		"dojo/dom-style", "dojo/dom-class", 'dojo/dom-attr','dojo/touch',
		'dojox/mobile/Tooltip' ], function(declare, lang, topic, array,
		query, View, request, script, util, viewRegistry, domConstruct, domStyle,
		domClass, domAttr,touch, Tooltip) {

	return declare('sys.zone.mobile.js.NavSwapView', [ View ],
			{
		
				currentServerKey : "",
		
				refNavBar : null,

				userId : "",

				criHandle : null,
				
				criSelectedClass : "selected",
				
				postCreate : function() {
					this.inherited(arguments);
					this
							.subscribe('/mui/nav/onComplete',
									'handleNavOnComplete');
					this.subscribe('/mui/navitem/_selected',
							'handleNavOnSelected');
					
					this.subscribe("/sys/zone/loadCri", 'changeCriInfo');
					this.subscribe("/sys/zone/criChanged", 'changeCri');
					
					this.subscribe("/mui/list/adjustDestination", lang.hitch(this,
							this.hideOpener));
					this.subscribe('/mui/list/loaded', "_wirteNum");
					
					this.subscribe("/mui/list/pushDomHide" , "onPushDomHide");
				},

				handleNavOnComplete : function(widget, items) {
					this.refNavBar = widget;
					//this.generateSwapList(widget.getChildren());
					this.refNavBar.getChildren()[0].setSelected();
				},

				handleNavOnSelected : function(obj, evt) {
					//首页处理
					if(obj.id=="home") {
						this._handleHomeView(obj, evt);
					} else {
						this._handleListView(obj, evt);
					}
				},
				
				_criShowHide : function(showString) {
					query(".mui_zone_cri").forEach(
							function(_item) {
								domStyle.set(_item, "display", showString);
							});
				},
				
				//处理首页
				_handleHomeView : function(obj, evt) {
					this._criShowHide("none");
					this._toTop();
					if(!this.baseInfoView)
						this.baseInfoView = this.getChildren()[0];
					if(this.list) {
						this.list.isLoadMore = false;
						domStyle.set(this.list.domNode, "display" , "none");
					}
					this.baseInfoView.show();
					topic.publish("/mui/list/pushDomHide", this);
				},
				//处理list
				_handleListView : function(obj, evt) {
					var self = this;
					if (!this.criHandle) {
						//this.criBtnDom = query(".mui_zone_cri_btn")[0];
						this.criHandle = this.connect(document.body, "click",
								this._criBtnonclick);
					}
					this._toTop();
					if (!obj.criInfo) {
						if(this.currentServerKey != 'null' && this.currentServerKey != obj.key) {
							script.get(util.formatUrl(obj.serverPath + evt.url),{
										jsonp : "jsonpcallback",
										timeout : 5000
									}).then(
									function(response) {
										obj.criInfo = response;
										obj.criInfo.key = obj.key;
										obj.criInfo.serverPath = obj.serverPath;
										self._initList(obj.criInfo, obj.key, obj.serverPath);
									},function(err) {
									});
						} else {
							request.get(util.formatUrl(evt.url), {
								handleAs : "json"
							}).then( function(response) {
								obj.criInfo = response;
								self._initList(obj.criInfo);
							}, function(err) {
							});
						}
					} else {
						self._initList(obj.criInfo);
					}
				},
				//选中某个标签，初始化筛选项和列表
				_initList : function(arr, key, serverPath) {
					if (!this.list) {
						this.list = this.getChildren()[1];
					}
					if(this.baseInfoView)
						this.baseInfoView.hide();
					domStyle.set(this.list.domNode, "display" , "");
					this.list.isLoadMore = true;
					this._criShowHide("");
					var criSelectIndex = 0;
					for ( var i = 0; i < arr.length; i++) {
						var item = arr[i];
						if (item.isDefault == true) {
							criSelectIndex = i;
							query(".mui_zone_selected_text").forEach(
									function(_item) {
										_item.innerText = util
												.formatText(item.text);
									});
							var url = util.urlResolver(item.url, {
								userId : this.userId
							});
							if(arr.key && this.currentServerKey != arr.key) {
								if("jsonp" != this.list.dataType) {
									this.list.store = null;
									this.list.dataType = "jsonp";
								}
								this.list.url = util.formatUrl(arr.serverPath + url);
							} else {
								if("json" != this.list.dataType) {
									this.list.store = null;
									this.list.dataType = "json";
								}
								this.list.url = util.formatUrl(url);
							}
							array.forEach(this.list.getChildren(), function(child){
								child.destroyRecursive();
							});
							topic.publish('/mui/list/pushDomShow',this);
							this.list.reload();
							break;
						}
					}
					topic.publish("/sys/zone/loadCri", this, {
						info : arr,
						criSelectIndex : criSelectIndex
					});
				},

				changeCriInfo : function(obj, evt) {
					if (!this.openerContainer) {
						this.openerContainer = new Tooltip();
						domConstruct.place(this.openerContainer.domNode,
								document.body, "last");
						domClass.add(this.openerContainer.domNode,
								'mui_zone_tip');
						var cover = this.openerContainer.containerNode;

						this.tabGroupContainer = domConstruct.create('div', {
							className : 'mui_zone_container'
						}, cover);
						
						this.connect(this.tabGroupContainer, "click", '_criClick');

					}
					if (evt.info) {
						this.criInfo = evt.info;
						var criSelectIndex = evt.criSelectIndex;
						var arr = this.criInfo;
						domConstruct.empty(this.tabGroupContainer);
						for ( var i = 0; i < this.criInfo.length; i++) {
							var _cri = domConstruct.create("span", {
								'className' : 'mui_zone_cri_item_text' 
										+ ((criSelectIndex === i) ? (" " + this.criSelectedClass) : ""),
								'innerHTML' : arr[i].text ? arr[i].text : "",
								'data-cri-index' : i
							});
							domConstruct.place(_cri, this.tabGroupContainer,
									"last");
						}
					}
				},
				
				// 筛选项点击事件
				_criClick : function(evt) {
					var target = evt.target;
					while (target && target != this.tabGroupContainer) {
						var index = domAttr.get(target, "data-cri-index");
						if (index >= 0) {
							this._toTop();
							topic.publish("/sys/zone/criChanged", this, {
								selectIndex : index
							});
							break;
						}
						target = target.parentNode;
					}
				},

				changeCri : function(obj, evt) {
					if (evt.selectIndex >= 0) {
						this._toTop();
						var cInfo = this.criInfo[evt.selectIndex];
						query(".mui_zone_selected_text").forEach(
								function(item, index, arr) {
									item.innerText = util
											.formatText(cInfo.text);
								});
						query(".knowledge_num").forEach(
								function(item, index, arr) {
									item.innerHTML = "";
								});
						var url = util.urlResolver(cInfo.url, {
							userId : this.userId
						});
						if(this.criInfo.key && this.criInfo.key != this.currentServerKey) {
							this.list.dataType = "jsonp";
							this.list.url = util.formatUrl(this.criInfo.serverPath + url);
						} else {
							this.list.dataType = "json";
							this.list.url = util.formatUrl(url);
						}
						array.forEach(this.list.getChildren(), function(child){
							child.destroyRecursive();
						});
						topic.publish('/mui/list/pushDomShow',this);
						this.list.reload();
						this.defer(function(){
							this.hideOpener();
						},100);
						
						this._criSelectedChange(evt.selectIndex);
					}

				},
				
				_criSelectedChange : function(index) {
					if(this.openerContainer) {
						domClass.remove(query("." + this.criSelectedClass, this.openerContainer.domNode)[0], 
								this.criSelectedClass);
						domClass.add(query("span[data-cri-index='" + index +"']")[0], this.criSelectedClass);
					}
				},
				
				_criBtnonclick : function(evt) {
					var target = evt.target;
					while (target) {
						if (domClass.contains(target, "mui_zone_cri_btn")) {
							var opener = this.openerContainer;
							if (!opener)
								return;
							if (opener.resize) {
								this.hideOpener(this);
							}
							else {
								opener.show(target, [ 'below' ]);
							}
							this.handle = this.connect(document.body, touch.press,
									'unClick');
							break;
						}
						target = target.parentNode;
					}
				},

				unClick : function(evt) {
					var target = evt.target, isHide = true;
					while (target) {
						if (domClass.contains(target,"mui_zone_cri_btn") || target == this.openerContainer.domNode) {
							isHide = false;
							break;
						}
						target = target.parentNode;
					}
					
					if (isHide)
						this.hideOpener();
					this.disconnect(this.handle);
				},

				hideOpener : function(srcObj) {
					if(this.openerContainer)
						this.openerContainer.hide();
				},

				//判断是否应该返回到顶端
				_toTop : function() {
					var scorllView = viewRegistry.getParentView(this);
					var headHight = query(".mui_zone_perinfo",
							scorllView.domNode)[0].offsetHeight;
					// + this.refNavBar.domNode.offsetHeight
					var position = scorllView.getPos();
					var y = position.y;
					if (-y > headHight) {
						topic.publish("/mui/list/toTop", this, {
							y : -headHight,
							time : 0
						});
					}
				},

				onSwapViewChanged : function(view) {
					this.inherited(arguments);
					if (this.refNavBar) {
						var index = array.indexOf(this.getChildren(), view);
						this.refNavBar.getChildren()[index].setSelected();
					}
				},
				
				_wirteNum: function(data) {
					if(data && data.totalSize >= 0) {
						query(".knowledge_num").forEach(
								function(item, index, arr) {
									item.innerHTML = "(" + data.totalSize + ")";
								});
					}
				},
				
				
				onPushDomHide : function(store) {
					if (array.some(this.getChildren(), function(child) {return child == store;})) {
						topic.publish("/mui/list/pushDomHide", this);
					}
				}
			});
});