(function($) {
		
$.fn.tabview = function(options) {
	var tabview = new TabView($(this), options);
	tabview.init();
};	
	
var TabView = EventTarget.extend({
	constructor: function(context, options) {
		this.options =  {
				delay: 500								// tab切换默认的延迟时间
				//onTweakEnter							// 当切换tab的时候，执行的函数
		};	
		this.context = $(context);
		this.tabList = [];
		this.selectedTab = null;
		this.timeoutId = null;
		this.base(options);
	},
	
	init: function(n) {
		var o = this, tab = null, elem, target;
		this.context.addClass("tabview");
		this.context.find(".tab_ul a").each(function(n) {
			elem = $(this);
			target =  $("#" + elem.attr('rel'));
			target.addClass("tabcontent");
			//target.hide();
			tab = {
				tabli: elem.parent(),
				tabref: elem,
				target: target,
				selected: false
			};	
			o.tabList[n] = tab;
			
			// 注册事件监听
			elem.bind("mouseover", o.onMouseover.binding(o, n));
			elem.bind("mouseout", o.onMouseout.binding(o));
			//elem.bind("mouseleave", o.bounds.tweakLeave);
		});
		// 初始化第一个tab
		this.showTab(n);
	},
	
	showTab: function(n)  {
		var tab = this.tabList[n];
		
		if (this.selectedTab == tab) {
			return;
		}
		
		tab["tabli"].addClass("selectTag");
		tab["target"].addClass("selectTag");
		//tab["target"].show();
		// 移除之前存在的tab
		if (this.selectedTab != null) {
			this.selectedTab["tabli"].removeClass("selectTag");
			this.selectedTab["target"].removeClass("selectTag");
		}
		this.selectedTab = tab;
		
		this.fireEvent("onTabshow", tab);
	},
	
	onMouseover: function(n, event) {
		var self = this;
		this.timeoutId = setTimeout(function() {
			self.showTab(n);
			self.fireEvent("onTweakEnter");
		}, this.options.delay);
	}, 
	
	onMouseout: function(event) {
		window.clearTimeout(this.timeoutId);
	}
	
});

KMS.TabView = TabView;
}(jQuery));