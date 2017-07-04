(function($) {
var Port = EventTarget.extend({
	constructor: function(context, options) {
		this.options = {
			rowsize: 8,
			use: ""
			// onRenderComplete: function() {}
		};
		
		this.context = $(context);
		
		this.base(options);
		this.loadData();
	},
	
	loadData: function() {
		var dataSource = this.options.dataSource;
		// 默认参数
		var defaults = {
			rowsize: this.options.rowsize	
		};
		
		$.extend(dataSource.data, defaults);
		$.ajax({
			type: 'GET',
			url: dataSource.url,
			data: dataSource.data,
			cache: false,
			beforeSend: this.onBeforeSend.binding(this),
			success: this.onDataLoad.binding(this),
			error: this.onErrorLoad.binding(this)
		});
	},
	
	onBeforeSend: function() {
		//var loadImg = "<div class=\"port_loading\" />";
		//this.port.html(loadImg);
	},
	
	onDataLoad: function(data, textStatus, XMLHttpRequest) {
		if (data) {
			this.renderData(data);
		}
	},
	
	onErrorLoad: function(XMLHttpRequest, textStatus, errorThrown) {
	},
	
	renderData: function(dataset) {
		var tmpl = this.options.use;
		// 数据行替换模板
		if (tmpl != '') {
			var html = $.getTemplate(tmpl).render(dataset);
			this.context.html(html);
		}
		//this.renderComplete();
		this.fireEvent("renderComplete");
	},
	
	renderComplete: function() {
		//var self = this;
		//var auto = this.options.auto;
		// 判断是否允许自动刷新
//		if (auto) {
//			var period = auto * 60 * 1000;
//			this.refresh.delay(period, this);
//		}
		//this.fireEvent("onRenderComplete");
	}
});

KMS.Port = Port;
}(jQuery));