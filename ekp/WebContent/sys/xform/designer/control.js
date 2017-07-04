/**********************************************************
功能：控件模版
使用：
	
作者：龚健
创建时间：2009-02-20
**********************************************************/
function Designer_Control_Definition() {
	//缺省控件定义
	this.controls = {
		base  : {
			type          : '',                                    //类型(必须)
			inherit       : '',                                    //继承对象(必须)
			isTextLabel   : false,                                 //是否为显示文本，文本绑定时以此为依据
			onDraw        : null,                                  //绘制控件(必须, 参数：parentNode>父节点)
			onDrawEnd     : null,
			dragRedraw    : true,                                 //控件在拖拽中是否重绘
			onDrag        : _Designer_Control_Base_DoDrag,         //开始拖拽
			onDragMoving  : _Designer_Control_Base_DoDragMoving,   //拖拽移动中
			onDragStop    : _Designer_Control_Base_DoDragStop,     //拖拽结束
			onShiftDrag   : function(event){},
			onShiftDragMoving: function(event){},
			onShiftDragStop:function(event){},
			onMoveStart   : _Designer_Control_Base_DoMoveStart,    //控件移动开始
			onMoving      : _Designer_Control_Base_DoMoving,       //控件移动中
			onMoveStop    : _Designer_Control_Base_DoMoveStop,     //控件移动结束
			onLock        : null,                                  //控件锁定事件(继承控件自实现)
			onUnLock      : null,                                  //控件解除锁定事件(继承控件自实现)
			onSelect      : null,                                  //控件选中内部元素事件(继承控件自实现)
			getRelatedTextControl : _Designer_Control_GetRelatedTextControl, //获取相邻单元格文本控件
			getBorderCell : _Designer_Control_GetBorderCell,        //获取指定方向单元格
			relatedWay    : 'left',                                 //属性：获取单元格方向
			getRelateWay  : null,                                   //方法：返回获取单元格方向，优先使用此方法
			drawXML       : null,                                   //绘制成XML格式(必须)
			insertValidate: null,                                   //容器插入校验
			onSerialize   : null                                    //序列化时
		},
		table : {
			type          : 'table',                               //类型(必须)
			inherit       : 'base',                                //继承对象(必须)
			container     : true,                                  //容器(必须)
			resizeMode    : 'onlyHeight',                          //尺寸调整模式
			onDraw        : _Designer_Control_Table_DoDraw,        //绘制控件(必须, 参数：parentNode>父节点)
			onInitialize  : _Designer_Control_Table_DoInitialize,  //控件初始化事件(可选)
			onMouseOver   : _Designer_Control_Table_DoMouseOver,   //控件Over事件(参数：mousePosition>鼠标绝对位置)
			onColumnStart : _Designer_Control_Table_DoColumnStart, //开始调整列宽
			onColumnDoing : _Designer_Control_Table_DoColumnDoing,
			onColumnEnd   : _Designer_Control_Table_DoColumnEnd,
			cellDistance  : _Designer_Control_Table_CellDistance,
			rowDistance   : _Designer_Control_Table_RowDistance,
			colDistance   : _Designer_Control_Table_ColDistance,
			setColWidth   : _Designer_Control_Table_SetColumnWidth,
			onRowStart    : _Designer_Control_Table_DoRowStart,    //开始调整行高
			onRowDoing    : _Designer_Control_Table_DoRowDoing,
			onRowEnd      : _Designer_Control_Table_DoRowEnd,
			onLock        : _Designer_Control_Table_DoLock,
			onUnLock      : _Designer_Control_Table_DoUnLock,
			onSelect      : _Designer_Control_Table_DoSelect,
			chooseCell    : _Designer_Control_Table_ChooseCell,    //选中单元格
			merge         : _Designer_Control_Table_Merge,         //合并单元格
			split         : _Designer_Control_Table_Split,         //拆分单元格
			insertRow     : _Designer_Control_Table_InsertRow,     //插入行
			appendRow     : _Designer_Control_Table_AppendRow,     //追加行
			insertColumn  : _Designer_Control_Table_InsertColumn,  //插入列
			appendColumn  : _Designer_Control_Table_AppendColumn,  //追加列
			deleteRow     : _Designer_Control_Table_DeleteRow,     //删除行
			deleteColumn  : _Designer_Control_Table_DeleteColumn,  //删除列
			_getControlsByCell : _Designer_Control_Table_GetControlsByCell, //获得单元格包含的控件集
			_resetCoordin : _Designer_Control_Table_ResetCoordinate,//更新坐标位置
			_getPosByRow  : _Designer_Control_Table_GetPosByRow,   //获得所在行的位置，根据坐标
			_isInSameRow  : _Designer_Control_Table_IsInSameRow,   //判断选中的单元格是否在同一行里
			_isInSameColumn  : _Designer_Control_Table_IsInSameColumn, // 判断选中的单元格是否在同一列里
			getColumnSize : _Designer_Control_Table_GetColumnSize, //获得当前表格列数
			_dealRowSpanCells : _Designer_Control_Table_DealRowSpanCells, // 处理跨行单元格
			attrs         : {
				row : {
					text  : Designer_Lang.controlTableRow,
					value : '4',
					type  : 'text',
					show  : false
				},
				cell : {
					text  : Designer_Lang.controlTableColumn,
					value : '4',
					type  : 'text',
					show  : false,
					style : null
				}
			}
		}
	};
	Designer.extend(true, this.controls, Designer_Config.controls || {});
};

/**********************************************************
描述：
	控件定义
功能：
	Designer_Control 控件对象
备注：
	dragAction:
		拖拽实现函数
		onStart : 开始拖拽，参数(event, self>当前控件对象)
		onMove  : 拖拽移动中，参数(event, self>当前控件对象)
		onStop  : 拖拽结束，参数(event, self>当前控件对象)
**********************************************************/
function Designer_Control(builder, type, drawAtOnce) {
	//属性
	this.owner = builder || null;                               //设计器对象
	this.type = type || 'table';
	//控件实例属性
	this.options = {
		domElement : null,                                      //控件Dom对象
		values     : {}                                         //控件属性缺省值
	};
	//相关配置属性
	this.container = false;                                     //容器
	this.resizeMode = 'all';                                    //尺寸调整模式(onlyWidth, onlyHeight, all, no)
	this.lock = false;                                          //锁定控件
	this.dragAction = {onStart:null, onMove:null, onStop:null}; //拖拽实现函数(开始拖拽函数，移动函数，停止函数)
	//父控件
	this.parent = null;
	//子控件
	this.children = [];
	//控件内部选中的子Dom元素
	this.selectedDomElement = [];

	//内部属性
	this._chooseElement = {domElement:null, mousePosition:''};  //mousePosition:up,down,left,right

	//内部调用方法
	this._initMethod = _Designer_Control_InitMethod;
	this._keepFitBorder = _Designer_Control_KeepFitBorder;

	//公用方法
	this.initialize = Designer_Control_Initialize;
	this.draw = Designer_Control_Draw;
	this.updateControlTree = Designer_Control_UpdateControlTree;
	this.getControlByDomElement = Designer_Control_GetControlByDomElement;
	this.mouseOver = Designer_Control_MouseOver;
	this.getControlByArea = Designer_Control_GetControlByArea;
	this.getTagName = Designer_Control_GetTagName;
	this.destroy = Designer_Control_Destroy;

	//初始化当前控件对象
	this._initMethod();
	//对象初始化
	this.initialize((drawAtOnce == null) ? true : drawAtOnce);
};

function Designer_Control_Initialize(drawAtOnce) {
	if (drawAtOnce) this.draw();
};

function Designer_Control_Draw(parentControl, parentNode, nextChild) {
	var parent = this.parent, domElement, _nextChild = nextChild || null, currElement = this.options.domElement;
	//父控件
	this.parent = parentControl || null;
	//父节点
	if (parentNode == null)	{
		domElement = (this.parent == null) ? this.owner.domElement : this.parent.options.domElement;
	} else {
		domElement = parentNode;
	}
	//强制删除重新绘制，控件不是容器时
	if (this.container || !this.dragRedraw) {
		if (currElement == null) {
			this._keepFitBorder(domElement, _nextChild);
		} else {
			if (_nextChild == null)
				domElement.appendChild(currElement);
			else
				domElement.insertBefore(currElement, _nextChild);
		}
	} else {
		if (currElement) currElement.parentNode.removeChild(currElement);
		this._keepFitBorder(domElement, _nextChild);
	}
	//往父控件中写入父子关系
	this.updateControlTree(parent, this.parent);
	//控件初始化
	if (currElement == null && this.onInitialize) this.onInitialize();
	if (this.onDrawEnd) this.onDrawEnd();
};

function Designer_Control_UpdateControlTree(oldParent, newParent) {
	var tree = this.owner.owner.treePanel;

	if (oldParent === newParent) {
		if (!tree.isClosed) tree.open();
		return;
	}
	if (this.parent !== newParent) this.parent = newParent;

	if (oldParent == null) {
		Designer.spliceArray(this.owner.controls, this);
		newParent.children.push(this);
	} else {
		Designer.spliceArray(oldParent.children, this);
		(newParent == null) ? this.owner.controls.push(this) : newParent.children.push(this);
	}
	if (!tree.isClosed) tree.open();
};

function Designer_Control_GetControlByDomElement(domElement) {
	var control, rtnControl;
	if (domElement == null) return null;
	if (this.options.domElement === domElement) return this;

	for (var i = this.children.length - 1; i >= 0; i--) {
		control = this.children[i];
		rtnControl = control.getControlByDomElement(domElement);
		if (rtnControl != null) return rtnControl;
	}
	return null;
};

function Designer_Control_GetControlByArea(area, exceptControl) {
	var control;
	for (var i = this.children.length - 1; i >= 0; i--) {
		control = this.children[i];
		if (control != exceptControl && Designer.isIntersect(area, control.options.domElement))
			return control.getControlByArea(area, exceptControl);
	}
	return this;
};

function Designer_Control_MouseOver(event) {
	if (this.onMouseOver) this.onMouseOver(event);
};

function Designer_Control_GetTagName() {
	var domElement = this.options.domElement;
	return (domElement && domElement.tagName) ? domElement.tagName.toLowerCase() : '';
};

function Designer_Control_Destroy() {
	var currElement = this.options.domElement, parent = this.parent, parentNode = null;
	//记录控件原所在地，若是单元格则记录，否则不记录
	if (parent && parent.getTagName() == 'table') parentNode = currElement.parentNode;
	//销毁掉子控件
	for (var i = this.children.length - 1; i >= 0; i--)
		this.children[i].destroy();
	//删除控件的Dom元素
	if (currElement) currElement.parentNode.removeChild(currElement);
	//销毁父控件中记录的对象句柄
	if (this.parent == null)
		Designer.spliceArray(this.owner.controls, this);
	else
		Designer.spliceArray(this.parent.children, this);
	//隐藏选中虚线框
	this.owner.resizeDashBox.hide();
	//若控件原所在的单元格没有内容，则添加上空格(&nbsp;)
	if (parentNode && parentNode.innerHTML == '') parentNode.innerHTML = '&nbsp;';
	//更新控件树
	if (!this.owner.owner.treePanel.isClosed)
		this.owner.owner.treePanel.open();
	//清空当前控件
	this.owner.owner.control = null;
};

/**********************************************************
描述：
	内部调用函数
功能：
	_Designer_Control_InitMethod    : 初始化自定义的相关方法
	_Designer_Control_KeepFitBorder : 保持外框为内部元素的真实宽度
**********************************************************/
function _Designer_Control_InitMethod() {
	var controls = this.owner.owner.controlDefinition;
	if (controls == null) return;
	//可以追溯的继承层级
	var inheritLevel = 0, inherits = [];
	//若相应方法没有，则寻找继承的控件是否存在相应的控件
	for (var control = controls[this.type];
		control && control.inherit != '' && inheritLevel < 10;
		control = controls[control.inherit]) {
		inherits.push(control);
		inheritLevel++;
	}
	if (control) inherits.push(control);
	//继承相应方法
	for (var i = inherits.length - 1; i >= 0; i--)
		Designer.extend(true, this, inherits[i] || {});
};

function _Designer_Control_KeepFitBorder(domElement, nextChild) {
	if (this.onDraw == null) return;
	//绘制控件
	this.onDraw(domElement, nextChild);
	
	//调整控件外层的DIV的宽度和高度
	var _domElement = this.options.domElement;
	if (_domElement.style.width == null || _domElement.style.width == '') {
		_domElement.style.width = _domElement.offsetWidth;
	}
	/* 以下代码貌似无用了，准备删除 by 2009-08-19 fuyx
	document.body.appendChild(_domElement);
	if (Designer.checkTagName(_domElement, 'div') || Designer.checkTagName(_domElement, 'label')) {
		var children = _domElement.childNodes, parentLen = domElement.offsetWidth, width = 0, isGroup = false;
		for (var i = children.length - 1; i >= 0; i--)
			if (children[i].nodeType != 3) {
				width += children[i].offsetWidth;
				//若存在子节点标签为nobr，则认为是一组，比如radio
				if (!isGroup && Designer.checkTagName(_domElement, 'nobr')) isGroup = true;
			}
		if (isGroup && width > parentLen) width = parentLen;
		_domElement.style.width = width + 'px';
	}
	//重新插入到指定位置
	domElement.insertBefore(_domElement, nextChild);
	*/
};

/**********************************************************
描述：
	控件函数
功能：
	_Designer_Control_Base_DoDrag       : 控件开始拖拽
	_Designer_Control_Base_DoDragMoving : 控件拖拽中
	_Designer_Control_Base_DoDragStop   : 控件拖拽结束
	_Designer_Control_GetRelatedTextControl : 获得相邻文本控件
	_Designer_Control_GetBorderCell : 获得相邻单元格
**********************************************************/

/************************基础控件*************************/
function _Designer_Control_Base_DoDrag(event) {
	var _prevDragDomElement = this.owner._dragDomElement, currElement = event.srcElement || event.target;
	//绑定调整大小框
	this.owner.resizeDashBox.attach(this);
	//若当前拖拽控件与前一个拖拽控件不同，则调用前一控件取消锁定状态
	if (_prevDragDomElement && _prevDragDomElement !== this && _prevDragDomElement.onUnLock)
		_prevDragDomElement.onUnLock();
	//记录当前拖拽控件
	this.owner._dragDomElement = this;
	//右键不认为是点击事件  2009-05-18 傅游翔
	if (Designer.eventButton(event) == 2) return;
	//控件锁定
	if (event.ctrlKey && this.onLock) {
		this.onLock(event);
	} else {
		if (!event.ctrlKey && this._chooseElement.domElement == null) {
			//取消锁定状态
			if (this.onUnLock) this.onUnLock();
			//选中内部Dom元素(除控件外)
			if (this.onSelect) this.onSelect(event);
		}
		//记录当前元素Dom对象
		this._srcElement = currElement;
		//记录当前元素的鼠标样式
		this._cursor = currElement.style.cursor;
		//准备开始拖拽
		if (this.dragAction.onStart)
			this.dragAction.onStart(event, this);
		else
			this.onMoveStart(event);
	}
	//独占鼠标
	if(Designer.UserAgent == 'msie') {
		event.cancelBubble = true;
		this.options.domElement.setCapture();
	} else {
		event.stopPropagation();
	}
};

function _Designer_Control_Base_DoDragMoving(event) {
	if(Designer.UserAgent == 'msie') {
		this.options.domElement.setCapture();
		event.cancelBubble = true;
	} else {
		event.preventDefault();
		event.stopPropagation();
	}
	window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
	//控件锁定，则不能移动
	if (event.ctrlKey) return;
	if (this.dragAction.onMove)
		this.dragAction.onMove(event, this);
	else
		this.onMoving(event);
};

function _Designer_Control_Base_DoDragStop(event) {
	if(Designer.UserAgent == 'msie') {
		this.options.domElement.releaseCapture();
	} else {
		//
	}
	if (this.dragAction.onStop)
		this.dragAction.onStop(event, this);
	else
		this.onMoveStop(event);
	//恢复当前元素的鼠标样式
	if (this._srcElement != null) {
		this._srcElement.style.cursor = this._cursor;
		//清除当前元素Dom对象
		this._srcElement = null;
	}
	//解除拖拽事件
	this.dragAction.onStart = null;
	this.dragAction.onMove = null;
	this.dragAction.onStop = null;
	this.owner.resizeDashBox.attach(this);
};

function _Designer_Control_Base_DoMoveStart(event) {
	var currElement = this.options.domElement, builder = this.owner, dragDashBox = builder.dragDashBox;
	var mousePos = builder.getMouseRelativePosition(event), area = Designer.absPosition(currElement); //, builder.domElement
	//显示拖拽虚线框
	dragDashBox.attach(currElement);

	this._prev_x = parseInt(dragDashBox.box.style.left);
	this._prev_y = parseInt(dragDashBox.box.style.top);
	this._x = mousePos.x - area.x;
	this._y = mousePos.y - area.y;
	this._srcElement.style.cursor = 'move';
};

function _Designer_Control_Base_DoMoving(event) {
	var builder = this.owner, dragDashBox = builder.dragDashBox.box, mousePos = builder.getMouseRelativePosition(event);
	dragDashBox.style.left = (mousePos.x - this._x) + 'px';
	dragDashBox.style.top = (mousePos.y - this._y) + 'px';
};

function _Designer_Control_Base_DoMoveStop(event) {
	var currElement = this.options.domElement, builder = this.owner, dragDashBox = builder.dragDashBox, control, mousePosition;
	//若鼠标移动没超过5px，则认为没有拖动
	var distance_x = Math.abs(parseInt(dragDashBox.box.style.left) - this._prev_x);
	var distance_y = Math.abs(parseInt(dragDashBox.box.style.top) - this._prev_y);
	if (distance_x >= 5 || distance_y >= 5) {
		//鼠标所在的控件
		mousePosition = Designer.getMousePosition(event);
		control = builder.getControlByArea(mousePosition, this);
		//记录控件原所在地，若是单元格则记录，否则不记录
		var parent = this.parent, parentNode = null;
		if (parent && parent.getTagName() == 'table') parentNode = currElement.parentNode;
		//重绘控件
		if (control == null) {
			this.draw();
		} else if (control.container) {
			switch (control.getTagName()) {
			case 'table':
				var container = control.options.domElement, rowLen = container.rows.length, row, cellLength, cell;
				for (var i = 0; i < rowLen; i++) {
					row = container.rows[i];
					cellLength = row.cells.length;
					for (var j = 0; j < cellLength; j ++) {
						cell = row.cells[j];
						if (Designer.isIntersect(mousePosition, cell)) {
							if (control.insertValidate && !control.insertValidate(cell, this)) {break;}
							//若需插入的单元格只有空格，则要清除空格(&nbsp;)
							if (cell.innerHTML == '&nbsp;') cell.innerHTML = '';
							//重绘当前控件
							this.draw(control, cell);
							break;
						}
					}
				}
				break;
			case 'div':
				var container = control.options.domElement;
				if (container != null) {
					if (control.insertValidate && !control.insertValidate(container, this)) {break;}
					if (container.innerHTML == '&nbsp;') container.innerHTML = '';
					this.draw(control, container);
				}
				break;
			}
		} else {
			if (control.parent) { // 拖动释放时在控件上
				var nextSibling = control.options.domElement.nextSibling;
				if (nextSibling === this.options.domElement) {
					nextSibling = control.options.domElement;
				}
				nextSibling = Designer.getDesignElement(nextSibling, 'nextSibling')
				this.draw(control.parent, control.options.domElement.parentNode, nextSibling);
			}
			//
		}
		//若控件原所在的单元格没有内容，则添加上空格(&nbsp;)
		if (parentNode && parentNode.innerHTML == '') parentNode.innerHTML = '&nbsp;';
	}
	//隐藏拖拽虚线框
	dragDashBox.hide();
};

/*获得当前控件左边的文本，若当前控件在单元格里则获取左边紧挨的单元格的文本控件的内容*/
function _Designer_Control_GetRelatedTextControl() {
	var parent = this.parent, currElement = this.options.domElement;
	if (parent && parent.getTagName() == 'table') {
		var pCell = this.getBorderCell(currElement, parent.getRelateWay ? parent.getRelateWay(this) : (parent.relatedWay ? parent.relatedWay : 'left'));
		if (pCell == null) return null;
		//获得前一单元格里最接近的文本控件内容
		var children = pCell.childNodes, element, control;
		for (var i = children.length - 1; i >= 0; i--) {
			element = children[i];
			if (element.nodeType != 3 && Designer.isDesignElement(element)) {
				control = parent.getControlByDomElement(element);
				if (control && control.isTextLabel) return control;
			}
		}
	} else if (parent && parent.getTagName() == 'div') {
		return parent.getRelatedTextControl();
	} else {
		var element = currElement.previousSibling;
		if (element && element.nodeType != 3 && Designer.isDesignElement(element)) {
			control = this.owner.getControlByDomElement(element);
			if (control && control.isTextLabel) return control;
		}
	}
	return null;
};

function _Designer_Control_GetBorderCell(currElement, type) {
	if (type == 'self') {
		return currElement.parentNode;
	}
	if (type == 'left') {
		return currElement.parentNode.previousSibling;
	}
	if (type == 'up') {
		var row = currElement.parentNode.parentNode.previousSibling;
		if (row == null) return null;
		//cellIndex 该属性在出现隐藏列时IE9一上版本会忽略隐藏
		//var index = currElement.parentNode.cellIndex;
		
		//作者 曹映辉 #日期 2013年11月26日  修复 cellIndex在出现隐藏列时出现序号错误问题
		var td=currElement.parentNode;
		var index=-1;
		for(i=0,obj=td.parentNode.childNodes;i < obj.length;i++){
			if(td==obj[i]){
				index=i;
				break;
			}
		}
		if(index==-1)
		{
			index = currElement.parentNode.cellIndex;
		}
		if (row.cells.length > index)
			return row.cells[index];
		else
			return null;
	}
	if (type == 'down') {
		var row = currElement.parentNode.parentNode.nextSibling;
		if (row == null) return null;
		var index = currElement.parentNode.cellIndex;
		if (row.cells.length > index)
			return row.cells[index];
		else
			return null;
	}
	if (type == 'right') {
		return currElement.parentNode.nextSibling;
	}
	return null;
}

/************************表格控件*************************/
function _Designer_Control_Table_DoInitialize() {
	var table = this.options.domElement, column = [];
	var rowCount = table.rows.length, colCount = 0, row, cell, cellColumn;
	//计算列总数
	row = table.rows[0], colCount = row.cells.length;
	for (var i = 0; i < colCount; i++) {
		cell = row.cells[i];
		rowCount = column.length;
		cellColumn = cell.getAttribute('column').split(',');
		for (var j = 0; j < cellColumn.length; j++)
			column.push([]);
		column[rowCount].push(cell);
		cell.setAttribute('width', cell.offsetWidth);
	}
	//遍历单元格，放入相应列组中
	rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) {
		row = table.rows[i];
		colCount = row.cells.length;
		for (var j = 0; j < colCount; j++) {
			cell = row.cells[j];
			cellColumn = cell.getAttribute('column').split(',');
			column[cellColumn[0]].push(cell);
			cell.setAttribute('width', cell.offsetWidth);
		}
	}
	//记录列对象集
	this.options.column = column;
};

function _Designer_Control_Table_DoDraw(parentNode) {
	var rows = this.attrs.row, rowCount = (rows && rows.value != '') ? parseInt(rows.value) : 4;
	var cells = this.attrs.cell, cellCount = (cells && cells.value != '') ? parseInt(cells.value) : 4;
	var domElement, row, cell;
	//绘制表格
	with(parentNode.appendChild(this.options.domElement = document.createElement('table'))) {
		setAttribute('cellSpacing', '1'); setAttribute('cellPadding', '0');
		setAttribute('align', 'center'); setAttribute('formDesign', 'landray');
	}
	//设置表格相应属性
	domElement = this.options.domElement;
	domElement.setAttribute('id', 'fd_' + Designer.generateID());
	domElement.style.width = '98%';
	domElement.style.border = '0px';
	domElement.style.backgroundColor = '#C0C0C0';
	//绘制行和列
	for (var i = 0; i < rowCount; i++) {
		row = domElement.insertRow(-1);
		row.style.backgroundColor = '#FFFFFF';
		row.style.height = '25';
		for (var j = 0; j < cellCount; j++) {
			cell = row.insertCell(-1);
			cell.setAttribute('row', '' + i);            //记录行数(多值，以逗号分割，有严格顺序)
			cell.setAttribute('column', '' + j);         //记录列数(多值，以逗号分割，有严格顺序)
			cell.innerHTML = '&nbsp;';
		}
	}
};

function _Designer_Control_Table_DoMouseOver(event) {
	var currElement = event.srcElement || event.target, area = Designer.absPosition(currElement);
	var table = this.options.domElement, mousePosition = Designer.getMousePosition(event);
	var up = Designer.absPosition(table.rows[0]), down = Designer.absPosition(table.rows[table.rows.length - 1]);
	//边框坐标
	var _left = up.x, _up = up.y, _right = up.x + table.rows[0].offsetWidth;
	var _down = down.y + table.rows[table.rows.length - 1].offsetHeight;
	//当前单元格坐标
	var cellRight = area.x + currElement.offsetWidth, cellDown = area.y + currElement.offsetHeight;
	var cellLeft = area.x, cellUp = area.y;
	//根据鼠标位置，获得拖拽列宽或行高的信息
	var mousePos = '';
	if (cellRight != _right && mousePosition.x >= cellRight - 2) {
		mousePos = 'right'; this.owner.domElement.style.cursor = 'e-resize';
	} else if (mousePosition.y >= cellDown - 2) {
		mousePos = 'down'; this.owner.domElement.style.cursor = 'n-resize';
	} else if (cellLeft != _left && mousePosition.x <= cellLeft + 2) {
		mousePos = 'left'; this.owner.domElement.style.cursor = 'e-resize';
	} else if (cellUp != _up && mousePosition.y <= cellUp + 2) {
		mousePos = 'up'; this.owner.domElement.style.cursor = 'n-resize';
	} else {
		mousePos = ''; this.owner.domElement.style.cursor = 'default';
	}
	if (mousePosition.x > up.x && mousePosition.x < up.x + 5 && mousePosition.y > up.y && mousePosition.y < up.y + 5) {
		mousePos = ''; this.owner.domElement.style.cursor = 'style/cursor/123.ico';
		this.options._selectTable = true;
	} else {this.options._selectTable = false;}
	this._chooseElement.mousePosition = mousePos;
	//若选中的不是单元格，则置为空
	if (!Designer.checkTagName(currElement, 'td')) currElement = null;
	//记录当前单元格
	this._chooseElement.domElement = currElement;
	//准备拖拽列
	if (mousePos == 'left' || mousePos == 'right') {
		this.dragAction.onStart = this.onColumnStart;
		this.dragAction.onMove = this.onColumnDoing;
		this.dragAction.onStop = this.onColumnEnd;
	} else if (mousePos == 'up' || mousePos == 'down') {
		this.dragAction.onStart = this.onRowStart;
		this.dragAction.onMove = this.onRowDoing;
		this.dragAction.onStop = this.onRowEnd;
	} else {
		this._chooseElement.domElement = null;
		this.dragAction.onStart = null;
		this.dragAction.onMove = null;
		this.dragAction.onStop = null;
	}
};

function _Designer_Control_Table_DoColumnStart(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '' || !Designer.checkTagName(event.srcElement || event.target, 'td')) return;

	var dashLine = self.owner.vDashLine;
	dashLine.attach(self, _chooseCell, position);
	dashLine._mouse_prev_x = event.clientX;
	dashLine._mouse_prev_y = event.clientY;
	//计算单元格子节点的宽度总和，高度总和，避免内容被压缩
	var table = self.options.domElement, columns = self.options.column, index = 0;
	var column = _chooseCell.getAttribute('column').split(','), minLimit, maxLimit;
	switch (position) {
	case 'left':
		index = parseInt(column[0]);
		minLimit = self.colDistance(columns[index - 1]);
		maxLimit = -self.colDistance(columns[index]);
		index = index - 1;
		break;
	case 'right':
		index = parseInt(column[column.length - 1]);
		minLimit = self.colDistance(columns[index]);
		maxLimit = -self.colDistance(columns[index + 1]);
		break;
	}
	dashLine._minLimit = minLimit;
	dashLine._maxLimit = maxLimit;
	dashLine._coordinate = parseInt(dashLine.border['left'].style.left);
	dashLine._colIndex = index;
	self._srcElement.style.cursor = 'e-resize';
};

function _Designer_Control_Table_DoColumnDoing(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '') return;

	var builder = self.owner, dashLine = builder.vDashLine, distance = event.clientX - parseInt(dashLine._mouse_prev_x);
	var mousePos = builder.getMouseRelativePosition(event);
	if (distance < dashLine._minLimit) {
		dashLine.border['left'].style.left = (dashLine._coordinate + dashLine._minLimit) + 'px';
	} else if (distance > dashLine._maxLimit) {
		dashLine.border['left'].style.left = (dashLine._coordinate + dashLine._maxLimit) + 'px';
	} else dashLine.border['left'].style.left = (mousePos.x + builder.domElement.scrollLeft) + 'px';
};

function _Designer_Control_Table_DoColumnEnd(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '') return;
	var builderPos = Designer.absPosition(self.owner.domElement);
	var dashLine = self.owner.vDashLine, divide = parseInt(dashLine.border['left'].style.left) - builderPos.x;
	var columns = self.options.column, columnLeft, areaLeft, columnRight, areaRight, widthRight;
	if (dashLine._colIndex != null) {
		//设置分割线左边的列宽
		columnLeft = columns[dashLine._colIndex];
		areaLeft = Designer.absPosition(columnLeft[0], self.owner.domElement);
		//设置分割线右边的列宽
		columnRight = columns[dashLine._colIndex + 1];
		areaRight = Designer.absPosition(columnRight[0], self.owner.domElement);
		widthRight = columnRight[0].offsetWidth;
		//调整相应的宽度
		self.setColWidth(columnLeft, divide - areaLeft.x);
		self.setColWidth(columnRight, areaRight.x + widthRight - divide);
		
		//alert(self.parent.width);
		//准备解决 表格列宽百分比布局 作者 曹映辉 #日期 2014年7月24日
//		var curTD=_chooseCell.parentNode;
//		var total=0;
//		for(var i=0;i<curTD.cells.length;i++)
//		{
//			total+=parseInt(curTD.cells[i].width);
//		}
//		
//		for(var i=0;i<curTD.cells.length;i++)
//		{
//			//curTD.cells[i]._width= (curTD.cells[i].width/total)*100+"%";
//		}
		
		//alert(total);
		//alert(_chooseCell.parentNode);
	}
	//清除记录的选择对象
	self._chooseElement.domElement = null;
	//隐藏分割线
	dashLine.hide();
	//清除临时记录的信息
	dashLine._colIndex = null;
	//只为修正IE某些时候没有正确渲染的问题 by 2009-08-19 fuyx
	if (self.selectedDomElement.length == 0) {
		self.options.domElement.style.display = 'none';
		self.options.domElement.style.display = '';
	}
};

function _Designer_Control_Table_CellDistance(cell) {
	var children = cell.childNodes, cellWidth = cellHeight = 0;
	var isColSpan = cell.getAttribute('colSpan') != null, isRowSpan = cell.getAttribute('rowSpan') != null;
	for (var i = children.length - 1; i >= 0; i--) {
		if (children[i].nodeType != 3) {
			if(!isColSpan) cellWidth += children[i].offsetWidth;
			if(!isRowSpan) cellHeight += children[i].offsetHeight;
		}
	}
	return {width: cellWidth, height: cellHeight};
};

function _Designer_Control_Table_RowDistance(row) {
	var distance = 0;
	for (var i = row.cells.length - 1; i >= 0; i--)
		distance = Math.max(distance, this.cellDistance(row.cells[i]).height);
	distance = distance - row.offsetHeight;
	return (distance > 0) ? 0 : distance;
};

function _Designer_Control_Table_ColDistance(column) {
	var distance = 0;
	for (var i = column.length - 1; i >= 0; i--)
		distance = Math.max(distance, this.cellDistance(column[i]).width);
	distance = distance - column[0].offsetWidth;
	return (distance > 0) ? 0 : distance;
};

function _Designer_Control_Table_SetColumnWidth(column, width) {
	for (var i = column.length - 1; i >= 0; i--) {
		if (parseInt(column[i].colSpan) > 1) {
			column[i].style.width = 'auto';
		} else
			column[i].style.width = width + 'px';
	}
};

function _Designer_Control_Table_DoRowStart(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '' || !Designer.checkTagName(event.srcElement || event.target, 'td')) return;

	var dashLine = self.owner.hDashLine;
	dashLine.attach(self, _chooseCell, position);
	dashLine._mouse_prev_x = event.clientX;
	dashLine._mouse_prev_y = event.clientY;
	//计算单元格子节点的宽度总和，高度总和，避免内容被压缩
	var table = self.options.domElement, index = 0;
	var row = _chooseCell.getAttribute('row').split(','), minLimit;
	switch (position) {
	case 'up':
		index = parseInt(row[0]);
		minLimit = self.rowDistance(table.rows[index - 1]);
		index = index - 1;
		break;
	case 'down':
		index = parseInt(row[row.length - 1]);
		minLimit = self.rowDistance(table.rows[index]);
		break;
	}
	dashLine._minLimit = minLimit;
	dashLine._coordinate = parseInt(dashLine.border['up'].style.top);
	dashLine._rowIndex = index;
	self._srcElement.style.cursor = 'n-resize';
};

function _Designer_Control_Table_DoRowDoing(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '') return;
	
	var builder = self.owner, dashLine = builder.hDashLine, distance = event.clientY - parseInt(dashLine._mouse_prev_y);
	var mousePos = builder.getMouseRelativePosition(event);
	if (distance < dashLine._minLimit)	{
		dashLine.border['up'].style.top = (dashLine._coordinate + dashLine._minLimit) + 'px';
	} else {
		dashLine.border['up'].style.top = (mousePos.y + builder.domElement.scrollTop) + 'px';
	}
};

function _Designer_Control_Table_DoRowEnd(event, self) {
	var _chooseCell = self._chooseElement.domElement, position = self._chooseElement.mousePosition;
	if (_chooseCell == null || position == '') return;

	var dashLine = self.owner.hDashLine, divide = parseInt(dashLine.border['up'].style.top);
	var table = self.options.domElement, cell = table.rows[dashLine._rowIndex];
	//设置行高
	if (dashLine._rowIndex != null) cell.style.height = (cell.offsetHeight + divide - parseInt(dashLine._coordinate)) + 'px';
	//清除记录的选择对象
	self._chooseElement.domElement = null;
	//隐藏分割线
	dashLine.hide();
	//清除临时记录的信息
	dashLine._rowIndex = null;
};

function _Designer_Control_Table_DoLock(event) {
	var currElement = event.srcElement || event.target;
	if (!this.chooseCell(currElement)) Designer.spliceArray(this.selectedDomElement, currElement);
};

function _Designer_Control_Table_DoUnLock() {
	for (var i = this.selectedDomElement.length - 1; i >= 0; i--) {
		this.chooseCell(this.selectedDomElement[i], false);
	}
	this.selectedDomElement = [];
};

function _Designer_Control_Table_DoSelect(event) {
	var currElement = event.srcElement || event.target;
	//若选中的不是单元格，则退出
	if (!Designer.checkTagName(currElement, 'td')) return;
	if (this.options._selectTable) {this.onUnLock(); return;}
	this.selectedDomElement = [];
	this.chooseCell(currElement, true);
};

/*函数功能：选中单元格  参数：cell>单元格，selected：可选，true(强制选中)，false(强制不选中) 返回：当前单元格是否选中*/
function _Designer_Control_Table_ChooseCell(cell, selected) {
	var oldClassName = cell.getAttribute('oldClassName'), argLength = arguments.length;
	//若当前单元格已经被选中，则会取消选中状态
	if (oldClassName != null) {
		if (argLength > 1 && selected){
			return true;
		}
		cell.className = oldClassName;
		cell.removeAttribute('oldClassName');
		//从选中列表中移除 作者 曹映辉 #日期 2014年7月23日
		this.selectedDomElement.splice($.inArray(cell,this.selectedDomElement),1);
		return false;
	} else {
		if (argLength > 1 && !selected) 
		{
			return false;
			
		}
		cell.setAttribute('oldClassName', cell.className);
		cell.className = 'table_select';
		this.selectedDomElement.push(cell);
		return true;
	}
};

function _Designer_Control_Table_Merge() {
	var rowMin = rowMax = columnMin = columnMax = -1, total = 0;
	var colspan = rowspan = 0, cell, rows, columns, cOwner, children, childCount;
	for (var i = this.selectedDomElement.length - 1; i >= 0; i--) {
		cell = this.selectedDomElement[i];
		rows = cell.getAttribute('row').split(',');
		columns = cell.getAttribute('column').split(',');
		//行的最小值和最大值
		rowMax = Math.max(rowMax, parseInt(rows[rows.length - 1]));
		rowMin = (rowMin == -1) ? parseInt(rows[0]) : Math.min(rowMin, parseInt(rows[0]));
		//列的最小值和最大值
		columnMax = Math.max(columnMax, parseInt(columns[columns.length - 1]));
		columnMin = (columnMin == -1) ? parseInt(columns[0]) : Math.min(columnMin, parseInt(columns[0]));
		//记录最小位置的单元格
		if (rowMin == parseInt(rows[0]) && columnMin == parseInt(columns[0])) cOwner = cell;
		//记录占用单元格数量
		total += (rows.length * columns.length);
	}
	//校验选中的单元格是否能合并(必须挨在一起成矩形)
	rowspan = rowMax - rowMin + 1;
	colspan = columnMax - columnMin + 1;
	if (colspan * rowspan != total) return;
	//合并
	if (colspan > 1) {
		cOwner.setAttribute('colSpan', '' + colspan);
		cOwner.removeAttribute('width');
		cOwner.style.width = "auto";
	}
	if (rowspan > 1) {
		cOwner.setAttribute('rowSpan', '' + rowspan);
		cOwner.removeAttribute('height');
		cOwner.style.height = "auto";
	}
	//删除其他单元格
	for (var i = this.selectedDomElement.length - 1; i >= 0; i--) {
		cell = this.selectedDomElement[i];
		if (cell && cell != cOwner) {
			children = cell.childNodes;
			for (var j = children.length - 1; j >= 0; j--) {
				if (children[j].nodeType != 3) cOwner.appendChild(children[j]);
			}
			//从列数组中删除
			columns = cell.getAttribute('column').split(',');
			Designer.spliceArray(this.options.column[columns[0]], cell);
			//删除单元格
			cell.parentNode.removeChild(cell);
		}
	}
	//更新属性
	rows = []; columns = [];
	for (var i = rowMin; i <= rowMax; i++) {
		rows.push('' + i);
	}
	for (var i = columnMin; i <= columnMax; i++) {
		columns.push('' + i);
	}
	cOwner.setAttribute('row', rows.join(','));
	cOwner.setAttribute('column', columns.join(','));
	//更新选中元素
	this.selectedDomElement = [cOwner];
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
};

function _Designer_Control_Table_Split() {
	var newCell, row, newColumns;
	if (this.selectedDomElement.length > 1) {
		alert(Designer_Lang.controlTableSelectSplitCell); return;
	}
	//获得单元格相关信息
	var cell = this.selectedDomElement[0];
	if (cell.getAttribute('colSpan') == null || cell.getAttribute('rowSpan') == null) return;
	//记录需拆分行和列信息
	var rows = cell.getAttribute('row').split(',');
	var columns = cell.getAttribute('column').split(',');
	//创建相应分拆的单元格
	var table = this.options.domElement;
	var columnCount = columns.length;
	for (var i = 1; i < columnCount; i++) {
		newCell = table.rows[rows[0]].insertCell(cell.cellIndex + i);
		newCell.setAttribute('row', rows[0]);
		newCell.setAttribute('column', columns[i]);
		newCell.innerHTML = '&nbsp;';
		this.options.column[columns[i]].push(newCell);
	}
	//当前单元格保留成一个无法拆分的单元格
	cell.removeAttribute('colSpan');
	cell.removeAttribute('rowSpan');
	cell.setAttribute('row', rows[0]);
	cell.setAttribute('column', columns[0]);
	//与拆分单元格不同行的其他位置
	var prevColCount = parseInt(columns[0]);
	var rowCount = rows.length, insertIndex = 0;
	for (var i = 1; i < rowCount; i++) {
		row = table.rows[rows[i]];
		if (prevColCount != 0) insertIndex = this._getPosByRow(row, prevColCount, 'column');
		//若没找到插入点，则认为是行尾
		insertIndex = (insertIndex == -1) ? row.cells.length : insertIndex;
		for (var j = 0; j < columnCount; j++) {
			cell = row.insertCell(insertIndex + j);
			cell.setAttribute('row', rows[i]);
			cell.setAttribute('column', columns[j]);
			cell.innerHTML = '&nbsp;';
			this.options.column[columns[j]].push(cell);
		}
	}
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
};

function _Designer_Control_Table_InsertRow() {
	if (this.selectedDomElement.length != 1) {
		alert(Designer_Lang.controlTableSelectOneCell); return;
	}
	//获得单元格相关信息
	var currCell = this.selectedDomElement[0], rows = currCell.getAttribute('row').split(',');
	var oldRows = currCell.parentNode.cells, cellCount = oldRows.length;
	var columns = this.options.column, oldCell, newCell, className, cloneColumns;
	//调整插入点后面的所有单元格的坐标属性
	this._resetCoordin(rows[0], -1, true);
	//找到有跨行合并的单元格
	this._dealRowSpanCells(currCell.parentNode, function(cell) {
		cell.rowSpan = cell.rowSpan + 1;
		var _rowNo = cell.getAttribute('row').split(',');
		_rowNo.push(parseInt(_rowNo[_rowNo.length - 1]) + 1);
		cell.setAttribute('row', _rowNo.join(','));
	});
	//克隆选中单元格所在的行
	var newRow = this.options.domElement.insertRow(rows[0]);
	for (var i = 0; i < cellCount; i++) {
		oldCell = oldRows[i];
		//克隆单元格
		newCell = oldCell.cloneNode(false);
		if (oldCell.rowSpan > 1) {newCell.rowSpan = 1;}
		newRow.appendChild(newCell);
		//设置相关属性
		newCell.setAttribute('row', rows[0]);
		newCell.innerHTML = '&nbsp;';
		//修正className
		className = oldCell.getAttribute('oldClassName');
		if (className != null) {
			newCell.className = className;
			newCell.removeAttribute('oldClassName');
		}
		//添加到列数组中
		cloneColumns = oldCell.getAttribute('column').split(',');
		columns[cloneColumns[0]].push(newCell);
	}
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
};

function _Designer_Control_Table_AppendRow() {
	var table = this.options.domElement;
	var oldRow = table.rows[table.rows.length -1];
	var oldCells = new Array();
	for (var i = 0, l = oldRow.cells.length; i < l; i ++) {
		oldCells.push(oldRow.cells[i]);
	}
	var columns = this.options.column;
	var rows = oldCells[0].getAttribute('row').split(',');
	var cloneColumns = null;
	var oldCell = null;
	//找到有跨行合并的单元格
	this._dealRowSpanCells(oldRow, function(cell) {
		oldCells.push(cell);
	});
	oldCells.sort(function(cell_1, cell_2) {
		var c1 = parseInt(cell_1.getAttribute('column').split(',')[0]);
		var c2 = parseInt(cell_2.getAttribute('column').split(',')[0]);
		return (c1 - c2);
	});
	var cellCount = oldCells.length; // 包含找到的合并单元格
	var newRow = table.insertRow(-1);
	for (var i = 0; i < cellCount; i++) {
		oldCell = oldCells[i];
		//克隆单元格
		newCell = oldCell.cloneNode(false);
		if (oldCell.rowSpan > 1) {newCell.rowSpan = 1;}
		newRow.appendChild(newCell);
		//设置相关属性
		newCell.setAttribute('row', '' + newRow.rowIndex);
		newCell.innerHTML = '&nbsp;';
		//修正className
		className = oldCell.getAttribute('oldClassName');
		if (className != null) {
			newCell.className = className;
			newCell.removeAttribute('oldClassName');
		}
		//添加到列数组中
		cloneColumns = oldCell.getAttribute('column').split(',');
		columns[cloneColumns[0]].push(newCell);
	}
	this.owner.resizeDashBox.attach(this);
}

function createLabelSubject(obj,lableIndex){
	var imgPath = Com_Parameter.StylePath+"doc/";
	var imgId = tableName + "_Label_Img_";
	var btnId = tableName + "_Label_Btn_";
}

function _Designer_Control_Table_InsertColumn(currCell) {
	if (this.selectedDomElement.length != 1) {
		alert(Designer_Lang.controlTableSelectOneCell); return;
	}
	//获得单元格相关信息
	var table = this.options.domElement, count = table.rows.length, currCell = (currCell == null ? this.selectedDomElement[0] : currCell);
	var columnAttr = currCell.getAttribute('column').split(','), colIndex = parseInt(columnAttr[0]);
	var columns = this.options.column, column = columns[colIndex], rows = [], newColumn = [];
	var row, cell, rowAttr, newCell;
	//调整插入点后面的所有单元格的坐标属性
	this._resetCoordin(colIndex, -1, false);
	//记录行
	for (var i = 0; i < count; i++) {
		rows.push(table.rows[i]);
	}
	//插入列，除了合并单元格横跨的情况
	for (var i = column.length - 1; i >= 0; i--) {
		rowAttr = column[i].getAttribute('row').split(',');
		row = table.rows[rowAttr[0]];
		for (var j = 0; j < row.cells.length; j++) {
			cell = row.cells[j];
			if (cell == column[i]) {
				newCell = row.insertCell(j);
				//设置坐标相关属性
				newCell.setAttribute('row', rowAttr[0]);
				newCell.setAttribute('column', '' + colIndex);
				newCell.innerHTML = '&nbsp;';
				//添加到列数组中
				newColumn.push(newCell);
				//从行数组中删除当前行记录
				Designer.spliceArray(rows, row);
				break;
			}
		}
		//当前单元格是列合并单元格时
		for (var j = rowAttr.length - 1; j > 0; j--) {
			row = table.rows[rowAttr[j]];
			//插入单元格
			newCell = row.insertCell(this._getPosByRow(row, colIndex, 'column'));
			//设置坐标相关属性
			newCell.setAttribute('row', rowAttr[j]);
			newCell.setAttribute('column', '' + colIndex);
			newCell.innerHTML = '&nbsp;';
			//添加到列数组中
			newColumn.push(newCell);
			//从行数组中删除当前行记录
			Designer.spliceArray(rows, row);
		}
	}
	columns.splice(colIndex, 0, newColumn);
	//更新合并单元格横跨的colspan和column属性
	var lastColumn = -1;
	for (var i = rows.length - 1; i >= 0; i--) {
		row = rows[i];
		for (var j = 0; j < row.cells.length; j++) {
			cell = row.cells[j];
			columnAttr = cell.getAttribute('column').split(',');
			lastColumn = parseInt(columnAttr[columnAttr.length - 1]);
			if ((parseInt(columnAttr[0]) <= colIndex) && (lastColumn >= colIndex)) {
				columnAttr.push('' + (lastColumn + 1));
				cell.setAttribute('colSpan', '' + (columnAttr.length));
				cell.setAttribute('column', columnAttr.join(','));
				break;
			}
		}
	}
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
};

function _Designer_Control_Table_AppendColumn() {
	var table = this.options.domElement;
	var rows = table.rows;
	var newColumn = [], columnSize = 0, row;
	row = rows[1];
	for (var i = 0; i < row.cells.length; i ++) {
		var cell = row.cells[i];
		columnSize += (cell.colSpan && cell.colSpan > 1 ? cell.colSpan : 1);
	}
	for (var i = rows.length - 1; i >= 0; i--) {
		row = rows[i];
		var newCell = row.insertCell(-1);
		newCell.setAttribute('row', '' + i);
		newCell.setAttribute('column', '' + columnSize);
		newCell.innerHTML = '&nbsp;';
		newColumn.push(newCell);
	}
	this.options.column.push(newColumn);
	this.owner.resizeDashBox.attach(this);
}

function _Designer_Control_Table_DeleteRow() {
	if (!confirm(Designer_Lang.buttonsDeleteRowConfirm)) {
		return;
	}
	var isInSameColumn = false;
	if (this.selectedDomElement.length < 1) {
		alert(Designer_Lang.controlTableSelectOneCell); return;
	} else if (!this._isInSameRow(this.selectedDomElement) 
			&& !(isInSameColumn = this._isInSameColumn(this.selectedDomElement))) {
		alert(Designer_Lang.controlTableSelectInRowOrInColumn); return;
	}
	//是否跨列
	var isSpanCell = this.selectedDomElement[0].rowSpan > 1;
	//获得单元格相关信息
	var table = this.options.domElement, currCell = this.selectedDomElement[0], row, cell;
	var rowAttr = currCell.getAttribute('row').split(','), rowIndex = parseInt(rowAttr[0]);
	//开始到当前单元格所在行，若发现包含当前行信息的单元格则更新rowspan
	for (var i = 0; i < rowIndex; i++) {
		row = table.rows[i];
		for (var j = row.cells.length - 1; j >= 0; j--) {
			cell = row.cells[j];
			rowAttr = cell.getAttribute('row').split(',');
			if (parseInt(rowAttr[rowAttr.length - 1]) >= rowIndex) {
				rowAttr.pop();
				if (rowAttr.length == 1)
					cell.removeAttribute('rowSpan');
				else
					cell.setAttribute('rowSpan', '' + rowAttr.length);
				cell.setAttribute('row', rowAttr.join(','));
			}
		}
	}
	//当前行若有列合并单元格，则删除当前行的内容，保留其他合并内容
	var remains = [], insertIndex = -1, deleteControls = [];
	row = table.rows[rowIndex];
	for (var i = row.cells.length - 1; i >= 0; i--) {
		cell = row.cells[i];
		//删除包含的控件
		deleteControls = this._getControlsByCell(cell);
		for (var j = deleteControls.length - 1; j >= 0; j--)
			deleteControls[j].destroy();

		rowAttr = cell.getAttribute('row').split(',');
		if (rowAttr.length > 1) {
			rowAttr.pop();
			if (rowAttr.length == 1)
				cell.removeAttribute('rowSpan');
			else
				cell.setAttribute('rowSpan', '' + rowAttr.length);
			cell.setAttribute('row', rowAttr.join(','));
			remains.push(cell);
		}
	}
	//调整删除行后面的所有单元格的坐标属性
	this._resetCoordin(rowIndex + 1, -1, true, -1);
	//寻找下一行的位置，然后插入当前行的列合并单元格
	row = table.rows[rowIndex + 1];
	for (var i = remains.length - 1; i >= 0; i--) {
		rowAttr = remains[i].getAttribute('column').split(',');
		//寻找插入点
		insertIndex = this._getPosByRow(row, parseInt(rowAttr[0]), 'column');
		//若没找到，则认为是行尾
		if (insertIndex == -1)
			row.appendChild(remains[i]);
		else
			row.insertBefore(remains[i], row.cells[insertIndex]);
	}
	//从列集合中删除当前单元格
	row = table.rows[rowIndex];
	var columns = this.options.column;
	for (var i = 0; i < row.cells.length; i ++) {
		var cell = row.cells[i];
		var col = columns[cell.getAttribute('column').split(',')[0]];
		for (var j = 0; j < col.length; j ++) {
			if (cell === col[j]) {
				col.splice(j, 1);
				break;
			}
		}
	}
	//删除当前行
	table.deleteRow(rowIndex);
	//清空选中
	if (!isSpanCell && !isInSameColumn) this.selectedDomElement = [];
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
	if (isInSameColumn) {
		this.selectedDomElement.shift();
		this.deleteRow();
	}
	if (this.options.domElement.cells.length == 0) {
		this.destroy();
	}
};

function _Designer_Control_Table_DeleteColumn() {
	if (!confirm(Designer_Lang.buttonsDeleteColConfirm)) {
		return;
	}
	var isInSameRow = false;
	if (this.selectedDomElement.length < 1) {
		alert(Designer_Lang.controlTableSelectOneCell); return;
	} else if (!this._isInSameColumn(this.selectedDomElement)
			&& !(isInSameRow = this._isInSameRow(this.selectedDomElement))) {
		alert(Designer_Lang.controlTableSelectInRowOrInColumn); return;
	}
	//是否跨列
	var isSpanCell = this.selectedDomElement[0].colSpan > 1;
	//获得单元格相关信息
	var columns = this.options.column, currCell = this.selectedDomElement[0], column, cell;
	var columnAttr = currCell.getAttribute('column').split(','), columnIndex = parseInt(columnAttr[0]);
	//开始到当前单元格所在列，若发现包含当前列信息的单元格则更新colspan
	for (var i = 0; i < columnIndex; i++) {
		column = columns[i];
		for (var j = column.length - 1; j >= 0; j--) {
			cell = column[j];
			columnAttr = cell.getAttribute('column').split(',');
			if (parseInt(columnAttr[columnAttr.length - 1]) >= columnIndex) {
				columnAttr.pop();
				if (columnAttr.length == 1)
					cell.removeAttribute('colSpan');
				else
					cell.setAttribute('colSpan', '' + columnAttr.length);
				cell.setAttribute('column', columnAttr.join(','));
			}
		}
	}
	//调整删除列后面的所有单元格的坐标属性
	this._resetCoordin(columnIndex + 1, -1, false, -1);
	//当前行若有行合并单元格，则删除当前列的内容，保留其他合并内容
	var newColumn = [], deleteControls = [];
	column = columns[columnIndex];
	for (var i = column.length - 1; i >= 0; i--) {
		cell = column[i];
		//删除包含的控件
		deleteControls = this._getControlsByCell(cell);
		for (var j = deleteControls.length - 1; j >= 0; j--)
			deleteControls[j].destroy();
		
		columnAttr = cell.getAttribute('column').split(',');
		if (columnAttr.length > 1) {
			columnAttr.pop();
			if (columnAttr.length == 1)
				cell.removeAttribute('colSpan');
			else
				cell.setAttribute('colSpan', '' + columnAttr.length);
			cell.setAttribute('column', columnAttr.join(','));
			newColumn.push(cell);
		} else cell.parentNode.removeChild(cell);
	}
	//更新列数组
	column = columns[columnIndex + 1];
	if (column) {
		newColumn = newColumn.concat(column);
		columns.splice(columnIndex, 2, newColumn);
	} else {
		columns.splice(columnIndex, 1);
	}
	//清空选中
	if (!isSpanCell && !isInSameRow) this.selectedDomElement = [];
	//选中框重新附着
	this.owner.resizeDashBox.attach(this);
	if (isInSameRow) {
		this.selectedDomElement.shift();
		this.deleteColumn();
	}
	if (this.options.domElement.cells.length == 0) {
		this.destroy();
	}
};

function _Designer_Control_Table_GetControlsByCell(cell) {
	var children = cell.childNodes, element, controls = [], control;
	for (var i = children.length - 1; i >= 0; i--) {
		element = children[i];
		if (element.nodeType != 3 && Designer.isDesignElement(element)) {
			control = this.getControlByDomElement(element);
			if (control) controls.push(control);
		}
	}
	return controls;
};

/*函数功能：更新指定行或列的坐标属性 参数：index>开始行(列)数 endIndex>结束行(列)数 isRow>行或列 offset>调整偏移*/
function _Designer_Control_Table_ResetCoordinate(startIndex, endIndex, isRow, offset) {
	var _startIndex = startIndex || 0, _endIndex = endIndex || -1, _offset = offset || 1;
	if (isRow) {
		var table = this.options.domElement, rows, rowAttr;
		_endIndex = (_endIndex == -1 || _endIndex > table.rows.length) ? table.rows.length : (_endIndex + 1);
		for (var i = _startIndex; i < _endIndex; i++) {
			rows = table.rows[i];
			for (var j = rows.cells.length - 1; j >= 0; j--) {
				rowAttr = rows.cells[j].getAttribute('row').split(',');
				for (var k = rowAttr.length - 1; k >= 0; k--) {
					rowAttr[k] = parseInt(rowAttr[k]) + _offset;
				}
				rows.cells[j].setAttribute('row', rowAttr.join(','));
			}
		}
	} else {
		var columns = this.options.column, column, cell, columnAttr;
		_endIndex = (_endIndex == -1 || _endIndex > columns.length) ? columns.length : (_endIndex + 1);
		for (var i = _startIndex; i < _endIndex; i++) {
			column = columns[i];
			for (var j = column.length - 1; j >= 0; j--) {
				cell = column[j];
				columnAttr = cell.getAttribute('column').split(',');
				for (var k = columnAttr.length - 1; k >= 0; k--) {
					columnAttr[k] = parseInt(columnAttr[k]) + _offset;
				}
				cell.setAttribute('column', columnAttr.join(','));
			}
		}
	}
};

function _Designer_Control_Table_GetPosByRow(row, colIndex, coordinateType) {
	var _colIndex = colIndex || 0, _cType = coordinateType || 'row';
	if (!row) return -1;

	var cells = row.cells, cellCount = cells.length, attrs;
	for (var i = 0; i < cellCount; i++) {
		attrs = cells[i].getAttribute(_cType).split(',');
		if (parseInt(attrs[0]) >= _colIndex) return i;
	}
	return -1;
};

function _Designer_Control_Table_IsInSameRow(cells) {
	if (cells.length < 2) return true;
	var rowIndex = cells[0].parentNode.rowIndex;
	for (var i = 1, l = cells.length; i < l; i ++) {
		if (rowIndex != cells[i].parentNode.rowIndex) {
			return false;
		}
	}
	return true;
}

function _Designer_Control_Table_IsInSameColumn(cells) {
	if (cells.length < 2) return true;
	var cellIndex = cells[0].cellIndex;
	for (var i = 1, l = cells.length; i < l; i ++) {
		if (cellIndex != cells[i].cellIndex) {
			return false;
		}
	}
	return true;
}

function _Designer_Control_Table_GetColumnSize() {
	var cols = 0;
	var cells = this.options.domElement.rows[0].cells;
	for (var i = 0, l = cells.length; i < l; i++) {   
		cols += cells[i].colSpan;
	}
	return cols;
}

function _Designer_Control_Table_DealRowSpanCells(currRow, doFun) {
	var cellCount = currRow.cells.length;
	//找到有跨行合并的单元格
	var columnSize = this.getColumnSize();
	if (columnSize > cellCount) {
		var _row = currRow.previousSibling;
		var _currMaxColSize = cellCount;
		var _rowIndex = 2; // 从2开始
		while(_row != null) {
			if (_row.cells.length > _currMaxColSize) {
				for (var i = 0, l = _row.cells.length; i < l; i ++) {
					if (_row.cells[i].rowSpan >= _rowIndex) { // 跨行单元格
						doFun(_row.cells[i]);
					}
				}
			}
			if (_row.cells.length == columnSize) {
				break;
			}
			_currMaxColSize = _row.cells.length;
			_row = _row.previousSibling;
			_rowIndex ++;
		}
	}
}