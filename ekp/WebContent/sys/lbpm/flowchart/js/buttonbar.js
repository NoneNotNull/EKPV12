/*******************************************************************************
 * 功能：按钮栏对象和方法
 * 使用： 在流程图的上一层IFrame引入
 * 作者：叶中奇
 * 创建时间：2008-05-05
 * 修改记录：
 ******************************************************************************/
var ButtonBarObject = new ButtonBar();
var ICON_SIZE = 16;
// =====================按钮栏对象=======================
function ButtonBar() {
	//==========方法==========
	this.AddLine = ButtonBar_AddLine; // 添加一条分隔线
	this.AddButton = ButtonBar_AddButton; // 添加一个操作按钮
	this.Clear = ButtonBar_Clear;

	var tbObj = document.getElementById("mainTable");
	this.DOMElement = tbObj.rows[0].cells[0];
}
/**
 * 增加清除ButtonBar的功能，防止出现重复按钮
 * 在view.js对ButtonBar继续init的时候将调用该方法
 * #作者：曹映辉 #日期：2011年12月13日 
 */
function ButtonBar_Clear() {
	this.DOMElement.innerHTML = "";
}
//功能：单个按钮对象
// 参数：
// parent：ButtonBar对象
// operation：按钮操作，类型为FlowChart_Operation（panel.js）
// imgIndex：该操作的按钮位置（在buttonbar.gif中的位置索引）
function ButtonBar_Button(parent, operation, imgIndex) {
	this.Operation = operation;
	this.Selected = false;
	this.SetSelected = ButtonBar_Button_SetSelected; // 注意：该方法必须实现

	var newElem = document.createElement("div");
	parent.DOMElement.appendChild(newElem);
	newElem.className = "button_nor";

	this.DOMElement = newElem;
	newElem.LKSObject = this;
	newElem.title = operation.Title || operation.Text;
	newElem.onselectstart = function(){return false;};
	newElem.onmouseover = ButtonBar_Button_OnMouseOver;
	newElem.onmouseout = ButtonBar_Button_OnMouseOut;
	newElem.onclick = ButtonBar_Button_OnClick;

	var childElem = document.createElement("div");
	newElem.appendChild(childElem);
	if (isNaN(imgIndex)) { // 支持图标为链接的方式
		childElem.className = "button_img_self";
		childElem.style.backgroundImage = "url(" + imgIndex + ")";
	} else {
		childElem.className = "button_img";
		childElem.style.backgroundPositionY = -imgIndex * ICON_SIZE;
		childElem.style.backgroundPosition = "center " + (-imgIndex * ICON_SIZE) + "px"; // Firefox
	}
}

//功能：添加一条分隔线
function ButtonBar_AddLine() {
	var newElem = document.createElement("div");
	this.DOMElement.appendChild(newElem);
	newElem.className = "button_line";
	var childElem = document.createElement("div");
	newElem.appendChild(childElem);
	childElem.className = "button_img";
}

//功能：添加一个操作按钮
function ButtonBar_AddButton(operation, imgIndex) {
	return new ButtonBar_Button(this, operation, imgIndex);
}

//功能：更新操作按钮是否被选中
function ButtonBar_Button_SetSelected(selected) {
	this.DOMElement.className = selected ? "button_sel" : "button_nor";
	this.Selected = selected;
}

//功能：操作按钮鼠标经过事件
function ButtonBar_Button_OnMouseOver(e) {
	this.className = "button_sel";
}

//功能：操作按钮鼠标移出事件
function ButtonBar_Button_OnMouseOut(e) {
	this.className = this.LKSObject.Selected ? "button_sel" : "button_nor";
}

//功能：操作按钮鼠标点击事件
function ButtonBar_Button_OnClick(e) {
	var operation = this.LKSObject.Operation;
	operation.Run(operation.Argument);
}