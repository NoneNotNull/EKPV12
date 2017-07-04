if(data==null || data.length==0){
	done();
	return;
}

//变量赋值
var element = render.parent.element;
var extend = param.extend?('_'+param.extend):'';
var ellipsis = param.ellipsis == 'true' || render.vars.ellipsis=='true';
var target = render.vars.target?render.vars.target:'_blank';
var highlight = render.vars.highlight == 'true'?cssName('highlight'):'';
var showCate = render.vars.showCate == null || render.vars.showCate == 'true'; 
var showCreator = render.vars.showCreator == null || render.vars.showCreator == 'true';
var showCreated = render.vars.showCreated == null || render.vars.showCreated == 'true';
var cateSize = parseInt(render.vars.cateSize);
if(isNaN(cateSize)){
	cateSize = 0;
}
var newDay = parseInt(render.vars.newDay);
if(isNaN(newDay)){
	newDay = 0;
}

//计算new日期
var showNewDate;
if(newDay>0){
	showNewDate = env.fn.parseDate(env.config.now);
	showNewDate.setTime(showNewDate.getTime()-newDay*24*60*60*1000);
}
function showNewIcon(oneData){
	if(newDay<=0 || oneData.created==null){
		return false;
	}
	return showNewDate < env.fn.parseDate(oneData.created);
};

//样式简化调用
function cssName(name){
	return 'lui_dataview_classic'+extend+'_'+name;
}

//添加一个格子
function addCell(rowDiv, oneData, key){
	if(oneData[key]){
		$('<span/>').attr('class', cssName(key)).text(oneData[key])
				.appendTo(rowDiv);
	}
};

//添加一个带链接的格子
function addLinkCell(rowDiv, oneData, text, href, css){
	var textBox;
	if(oneData[href]){
		textBox = $('<a/>').attr({
				'class':cssName(css+'link'),
				'href':env.fn.formatUrl(oneData[href]),
				'target':target
			});
	}else{
		textBox = $('<span/>').attr('class', cssName(css+'nolink'));
	}
	textBox.attr('title', oneData[text]);
	textBox.appendTo(rowDiv);
	return textBox;
};

//添加一行
function addRow(oneData, isFirst){
	var rowDiv = $('<div/>').attr('class', cssName('row')+' clearfloat')
			.appendTo(contentDiv);
	if(isFirst){
		rowDiv.addClass(highlight);
	}
	
	//图标
	var iconSpan = $('<span/>')
			.appendTo(rowDiv);
	if(oneData.icon && oneData.icon.indexOf('/')==-1){
		iconSpan.attr('class', cssName('customicon'));
		$('<span/>').attr('class', 'lui_icon_s '+oneData.icon)
			.appendTo(iconSpan);
	}else{
		iconSpan.attr('class', cssName('icon'));
	}
	
	//文本区域
	var textArea = $("<div/>").attr('class',  cssName('textArea')+' clearfloat')
			.appendTo(rowDiv);
	var linkBox, text;
	
	//分类
	if(showCate && oneData.catename && oneData.catename!=''){
		linkBox = addLinkCell(textArea, oneData, 'catename', 'catehref', 'cate_');
		text = oneData.catename;
		if(cateSize>0 && text.length>cateSize){
			text = text.substring(0, cateSize)+'..';
		}
		linkBox.text('['+text+']');
	}
	
	//标题
	linkBox = addLinkCell(textArea, oneData, 'text', 'href', '');
	text = oneData.text || '';
	if(ellipsis && text.length>3){
		//等全部显示完毕后在调整宽度，避免出现滚动条导致页面变窄
		linkBox.text('.');
		oneData.textBox = linkBox;
		oneData.textArea = textArea;
	}else{
		linkBox.text(text);
	}
	
	if(oneData.isintroduced=='true'){
		$('<span/>').attr('class', cssName('introduced'))
		.appendTo(textArea);
	}
	
	//其它信息
	addCell(textArea, oneData, 'otherinfo');
	
	//New图标
	if(showNewIcon(oneData)){
		$('<span/>').attr('class', cssName('new'))
				.appendTo(textArea);
	}
	
	//创建时间
	if(showCreated){
		addCell(textArea, oneData, 'created');
	}
	
	//创建者
	if(showCreator){
		addCell(textArea, oneData, 'creator');
	}
}

function ellipsisText(oneData){
	//textArea然后获取高度，再填充其它字符，若高度改变说明折行
	var textArea = oneData.textArea;
	if(textArea==null)
		return;
	var textBox = oneData.textBox;
	var text = oneData.text;
	var height = textArea.height();
	textBox.text(text);
	for(var i=text.length-2; height>5 && i>0 && textArea.height()>height; i--){
		textBox.text(text.substring(0, i)+'..');
	}
	oneData.textBox = null;
	oneData.textArea = null;
}

var contentDiv = $("<div/>").attr('class', 'lui_dataview_classic'+extend)
		.appendTo(element);
for(var i=0; i<data.length; i++){
	//debugger;
	addRow(data[i], i==0);
}
if(ellipsis){
	for(var i=0; i<data.length; i++){
		ellipsisText(data[i]);
	}
}
done();