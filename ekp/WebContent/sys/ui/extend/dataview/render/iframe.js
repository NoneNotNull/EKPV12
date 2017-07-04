var iframeObj = null;
var iframeLoad = null;
var heig = render.parent.element.parent().height();
if(data.src!=null){
	var resizeFun=function(argu){
		iframeObj.css({"height":argu.height});
	};
	var src = env.fn.formatUrl(data.src);
	var tempData = [];
	tempData["lui.element.id"] = render.parent.id;
	var new_src = env.fn.variableResolver(src,tempData);
	var frameName = "";
	if($.trim(render.vars.frameName) != ""){
		frameName = "name='"+$.trim(render.vars.frameName)+"'";
	} 
	if(new_src.indexOf('='+render.parent.id)>-1){		
		iframeObj = $('<iframe width="100%" height="100%" src="'+new_src+'" scrolling="no" frameborder="0" '+frameName+'></iframe>');
		render.parent.on('resize',resizeFun,render);
		render.parent.onErase(function(){render.parent.off('resize', resizeFun);});
	}else{
		//debugger;
		if(data.height!=null){
			heig = data.height;
		}
		iframeObj = $('<iframe width="100%" height="'+heig+'" src="'+new_src+'" scrolling="auto" frameborder="0" '+frameName+'></iframe>');
	}
	iframeLoad = $("<img style='position: absolute;' src='"+env.fn.formatUrl('/sys/ui/js/ajax.gif')+"' />");
	iframeObj.load(function(){
		iframeLoad.remove();
	});
}
done(iframeObj);
render.parent.element.prepend(iframeLoad);