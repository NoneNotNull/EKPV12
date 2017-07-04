define( [ "dojo/_base/declare", "dojo/_base/array", "dijit/_WidgetBase",
		"dojo/json", "dojo/_base/lang", "dojo/topic", "dojo/dom-construct",
		"dojo/dom-style", "dojo/dom-class", "dojox/mobile/_css3", 
		"mui/util", "dojo/touch", "mui/i18n/i18n!sys-mobile"], function(declare, array, WidgetBase, JsonFun, lang,
		topic, domConstruct, domStyle, domClass, css3 , util , touch, Msg) {
	return declare("mui.search._SearchPrompt", [ WidgetBase], {

		_storageKey : '_muiSearchKeywords',

		_storageItem : [],
		
		prefix : '',
		
		langSetting:{
			noRecord : Msg['mui.search.norecord'],
			clearRecord : Msg['mui.search.clearrecord']
		},

		buildRendering : function() {
			this.domNode = this.containerNode = this.srcNodeRef
					|| domConstruct.create('div', {
						className : 'muiSearchPrompt'
					});
			this.inherited(arguments);
			this.histroyRecord = domConstruct.create("div", {
				className : "muiSearchRecord muiSearchNoRecord",
				innerHTML : this.langSetting.noRecord
			}, this.containerNode);
			this.operateArea = domConstruct.create("div", {
				className : "muiSearchOpt"
			}, this.containerNode);
			this.clearNode = domConstruct.create("div", {
				className : "muiSearchClearBtn",
				innerHTML : this.langSetting.clearRecord
			}, this.operateArea);
		},

		postCreate : function() {
			this.inherited(arguments);
			this.connect(this.clearNode, "onclick", "_clearRecord");
			this.subscribe("/mui/search/submit", "_addRecord");
		},

		startup : function() {
			if (this._started)
				return;
			this.inherited(arguments);
			util.disableTouch(this.domNode , touch.move );
		},
		
		show : function() {
			this._drawRecord();
			domStyle.set(this.containerNode, {
				display : 'block'
			});
			this.defer(function(){
			domStyle.set(this.containerNode,
					css3.name('transform'),
					'translate3d(0, 0, 0)');
			},10);
		},
		
		hide : function() {
			domStyle.set(this.containerNode,
					css3.name('transform'),
					'translate3d(100%, 0, 0)');
			this.defer(function() {
					domStyle.set(this.containerNode, {
						display : 'none'
					});
				}, 510);
		},
		_drawRecord : function(append) {
			if(!this._drawed){//第一次以及缓存变化时才会绘制
				if (!append) {
					domConstruct.empty(this.histroyRecord);
				}
				if (window.localStorage) {
					var storeKey = this.prefix + this._storageKey;
					var str = window.localStorage.getItem(storeKey);
					if (str && str != '') {
						this._storageItem = JsonFun.parse(str);
						if (this._storageItem.length > 0) {
							for ( var i = 0; i < this._storageItem.length; i++) {
								var rItem = domConstruct.create("div", {
									className : "muiSearchRecordItem",
									innerHTML : this._storageItem[i]
								}, this.histroyRecord);
								this.connect(rItem, "onclick", "_selectRecord");
							}
							domStyle.set(this.clearNode, {
								display : 'inline-block'
							});
							domClass.remove(this.histroyRecord,"muiSearchNoRecord");
						}
					}else{
						this.histroyRecord.innerHTML = this.langSetting.noRecord;
						domStyle.set(this.clearNode, {
							display : 'none'
						});
						domClass.add(this.histroyRecord,"muiSearchNoRecord");
					}
				}
				this._drawed = true;
			}
		},
		_addRecord : function(srcObj,ctx) {
			if (window.localStorage) {
				var keyword = ctx.keyword;
				var storeKey = this.prefix + this._storageKey;
				if (this._storageItem.length == 0) {
					this._storageItem.push(keyword);
				} else if (this._storageItem.length <= 10) {
					var idx = array.indexOf(this._storageItem, keyword);
					if (idx > -1) {
						this._storageItem.splice(idx, 1);
					}
					this._storageItem.unshift(keyword);
				}
				if (this._storageItem.length > 10) {
					this._storageItem = this._storageItem.slice(0, 10);
				}
				try {
					window.localStorage.setItem(storeKey, JsonFun
							.stringify(this._storageItem));
				} catch (e) {
					if(window.console)
						console.log(e.name);
				}
				this._drawed = false;
			}
		},
		_clearRecord : function(evt) {
			if (window.localStorage) {
				this._storageItem = [];
				var storeKey = this.prefix + this._storageKey;
				window.localStorage.removeItem(storeKey);
				this._drawed = false;
				this._drawRecord();
			}
		},
		_selectRecord : function(evt) {
			var target = evt.target || evt.srcElement;
			topic.publish("/mui/search/keyword", this, {
				keyword : target.innerHTML
			});
		}
	});
});
