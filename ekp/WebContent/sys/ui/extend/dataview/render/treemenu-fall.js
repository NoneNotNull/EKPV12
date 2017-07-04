if(data==null || data.length==0){
	done();
	return;
}
//初始化变量
var element = render.parent.element;
var target = render.vars.target?render.vars.target:'_blank';
var cols = parseInt(render.vars.cols, 10);
if(isNaN(cols) || cols==0){
	cols = 3;
}
if(data.length<cols){
	cols = data.length;
}
var width = (Math.floor(1000/cols)-1)/10.0 + '%';

//画表格
var tr = $('<table />').attr('class', 'lui_dataview_treemenu_fall')
	.appendTo(element).get(0).insertRow(-1);
for(var i=0; i<cols; i++){
	insertCell(i==0);
}

//插入数据
for(var i=0; i<data.length; i++){
	insertData(data[i], getMinHeightTd(), 1);
}

function insertCell(first){
	var td = tr.insertCell(-1);
	td.style.width = width;
	if(first){
		td.className = 'lui_dataview_treemenu_fall_firstCol';
	}
}

function insertData(oneData, parent, lv){
	var div = $('<div/>').attr('class', 'lui_dataview_treemenu_fall_lv_'+lv)
		.appendTo(parent);
	var txt = $('<a />').attr({'class':'textEllipsis lui_dataview_treemenu_fall_lv_'+lv+'_txt','title':oneData.text}).text(oneData.text)
		.appendTo(div);
	if(oneData.href!=null){
		txt.attr({'href':env.fn.formatUrl(oneData.href), 'target':target});
	}
	if(oneData.children!=null && oneData.children.length>0){
		var child = $('<div/>').attr('class', 'lui_dataview_treemenu_fall_lv_'+lv+'_child')
			.appendTo(div);
		for(var i=0; i<oneData.children.length; i++){
			insertData(oneData.children[i], child, lv+1);
		}
	}
}

function getMinHeightTd(){
	var height = 100000;
	var rtnVal;
	for(var i=0; i<tr.cells.length; i++){
		var td = tr.cells[i];
		var obj = td.lastChild;
		if(obj==null){
			return $(td);
		}
		var h = obj.offsetTop + obj.offsetHeight;
		if(h < height){
			rtnVal = $(td);
			height = h;
		}
	}
	return rtnVal;
}
done();