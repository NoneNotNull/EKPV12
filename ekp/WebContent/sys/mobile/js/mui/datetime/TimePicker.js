define([ "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/date/locale", "dojo/date/stamp",
         "dojox/mobile/SpinWheelTimePicker", "dojox/mobile/SpinWheelSlot"], function(
		declare, lang, array, datelocale, datestamp, SpinWheelTimePicker, SpinWheelSlot) {
	
	var _format = {
		format:function(d){
			return datelocale.format(d, {timePattern:this.disPattern, selector:"time"});
		},
		toTimeStr:function(str){
			var tmpD = datelocale.parse(str, {timePattern:this.disPattern, selector:"time"});
			return datelocale.format(tmpD, {timePattern:this.valPattern, selector:"time"});
		},
		toDisTimeStr:function(str){
			var tmpD = datelocale.parse(str, {timePattern:this.valPattern, selector:"time"});
			return datelocale.format(tmpD, {timePattern:this.disPattern, selector:"time"});
		}
	};
	var hourMixin = lang.mixin({
		//显示时格式
		disPattern:"HH时",
		//对应时间值格式
		valPattern:"HH",
		initLabels: function(){
			if(this.labelFrom !== this.labelTo){
				this.labels = [];
				var d = new Date(2000, 0, 1, this.labelFrom, 0);
				for(var i = this.labelFrom; i <= this.labelTo; i++){
					d.setHours(i);
					this.labels.push(this.format(d));
				}
			}
		}
	}, _format);;

	var minuteMixin = lang.mixin({
		disPattern:"mm分",
		valPattern:"mm",
		initLabels: function(){
			if(this.labelFrom !== this.labelTo){
				this.labels = [];
				var d = new Date(2000, 0, 1, 0, this.labelFrom);
				for(var i = this.labelFrom; i <= this.labelTo; i++){
					d.setMinutes(i);
					this.labels.push(this.format(d));
				}
			}
		}
	}, _format);
	
	var claz = declare("mui.datetime.TimePicker", [ SpinWheelTimePicker ], {
		pattern:"HH:mm",
		
		slotClasses:[
		             declare(SpinWheelSlot, hourMixin),
		        	 declare(SpinWheelSlot, minuteMixin)
		        	 ],
		        	 
		slotProps:[
	 			{labelFrom:0, labelTo:23, style:{width:"50px", textAlign:"right"}},
	 			{labelFrom:0, labelTo:59, zeroPad:2, style:{width:"50px", textAlign:"right"}}
	 			],
		
		_setValueAttr : function(value) {
			if (!value){
				var now = new Date();
				value = datelocale.format(now, {timePattern:this.pattern, selector:"time"});
			}
			var values = value.trim().split(':');
			if (values.length > 1){
				var tmpVals = [];
				var _self = this;
				array.forEach(values,function(val,idx){
					tmpVals.push(_self.slots[idx].toDisTimeStr(val));
				});
				this.values = tmpVals;
			}
		},

		_getValueAttr : function() {
			var values = this.get('values');
			if (values.length > 1){
				var tmpVals = [];
				var _self = this;
				array.forEach(values,function(val,idx){
					tmpVals.push(_self.slots[idx].toTimeStr(val));
				});
				return tmpVals[0] + ':' + tmpVals[1];
			}
		}

	});
	return claz;
});