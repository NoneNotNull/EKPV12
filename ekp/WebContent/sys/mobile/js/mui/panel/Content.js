define("mui/panel/Content", [ "dojo/dom-construct", 'dojo/_base/declare',
		"dojo/dom-class", "dojo/dom-style", "dojo/topic", "dojo/_base/lang",
		"dijit/_WidgetBase", "dijit/_Contained", "dijit/_Container",
		"dojo/_base/array" ], function(domConstruct, declare, domClass,
		domStyle, topic, lang, WidgetBase, Contained, Container, array) {
	return declare('mui.panel.Content', [ WidgetBase, Contained, Container ], {

		title : '',

		icon : '',

		baseClass : 'muiAccordionPanelContent',

		toggle : true,

		expand : true,

		// 是否初始化
		inited : false,

		// 是否初始化内容
		loaded : false,

		hasChild : true,

		buildRendering : function() {
			this.domNode = this.containerNode = this.srcNodeRef
					|| domConstruct.create('div', {
						className : 'muiAccordionPanelContent'
					});
			this.inherited(arguments);

		},

		postscript : function() {
			this.inherited(arguments);
		},

		startup : function() {
			if (this._started)
				return;
			this.inherited(arguments);
		},

		// 加载内容
		initContent : function() {
			if (this.inited)
				return;
			var children = this.getChildren();
			// 内部无mobile组件
			if (children.length == 0) {
				this.set('hasChild', false);
				if (this.expand)
					this.show();
				return;
			}
			this.content = children[0];
			this.expand = this.content.lazy ? false : true;
			this.loaded = this.expand;
			this.inited = true;
			if (this.expand)
				this.show();
		},

		reload : function() {
			if (this.loaded)
				return;
			var content = this.content;
			if (content.reload)
				content.reload();
			this.loaded = true;
		},

		hide : function() {
			domStyle.set(this.domNode, 'opacity', 0);
			this.defer(function() {
				domStyle.set(this.domNode, 'display', 'none');
				this.expand = false;
			}, 200);

		},

		show : function() {
			if (this.reload && !this.loaded && this.hasChild)
				this.reload();
			domStyle.set(this.domNode, {
				'display' : 'block',
				'opacity' : 1
			});
			this.expand = true;
		}

	});
});