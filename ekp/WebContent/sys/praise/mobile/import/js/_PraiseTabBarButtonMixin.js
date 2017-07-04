define(	["dojo/_base/declare", "dojo/_base/lang","dojo/dom-class", 
       	 "mui/dialog/Tip", "sys/praise/mobile/import/js/_PraiseInformationMixin"], 
		function(declare, lang, domClass, Tip, _PraiseInformationMixin) {

			return declare("sys.praise.mobile.import.js._PraiseTabBarButtonMixin", [_PraiseInformationMixin], {

				scaleClass : 'mui-scaleX',

				praisedClass : 'mui-praise-on',

				unPraisedClass : 'mui-praise',

				buildRendering : function() {
					this.inherited(arguments);
				},

				startup : function() {
					if (this._started)
						return;
					this.inherited(arguments);
					this.hasPraised();
				},

				replaceClass : function(flag) {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					var class1 = flag ? this.praisedClass : this.unPraisedClass;
					var class2 = flag ? this.unPraisedClass : this.praisedClass;
					domClass.replace(i1, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
					domClass.replace(i2, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
				},

				removeScaleClass : function() {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					this.defer(lang.hitch(this, function() {
										domClass.remove(i1, this.scaleClass);
										domClass.remove(i2, this.scaleClass);
									}), 300);
				},

				togglePraised : function(isInit) {
					if(!isInit){
						if(this.isPraised){
							Tip.tip({
								icon : 'mui '
										+ this.praisedClass,
								text : '赞+1'
							});
						}else{
							Tip.tip({
								icon : 'mui '
										+ this.unPraisedClass,
								text : '取消赞'
							});
						}
					}
					this.replaceClass(this.isPraised);
					this.removeScaleClass();
				},

				// 切换收藏
				onClick : function(evt) {
					this.doPraised();
				}
			});
		});