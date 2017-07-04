define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-construct",
		"dojo/dom-style" ], function(declare, _WidgetBase, domConstruct,
		domStyle) {

	return declare("mui.attachment.PageSlider", [ _WidgetBase ],
			{
				baseClass : "mblSlider muiAttViewerPageSlider",

				buildRendering : function() {
					this.inherited(arguments);
					this.subscribe('/mui/attachment/viewer/pageChange',
							'pageChange');
					this.subscribe('/mui/attachment/viewer/iframeLoaded',
							'iframeLoad');
				},

				change : function(evt) {
					this.max = evt.pageCount;
					if (this.pageNode)
						this.pageNode.innerHTML = evt.pageNum + '/'
								+ evt.pageCount;
				},

				iframeLoad : function(obj, evt) {
					if (evt == null)
						return;
					var scale = evt.scale;
					this.scale(scale);
				},

				scale : function(scale) {
					this.pageNode = domConstruct.create('div', {
						className : 'muiAttViewerPage'
					}, this.domNode, 'after');
					domStyle.set(this.pageNode, {
						'font-size' : parseFloat(domStyle.get(this.pageNode,
								'font-size'))
								* scale + 'px',
						'padding-right' : parseFloat(domStyle.get(
								this.pageNode, 'padding-right'))
								* scale + 'px'
					});
				},

				pageChange : function(obj, evt) {
					if (!evt)
						return;
					this.change(evt);
				}

			});
})