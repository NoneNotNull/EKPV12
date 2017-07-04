define([ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
		"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
		"mui/util", "mui/rating/Rating" ], function(declare, domConstruct,
		domClass, domStyle, domAttr, ItemBase, util, Praise) {
	var item = declare("sys.introduce.IntroduceItemMixin", [ ItemBase ], {
		tag : "li",
		// 简要信息
		summary : "",
		// 创建时间
		created : "",
		// 推荐分数
		score : 0,
		// 标题
		label : "",
		// 创建者图像
		icon : "",
		// 去除焦点虚线框
		tabIndex : "",
		// 被推荐人名单
		introduceGoalNames : "",
		// 推荐类型
		introduceType : "",

		buildRendering : function() {
			this._templated = !!this.templateString;
			if (!this._templated) {
				this.domNode = this.containerNode = this.srcNodeRef
						|| domConstruct.create(this.tag, {
							className : 'muiIntroduceItem'
						});
			}
			this.inherited(arguments);
			if (!this._templated)
				this.buildInternalRender();
		},
		buildInternalRender : function() {
			if (this.icon) {
				var imgDivNode = domConstruct.create("div", {
					className : "muiIntroduceIcon"
				}, this.containerNode);
				this.imgNode = domConstruct.create("img", {
					className : "muiIntroduceImg",
					src : this.icon
				}, imgDivNode);
			}

			if (this.label) {
				domConstruct.create("span", {
					className : "muiIntroduceLabel muiAuthor",
					innerHTML : this.label
				}, this.domNode);
			}

			// 半月遮
			domConstruct.create('div', {
				className : 'muiIntroduceRound'
			}, this.domNode);

			this.contentNode = domConstruct.create('div', {
				className : 'muiIntroduceContent'
			}, this.domNode, 'last');

			this.infoNode = domConstruct.create('div', {
				className : 'muiIntroduceInfo'
			}, this.contentNode);

			if (this.summary) {
				this.summaryNode = domConstruct.create("p", {
					className : "muiIntroduceSummary",
					innerHTML : this.summary
				}, this.infoNode);
			}
			var praise = domConstruct.create("span", {
				className : "muiIntroduceScore"
			}, this.infoNode);
			var widget = new Praise({
				numStars : 3,
				value : 3 - parseInt(this.score, 10),
				icon : 'mui mui-2 mui-praise',
				baseClass : 'muiIntroduceScoreArea'
			});
			praise.appendChild(widget.domNode);

			if (this.created) {
				this.createdNode = domConstruct.create("div", {
					className : "muiIntroduceCreated",
					innerHTML : '<i class="mui mui-time"></i>' + this.created
				}, this.infoNode);
			}

			// 推荐对象
			this.targetNode = domConstruct.create('div', {
				className : 'muiIntroduceTarget',
				innerHTML : '<span class="muiIntroduceTargetTitle">推荐对象：</span>'
			}, this.contentNode, 'last');

			// 推荐类型
			if (this.introduceType) {
				this.introduceTypeNode = domConstruct.create('span', {
					className : 'muiIntroduceTargetType',
					innerHTML : this.introduceType
				}, this.targetNode, 'last');
			}

			// 被推荐人员
			if (this.introduceGoalNames) {
				this.introduceGoalNamesNode = domConstruct.create('span', {
					className : 'muiIntroduceTargetName',
					innerHTML : this.introduceType ? '，'
							+ this.introduceGoalNames : this.introduceGoalNames
				}, this.targetNode, 'last');
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