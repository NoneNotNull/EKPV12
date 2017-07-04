define([
        "dojo/_base/declare", 
        'dojo/topic', 
        'dojo/_base/lang',
        'dojo/_base/array'
        ], function(declare, topic, lang, array) {
	
	return declare('mui.list._NavAttachMixin', null, {
		
		navCompleteTopic: '/mui/nav/onComplete',
		
		navSetSelectedTopic: '/mui/nav/setSelected',
		
		refNavBar: null,
		
		postCreate: function() {
			this.inherited(arguments);
			
			if (this.navCompleteTopic) {
				this.subscribe(this.navCompleteTopic, 'handleNavOnComplete');
			}

			this.subscribe(this.swapChangedTopic, 'handleSwapChanged');
		},
		
		handleNavOnComplete: function(widget, items) {
			this.refNavBar = widget;
			this.generateSwapList(widget.getChildren());
		},
		
		handleSwapChanged: function(view) {
			if (this.refNavBar) {
				var index = array.indexOf(this.getChildren(), view);
				this.refNavBar.getChildren()[index].setSelected();
			}
		}
	});
});