define(
		[ "dojo/_base/declare","dojo/text!../tmpl/editor_layout.html" ],
		function(declare,layout) {

		return declare("sys.task.mobile.resource.js.EditorMixin",null,{
			layout : layout
		});
			
});