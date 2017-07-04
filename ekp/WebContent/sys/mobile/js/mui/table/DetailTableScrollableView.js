define( [ "dojo/_base/declare", "mui/view/DocScrollableView"],
		function(declare, DocScrollableView) {
	
	return declare("mui.table.DetailTableScrollableView", [ DocScrollableView], {
		stopParser:true,
		
		buildRendering : function() {
			this.inherited(arguments);
		}
	});
});