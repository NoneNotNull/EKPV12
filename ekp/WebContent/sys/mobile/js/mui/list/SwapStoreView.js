define([
	'dojo/_base/declare', 
	'dojo/_base/lang',
	'dijit/_WidgetBase',
	'dojox/mobile/SwapView'
	], function(declare, lang, WidgetBase, SwapView) {
	
	var topicOnSwap = 'mui/list/onListSwaped';
	
	var topicOnFilter = '/mui/list/_onFilter';
	
	return declare('mui.list.SwapStoreView', [WidgetBase], {
		
		baseCloneList: null,
		
		postCreate: function() {
			this.inherited(arguments);
			// 绑定nav加载完成事件
		},
		
		startup: function() {
			if(this._started){
				return;
			}
			this.inherited(arguments);
			
		},
		
		createLists: function() {
			// 创建swap对象
			// 通过clone动态创建list
			// 设置list为swap的子对象
			// 替换list的onfilter 做界面切换，然后再刷新
		}
		
	});
});