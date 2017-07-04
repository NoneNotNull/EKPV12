var element = render.parent.element;
if(data==null || data.length==0){
	done();
	return;
}

var cssExtend = "";			//CSS后缀
var iconChange = false;		//图标无切换效果
var showMore = false;		//不显示更多菜单
var target = "_blank";		//目标帧
var width  = element.parent().width();	//容器宽度
var height = element.parent().height();	//容器高度
var cellWidth = 0;			//单个格子宽度，含外框
var cellHeight = 0;			//单个格子高度，含外框
var space = 0;				//格子间隔/2
var endSpace = 0;			//右边空余的像素
var showCount = 0;			//能显示的格子个数

if(param.extend!=null){
	cssExtend = "_" + param.extend;
}
iconChange = (param.iconChange==true || param.iconChange=='true');
showMore = (param.showMore==true || param.showMore=='true');
if(render.vars!=null){
	if(render.vars.showMore!=null){
		showMore = (render.vars.showMore=="true");
	}
	if(render.vars.target!=null){
		target = render.vars.target=='auto'?null:render.vars.target;
	}
}
element.html('');
var picMenuListDiv = $('<div>').attr('class', 'lui_dataview_picmenulist'+cssExtend)
		.appendTo(element);
buildFirstMenu();
buildNextMenu();
buildMoreMenu();
done();

//构造一个菜单
function buildMenu(oneData, isMore, isFirst){
	var text = env.fn.formatText(oneData.text);
	var topDivClass = 'lui_dataview_picmenu' + (oneData.selected?'_selected':(isMore?'_more':''));
	var topDiv = $("<div/>").attr({'class':topDivClass, 'title':oneData.text});
	if(isMore)
		topDiv.attr('data-lui-switch-class',"lui_dataview_picmenu_more_on");
	if(!isFirst){
		topDiv.css({'paddingLeft':space,'paddingRight':space});
	}
	var bodyDiv = $("<div/>").attr({'class':'lui_dataview_picmenu_left'}).appendTo(topDiv);;
	bodyDiv = $("<div/>").attr({'class':'lui_dataview_picmenu_right'}).appendTo(bodyDiv);
	bodyDiv = $("<div/>").attr({'class':'lui_dataview_picmenu_content'}).appendTo(bodyDiv);
	
	var iconDiv = $('<div>').attr('class','lui_icon_l')
			.appendTo(bodyDiv);
	$('<div>').attr('class', 'lui_icon_l '+oneData.icon)
			.appendTo(iconDiv);
	
	var textDiv = $('<div>').attr('class', 'textEllipsis lui_dataview_picmenu_txt')
			.appendTo(bodyDiv);
	textDiv.text(oneData.text);
	
	topDiv.mouseover(function(){
		if(iconChange){
			iconDiv.addClass('lui_icon_on');
		}
		if(!isMore)
			topDiv.attr('class', topDivClass + '_on');
	});
	topDiv.mouseout(function(){
		if(iconChange){
			iconDiv.removeClass('lui_icon_on');
		}
		if(!isMore)
			topDiv.attr('class',topDivClass);
	});
	if(oneData.href!=null){
		topDiv.click(function(){
			if(oneData.href.toLowerCase().indexOf("javascript:")>-1){
				location.href = oneData.href;
			}else{
				window.open(env.fn.formatUrl(oneData.href), target || oneData.target || '_blank');
			}
			
		});
	}
	return topDiv;
}

//构造第一个菜单，同时进行计算
function buildFirstMenu(){
	var firstMenu = buildMenu(data[0],false, true)
			.appendTo(picMenuListDiv);
	cellWidth = firstMenu.outerWidth(true);
	cellHeight = firstMenu.outerHeight(true);
	var cols = Math.floor(width/cellWidth);
	if(cols <= 1){
		cols = 2;	//最少显示两个
	}
	space = Math.floor((width - firstMenu.width()*cols)/(cols*2));
	if(space<2){
		space = 2;
	}
	cellWidth = firstMenu.width() + space * 2;
	endSpace = width - cellWidth * cols;
	if(endSpace<0){
		endSpace = 0;
	}
	if(showMore){
		var rows = Math.floor(height/cellHeight);
		if(rows <= 0){
			rows = 1;
		}
		showCount = cols * rows;
		if(showCount >= data.length){
			showCount = data.length;
			showMore = false;
		}else{
			showCount--;
		}
	}else{
		showCount = data.length;
	}
	firstMenu.css({'paddingLeft':space,'paddingRight':space});
	return firstMenu;
}

//构造其它菜单
function buildNextMenu(){
	for(var i=1; i<showCount; i++){
		buildMenu(data[i], false, false)
				.appendTo(picMenuListDiv);
	}
}

//构造更多操作
function buildMoreMenu(){
	if(!showMore)
		return;
	var bgcolor = "white";
	var popDiv = $('<div>').attr('class', 'lui_dataview_picmenu_popup'+cssExtend);
	popDiv.css({"width": width - endSpace,"background":bgcolor});
	for(var i=showCount; i<data.length; i++){
		buildMenu(data[i],false,false)
				.appendTo(popDiv);
	}
	//TODO 多语言未处理
	var moreMenu = buildMenu({"icon":"lui_icon_l_icon_more","text":"更多"}, true, false);
	picMenuListDiv.append(moreMenu);
	picMenuListDiv.append(popDiv);
	seajs.use(['sys/ui/js/popup'],function(popup){
			var pp = popup.build(moreMenu,popDiv,{"align":"down-right"});
			render.parent.onErase(function(){pp.destroy();});
	});
}