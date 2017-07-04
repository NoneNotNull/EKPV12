define([
	"dojo/_base/declare", 
	"dojo/_base/lang", 
	'dojo/topic', 
	'dojo/dom-construct',
	'dojo/query',
	"dojox/mobile/viewRegistry",
	"dojo/when",
	"mui/i18n/i18n!sys-mobile", 
	], function(declare, lang, topic, domCtr, query, viewRegistry, when, Msg) {
	
	var resetHtml = '<span><i class="mui mui-down"></i>' + Msg['mui.list.pull.reload'] +'</span>';
	var readyHtml = '<span><i class="mui mui-rotate-180 mui-down mui-top"></i>' + Msg['mui.list.pull.release'] +'</span>';
	var pullHtml = '<span><i class="mui mui-loading mui-spin"></i>' + Msg['mui.list.pull.loading'] +'</span>';
	
	return declare("mui.list._ViewPullReloadMixin", null, {

		pull: false,
		
		_pullItem: null,
		
		_pullDom: null,
		
		_createPullDom: function() {
			if (!this._pullDom) {
				this._pullDom = domCtr.toDom('<div class="listPullItem"></div>');
				domCtr.place(this._pullDom, this.containerNode, 'first');
				this._resetForLoad();
			}
		},
		
		_readyForLoad: function() {
			var pullDom = this._pullDom;
			if (pullDom.innerHTML == readyHtml) {
				return;
			}
			pullDom.innerHTML = readyHtml;
		},
		
		_pullForLoad: function() {
			var pullDom = this._pullDom;
			pullDom.innerHTML = pullHtml;
		},
		
		_resetForLoad: function() {
			var pullDom = this._pullDom;
			pullDom.innerHTML = resetHtml;
		},
		
		_setPullAttr: function(pull) {
			var pullDom = this._pullDom;
			if (pull) {
				this._pullForLoad();
			} else {
				this._resetForLoad();
			}
			this._set("pull", pull);
		},
		
		_buildPullHandle: function() {
			var self = this;
			return {
					work: function() {}, 
					done: function() {
						self.pullDone();
					}, 
					error: function() {
						self.pullDone();
					}
			};
		},
		
		pullDone: function() {
			this.set('pull', false);
			// 必须异步，否则会有问题
			this.defer(function() {
				this.slideTo({y:0}, 0.3, "ease-out");
			}, 0);
		},
		
		onAfterScroll: function(evt) {
			var h = this._pullDom.offsetHeight;
			if(evt.beforeTopHeight > h) {
				this._readyForLoad();
			} else {
				this._resetForLoad();
			}
			return this.inherited(arguments);
		},
		
		adjustDestination: function(to, pos, dim) {
			var h = this._pullDom.offsetHeight;
			if (pos.y > h) {
				this.slideTo({y:h}, 0.3, "ease-out");
				var handle = this._buildPullHandle();
				this.onPull(this, handle);
				return false;
			}
			return this.inherited(arguments);
		},
		
		reload: function() {
			var handle = this._buildPullHandle();
			this.onReload(this, handle);
		},
		
		onReload: function(widget, handle) {
			topic.publish('/mui/list/onReload', this, handle);
		},
		
		onPull: function(widget, handle) {
			this.set("pull", true);
			topic.publish("/mui/list/onPull", this, handle);
		},
		
		startup : function(){
			if(this._started){ return; }
			
			this.inherited(arguments);
			
			this._createPullDom();
			this.set("pull", false);
		}
	});
});