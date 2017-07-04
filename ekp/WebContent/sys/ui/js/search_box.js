

define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	require('lui/search/search.css');
	var render = require('lui/view/render');
	var source = require('lui/data/source');
	var base = require("lui/base");
	var topic = require("lui/topic");
	var $ = require('lui/jquery');

	var SearchBox = base.DataView.extend({

		className : 'search-box',

		initProps : function($super, cfg) {
			$super(cfg);
			this.placeholder = cfg.placeholder || lang['ui.criteria.insert'];
			this.topic = cfg.topic;
			this.searchText = cfg.searchText || 'searchText';

			var css = {};
			var inputCss = {};
			var btnCss = {};
			if (cfg.width)
				inputCss.width = cfg.width;
			if (cfg.height) {
				inputCss.height = cfg.height;
				btnCss.height = cfg.height;
			}
			if (cfg.backgroundColor)
				css.backgroundColor = cfg.backgroundColor;
			this.css = css;
			this.inputCss = inputCss;
			this.btnCss = btnCss;
		},

		startup : function($super) {
			if (!this.render) {
				this.setRender(new render.Template({
					code : "{$<input type=\"text\" class=\"search-box-text\" placeholder=\"{%data[0].placeholder%}\" />"
							+ "<input type=\"button\" class=\"search-box-cancel\" title=\""+lang['ui.search.cancel']+"\" />"
							+ "<input type=\"button\" class=\"search-box-btn\" title=\""+lang['ui.search.doit']+"\" />$}",
					parent : this
				}));
				this.render.startup();
			}
			if (!this.source) {
				this.setSource(new source.Static({
							datas : [{
										'placeholder' : this.placeholder
									}],
							parent : this
						}));
				if(this.source.startup)
					this.source.startup();
			}
			$super();
		},

		doRender : function($super, html) {
			$super(html);
			var self = this;
			this.element.css(this.css);

			this.element.find('.search-box-text').bind('keyup', function(evt) {
						self.onEnter(evt);
					}).css(this.inputCss);

			this.element.find('.search-box-btn').bind('click', function(evt) {
						self.onClick(evt);
					}).css(this.btnCss);

			this.element.find('.search-box-cancel').bind('click',
					function(evt) {
						self.onCancel(evt);
					}).css(this.btnCss);
			LUI.placeholder(this.element);
			this.synchButton();
		},

		synchButton : function(invert) {
			if (this.element.find('.search-box-text').val() != '') {
				this.element.find('.search-box-cancel').show();
				this.element.find('.search-box-btn').hide();
			} else {
				this.element.find('.search-box-cancel').hide();
				this.element.find('.search-box-btn').show();
			}
		},

		onCancel : function(evt) {
			this.element.find('.search-box-text').val('');
			this.onSearch(evt);
		},

		onClick : function(evt) {
			this.onSearch(evt);
		},

		onEnter : function(evt) {
			if (evt.keyCode == 13) {
				this.onSearch(evt);
			} else {
				this.element.find('.search-box-cancel').hide();
				this.element.find('.search-box-btn').show();
			}
		},

		onSearch : function(evt) {
			var text = this.element.find('.search-box-text').val(), evtDatas = {};
			// 防止多次转码
			evtDatas[this.searchText] = text;
			this.emit('search.changed', evtDatas);
			if (this.topic) {
				var topicEvent = {
					query : [],
					queryType : 'add'
				};
				topicEvent.query.push({
							key : this.searchText,
							value : [text]
						});
				topic.channel(this).publish(this.topic, topicEvent);
			}
			this.synchButton();
		}

	});

	exports.SearchBox = SearchBox;
});