define([
    "dojo/_base/declare",
    "dojo/dom-construct",
	], function(declare, domConstruct) {
	var create = declare("km.forum.mobile.resource.js.ForumTopicReplayMixin", null, {
		
		align:"center",
		
		count:0,
		
		postCreate : function() {
			this.inherited(arguments);
			this.subscribe("/km/forum/replaySuccess",'changeCount');
		},
		
		_onClick:function(evt){
			this.defer(function(){
				if(window.replayPost){
					window.replayPost();
				}
			},350);
		},
		
		changeCount:function(){
			this.count = this.count + 1; 
			this.labelNode.innerHTML =  this.count;
		},
		
		_setCountAttr:function(count){
			if(count>0){
				this.labelNode.innerHTML =  count;
			}else{
				this.labelNode.innerHTML = '';
			}
		}
	});
	return create;
});