define([ "dojo/_base/declare", "dojo/_base/lang", "mui/form/editor/EditorPopupMixin" ], function(
		declare, lang, EditorPopupMixin) {

	return new declare("mui.form.EditorUtil", EditorPopupMixin, {

		// 弹出框
		popup: function(url, options, callback) {
			var config = {_url : url,afterHideMask : callback};
			config = lang.mixin(config,options ? options : {});
			var editor = new EditorPopupMixin(config);
			editor.onEditorClick.call(editor);
		},

		// 自适应
		resize: function() {

		}
	})();
});