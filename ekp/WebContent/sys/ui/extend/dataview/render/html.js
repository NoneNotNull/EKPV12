var instances;
var heig = render.parent.element.parent().height();
var scroll = (function(){
		try{
			return render.parent.parent.config.scroll;
		}catch(e){}
		return true;
	})();
var hscroll = "";
if(scroll==false){
	hscroll = " overflow-y:hidden;";
}
var dom = $("<div class='lui_dataview_html_div' style='min-height:"+heig+"px;"+hscroll+"'>"+data.html+"</div>");
dom.find("[data-lui-mark='panel.dataview.height']").css("min-height",heig);
done(dom); 
seajs.use(['lui/parser'],function(parser){				
	parser.parse(render.parent.element,function(_instances){
		instances = _instances;
	});
});
render.parent.onErase(function(){
	for (var i in instances){
		instances[i].destroy();
	}		
});