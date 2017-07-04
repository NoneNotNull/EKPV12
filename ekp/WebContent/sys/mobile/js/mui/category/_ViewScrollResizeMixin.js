define( [ "dojo/_base/declare","dojo/topic"], function(declare, topic) {

	return declare("mui.list._ViewScrollResizeMixin", null, {

		startup : function() {
			if (this._started) {
				return;
			}
			this.inherited(arguments);
			this.subscribe("/mui/list/loaded",'_scrollResize');
			this.subscribe("/mui/view/scrollTo",'_scrollTo');
		},
		
		_scrollTo:function(srcObj,evt){
			if(srcObj.key==this.key && this.slideTo){
				if(evt){
					if(evt.y && evt.y!=0){
						var scrollH = this.domNode.offsetHeight;
						var listH = this.containerNode.offsetHeight;
						var navAreaH = listH + evt.y;
						var yTop = 0;
						if(navAreaH < scrollH){
							if(listH<scrollH){
								yTop = 0;
							}else{
								yTop = 0 - (listH - scrollH);
							}
							 evt.y = yTop;
						}
						this.slideTo(evt, 0.5, 'linear');
						return;
					}
				}
				this.slideTo({y:0}, 0.5, 'linear');	
				return;
			}
		},
		
		_runSlideAnimation : function(from, to, duration, easing, node, idx) {
			topic.publish("/mui/view/afterScroll", this, {
				from : from,
				to : to
			});
			this.inherited(arguments);
		},

		
		_scrollResize : function(srcObj){
			if(srcObj.key==this.key){
				if(this.resize){
					this.resize();
					topic.publish("/mui/view/resized",this);
				}
				this._scrollTo(srcObj);
			}
		}
	});
});