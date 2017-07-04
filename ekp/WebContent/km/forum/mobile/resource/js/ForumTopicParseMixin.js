define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "sys/praise/mobile/import/js/_PraiseTabBarButtonMixin"
	], function(declare, domConstruct, _PraiseTabBarButtonMixin) {
	var create = declare("km.forum.mobile.resource.js.ForumTopicParseMixin", [_PraiseTabBarButtonMixin], {
	
		togglePraised:function(isInit){
			this.inherited(arguments);
			if(!isInit){
				if(this.isPraised){
					this._set('count',this.count + 1);
				}else{
					this._set('count',this.count - 1);
				}
				this._reDrawLabel();
			}
		},
		
		_reDrawLabel:function(){
			if(this.labelNode){
				if(this.count>0){
					this.labelNode.innerHTML =  this.count;
				}else{
					this.labelNode.innerHTML = '';
				}
			}
		},
		
		_setCountAttr:function(count){
			this._set('count',count);
			this._reDrawLabel();
		}
	});
	return create;
});