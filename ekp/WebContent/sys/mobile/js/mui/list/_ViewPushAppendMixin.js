define([
	"dojo/_base/declare", 
	"dojo/_base/lang", 
	'dojo/topic', 
	'dojo/dom-construct',
	'dojo/query',
	"dojox/mobile/viewRegistry",
	"dojo/when",
	'dojo/dom-style',
	'mui/i18n/i18n!sys-mobile',
	"dojo/_base/array"
	], function(declare, lang, topic, domCtr, query, viewRegistry, when, domStyle, Msg, array) {
	
	return declare("mui.list._PushMixin", null, {
		
		push: false,
		
		_pushItem: null,
		
		_pushDom: null,
		
		_createPushDom: function() {
			if (!this._pushDom) {
				this._pushDom = domCtr.toDom('<div class="listPushItem"><span><i class="mui mui-loading mui-spin"></i>' + Msg['mui.list.push.more'] + '</span></div>');
				domCtr.place(this._pushDom, this.containerNode, 'last');
			}
		},
		
		_setPushAttr: function(push) {
			this._set("push", push);
		},
		
		pushDone: function() {
			this.set('push', false);
		},
		
		_buildPushHandle: function() {
			var self = this;
			return {
				work: function() {}, 
				done: function() {
					self.pushDone();
				}, 
				error: function() {
					self.pushDone();
				}
			};
		},
		
		onAfterScroll: function(evt) {
			if(evt.afterBottom && !this.push){
				this.set("push", true);
				var handle = this._buildPushHandle();
				this.onPush(this, handle);
				topic.publish("/mui/list/onPush", this, handle);
			}
			return this.inherited(arguments);
		},
		
		adjustDestination: function(to, pos, dim) {
			var h = this._pushDom.offsetHeight;
			if (to.y + dim.o.h < h && !this.push) {
				this.set("push", true);
				var handle = this._buildPushHandle();
				this.onPush(this, handle);
				topic.publish("/mui/list/onPush", this, handle);
			}
			return this.inherited(arguments);
		},
		
		onPush: function(widget) {
			
		},
		
		handlePushDomHide : function(store) {
			if (array.some(this.getChildren(), function(child) {return child == store;})) {
				domStyle.set(this._pushDom, { display : 'none' });
			}
		},

		handlePushDomShow : function(store) {
			if (array.some(this.getChildren(), function(child) {return child == store;})) {
				domStyle.set(this._pushDom, { display : 'table' });
			}
		},
		
		startup : function(){
			if(this._started){ return; }
			
			this.inherited(arguments);

			this._createPushDom();
			this.set("push", false);
			this.subscribe('/mui/list/pushDomHide','handlePushDomHide');
			this.subscribe('/mui/list/pushDomShow','handlePushDomShow');
		}
	});
});