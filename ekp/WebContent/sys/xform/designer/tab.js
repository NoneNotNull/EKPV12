/**
 * 多标签控件
 * @作者：曹映辉 @日期：2012年1月9日 
 */
 /*
  * 扩展builder的createControl函数，增加基于控件的创建功能
  * 参数：controlType>控件类型 currElement>需插入控件的容器Dom对象(可选)，若没有此参数，则根据当前选中控件*/

Designer_Builder.prototype.createControlByControl=function(controlType, currElement,control) {
	if(!control){
		control = currElement ? this.getControlByDomElement(currElement) : this.owner.control;
	}
	var created = typeof controlType == 'string' ? new Designer_Control(this, controlType, false) : controlType;
	if (control != null && control.container) {
		switch (control.getTagName()) {
		case 'table':
			var owner = currElement ? currElement : control.selectedDomElement[0];
			if (owner != null) {
				if (owner.tagName == null || owner.tagName.toUpperCase() != 'TD') {
					owner = control.options.domElement.cells[0];
				}
				if (control.insertValidate && !control.insertValidate(owner, created)) {break;}
				//若需插入的单元格只有空格，则要清除空格(&nbsp;)
				if (owner.innerHTML == '&nbsp;') owner.innerHTML = '';
				//绘制控件
				created.draw(control, owner);
			}
			break;
		case 'div':
			var owner = control.options.domElement;
			if (owner != null) {
				if (control.insertValidate && !control.insertValidate(owner, created)) {break;}
				if (owner.innerHTML == '&nbsp;') owner.innerHTML = '';
				created.draw(control, owner);
			}
			break;
		}
	} else {
		if (control != null && created.container) { // 处理容器新建时，在在控件上点击时
			var parent = control.parent ? control.parent : null;
			if (control.parent) {
				created.draw(parent, control.options.domElement.parentNode, Designer.getDesignElement(control.options.domElement.nextSibling, 'nextSibling'));
			} else {
				// 传统直接添加
				created.draw(null, this.domElement);
				this.controls.push(created);
			}
			var newParentDom = null;
			try {
				switch (created.getTagName()) {
					case 'table': newParentDom = created.options.domElement.rows[1].cells[1]; break;
					case 'div': newParentDom = created.options.domElement; break;
				}
			} catch (e) {}
			if (newParentDom != null) {
				control.draw(created, newParentDom); // 控件移动到新建容器中
			}
		} else if (control != null && control.parent && control.parent.container) {// 普通点在控件上
			var parent = control.parent ? control.parent : null;
			created.draw(parent, control.options.domElement.parentNode, Designer.getDesignElement(control.options.domElement.nextSibling, 'nextSibling'));
		} else {
			// 传统直接添加
			created.draw(null, this.domElement);
			this.controls.push(created);
		}
	}
	//选中控件
	this.resizeDashBox.attach(created);

	this.clearSelectedControl(); // 清空所有选择控件
	this.addSelectedControl(created);
	//记录当前控件
	this.owner.setControl(created);
	//更新控件树
	if (!this.owner.treePanel.isClosed)
		this.owner.treePanel.open();
	//相同则不重绘属性框
	//var attrPanel = this.owner.attrPanel;
	//if (!attrPanel.isClosed) attrPanel.show();
};


document.writeln("<style>");
//document.writeln("body{scrollbar-face-color:#A6DAFF;scrollbar-arrow-color:#FEFEFC;scrollbar-highlight-color:#FDFDFD;scrollbar-3dlight-color:#E5E5E3;scrollbar-shadow-color:#959794;scrollbar-darkshadow-color:#E4E6E5;scrollbar-track-color:#EEEEEE;}");
document.writeln(".td_label0{background:url("+Com_Parameter.StylePath+"doc/tdlabbg.gif)}");
document.writeln("</style>");
Designer_Config.operations['mutiTab']={
		lab : "5",
		imgIndex : 46,
		title:Designer_Lang.controlMutiTab_name_insert,
		run : function (designer) {
			designer.toolBar.selectButton('mutiTab');
		},
		type : 'cmd',
		shortcut : 'U',
		sampleImg : 'style/img/mutiTab.png',
		select: true,
		cursorImg: 'style/cursor/mutiTab.cur'
};
Designer_Config.controls.mutiTab={
			type : "mutiTab",
			storeType : 'layout',
			inherit    : 'base',
			container     : true,
			currentPanel:null,
			onDraw : _Designer_Control_MutiTab_OnDraw,
			onDrawEnd : _Designer_Control_MutiTab_OnDrawEnd,
			drawXML : _Designer_Control_MutiTab_DrawXML,
			onSelect:_Designer_Control_MutiTab_Select,
			onInitialize:_Designer_Control_MutiTab_DoInitialize,
			implementDetailsTable : true,
			insertValidate:_Designer_Control_Tab_InsertValidate,
			resetDashBox:_Designer_Control_Tab_ResetDashBox,
			destroyMessage:Designer_Lang.controlMutiTab_msg_del,
			//onAttrLoad : _Designer_Control_Attr_Tab_OnAttrLoad,
			attrs : {
				//label : Designer_Config.attrs.label,
				isUp : {
					text: Designer_Lang.controlMutiTab_isUp,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: false,
					onclick:'_Designer_Control_Attr_IsUp_Click(this)'
				},
				tabNames:{
					text: Designer_Lang.controlMutiTab_tabNames,
					value: "null",
					type: 'self',
					draw: _Designer_Control_Attr_mutiTab_Self_Draw,
					names:[],		
					show: true
				}
			},
			info:{
				name:Designer_Lang.controlMutiTab_name,
				preview: "mutiTab.png"
			}
			,
			resizeMode : 'no'
};
Designer_Config.buttons.control.push("mutiTab");
Designer_Menus.add.menu['mutiTab'] = Designer_Config.operations['mutiTab'];
/**
 * 校验当前控件是否可以提升
 */
function _Designer_Control_Attr_IsUp_Click(obj){
	
	var designer = (new Function('return ' + obj.form.designerId))();
	var control = designer.attrPanel.panel.control;
	var controls=designer.builder.controls;
	var domElement=control.options.domElement;
	
	var canUp=Designer_Control_Check_canUp(control,designer);
	
	if(!canUp){
		//当用户试图选中时弹出提示，用户试图取消时不需要提示
		if(obj.checked){
			//'提升多标签必须设置为根容器，该控件外或同级不能包含任何其他控件';
			alert(Designer_Lang.GetMessage(Designer_Lang.controlMutiTab_msg_error_position));
		}
		//control.options.values.isUp=false;
		obj.checked=false;
	}
	
	//alert(control.type);
	//var form = obj.form
}
function Designer_Control_Check_canUp(control,designer){
	var controls=designer.builder.controls;
	if(controls.length !=1){
		return false;
	}
	if(controls[0] != control){
		return false;
	}
	return true;
}
function _Designer_Control_Attr_mutiTab_Self_Draw(name, attr, value, form, attrs, values,control){
	
	
	var controlId=control.options.domElement.id;
	var html=[];
	for(var i=0;i<attr.names.length;i++){
		if(i==0){
			html.push(createTabName(attr.names[i],controlId,true));
		}
		else{
			html.push(createTabName(attr.names[i],controlId));
		}

	}
	html=html.join('');
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_Attr_Tab_OnAttrLoad(){
	//alert('L');
	//Designer.instance.builder.parse(this,this.options.domElement);
}

function createTabName(tabName,controlId,isFirst){
	var html="";
	html+="<span name='tabNamesSpans' name='spanTab_'"+controlId+">"
	html+= tabName.value+"<br/>";
	html+="<input type='text' name='tabNamesAttr_"+controlId+"' value='"+tabName.value+"' id='"+tabName.id+"_attr'/>";
	if(!isFirst){
		html+="<input type='button' value='-' onclick='remove_tab(this)'/>";
	}
	html+="<input type='button' value='+' onclick='add_tab(this)' name='inputAdd@"+controlId+"'/>";
	html+="<br/></span>";
	return html;
}
function add_tab(obj){
	//当面板个数发生变化是显示按钮
	Designer_AttrPanel.showButtons(obj);
	var spanTotal = $("span[name='tabNamesSpans']");
	var tabNamesCount=spanTotal.size();
	if(tabNamesCount>0){
		var controlId= obj.name.split("@")[1];
		$(obj.parentNode).after(createTabName({value:Designer_Lang.controlMutiTab_initTab+(tabNamesCount+1),id:Designer.generateID()},controlId));
	}
	
}
function remove_tab(obj){
	var isDel=confirm(Designer_Lang.GetMessage(Designer_Lang.controlMutiTab_msg_del_tab));
	if(!isDel){
		return;
	}
	Designer_AttrPanel.showButtons(obj);
	$(obj.parentNode).remove();
}
function _Designer_Control_MutiTab_Select(event){
	var currElement = event.srcElement || event.target;
	//alert(currElement);
}
function _Designer_Control_MutiTab_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('table', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "Label_Tabel_fd_" + Designer.generateID();

	domElement.id = this.options.values.id;
	domElement.style.width="100%";
	
	
}
function _Designer_Control_MutiTab_DrawXML() {
 	if (this.children.length > 0) {
		var xmls = [];
		this.children = this.children.sort(Designer.SortControl);
		for (var i = 0, l = this.children.length; i < l; i ++) {
			var c = this.children[i];
			if (c.drawXML) {
				var xml = c.drawXML();
				if (xml != null)
					xmls.push(xml, '\r\n');
			}
		}
		return xmls.join('');
	}
	return '';
}
function _Designer_Control_MutiTab_DoInitialize(){
	var self=this;
	var domElement = this.options.domElement;
	var domElement = this.options.domElement;
	this.options.values.isUp=domElement.getAttribute("isUp");
	if(this.options.values.isUp=='true'){
		//设置全局的提升标识的值
		Designer.instance.isUpTab=true;
	}
	
		
	this.options.values.id=domElement.getAttribute("id");
	
	
	var lks_label =  $(domElement).find("tr[LKS_LabelName][name="+domElement.id+"_name]");
	var tabNames=this.attrs.tabNames.names;
	if(lks_label.size()==0){
		this.attrs.tabNames.names=[{value:Designer_Lang.controlMutiTab_initTab_One,id:Designer.generateID()},{value:Designer_Lang.controlMutiTab_initTab_Two,id:Designer.generateID()},{value:Designer_Lang.controlMutiTab_initTab_Three,id:Designer.generateID()}];
	}else if(tabNames.length == 0){
		lks_label.each(function(index, domEle){
			
			tabNames.push({value:domEle.getAttribute("LKS_LabelName"),id:domEle.getAttribute("id")});
			
//			if($(domEle).css("display")=='block'){
//				self.selectedDomElement=[];
//				self.selectedDomElement.push(domEle.childNodes[0]);
//			}
		});
	}
	this.resetDashBox();
	
	
}
function _Designer_Control_MutiTab_OnDrawEnd(){
	var builder = Designer.instance.builder;
	//序列化相关信息
	builder.onSerialize(this);
	builder.serialize(this);
	builder.onSerialized(this);
	
	
	var values = this.options.values;
	var domElement = this.options.domElement;
	var myDom = $(domElement).clone(true);
	for (var i = this.children.length - 1; i >= 0; i--){
			//权限域，需调用原始的销毁函数
		    if(this.children[i].type=='right'){
		    	//this.children[i].destroy();
		    	this.children[i]._destroy();
		    }
		    else{
		    	this.children[i].destroy();
		    }
			
	}
	$(domElement).html(myDom.html());
	if (values){
		//设置是否提升属性。默认不提升
		if(!values.isUp){
			values.isUp=false;
		}
		//判断当前变更是否可以提升
		var canUp = Designer_Control_Check_canUp(this,Designer.instance);
		//当前变更允许提升时，根据当前的提升状态值决定全局提升标识
		if(canUp){
			//设置全局的提升标识的值
			Designer.instance.isUpTab=values.isUp;
			
		//当前变更后不允许提升，当原来是提示状态的强制设置为不可以提升
		}else if(values.isUp=='true'){
			values.isUp=false;
			Designer.instance.isUpTab=false;
			alert(Designer_Lang.GetMessage(Designer_Lang.controlMutiTab_msg_info_upinfo));
		}	
		domElement.setAttribute("isUp",values.isUp);
		
	}
	var size = $(domElement).find("tr[LKS_LabelName][name="+domElement.id+"_name]").size();
	
	var html=[];
	html.push("<tbody>");
	
	//记录新初始化的选项卡，为每个新生成的选项卡默认增加一个标准表格控件
	var newTabIds=[];
	//记录当前选项的选项卡索引
	var currentLabel=1;
	//所有待生成选项卡的集合
	var newTabNames=[];
	//初次生成选项卡
	if(size==0){	
		var newTabNames = this.attrs.tabNames.names;

		for(var i=0;i<newTabNames.length;i++){
			html.push("<tr LKS_LabelName='"+newTabNames[i].value+"' name='"+domElement.id+"_name' id='"+newTabNames[i].id+"'><td>&nbsp;</td></tr>");
			newTabIds.push(newTabNames[i].id);
		}
	}
	else{	
		currentLabel=$(domElement).attr("LKS_CurrentLabel");
		//清除选择的当前选项卡，默认选择第一个选项卡
		$(domElement).removeAttr("LKS_CurrentLabel");
		
		//属性面板中设置的标签名
		newTabNames = document.getElementsByName("tabNamesAttr_"+domElement.id);
		//保存后重新打开标签时取原值
		if(newTabNames.length==0){
			newTabNames=this.attrs.tabNames.names;
		}

		this.attrs.tabNames.names=[];
		for(var i=0;i<newTabNames.length;i++){
			var id=newTabNames[i].id.split("_")[0];
			
			this.attrs.tabNames.names.push({value:newTabNames[i].value,id:id});
			
			var obj = $(domElement).find("tr[LKS_LabelName][id="+id+"]");
			var inHTML="";
			var disStyle="display:none";
			
			//当前存在的选项卡
			if(obj.size()!=0){
				//去除拖拽后鼠标样式变为手型
				obj.children(0).removeAttr("style");
				inHTML = obj.html();
				
			}
			else{
				inHTML="<td>&nbsp;</td>";
				newTabIds.push(id);	
			}
			if(i==0){
				disStyle="table-row";
			}
			
			html.push("<tr LKS_LabelName='"+newTabNames[i].value+"' name='"+domElement.id+"_name' id='"+id+"' style='"+disStyle+"'>"+inHTML+"</tr>");
			
		}

	}
	html.push("</tbody>");	
	$(domElement).empty();
	$(domElement).html(html.join(''));
	Doc_LabelInfo=[];
	Doc_LabelInfo=[domElement.id];
	var th=this;
	setTimeout(function(){
		Doc_ShowLabelTable();
		//设置选中选项卡位置
		if(currentLabel>newTabNames.length){
			currentLabel=1;
		}
		Doc_SetCurrentLabel(domElement.id,currentLabel);
		//初始化选项卡默认表格
		for(var i=0;i<newTabIds.length;i++){
			var newTr=document.getElementById(newTabIds[i]);
			Designer.instance.builder.createControlByControl('standardTable',newTr.children[0],th); 
		}
		//重新将控件添加到控件树集合中
		Designer.instance.builder.parse(th,domElement);
		th.resetDashBox();
	},0);
	
}
//重新设置虚线框的位置
function _Designer_Control_Tab_ResetDashBox(){
	var domElement = this.options.domElement;
	
	var firstTabTr=$(domElement).children(0).children()[1];
	//table>tbody>tr>td>input
	var inputButtons = $(domElement).children(0).children(0).children(0).find("input[id^="+domElement.id+"]");
	var self=this;
	inputButtons.bind("click",function(){
		Designer.instance.builder.resetDashBoxPos();
		//alert(self);
		//Designer.instance.builder.clearSelectedControl();
		//Designer.instance.builder.selectedControl(domSrc.children(0)[0]);
		
//		var starIndex = (domElement.id+"_Label_Btn_").length;
//		var index = $(this).attr("id").substr(starIndex);
//		var domSrc=$(domElement).children(0).find("tr[LKS_LabelIndex="+index+"]");
//		self.selectedDomElement=[];
//		self.selectedDomElement.push(domSrc.children(0)[0]);
		
	});
}
/**
 * 禁止控件拖入容器非编辑区域
 */
function _Designer_Control_Tab_InsertValidate(cell, control){
	if (cell.tagName != 'TD')
	{
		return false;
	}
	//只有包含LKS_LabelName属性的cell才可以添加元素
	if(!$(cell.parentNode).attr("LKS_LabelName")){
		return false;
	}
	
	return true;
}
