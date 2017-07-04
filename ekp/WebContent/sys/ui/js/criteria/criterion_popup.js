
define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	var base = require("lui/base");
	var popup = require("lui/popup");
	var layout = require("lui/view/layout");
	var criterion = require("lui/criteria/criterion");
	var cbase = require("lui/criteria/base");
	var select_panel = require('lui/criteria/select_panel');
	
	var criteriaGroup = cbase.criteriaGroup;
	var CRITERION_CHANGED = cbase.CRITERION_CHANGED;
	var CriterionSelectDatas = select_panel.CriterionSelectDatas;
	
	var CriterionPopup = criterion.Criterion.extend({
		_className: 'criteria-popup',
		initProps: function($super, cfg) {
			$super(cfg);
			this.element.addClass(this._className);
			if (!this.title)
				this.title = lang['ui.criteria.otherItem'];
			this.setSelectBox(new CriterionPopupSelectBox({parent: this, parentNode: this.element}));
		},
		addChild: function($super, child, attr) {
			if (child instanceof CriterionPopupBox) {
				this.selectBox.addChild(child);
				child.setParentNode(this.selectBox.element.children('.criterion-expand'));
				return;
			}
			$super(child, attr);
			if (attr == null) {
				if (child instanceof CriterionPopupSelectBox) {
					this.setSelectBox(child);
				}
			}
		},
		startup: function($super) {
			$super();
			this.selectBox.element.before(this.titleBox.element);
		}
	});
	
	var CriterionPopupSelectBox = base.Container.extend({
		className: "criterion-value",
		initProps: function($super, cfg) {
			$super(cfg);
			this.element.html("<ul class=\"criterion-expand\"></ul>");
		},
		supportMulti: function() {
			return this.children.length > 0;
		},
		setMulti: function(multi) {
			for (var i = 0; i < this.children.length; i ++) {
				var child = this.children[i];
				if (child.supportMulti && child.supportMulti()) {
					child.setMulti(multi);
				}
			}
		},
		draw: function() {
			for (var i = 0; i < this.children.length; i ++) {
				this.children[i].draw();
			}
			this.element.show();
		}
	});
	
	var CriterionPopupBox = base.Container.extend({
		className: "criterion-popup-box",
		_isCriterionProxy: true,
		initProps: function($super, cfg) {
			$super(cfg);
			this.criterionSelectElement = null;
			this.title = cfg.title || null;
			this.key = cfg.key || null;
			this.multi = cfg.multi || false;
			this.popup = null;
		},
		setPopup: function(popup) {
			this.popup = popup;
		},
		addChild: function($super, child, attr) {
			$super(child, attr);
			if (attr == null) {
				if (child instanceof popup.Popup) {
					this.setPopup(child);
				}
			}
		},
		supportMulti: function() {
			return this.criterionSelectElement && this.criterionSelectElement.supportMulti();
		},
		setMulti: function(multi) {
			this.multi = multi;
			this.criterionSelectElement.setMulti(multi);
		},
		onSelected: function(evt) {
			if (evt.src == this.criterionSelectElement.selectedValues) {
				if (evt.values != null && evt.values.length > 0) {
					if (!this.element.find('li > a').hasClass('selected'))
						this.element.find('li > a').addClass('selected');
				} else {
					this.element.find('li > a').removeClass('selected');
				}
			}
		},
		startup: function($super) {
			$super();
			if (!this.layout) {
				this.layout = new layout.Template({src:require.resolve('./template/criterion-popup-cell.html#'), parent: this});
				this.layout.startup();
			}
			
			// find criterionSelectElement
			if (!this.popup) {
				this.addChild(new popup.Popup({"borderWidth": 1, parent: this}));
			}
			var pcs = this.popup.children;
			for (var i = 0; i < pcs.length; i ++) {
				if (pcs[i] instanceof CriterionSelectDatas) {
					this.setCriterionSelectElement(pcs[i]);
					break;
				}
			}
			console.info(this.criterionSelectElement, this.popup.children);
			criteriaGroup(this).subscribe(CRITERION_CHANGED, this.onSelected, this);
		},
		setCriterionSelectElement: function(selectDatas) {
			this.criterionSelectElement = selectDatas;
			selectDatas.title = this.title;
			selectDatas.key = this.key;
		},
		doLayout: function($super, html) {
			this.element.append(html);
			// 需要重构改进
			// this.popup.setParentNode(document.body);
			this.popup.positionObject = this.element.find('.popup-area');
			this.popup.element.css('background-color', '#fff');
			$super(html);
			if (this.criterionSelectElement) {
				this.criterionSelectElement.element.addClass('criteria-popup-value');
				this.criterionSelectElement.element.css('background-color', '#fff');
				this.criterionSelectElement.draw();
			}
			var self = this;
			this.popup.on("show", function() {
				self.element.find('.popup-area').css('border-color', '#fff');
			});
			this.popup.on("hide", function() {
				self.element.find('.popup-area').css('border-color', '');
			});
			
			this.resizeWidth();
			
			this.element.show();
		},
		
		// 弹出框宽度少于源对象，设置最小宽度
		resizeWidth : function() {
			var self = this;
			this.on('load', function() {
				var sourceWidth = self.popup.positionObject.outerWidth();
				self.popup.element.css('min-width', sourceWidth);
			});
			return this;
		},
		
		isEnable: function() {
			return this.criterionSelectElement.isEnable();
		}
	});
	
	exports.CriterionPopup = CriterionPopup;
	exports.CriterionPopupSelectBox = CriterionPopupSelectBox;
	exports.CriterionPopupBox = CriterionPopupBox;
});