define(
		[ "dojo/_base/declare", "dojo/_base/lang", "dojo/dom-construct",
				"dojo/dom-attr", "dojo/topic", "dojo/touch",
				"dijit/_WidgetBase", "dojo/dom-style", "dojo/dom-class",
				"dojo/_base/Deferred" ],
		function(declare, lang, domConstruct, domAttr, topic, touch,
				WidgetBase, domStyle, domClass, Deferred) {

			var Rating = declare(
					"mui.rating.Rating",
					[ WidgetBase ],
					{

						icon : "mui mui-star-on mui-2",

						// 最大分数
						numStars : 5,

						value : 0,

						baseClass : "muiRating",

						editable : false,

						// 未选中类名
						classOff : 'muiRatingOff',
						// 选中类名
						classOn : 'muiRatingOn',

						eventName : "/mui/rating/ratingSelected",

						// 等级对象集合
						ratings : [],

						unratings : [],

						buildRendering : function() {
							this.inherited(arguments);
							this.starArea = domConstruct.create("div", {
								className : "muiRatingArea"
							}, this.domNode);
							this.buildStarts(this.classOff, this.starArea,
									!this.editable);
						},

						buildStarts : function(className, node, editable) {

							if (editable) {
								if (this.value % 1 > 0) {
									this.nbuildStartsHarf(node);
								} else {
									this.nbuildStarts(node);
								}
								return;
							}
							domStyle.set(this.domNode, {
								position : 'relative'
							});
							for (var i = 0; i < this.numStars; i++) {
								var rating = domConstruct.create("i", {
									className : this.icon + " " + className,
									score : (i + 1)
								}, node);
								this.connect(rating, touch.release,
										"_selectStar");
								if (className == this.classOff)
									this.unratings.push(rating);
								if (className == this.classOn)
									this.ratings.push(rating);
							}
						},

						nbuildStarts : function(node) {
							for (var i = 0; i < this.value; i++) {
								var star = domConstruct.create("i", {
									className : this.icon + " " + this.classOn
								}, node);
							}
							var len = this.numStars - this.value;
							for (var j = 0; j < len; j++) {
								var star = domConstruct.create("i", {
									className : this.icon + " " + this.classOff
								}, node);
							}
						},

						// 构建有小数点的星星分数
						nbuildStartsHarf : function(node) {
							var onStarsNum = parseInt(this.value);
							var percent = this.value % 1;
							var offStarsNum = this.numStars - onStarsNum - 1;
							for (var i = 0; i < onStarsNum; i++) {
								var star = domConstruct.create("i", {
									className : this.icon + " " + this.classOn
								}, node);
							}
							// 构建残缺星星
							var harfStar = domConstruct.create("span", {
								className : this.icon + " " + this.classOff
										+ " mulRatingHarfContainer"
							}, node);
							var harfStarOn = domConstruct.create("span", {
								className : this.icon + " " + this.classOn
										+ " mulRatingHarf"
							}, harfStar);
							domStyle.set(harfStarOn, {
								width : (percent / 1) * 100 + "%",
								margin : 0
							});
							domStyle.set(this.starArea, {
								"text-align" : "center"
							});
							for (var j = 0; j < offStarsNum; j++) {
								var star = domConstruct.create("i", {
									className : this.icon + " " + this.classOff
								}, node);
							}
						},

						_setValueAttr : function(value) {
							this._set("value", value);
							if (this.Value == 0 || !this.editable)
								return;
							if (this.valArea == null) {
								this.valArea = domConstruct.create("div", {
									className : "muiRatingValue"
								}, this.domNode);
								this.buildStarts(this.classOn, this.valArea);
							}
							this.valArea.style.width = (parseFloat(this.value) / parseFloat(this.numStars))
									* 100 + "%";

							var value = parseInt(this.value);
							var self = this;
							var scaleClass = 'muiRatingScale', hideClass = "muiRatingHide";
							for (var i = 0; i < value; i++) {
								~~function(i) {
									return function() {
										var def = new Deferred();
										def.then(function() {
											domClass.remove(self.unratings[i],
													hideClass);
											domClass.remove(self.ratings[i],
													scaleClass);
										});

										self.defer(function() {
											domClass.add(self.unratings[i],
													hideClass);
											domClass.add(self.ratings[i],
													scaleClass);
											self.defer(function() {
												def.resolve();
											}, 200);
										}, i * 200);
									}();
								}(i);
							}
						},

						_selectStar : function(evt) {
							var star = evt.target || evt.srcElement;
							value = domAttr.getNodeProp(star, "score");
							this.set("value", parseInt(value, 10));
							topic.publish(this.eventName, this);
						}
					});

			return Rating;

		});
