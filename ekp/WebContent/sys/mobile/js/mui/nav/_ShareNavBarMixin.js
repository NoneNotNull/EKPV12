/*******************************************************************************
 * 导航平分插件
 ******************************************************************************/
define(
		"mui/nav/_ShareNavBarMixin",
		[ "dojo/_base/declare", "dojo/_base/array", "dojo/dom-style" ],
		function(declare, array, domStyle) {
			var cls = declare(
					'mui.nav._ShareNavBarMixin',
					null,
					{

						buildRendering : function() {
							this.inherited(arguments);
							this.subscribe('/mui/nav/onComplete', 'onShare')
						},

						onShare : function(obj, evt) {
							var c_w = this.containerNode.offsetWidth, d_w = this.domNode.offsetWidth;
							if (c_w > d_w)
								return;
							var children = this.getChildren();
							var innerWidth = 0;
							array.forEach(children, function(item) {
								var node = item.domNode;
								innerWidth += node.offsetWidth;
							});
							var pd = (c_w - innerWidth) / (children.length * 2);
							array.forEach(children, function(item) {
								var node = item.domNode;
								domStyle.set(node, {
									'margin-left' : pd + 'px',
									'margin-right' : pd + 'px'
								})
							});
						}
					});
			return cls;
		});