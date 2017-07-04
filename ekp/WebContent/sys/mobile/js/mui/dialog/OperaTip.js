define([ "dojo/_base/declare", "dojo/_base/lang", "dojo/dom-class",
		"dojo/dom-construct", "dojo/dom-style", "mui/dialog/_DialogBase",
		"dojo/_base/window", "dojo/_base/fx", "mui/util", "dojo/touch",
		"dojo/_base/array", "dojo/dom-geometry" ], function(declare, lang,
		domClass, domConstruct, domStyle, _DialogBase, win, fx, util, touch,
		array, domGeom) {

	var OperaTip = declare('mui.dialog.OperaTip', [ _DialogBase ], {

		baseClass : "muiDialogOperationTip",

		refNode : null,

		pos : 'left',

		operas : [],

		buildRendering : function() {
			if (this.operas.length == 0)
				return;
			this.inherited(arguments);
			this.domNode = domConstruct.create('div', {
				className : 'muiDialogOperationTip'
			}, document.body);

			this.operaNode = domConstruct.create('div', {
				className : 'muiDialogOperationContainer'
			}, this.domNode);
			array.forEach(this.operas, function(item) {
				var opera = domConstruct.create('div', {
					className : 'muiDialogOperationButton',
					innerHTML : '<span class="' + item.icon
							+ ' mui"></span>&nbsp;' + item.text
				}, this.operaNode);
				if (item.func)
					this.connect(opera, 'click', function(evt) {
						item.func(evt);
					});
			}, this);
		},

		show : function() {
			if (!this.domNode)
				return;
			var ref = this.refNode;
			var pos = domGeom.position(ref);
			var w = util.getScreenSize().w;
			domStyle.set(this.domNode, {
				top : pos.y + 'px',
				right : w + 10 - pos.x + 'px'
			});

			domStyle.set(this.operaNode, {
				'-webkit-transform' : 'translate3d(0,0,0)'
			});

			this.handle = this.connect(document.body, touch.press,
					'onBodyClick');
			this.inherited(arguments);
			return this;
		},

		hide : function() {
			domStyle.set(this.operaNode, {
				'-webkit-transform' : 'translate3d(100%,0,0)'
			});
			this.defer(function() {
				this.disconnect(this.handle);
				domConstruct.destroy(this.domNode);
				this.domNode = null;
				this.destroy();
			}, 200);
			this.inherited(arguments);
			return this;
		},

		onBodyClick : function(evt) {
			var target = evt.target, isHide = true;
			while (target) {
				if (target == this.domNode) {
					isHide = false;
					break;
				}
				target = target.parentNode;
			}
			if (isHide) {
				this.defer(function() {
					this.hide();
				}, 500);
			}
		}
	});

	return {
		tip : function(options) {
			return new OperaTip(options).show();
		},
		OperaTip : OperaTip
	};

})