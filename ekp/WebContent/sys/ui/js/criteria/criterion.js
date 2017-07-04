define(function(require, exports, module) {

	var base = require("lui/base");
	var element = require("lui/element");
	var $ = require('lui/jquery');
	var select = require('lui/criteria/select_panel');
	
	var Criterion = base.Container.extend({
		className: 'criterion',
		initProps: function($super, cfg) {
			$super(cfg);
			this.criterions = [];
			this.title = cfg.title;
			this.canMulti = cfg.canMulti == 'false' || cfg.canMulti == false ? false : true;
			this.multi = cfg.multi || false;
			this.key = cfg.key;
			this.expand = cfg.expand || false;
		},
		supportMulti: function() {
			return this.selectBox && this.selectBox.supportMulti();
		},
		setMulti: function(multi) {
			this.multi = multi;
			this.selectBox.setMulti(multi);
		},
		isEnable: function() {
			if (!this.selectBox) {
				return true;
			}
			if(!this.selectBox.isEnable)
				return true;
			return this.selectBox.isEnable();
		},
		show: function(show, animate) {
			if (!this.isEnable()) {
				this.element.hide();
				return;
			}
			if (show) {
				if (animate) {
					this.element.slideDown();
				} else {
					this.element.show();
				}
			} else {
				if (animate) {
					this.element.slideUp();
				} else {
					this.element.hide();
				}
			}
		},
		doLayout: function() {
			this.titleBox.setParentNode(this.element);
			this.selectBox.setParentNode(this.element);
			
			this.titleBox.draw();
			this.selectBox.draw();
			if (this.expand) {
				this.show(true, false);
			}
		},
		addChild: function($super, child, attr) {
			$super(child, attr);
			if (attr == null) {
				if (child instanceof CriterionTitleBox) {
					this.setTitleBox(child);
				}
				if (child instanceof CriterionSelectBox) {
					this.setSelectBox(child);
				}
			}
		},
		setSelectBox: function(box) {
			this.selectBox = box;
		},
		setTitleBox: function(box) {
			this.titleBox = box;
		},
		startup: function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.titleBox) {
				this.titleBox = new CriterionTitleBox({parent:this});
				this._startupChild(this.titleBox);
			}
			if (!this.selectBox) {
				this.selectBox = new CriterionSelectBox({parent:this});
				this._startupChild(this.selectBox);
			}
			
			$super();
			return this;
		},
		draw: function() {
			if(this.isDrawed){
				this.fire({"name":"isDrawed"});
				return;
			}
			this.doLayout();
			this.isDrawed = true;
		}
	});
	
	var CriterionTitleBox = base.Container.extend({
		initProps: function($super, cfg) {
			$super(cfg);
			this.title = cfg.title;
		},
		className: 'criterion-title',
		startup: function() {
			if (this.isStartup) {
				return;
			}
			if (this.children.length == 0 
					&& this.element.children().length == 0 
					&& $.trim(this.element.text()) == '') {
				var text = new element.Text({text: this.title || this.parent.title, parent: this, parentNode: this.element});
				this.addChild(text);
			}
			this.isStartup = true;
		},
		draw :function() {
			if(this.isDrawed)
				return this;

			for (var i = 0; i < this.children.length; i++) {
				if(this.children[i].draw) {
					this.children[i].draw();
				}
			}
			this.element.show();
			this.isDrawed = true;
			return this;
		}
	});
	
	var CriterionSelectBox = base.Container.extend({
		className: "criterion-value",
		initProps: function($super, cfg) {
			$super(cfg);
			this.criterionSelectElement = null;
			//this.initCriterionAreas();
		},
		initCriterionAreas: function() {
			this.collapseArea = $("<ul class=\"criterion-collapse\"></ul>").appendTo(this.element);
			this.optionsArea = $("<div class=\"criterion-options\"></div>").appendTo(this.element);
		},
		addChild: function($super, child, attr) {
			$super(child, attr);
			if (attr == null) {
				if (child instanceof select.CriterionSelectDatas) {
					this.setCriterionSelectElement(child);
				}
			}
		},
		setCriterionSelectElement: function(elem) {
			this.criterionSelectElement = elem;
		},
		supportMulti: function() {
			return this.criterionSelectElement.supportMulti();
		},
		setMulti: function(multi) {
			this.criterionSelectElement.setMulti(multi);
		},
		isEnable: function() {
			return this.criterionSelectElement.isEnable();
		},
		startup: function() {
			if (this.isStartup) {
				return;
			}
			this._startupChild(this.criterionSelectElement);
			
			this.isStartup = true;
		},
		draw :function($super){
			if(this.isDrawed)
				return;
			// 构建更多按钮
			this.buildMore();
			this.initCriterionAreas();
			$super();
			if (this.criterionSelectElement) {
				this.criterionSelectElement.setParentNode(this.collapseArea);
				this.criterionSelectElement.draw();
			}
			this.element.show();
		},
		
		// 最大高度转化为高度，便于后面动画实现
		max_height2height : function() {
			if(this.h2h)
				return;
			this.element.css({
				'height' : this.max_height,
				'max-height' : 'none'
			});
			this.h2h = true;
		},
		
		// 高度转换为最大高度
		height2max_height : function() {
			if(!this.h2h)
				return;
			this.element.css({
				'height' : 'auto',
				'max-height' : this.max_height
			});
			this.h2h = false;
		},
		
		// 重置更多按钮
		resetMore : function() {
			this.height2max_height();
			this.toggleHadMoreClass();
			this.resetMoreArrowClass();
		},
		
		// 需要显示更多按钮class
		criterionHadMore : 'criterion-had-more',
		
		arrowClass : 'criterion-more-up',
		
		// 是否显示更多按钮
		toggleHadMoreClass : function() {
			var self = this;
			setTimeout(function() {
				self.orign_height = self.collapseArea.height();
				if (self.orign_height > parseInt(self.max_height))
					self.element
							.addClass(self.criterionHadMore);
				else
					self.element
							.removeClass(self.criterionHadMore);
			}, 201);
		},
		
		// 切换更多按钮样式
		resetMoreArrowClass : function() {
			this.moreArrow.removeClass(this.arrowClass);
			this.isMore = false;
		},
		
		// 构建更多按钮
		buildMore : function() {
			this.moreArea = $("<div class=\"criterion-more\"></div>").appendTo(this.element);
			this.moreArrow = $("<div class=\"criterion-more-down\"></div>").appendTo(this.moreArea);
			this.max_height = this.element.css('max-height');
			var self = this;
			// 监听已加载展开全部条件时事件
			this.parent.on('isDrawed',function(){
				self.resetMore();
			});
			// 监听渲染完后事件，用于判定是否出现更多按钮&还原最大高度
			this.criterionSelectElement.on('load', function() {
				self.resetMore();
			});
			this.bindMore();
		},
		
		// 绑定更多按钮点击事件
		bindMore : function() {
			var self = this;
			this.moreArea.on('click', function(evt) {
						self.max_height2height();
						var height = 0;
						if (self.isMore) {
							height = self.max_height;
							self.isMore = false;
							self.moreArrow.removeClass(self.arrowClass);
						} else {
							height = self.collapseArea.height();
							self.isMore = true;
							self.moreArrow.addClass(self.arrowClass);
						}
						self.element.animate({
									'height' : height
								}, 200);
					});
		}
	});
	
	exports.Criterion = Criterion;
	exports.CriterionTitleBox = CriterionTitleBox;
	exports.CriterionSelectBox = CriterionSelectBox;
});