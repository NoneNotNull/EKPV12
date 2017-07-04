define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var parser = require('lui/parser');
	var env = require('lui/util/env');
	var loader = require('lui/util/loader');
	var base = require("lui/base");

	function buildZoneInfo(event, element, id){
		var person = new ZoneInfo({fdId: id, triggerObject: $(element)});
		person.startup();
		person.draw();
	}
	
	var ResourceLoadZoneLay = base.Base.extend(loader.ResourceLoadMixin, {
		initProps: function($super, cfg) {
			$super(cfg);
			this._initResource(cfg);
		}
	});	
	
	var ZoneLay = ResourceLoadZoneLay.extend({
		outerHtml: null,
		_onLoad: function(html) {
			this.outerHtml = html;
		},
		setHtml: function(data, cb){
			$(this.outerHtml).appendTo($(data.element));
			cb(data);
		},
		_resReady: function(data, cb) {
			if (this._loaded) {
				this.setHtml(data, cb);
				return;
			}
			this._try_times ++;
			if (this._try_times > 5000) {
				return;
			};
	    	var self = this;
	    	setTimeout(function() {
	    		self._resReady(data, cb);
	    	}, 20);
	    },
	    get : function(data, cb){
	    	this._resReady(data, cb);
	    }
	});
	
	
	var ZoneInfo = base.Container.extend({
		initProps : function($super,_config){
			this.config = _config;
			this.fdId = _config.fdId;
			this.triggerObject = _config.triggerObject;
			this.borderWidth = this.config.borderWidth || 1;
			this.popupObject = this.element;
			$super(_config);
		},
		startup :function(){
			this.zindex = LUI.zindex();
			this.popupObject.addClass("lui_zone_popupW");
			this.popupObject.css({"position":"absolute","z-index":this.zindex,"border-color": "#e1e1e1","border-style": "solid","background-color": "white"});
			this.popupObject.appendTo($(document.body));
			if(this.zoneLay == null){
				var config = {
					"src":env.fn.formatUrl("/sys/zone/resource/zoneInfo.jsp?fdId=" + this.fdId)
				};
				this.zoneLay = new ZoneLay(config);
			}			
		},
		doLayer : function(obj){
			var self = this;
			self.zonePosition = new ZonePosition(self);
			this.element.hide();
			this.element.css({"border-width": "" + (this.borderWidth) + "px"});			
			parser.parse(obj.element[0]);
			// 必须清除原有的mouseover属性的事件函数
			this.triggerObject.attr('onmouseover', null);
			this.__overEvent();
			this.triggerObject.mouseover();
		},
		draw :function($super){
			if (this.isDrawed){
				return;
			}
			var self = this;
			if(this.zoneLay){
				this.zoneLay.on("error",function(msg){
					self.element.append(msg);
				});
				this.zoneLay.get(this,function(obj){
					 self.doLayer(obj);
				});
			}
			$super();
			this.isDrawed = true;
		},
		getPosition: function(){
			return this.zonePosition.getPosition();
		},
		show: function(){
			this.emit('show');
			this.element.css(this.getPosition());
			this.element.show();
		},
		hide: function(){
			this.element.hide();
			this.emit('hide');
		},
		__overEvent : function(){
 			var self = this;
			var show = false;
			var showTimeout = -1, hideTimeout = -1;
			self.triggerObject.bind("mouseover",function(evt){
 				if(show || showTimeout>-1)
 					return;
 				showTimeout = window.setTimeout(function(){
 					show = true;
 					showTimeout = -1;
 					self.show();
 				},300);
 			});
			self.triggerObject.bind("mouseout",function(evt){
 				if(showTimeout>-1){
 					window.clearTimeout(showTimeout);
 					showTimeout = -1;
 				}
 			});
 			//触发隐藏
 			self.on('over', function(){
 				if(hideTimeout>-1){
 					window.clearTimeout(hideTimeout);
 					hideTimeout = -1;
 				}
 			});
 			self.on('out', function(){
 				if(hideTimeout>-1){
 					window.clearTimeout(hideTimeout);
 					hideTimeout = -1;
 				}
 				if(show){
 					hideTimeout = window.setTimeout(function(){
 	 					show = false;
 						hideTimeout = -1;
 	 					self.hide();
 	 				},300);
 				}
 			});
 			self.hoverEvent = {
 				"mouseover" : function(){
					self.emit('over');
 				},
 				"mouseout":function(){
 					self.emit('out');
 				}
 			}; 
 			self.element.bind(self.hoverEvent);
			self.triggerObject.bind(self.hoverEvent); 
		}
	});
	
	var ZonePosition = base.Base.extend({
 		initProps : function(_config){
 			this.triggerObject = _config.triggerObject;
 			this.element = _config.element;
 			this.borderWidth = _config.borderWidth;
 			this.arrowElement = _config.element.find(".lui_zone_info_arrow_box");
 			this.arrowBorder = _config.element.find(".lui_zone_info_arrow_border");
 			this.arrowCover = _config.element.find(".lui_zone_info_arrow_cover");
 		},
 		__update_new_pos : function(){
 			//层的宽高
			this.layClient = {width: this.element.outerWidth(true), height: this.element.outerHeight(true)};
			//箭头的宽高
			this.arrowClient = {width: this.arrowBorder.outerWidth(true), height: this.arrowBorder.outerHeight(true)};
			//触发对象坐标、宽高
			this.triClient = this.__getTriClient();
			//文档滚动偏移量、可见宽高
			this.client = this.__getWindowClient();
 		},
 		getPosition: function(){
 			this.__update_new_pos();
			var __t_size = this.triClient.top - this.client.top;
			var __b_size = (this.client.height + this.client.top) - this.triClient.top - this.triClient.height;
			var __l_size = this.triClient.left - this.client.left;
			var __r_size = (this.client.width + this.client.left) - this.triClient.left - this.triClient.width;
			
			var _top = 0, _left = 0;
			if(__t_size >= this.layClient.height){
				//显示在上方
				_top = this.triClient.top - this.layClient.height - this.arrowClient.height/2;
				_left = this.__getLeft();
				this.__buildTopArrow(_left);
			}else if(__b_size> this.layClient.height){
				//显示在下方
				_top = this.triClient.top + this.triClient.height + this.arrowClient.height/2;
				_left = this.__getLeft();
				this.__buildBottomArrow(_left);
			}else if(__r_size > this.layClient.width){
				//显示在右边
				_top = this.__getTop();
				_left = this.triClient.left + this.triClient.width + this.arrowClient.width/2;
				this.__buildRightArrow(_top);
			}else if(__l_size > this.layClient.width){
				//显示在左边
				_top = this.__getTop();
				_left = this.triClient.left - this.layClient.width - this.arrowClient.width/2;
				this.__buildLeftArrow(_top);
			}else{
				//都不符合，窗口缩得很小，显示在下方
				_top = this.triClient.top + this.triClient.height + this.arrowClient.height/2;
				_left = this.__getLeft();	
				this.__buildBottomArrow(_left);
			}
			return {top: _top, left: _left}; 			
 		},
 		__getLeft: function(){
			var __pl = this.triClient.left - this.client.left;
			var __pr = this.client.width + this.client.left - this.triClient.left;
			var __halfLayW = this.layClient.width / 2;
			var __left = this.triClient.left - __halfLayW;
			if(__pl < __halfLayW && __pr >= __halfLayW){
				__left = this.client.left;
			}else if(__pl >= __halfLayW && __pr < __halfLayW){
				__left = this.client.left + this.client.width - this.layClient.width;
			}
			return __left;
 		},
 		__getTop: function(){
 			var __pt = this.triClient.top - this.client.top;
 			var __pb = this.client.height + this.client.top - this.triClient.top;
 			var __halfLayH = this.layClient.height / 2;
 			var __top = this.triClient.top - __halfLayH;
 			if(__pt < __halfLayH && __pb >= __halfLayH){
 				__top = this.client.top;
 			}else if(__pt >= __halfLayH && __pb < __halfLayH){
 				__top = this.client.top + this.client.height - this.layClient.height;
 			}
 			return __top;
 		},		
		__getTriClient: function(){
			var _$tri = this.triggerObject;
			var _offset = _$tri.offset();
			return {left: _offset.left, top: _offset.top, width: _$tri.outerWidth(true), height: _$tri.outerHeight(true)};
		}, 		
		__getWindowClient: function(){ 
			var l, t, w, h; 
			l = document.documentElement.scrollLeft || document.body.scrollLeft; 
			t = document.documentElement.scrollTop || document.body.scrollTop; 
			w = document.documentElement.clientWidth; 
			h = document.documentElement.clientHeight; 
			return { left: l, top: t, width: w, height: h }; 
		},
		__buildBottomArrow: function(_left){
			var top = - this.layClient.height - this.arrowClient.height + this.borderWidth;
			this.arrowElement.css({left: this.__getLeftForTB(_left), top: top});
			this.__removeAllClass();
			this.arrowElement.addClass("arrow_b");
			this.arrowCover.css({left: 0, top: this.borderWidth, "border-color": "transparent transparent #fff transparent"});
			this.arrowBorder.css({left: 0, "border-color": "transparent transparent #d0d0d0 transparent"});
		},
		__buildTopArrow: function(_left){
			this.arrowElement.css({left: this.__getLeftForTB(_left), top: 0});
			this.__removeAllClass();
			this.arrowElement.addClass("arrow_t");
			this.arrowCover.css({left: 0, top: -this.borderWidth, "border-color": "#fff transparent transparent transparent"});
			this.arrowBorder.css({left: 0, "border-color": "#d0d0d0 transparent transparent transparent"});		
		},
		__getLeftForTB: function(_left){
			var triX = this.triClient.left + this.triClient.width/2;
			var layX = _left + this.layClient.width;
			var arrowLeft = triX - this.arrowClient.width/2;
			if(triX < _left){
				arrowLeft = _left;
			}else if(triX > layX){
				arrowLeft = layX - this.arrowClient.width;
			}
			return arrowLeft - _left;
		}
		,
		__buildLeftArrow: function(_top){
			var left = this.layClient.width - this.borderWidth;
			this.arrowElement.css({left: left, top: this.__getTopForLR(_top)});
			this.__removeAllClass();
			this.arrowElement.addClass("arrow_l");
			this.arrowCover.css({left: - this.borderWidth, top: 0, "border-color": "transparent transparent transparent #fff"});
			this.arrowBorder.css({left: 0, top: 0,"border-color": "transparent transparent transparent #d0d0d0"});
		},
		__buildRightArrow: function(_top){
			this.arrowElement.css({left: 0, top: this.__getTopForLR(_top)});
			this.__removeAllClass();
			this.arrowElement.addClass("arrow_r");
			this.arrowCover.css({left: this.borderWidth - this.arrowClient.width, top: 0, "border-color": "transparent #fff transparent transparent"});
			this.arrowBorder.css({left: - this.arrowClient.width, top: 0,"border-color": "transparent #d0d0d0 transparent transparent"});			
		},
		__getTopForLR: function(_top){
			var triY = this.triClient.top + this.triClient.height/2;
			var layY = _top + this.layClient.height;
			var arrowTop = triY - this.arrowClient.height/2;
			if(triY < _top){
				arrowTop = _top;
			}else if(triY > layY){
				arrowTop = layY - this.arrowClient.height;
			}
			return arrowTop - _top - this.layClient.height;
		},
		
		
		__removeAllClass : function() {
			this.arrowElement.removeClass("arrow_l arrow_r arrow_b arrow_t");
		}
	});
	
	
	exports.buildZoneInfo = buildZoneInfo;
	exports.ZoneInfo = ZoneInfo;
});