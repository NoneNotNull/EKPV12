// 1 描述控件

Designer_Config.controls['reference'] = {
		type : "reference", // 根据控件进行命名，与上面sqlselect保持一致
		storeType : 'field', // 需要值保存，使用此属性
		inherit : 'base', // 继承控件，base控件具有拖拽功能
		onDraw : _Designer_Control_Reference_OnDraw, //绘制函数，注意命名不要把原有函数覆盖
		drawXML : _Designer_Control_Reference_DrawXML, //生成数据字典，注意命名不要把原有函数覆盖
		implementDetailsTable : false, // 是否支持明细表
		attrs : { // 这个是属性对话框配置，这里需要根据需求来配置
			label : Designer_Config.attrs.label, // 内置显示文字属性
			sigtext:{
				text:"签章名称",
				value:"sig1",
				type:'text',
				checked:false,
				show:true
			},
			formula: Designer_Config.attrs.formula,
			reCalculate: Designer_Config.attrs.reCalculate
		},
		info : {
			name: "自定义签章" // 控件描述
		},
		width:500,
		resizeMode : 'no' // 是否可修改大小还有其他属性，可参考 config.js里的内容
};
// 2 描述按钮

Designer_Config.operations['reference'] = {
		imgIndex : 18, // 按钮图片, 直接通过css背景图定位方式来实现，图片是icon.gif
		title : "自定义签章",
		run : function (designer) {
			designer.toolBar.selectButton('reference');
		},
		type : 'cmd',
		shortcut : 'Q',
		sampleImg : Com_Parameter.ContextPath+'km/signature/image/tip.png', // 提示图片
		select: true,
		cursorImg: Com_Parameter.ContextPath+'km/signature/image/addDoc.cur', // 鼠标手势
		childElem: function() {
			var c = document.createElement("div");
			var img = document.createElement('img');
			img.src=Com_Parameter.ContextPath+'km/signature/image/toobar.png';
			c.style.width='16px';
			c.style.height='16px';
			img.style.width='16px';
			img.style.height='16px';
			c.align='center';
			c.appendChild(img);
			c.style.padding = '2px';
			return c;
		}
};

// 3 添加按钮到工具栏
Designer_Config.buttons.control.push("reference");
 
// 4 添加按钮到右键菜单
Designer_Menus.add.menu['reference'] = Designer_Config.operations['reference'];
 
// 5 绘制HTML函数，注意命名不要把原有函数覆盖

function _Designer_Control_Reference_OnDraw(parentNode, childNode){
	
	// 必须要做ID设置
	var init =false;
	if (this.options.values.id == null) {
		this.options.values.id = "fd_" + Designer.generateID();
		init = true;
	}
	// 调用内建方法创建dom对象，由于有一些内置属性需要添加，建议使用此方法
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	// 以下是绘制，这个根据需求自己定义
	//var htmlCode='<input type="button" style="cssText:'+setCSS()+'" 
//							isAllowUnPublished="'+this.options.values.isAllowUnPublished+'" 
//							value="关联文档" 
//							id="'+this.options.values.id+'" 
//							label="'+_Get_Designer_Control_Label(this.options.values, this)+'" 
//							isUpdateRight="'+this.options.values.isUpdateRight+'" 
//							isMyDoc="'+this.options.values.isMyDoc+'" />';
	var htmlCode='<div id="'+this.options.values.id+'" style="width: 671px; height: 96px;background:#666;">签章信息</div>';
	domElement.innerHTML = htmlCode;
}


// 6 绘制数据字典，必须按照标准的数据字典格式来。注意命名不要把原有函数覆盖
// 具体属性参考 com/landray/kmss/sys/metadata/dict 包下内容

function _Designer_Control_Reference_DrawXML() {
	var values = this.options.values;
	var buf = [];
	buf.push('<extendSimpleProperty ');
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	buf.push("length='1000'");
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

/*function setCSS(){
	var url=Com_Parameter.ContextPath+'km/signature/image/background.png';
	var css="width:20px;" +
			"height:25px;" +
			"background-image: url("+url+");"+
			"BORDER-RIGHT: #efed60 1px solid; " +
			"PADDING-RIGHT: 2px; " +
			"BORDER-TOP: #efed60 1px solid; " +
			"PADDING-LEFT: 2px;" +
			"FONT-SIZE: 12px; " +
			"FONT-WEIGHT: BOLD;" +
			"BORDER-LEFT: #efed60 1px solid;" +
			"CURSOR: hand; " +
			"COLOR: black; " +
			"PADDING-TOP: 2px; " +
			"BORDER-BOTTOM: #efed60 1px solid;" ;
	return css;
}*/

