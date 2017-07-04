define( [ "dojo/_base/declare", "dojo/dom","mui/rtf/_ImageResizeMixin",
		"mui/rtf/_TableResizeMixin" ], function(declare, dom,
		_ImageResizeMixin, _TableResizeMixin) {

	var claz = declare("mui.rtf.RtfResize", [ _ImageResizeMixin,
			_TableResizeMixin ], {

		//包含编辑器内容dom对象
		containerNode : null,

		//RTF名称
		name : null,

		formatContent : function(domNode) {
			this.inherited(arguments);
		},

		setName : function(name) {
			this.name = name;
		},

		// 构造函数
		constructor : function(name) {
			this.inherited(arguments);
			if (typeof (name) == "object") {
				this.setName(name['name']);
				this.containerNode = name['containerNode'];
			} else {
				this.setName(name);
			}
			this.load();
		},

		load : function() {
			var _container = null;
			if (this.name != null) {
				_container = '_____rtf_____' + this.name;
				_container = dom.byId(_container);
			} else {
				_container = this.containerNode;
			}
			this.formatContent(_container);
		}
	});
	return claz;
});