define([ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
		"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
		"mui/rating/Rating", "mui/util" ], function(declare, domConstruct,
		domClass, domStyle, domAttr, ItemBase, Rating, util) {
	var item = declare("sys.evaluation.EvaluationItemMixin", [ ItemBase ], {
		tag : "li",
		// 简要信息
		summary : "",
		// 创建时间
		created : "",
		// 点评分数
		score : 0,
		// 标题
		label : "",
		// 创建者图像
		icon : "",
		tabIndex : "",

		// pc端表情src
		faceUrl : '/sys/evaluation/import/resource/images/bq/',

		// /\[face/g,'<img src="' +
		// Com_Parameter.ContextPath +
		// 'sys/evaluation/import/resource/images/bq/')
		// .replace(/\]/g,'.gif" type="face"></img>'

		buildRendering : function() {
			this._templated = !!this.templateString;
			if (!this._templated) {
				this.domNode = this.containerNode = this.srcNodeRef
						|| domConstruct.create(this.tag, {
							className : 'muiEvaluationItem'
						});
			}
			this.inherited(arguments);
			if (!this._templated)
				this.buildInternalRender();
		},
		buildInternalRender : function() {
			if (this.icon) {
				var imgDivNode = domConstruct.create("div", {
					className : "muiEvaluationIcon"
				}, this.containerNode);
				this.imgNode = domConstruct.create("img", {
					className : "muiEvaluationImg",
					src : this.icon
				}, imgDivNode);
			}
			this.contentNode = domConstruct.create('div', {
				className : 'muiEvaluationContent'
			}, this.domNode, 'last');
			if (this.label) {
				this.labelNode = domConstruct.create("h2", {
					className : "muiEvaluationInfo"
				}, this.contentNode);
				domConstruct.create("span", {
					className : "muiEvaluationLabel muiAuthor",
					innerHTML : this.label
				}, this.labelNode);
				var star = domConstruct.create("span", {
					className : "muiEvaluationScore"
				}, this.labelNode);
				var widget = new Rating({
					value : 5 - parseInt(this.score, 10)
				});
				star.appendChild(widget.domNode);
			}

			if (this.created) {
				this.createdNode = domConstruct.create("div", {
					className : "muiEvaluationCreated",
					innerHTML : '<i class="mui mui-time"></i>' + this.created
				}, this.contentNode);
			}

			if (this.summary) {
				this.summaryNode = domConstruct.create("p", {
					className : "muiEvaluationSummary",
					innerHTML : this.summary.replace(/\[face/g,
							'<img src="' + util.formatUrl(this.faceUrl))
							.replace(/\]/g, '.gif" type="face"></img>')
				}, this.contentNode);
			}
		},

		startup : function() {
			if (this._started) {
				return;
			}
			this.inherited(arguments);
		},

		_setLabelAttr : function(text) {
			if (text)
				this._set("label", text);
		}
	});
	return item;
});