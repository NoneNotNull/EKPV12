define(
		[ "dojo/_base/declare", "dijit/_Contained", "dijit/_Container",
				"dijit/_WidgetBase", "dojo/dom-class", "dojo/dom-construct",
				"dojo/dom-style", "dojo/topic", "dojo/query", "dojo/window",
				"mui/search/_SearchPrompt", "dojo/_base/lang", "mui/util", "mui/i18n/i18n!sys-mobile",
				],
		function(declare, Contained, Container, WidgetBase, domClass,
				domConstruct, domStyle, topic, query, win, SearchPrompt, lang, util, Msg) {

			return declare(
					"mui.search.SearchBar",
					[ WidgetBase, Container, Contained ],{
						
						//模块标识
						modelName : "",

						//搜索请求地址
						searchUrl : "/sys/ftsearch/mobile/index.jsp?keyword=!{keyword}&modelName=!{modelName}",
						
						//搜索结果直接挑转至searchURL界面
						jumpToSearchUrl:true,
						
						//搜索关键字
						keyword : "",
						
						//显示高度
						height : "inherit",
						
						//提示文字
						placeHolder : "搜索",

						//是否需要输入提醒
						needPrompt:true,
						
						buildRendering : function() {
							this.inherited(arguments);
							domClass
									.replace(this.containerNode, "muiSearchBar");
							var searchContainer = null;
							var nodelist = query(this.containerNode).parent(
									"form");
							if (nodelist.length == 0) {
								this._searchForm = domConstruct.create("form",
										{}, this.containerNode);
								searchContainer = domConstruct.create("div", {
									className : "muiSearchBarContainer"
								}, this._searchForm);
							} else {
								searchContainer = domConstruct.create("div", {
									className : "muiSearchBarContainer"
								}, this.containerNode);
								this._searchForm = nodelist[0];
							}
							var searchArea = domConstruct.create("div", {
								className : "muiSearchDiv"
							}, searchContainer);
							this._searchContainer = searchContainer;

							domConstruct.create("div", {
								className : "muiSearchIcon mui mui-search"
							}, searchArea);

							this.clearNode = domConstruct.create("div", {
								className : "muiSearchClear mui mui-fail"
							}, searchArea);

							this.searchNode = domConstruct.create("input", {
								className : "muiSearchInput",
								type : "search",
								value : this.keyword,
								placeHolder : (this.placeHolder?this.placeHolder:Msg['mui.search.search'])
							}, searchArea);

							this.buttonArea = domConstruct.create("div", {
								className : "muiSearchBtnDiv"
							}, searchContainer);

							this.cancelNode = domConstruct.create("div", {
								className : "muiSearchCancelBtn",
								innerHTML : Msg['mui.search.cancel']
							}, this.buttonArea);
							domStyle.set(this.buttonArea, {
								display : 'none'
							});
							if (this.keyword != '') {
								domStyle.set(this.clearNode, {
									display : 'inline-block'
								});
							}
						},
						
						postCreate : function() {
							this.inherited(arguments);
							this.connect(this._searchForm, "onsubmit",
									"_onSearch");
							this.connect(this.searchNode, "onfocus",
											"_onfocus");
							this.connect(this.searchNode, "onclick",
								"_onfocus");
							this.subscribe("/mui/searchbar/show", "_onfocus");
							this.connect(this.searchNode, "oninput",
									"_onChange");
							this.connect(this.clearNode, "onclick", "_onClear");
							this.connect(this.cancelNode, "onclick",
									"_onCancel");
							this.subscribe("/mui/search/keyword","_fillKeyword");
							this.subscribe("/mui/search/submit", "_onSubmit");
						},

						startup : function() {
							if (this._started)
								return;
							this.inherited(arguments);
							var h;
							if (this.height === "inherit") {
								if (this.domNode.parentNode) {
									h = this.domNode.parentNode.offsetHeight + "px";
								}
							} else if (this.height) {
								h = this.height;
							}
							if (h) {
								domStyle.set(this.domNode,{'height':h,'line-height':h});
								domStyle.set(this._searchForm,{'height':h,'line-height':h});
								var marginTop = domStyle.get(this._searchForm,"height")- domStyle.get(this._searchContainer,"height");
								marginTop = (marginTop/2);
								domStyle.set(this._searchContainer,{'margin-top':marginTop + 'px'});
							}
						},

						_fillKeyword : function(srcObj,ctx) {
							if (ctx) {
								var data = ctx;
								this.searchNode.value = data.keyword;
								this._onSearch();
							}
						},

						_onfocus : function(srcObj) {
							this._searchFocus = true;
							domStyle.set(this.buttonArea, {
								display : 'table-cell'
							});
							if (!this._prompt && this.needPrompt) {
								var promptNode = domConstruct.create("div", {
									className : "muiSearchPrompt"
								}, document.body);
								var topH = domStyle.get(this.containerNode,"height")+1;
								domStyle.set(promptNode, {
									top : topH + "px",
									height: (win.getBox().h -topH) + "px"
								});
								this._prompt = new SearchPrompt( {
									srcNodeRef : promptNode,
									prefix : this.modelName
								});
								this._prompt.startup();
							}
							if(this._prompt)
								this._prompt.show();
							var _self = this;
							var tmpEvt = this.connect(document.body, "touchend", function(evt){
								if(evt.target != _self.searchNode){
									setTimeout(function(){  
										_self.searchNode.blur(); 
									_self.disconnect(tmpEvt);
									},350);
								}
							});
							this._eventStop(srcObj);
						},

						_onChange : function(evt) {
							if (this.searchNode.value != '') {
								domStyle.set(this.clearNode, {
									display : 'inline-block'
								});
							} else {
								domStyle.set(this.clearNode, {
									display : 'none'
								});
							}
						},

						_onClear : function(evt) {
							this.searchNode.value = "";
							domStyle.set(this.clearNode, {
								display : 'none'
							});
						},

						_onCancel : function(evt) {
							this._onClear(evt);
							this.defer(function() {
								this._hidePrompt();
								topic.publish("/mui/search/cancel",this);
							}, 450);
						},

						_hidePrompt : function() {
							domStyle.set(this.buttonArea, {
								display : 'none'
							});
							if (this._prompt) {
								this._prompt.hide();
							}
						},

						_eventStop : function(evt) {
							if (evt) {
								if (evt.stopPropagation)
									evt.stopPropagation();
								if (evt.cancelBubble)
									evt.cancelBubble = true;
								if (evt.preventDefault)
									evt.preventDefault();
								if (evt.returnValue)
									evt.returnValue = false;
							}
						},

						_onSubmit : function(srcObj , ctx) {
							if(ctx && ctx.url && this.jumpToSearchUrl){
								this.searchNode.value = this.keyword;
								this._hidePrompt();
								location = ctx.url;
							}
						},

						_onSearch : function(evt) {
							this.searchNode.blur(); 
							this._eventStop(evt);
							if (this.searchNode.value != '') {
								var arguObj = lang.clone(this);
								arguObj.keyword = this.searchNode.value;
								var url =  util.formatUrl(util.urlResolver(
										this.searchUrl, arguObj));
								topic.publish("/mui/search/submit",this, {keyword: arguObj.keyword , url:url});
							}
							return false;
						}
					});
		});
