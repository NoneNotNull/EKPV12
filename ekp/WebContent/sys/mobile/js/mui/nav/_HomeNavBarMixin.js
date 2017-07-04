define([ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-style",
		"mui/header/HeaderItem", "mui/folder/_Folder", "dojo/_base/lang",
		"mui/back/HrefBackMixin", "dojo/topic", "mui/util" ], function(declare,
		domConstruct, domStyle, HeaderItem, _Folder, lang, HrefBackMixin,
		topic, util) {
	var cls = declare('mui.nav._HomeNavBarMixin', null, {

		homeClick : null,

		homeIcon : 'mui mui-home-opposite',

		addFirstChild : function(item) {
			this.firstItem = item;
			domStyle.set(item.domNode, 'display', 'none');
			this.addChild(item);
			this.subscribe('/mui/nav/onComplete', 'buildHomeBtn');
		},

		homeItemClick : function(e) {
			var item = this.firstItem;
			topic.publish('/mui/navitem/_selected', item, {
				width : 0,
				left : 0,
				target : item,
				url : item.url
			});
			if (window[this.homeClick])
				window[this.homeClick]();
			else if ('[object Function]' == Object.prototype.toString
					.call(this.homeClick)) {
				this.homeClick();
			} else
				new Function(this.homeClick)();
		},

		buildHomeBtn : function() {
			var mixins = [ _Folder, HrefBackMixin ];
			HeaderItem = HeaderItem.createSubclass(mixins);
			var item = new HeaderItem({
				icon : this.homeIcon,
				click : lang.hitch(this, this.homeItemClick),
				url : util.formatUrl(this.firstItem.url),
				moveTo : this.firstItem.moveTo
			});
			item.buildRendering();
			item.startup();
			domConstruct.place(item.domNode, this.domNode, 'before');
		}
	});
	return cls;
});