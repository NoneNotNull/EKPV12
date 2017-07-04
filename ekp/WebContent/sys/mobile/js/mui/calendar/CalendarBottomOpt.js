define(['dojo/_base/declare','dijit/_WidgetBase','dijit/_Contained','dojo/dom-construct'],
		function(declare,WidgetBase,Contained,domConstruct){
	
	return declare('mui.calendar.CalendarBottomOpt',[WidgetBase,Contained],{
		
		startup:function(){
			var parent=this.getParent();
			if(parent){
				domConstruct.place(this.srcNodeRef, parent.eventNode,"last");
			}
		}
		
	});
	
});