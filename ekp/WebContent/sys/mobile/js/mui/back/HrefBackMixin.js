define( [ "dojo/_base/declare", "dojo/dom-class", "mui/util" ], function(declare, domClass, util) {
	return declare("mui.back.HrefBackMixin", null , {
			//返回的地址
			href : "",
			
			icon:'mui mui-home-opposite',
			
			buildRendering : function() {
				this.inherited(arguments);
				domClass.add(this.domNode,"muiHrefBack");
			},
			
			
			_onExpand : function(evt){
				if (window[this.click])
					window[this.click]();
				else if ('[object Function]' == Object.prototype.toString
						.call(this.click)){
					this.click();
				}else
					new Function(this.click)();
				this.inherited(arguments);
			},
			

			show : function(refHeight) {
				// 自定义返回事件
				if (this.click)
					return;
				var url = dojoConfig.baseUrl ? dojoConfig.baseUrl : '/';
				if (this.href) {
					url = util.formatUrl(this.href);
				}
				location = url;
			}
	});
});