define([ "dojo/_base/declare", "dojo/dom-geometry", "dojo/touch","dojo/date",
         "dojo/_base/window", "dojo/topic", "dojo/_base/array","mui/util" ],
		function(declare, domGeometry, touch, dateClaz, win, topic, array, util) {
	
	var claz=declare('mui.calendar._ContentEventMixin',null,{
		
		_changeMonthConnects:[],
		
		buildRendering:function(){
			this.inherited(arguments);
			this.bindChangeMonthEvent();
		},
		
		bindChangeMonthEvent:function(){
			this.touchStartHandle = this.connect(this.domNode,
					touch.press, "onTouchStart");
		},
		
		onTouchStart:function(e){
			this.dy = 0;
			//this.eventStop(e);
			this._changeMonthConnects.push(this.connect(this.domNode,touch.move, "onTouchMove"));
			this._changeMonthConnects.push(this.connect(this.domNode,touch.release, "onTouchEnd"));
			this.startY = e.touches ? e.touches[0].pageY
					: e.clientY;
		},
		
		onTouchMove:function(e){
			//this.eventStop(e);
			this.currentY = e.touches ? e.touches[0].pageY : e.clientY;
			this.dy=this.currentY-this.startY;
		},
		
		onTouchEnd:function(e){
			//this.eventStop(e);
			var dist=this.domNode.clientHeight / 4;
			if(this.dy>dist){
				this.set('currentDate', dateClaz.add(
						this.currentDate, 'month', 1));
			}
			if(this.dy < -dist ){
				this.set('currentDate', dateClaz.add(
						this.currentDate, 'month', -1));
			}
			//移除事件
			array.forEach(this._changeMonthConnects, function(item) {
				this.disconnect(item);
			}, this);
			this._changeMonthConnects = [];
		},
		
		eventStop : function(evt) {
			evt.preventDefault();
			evt.stopPropagation();
		}
		
		
	});
	
	
	return claz;
	
});