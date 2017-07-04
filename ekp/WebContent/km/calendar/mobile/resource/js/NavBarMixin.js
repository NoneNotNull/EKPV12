define(['dojo/_base/declare','dojo/dom-style','dojo/dom-construct'],
		function(declare,domStyle,domConstruct){
	
	return declare('km.calendar.mobile.resource.js.NavBarMixin',null,{
		
		buildRendering:function(){
			this.inherited(arguments);
			
			//自定义选中节点(覆盖原来的样式)
			domConstruct.destroy(this.selectedNode);
			this.selectedNode=domConstruct.create('div', {
				className : 'muiCalendarNavBarSelected'
			}, this.domNode);
			domConstruct.create('i', {
				className : 'arr arrM'
			}, this.selectedNode);
			domConstruct.create('i', {
				className : 'arr arrC'
			}, this.selectedNode);
		}
		
		
	});
	
	
	
});