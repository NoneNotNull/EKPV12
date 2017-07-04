define([ "dojo/_base/declare", "dojox/mobile/_ItemBase", "dojo/dom-construct",
		"dojo/string", "dojo/dom-class", "dojo/touch", "mui/util",
		"dojo/request", "mui/rtf/RtfResizeUtil", "dojo/_base/lang" ], function(
		declare, ItemBase, domConstruct, string, domClass, touch, util,
		request, RtfResizeUtil, lang) {
	var item = declare("kms.ask.item.AskAdditionItemMixin", [ ItemBase ], {

		tag : "li",

		buildRendering : function() {
			this._templated = !!this.templateString;
			if (!this._templated) {
				this.domNode = this.containerNode = this.srcNodeRef
						|| domConstruct.create(this.tag, {
							className : 'muiAskAdditionItem'
						});
				this.contentNode = domConstruct.create('div', {
					className : 'muiAskAdditionListItem'
				}, this.domNode);
			}
			this.inherited(arguments);
			if (!this._templated)
				this.buildInternalRender();
		},

		buildInternalRender : function() {

			this.infoNode = domConstruct.create('div', {
				className : 'muiAskInfo'
			}, this.containerNode);
			this.contentNode = domConstruct.create('div', {
				className : 'muiAskContent',
				innerHTML : this.docContent + '<span class="muiAskTime">'
						+ this.fdTime + '</span>'
			}, this.infoNode);
			var resize = new RtfResizeUtil({
				channel : 'ask',
				containerNode : this.contentNode
			});

			this.subscribe('/mui/list/onPull', lang.hitch(resize,
					resize.destroy));
		},

		_setLabelAttr : function(text) {
			if (text)
				this._set("label", text);
		}
	});
	return item;
});