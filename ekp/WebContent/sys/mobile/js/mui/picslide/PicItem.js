define( [ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-style",
		"dojox/mobile/_ItemBase", "mui/util", "dojo/topic" ], function(declare,
		domConstruct, domStyle, ItemBase, util, topic) {
	var PicItem = declare("mui.picslide.PicItem", [ ItemBase ], {

		picClick : "/mui/picitem/click",

		picResizeEvt : "/mui/picitem/resize",

		baseClass : 'muiListPicslideItem',
		
		itemIndex : 0,

		buildRendering : function() {
			this.inherited(arguments);
			this.domNode.tabIndex = "0";
			this.imageNode = domConstruct.create("img", {
				className : "muiListPicItemImg"
			}, this.domNode);
		},

		postCreate : function() {
			this.inherited(arguments);
			this.connect(this.domNode, "onclick", "_onclick");
			this.subscribe(this.picResizeEvt, "_resize");
		},

		startup : function() {
			if (this._started) {
				return;
			}
			this.inherited(arguments);
			this.imageNode.alt = this.alt ? this.alt : this.label;
			this.imageNode.src = this.icon ? this.icon : this.url;
		},

		_resize : function(srcObj,evt) {
			if (evt) {
				var arg = evt;
				if (arg.tensile == false) {
					domStyle.set(this.domNode, {
						"line-height" : arg.height + "px"
					});
					domStyle.set(this.imageNode, {
						"max-height" : arg.height + "px",
						"max-width" : arg.width + "px"
					});
				} else {
					domStyle.set(this.imageNode, {
						"height" : arg.height + "px",
						"width" : arg.width + "px"
					});
				}
			}
		},

		_onclick : function(e) {
			topic.publish(this.picClick,this, this.itemIndex, e);
			if (this.href) {
				e.stopPropagation();
				e.preventDefault();
				location.href = util.formatUrl(this.href);
			}
		},

		_setLabelAttr : function(text) {
			this._set("label", text);
		},

		_setIconAttr : function(icon) {
			this._set("icon", icon);
			this.imageNode.src = this.icon;
		}
	});
	return PicItem;
});