define([ "dojo/_base/declare", "dojo/dom-construct", "dojo/html",
		"dojox/mobile/_css3", "dojo/dom-style", "dojo/_base/lang" ], function(
		declare, domConstruct, html, css3, domStyle, lang) {
	var claz = declare("mui.property.PropertyDialogMixin", null, {
		modelName : null,

		fdCategoryId : null,
		// 筛选刷新列表
		referListId : null,

		show : function(evt) {
			this.openFilter();
		},

		hideFilter : function() {
			if (!this.dialogDiv)
				return;
			var tmpStyle = {};
			tmpStyle[css3.name('transform')] = 'translate3d(100%, 0, 0)';
			domStyle.set(this.dialogDiv, tmpStyle);
		},

		showFilter : function() {
			if (!this.dialogDiv)
				return;
			var tmpStyle = {};
			tmpStyle[css3.name('transform')] = 'translate3d(0, 0, 0)';
			domStyle.set(this.dialogDiv, tmpStyle);
		},

		openFilter : function() {
			if (this.dialogDiv) {
				this.showFilter();
				return;
			}
			this.subscribe('/mui/property/hide', 'hideFilter');
			var self = this;
			require([ 'dojo/text!mui/property/filter.jsp?modelName='
					+ this.modelName + '&fdCategoryId=' + this.fdCategoryId ],
					function(tmpl) {

						self.dialogDiv = domConstruct.create("div", {
							className : 'muiPropertyFilterDialog'
						}, document.body, 'last');
						var dhs = new html._ContentSetter({
							node : self.dialogDiv,
							parseContent : true,
							cleanContent : true,
							onBegin : function() {
								this.content = lang.replace(this.content, {
									referListId : self.referListId
								});
								this.inherited("onBegin", arguments);
							}
						});
						dhs.set(tmpl);
						dhs.parseDeferred.then(function(results) {
							self.parseResults = results;
							self.showFilter();
						});
						dhs.tearDown();
					});
		}
	});
	return claz;
});