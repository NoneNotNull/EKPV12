define([
    "./iconUtils",
    'mui/dialog/Tip',
    'dojox/mobile/SwapView',
    'dojo/NodeList-dom',
	'dojo/NodeList-html',
	'dojo/NodeList-manipulate',
	'dojo/NodeList-traverse'
	], function(iconUtils, Tip, SwapView) {
	if (!window.building) {
		window.building = function(){
			Tip.tip({
				icon : 'mui mui-warn',
				text : '功能建设中'
			});
		};
	}
	// 修改 w/4 为 w/2
	SwapView.prototype.slideTo = function(/*Object*/to, /*Number*/duration, /*String*/easing, /*Object?*/fake_pos){
		// summary:
		//		Overrides dojox/mobile/scrollable.slideTo().
		if(!this._beingFlipped){
			var w = this.domNode.offsetWidth;
			var pos = fake_pos || this.getPos();
			var newView, newX;
			if(pos.x < 0){ // moving to left
				newView = this.nextView(this.domNode);
				if(pos.x < -w/2){ // slide to next
					if(newView){
						to.x = -w;
						newX = 0;
					}
				}else{ // go back
					if(newView){
						newX = w;
					}
				}
			}else{ // moving to right
				newView = this.previousView(this.domNode);
				if(pos.x > w/2){ // slide to previous
					if(newView){
						to.x = w;
						newX = 0;
					}
				}else{ // go back
					if(newView){
						newX = -w;
					}
				}
			}

			if(newView){
				newView._beingFlipped = true;
				newView.slideTo({x:newX}, duration, easing);
				newView._beingFlipped = false;
				newView.domNode._isShowing = (newView && newX === 0);
			}
			this.domNode._isShowing = !(newView && newX === 0);
		}
		// this.inherited(arguments);
		this._runSlideAnimation(this.getPos(), to, duration, easing, this.containerNode, 2);
		this.slideScrollBarTo(to, duration, easing);
	};
	return {"iconUtils": iconUtils, "building": building};
});