define([
	'dojo/_base/declare',
	'dojo/topic',
	'dojo/_base/array',
	'./SwapScrollableView',
	], function(declare, topic, array, SwapScrollableView) {
	
	return declare('mui.list.NavSwapScrollableView', [SwapScrollableView], {
		
		refNavBar: null,
		
		postCreate: function() {
			this.inherited(arguments);
			this.subscribe('/mui/nav/onComplete', 'handleNavOnComplete');
		},
		
		handleNavOnComplete: function(widget, items) {
			this.refNavBar = widget;
			this.generateSwapList(widget.getChildren());
		},
		
		onSwapViewChanged: function(view) {
			this.inherited(arguments);
			if (this.refNavBar) {
				var index = array.indexOf(this.getChildren(), view);
				var selectedItem = this.refNavBar.getChildren()[index];
				this.refNavBar.selectedItem = selectedItem;
				selectedItem.setSelected();
			}
		}
	});
});