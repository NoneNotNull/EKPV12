/**********************************************************
功能：基本属性列表
使用：

备注：

作者：
创建时间：2009-03-18
**********************************************************/
document.writeln('<link href="'+Com_Parameter.ContextPath+ 'sys/xform/designer/fieldlayout/fieldlist.css" type="text/css" rel="stylesheet" />');
function GetFieldsDictVarInfoByModelName(){
	//view 界面获取不到modelname无需加载处理
	if(!window.parent._xform_MainModelName){
		return [];
	}
	return new KMSSData().AddBeanData("sysFieldsDictVar&modelName="+window.parent._xform_MainModelName).GetHashMapArray();
}
var _FieldsDictVarInfoByModelName=GetFieldsDictVarInfoByModelName();
var GetFieldsDictVarInfoByModelNameObj=function(){
	var obj={};
	if(!_FieldsDictVarInfoByModelName ||_FieldsDictVarInfoByModelName.length==0){
		return obj;
	}
	for(var i=0;i<_FieldsDictVarInfoByModelName.length;i++){
		var fieldDict=_FieldsDictVarInfoByModelName[i];
		obj[fieldDict.name]=fieldDict;
	}
	return obj;
}
var _FieldsDictVarInfoByModelNameObj=GetFieldsDictVarInfoByModelNameObj();
function _Designer_Attr_AddAll_FieldLayout_Controls(controls, obj) {
	for (var i = 0, l = controls.length; i < l; i ++) {
		if("fieldlaylout"==controls[i].type){
			obj[controls[i].options.values.fieldIds]=controls[i];
		}
		_Designer_Attr_AddAll_FieldLayout_Controls(controls[i].children, obj);
	}
}


var Designer_FieldPanel = function() {
	this.domElement = document.createElement('div');
//	this.width = '252px';
}
Designer_FieldPanel.selectLayout=function(builder,obj){
	if($(obj).attr("class") == "field_panel_choosed"){
		//alert('该属性已经选择,不能重复选择');
		return;
	}
	$("div[class='field_panel_click']").attr("class",'field_panel_normal');
	$(obj).attr("class","field_panel_click");
	builder.owner.toolBar.selectButton('fieldlaylout');
	builder.owner.fieldPanel.chooseField={"name":obj.getAttribute("name"),"label":obj.getAttribute("label"),"type":obj.getAttribute("type")};
}
Designer_FieldPanel.mouseover=function(div){
	//
	if($(div).attr("class") != "field_panel_normal"){
		return;
	}
	$(div).attr("class","field_panel_mouseover");
}
Designer_FieldPanel.onmouseout=function(div){
	//
	if($(div).attr("class") != "field_panel_mouseover"){
		return;
	}
	$(div).attr("class","field_panel_normal");
}

Designer_FieldPanel.prototype = {
	//设计面板上已经存在的字段
	getfieldsInDesign:function(){
		var c={};
		_Designer_Attr_AddAll_FieldLayout_Controls(this.designer.builder.controls,c);
		return c;
	},
	//选择的字段
	chooseField:'',
	init : function(panel) {
		this.panel = panel;
		this.designer = panel.owner;

		this.builder = this.designer.builder;
		this.builderName = this.panel.owner.id + '.builder';
		this.attrPanelName = this.panel.owner.id + '.attrPanel';
		this.initTitle();
		this.initMain();
		this.initBottomBar();
		this.setTitle('基本属性列表');
		this.panel.open = function() {
			//_Designer_Attr_AddAll_FieldLayout_Controls(this.panel.builder.controls,this.panel.fieldsInDesign);
			//默认在右边展示面板 作者 曹映辉 #日期 2014年12月12日
			if(this.domElement.style.left=="5px"){
				this.domElement.style.left=(document.body.clientWidth-257)+"px";
			}
			if (this.domElement._clientTop != null) {
				this.domElement.style.top = parseInt(this.domElement._clientTop) + document.body.scrollTop + 'px';
			}
			else if (this.domElement.offsetTop < document.body.scrollTop) {
				this.domElement.style.top = document.body.scrollTop + Designer.absPosition(this.owner.builder.domElement).y + 'px';
			}
			else if (this.domElement.offsetTop > 
				(document.body.scrollTop + document.body.clientHeight)) {
				var top = (document.body.scrollTop + document.body.clientHeight)
						 - this.domElement.offsetHeight;
				top = top < 0 ? 0 : top;
				this.domElement.style.top = (top + 'px');
			}
			else {
				this.domElement.style.top = Designer.absPosition(this.owner.builder.domElement).y + 'px';
			}
			Designer_Panel_Open.call(this);
			this.domElement._clientTop = this.domElement.offsetTop - document.body.scrollTop;
		};
		var _domElement = this.panel.domElement;
		Designer.addEvent(window , 'scroll' , function() {
			if  (_domElement._clientTop != null) {
				_domElement.style.top = parseInt(_domElement._clientTop) + document.body.scrollTop + 'px';
			}
		});
		
	},

	initTitle : Designer_Panel_Default_TitleDraw,

	initMain : function() {
		var self = this;
		this.mainWrap = document.createElement('div');
		this.mainWrap.className = 'panel_main_tree';
		this.mainBox = document.createElement('div');
		this.mainBox.className = 'panel_main_tree_box';

		this.mainWrap.appendChild(this.mainBox);
		this.domElement.appendChild(this.mainWrap);
		this.setNoControl();

		this.panel.draw = function() {
			self.draw();
		}
	},

	setTitle : Designer_Panel_Default_SetTitle,

	initBottomBar : Designer_Panel_Default_BottomDraw,

	setNoControl: function() {
		this.mainBox.innerHTML = '<center>没有可以用的属性或扩展</center>';
		this.mainWrap.style.height = this.mainBox.offsetHeight + 'px';
	},
	draw : function() {
		if (this.panel.isClosed) return; // 不执行操作
		this.controls = []; // 当前控件集合
		//var callFun = new Function('return window.parent._XForm_GetSysDictObj_' + Designer.instance.fdKey + '();');
		var baseObjs = _FieldsDictVarInfoByModelName;
		if(!baseObjs||baseObjs.length==0){
			this.setNoControl();
			return;
		}
		var objFieldsInDesign=this.getfieldsInDesign();
		var contentHTML=[];
		for(var i=0;i<baseObjs.length;i++){
			var f=baseObjs[i];
			var classId="field_panel_normal";
			if(objFieldsInDesign[f.name]){
				classId="field_panel_choosed";
			}
			contentHTML.push("<div class='"+classId+"' ");
			//name label type
			contentHTML.push(" name='"+f.name+"'");
			contentHTML.push(" label='"+f.label+"'");
			contentHTML.push(" type='"+f.type+"'");
			contentHTML.push(" onmouseover='Designer_FieldPanel.mouseover(this);'");
			contentHTML.push(" onmouseout='Designer_FieldPanel.onmouseout(this);'");
			contentHTML.push(" onclick='Designer_FieldPanel.selectLayout("+this.builderName+",this)'");
			contentHTML.push(">");
			contentHTML.push("<span>");
			if("true"==f.required){
				contentHTML.push("<SPAN class=txtstrong>*</SPAN>");
			}
			contentHTML.push(f.label);
			contentHTML.push("</span>");
			if("true"==f.required){
				contentHTML.push("(必选)");
			}
			contentHTML.push("</div>");
		}
		//this.buildTree(this.builder.controls, -1);
		//this.mainBox.innerHTML = '<div style="position : relative">'+ this.tree.toString()+'</div>';
		this.mainBox.innerHTML = '<div style="position : relative">'+ contentHTML.join('')+'</div>';
		
		if (this.mainBox.offsetHeight > 300) {
			this.mainBox.style.height = '300px';
			this.mainBox.style.overflow = 'auto';
		}
		this.mainWrap.style.height = this.mainBox.offsetHeight + 'px';
	}
}
Designer_Config.operations['fieldlist'] = {
		imgIndex : 55,
		title : '基本属性列表',
		run : function (designer) {
			if(designer.fieldPanel.isClosed){
				designer.fieldPanel.open();
			}
			else{
				designer.fieldPanel.close();
			}
			
		},
		type : 'cmd',
		hotkey : 'shift+t',
		hotkeyName : 'Shift + T',
		isAdvanced: false
	};
Designer_Config.buttons.control.push("fieldlist");