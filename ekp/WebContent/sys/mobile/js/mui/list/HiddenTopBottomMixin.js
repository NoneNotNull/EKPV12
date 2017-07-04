define([
        "dojo/_base/declare", 
        'dojo/topic'], 
		function(declare, topic) {

	return declare("mui.list.HiddenTopBottomMixin", null, {
		
		hideTopBottom: true,
		
		startup : function() {
			if (this._started) {
				return;
			}
			this.inherited(arguments);
			if (this.hideTopBottom) {
				this.subscribe('/mui/list/hideTopBottom', this.doHideTopBottom);
			}
		},
		
		doHideTopBottom: function(srcObj, evt) {
			if (!this.hideTopBottom) {
				return;
			}
			this.domNode.style.display = evt ? 'none' : '';
		}
	});
});