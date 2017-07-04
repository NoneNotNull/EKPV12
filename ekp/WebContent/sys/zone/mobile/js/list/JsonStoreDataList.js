define([
    "dojo/_base/declare",
	"mui/list/JsonStoreList",'dojo/topic',"dojo/query",
	"mui/util","dojo/dom-style","dojo/dom-construct","dojo/dom-attr", 
	"dojox/mobile/TransitionEvent","dijit/registry","dojo/dom-geometry"
	], function(declare, JsonStoreList, topic, query,
				util, domStyle, domConstruct,
				domAttr,TransitionEvent,registry, domGeometry) {
	
	return declare("sys.zone.mobile.list.js.JsonStoreDataList", [JsonStoreList], {
			
			startup : function() {
				this.set ("lazy", false);
				this.subscribe('/mui/list/loaded', 'handleOnLoaded');
				this._getDef();
				this._calWidth();
				this.inherited(arguments);
			},
			
			//参考元素
			_getDef: function() {
				if(!this.def) {
					var def= query(".mui_fans_zone_defined", this.domNode)[0];
					if(!def) {
						def = domConstruct.create('li' , {
							className : "mui_fans_zone_defined"
						}, this.domNode, "first");
					}
					this.def = def;
					var moreButton = domConstruct.create('a', {
						className: "mui_fans_zone_item",
						"href" : "javascript:void(0);",
						'innerHTML' : '<div class="mui mui-more3 mui_fans_zone_more"></div>'
					},this.def);
					this.connect(moreButton, "click",  this._morePersonClick);
				}
				return this.def;
			},
			
			//更多按钮点击事件
			_morePersonClick : function(e) {
				
				if(!this.moreViewId)
					return;
				//发滑动事件
				topic.publish("/sys/zone/onSlide", this, {
					moreViewId : this.moreViewId,
					target : e.target
				});
			},
			
			_calWidth : function() {
				if(this.totalNum <= 0) {
					return;
				}
				var rowsize = 0;
				//var containterWidth = this.domNode.offsetWidth;
				//var itemWidth = this.def.offsetWidth;
				var containterWidth = domGeometry.getMarginSize(this.domNode).w;
				var itemWidth = domGeometry.getMarginSize(this.def).w;
				//可放下的个数
				var allNum = parseInt(containterWidth / itemWidth);
				if(allNum >= this.totalNum) {
					rowsize = allNum;
					domStyle.set(this.def, "display", "none");
				} else {
					rowsize = allNum - 1;
				}
				this.url =  this.url + "&rowsize=" + rowsize;
			},
	
			handleOnPush: function(widget, handle) {
				return;
			},
			
			handleOnLoaded : function(obj, data) {
				domConstruct.place(this.def, this.domNode, "last");
				//全局事件，隐藏加载更多
				if(obj === this) {
					topic.publish("/mui/list/pushDomHide");
				}
			},
			
			//覆盖无数据
			buildNoDataItem : function(widget) {
				if(widget.totalSize == 0 )
					this.hiedDef();
			},
			
			hiedDef: function(){
				if(this.def)
					domStyle.set(this.def, "display", "none");
			}

	});
});