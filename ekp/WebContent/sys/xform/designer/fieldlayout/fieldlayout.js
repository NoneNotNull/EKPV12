Designer_Config.operations['fieldlaylout'] = {
	lab : "5",
	imgIndex : 54,
	title :'基本属性布局',
	run : function(designer) {
		designer.toolBar.selectButton('fieldlaylout');
	},
	type : 'cmd',
	shortcut : '',
	isAdvanced: false,
	select : true,
	cursorImg : 'style/cursor/fieldlayout.cur'
};
Designer_Config.controls.fieldlaylout = {
	type : "fieldlaylout",
	storeType : 'none',
	inherit : 'base',
	container : false,
	onDraw : _Designer_Control_fieldlaylout_OnDraw,
	onDrawEnd : _Designer_Control_fieldlaylout_OnDrawEnd,
	drawXML : _Designer_Control_fieldlaylout_DrawXML,
	implementDetailsTable : false,
	destroy: function(){
		//调用系统的销毁方法
		Designer_Control_Destroy.call(this);
		
		if(!this.owner.owner.fieldPanel.isClosed){
			//刷新基本属性布局已选属性面板
			this.owner.owner.fieldPanel.open();
		}
		
	},
	onAttrLoad : function(){
	},
	attrs : {
		fieldNames : {
			text : '基本属性字段',
			value : '',
			label:'',
			required: true,
			readOnly:true,
			width:"75%",
			type : 'comText',
			operate:'_fieldContorl_Choose',
			checkout:Designer_Layout_Control_Source_Required_Checkout,
			show : true
		},
		fieldIds : {
			text : '基本属性字段Id',
			value : '',
			type : 'text',
			show : false
		},
		
		paramsJSP : {
			text : '参数JSP路径',
			value : '',
			type : 'text',
			show : false
		}
		,
		fieldParams : {
			text : '参数设置',
			value : '',
			type : 'self',
			draw : _Designer_Control_Attr_fieldlaylout_params_Self_Draw,
			checkout:Designer_Layout_Control_fieldParams_Required_Checkout,
			show : true
		}
	},
	info : {
		name : '基本属性布局'
		//preview : "mutiTab.png"
	},
	resizeMode : 'no'
};
Designer_Config.buttons.control.push("fieldlaylout");
Designer_Menus.add.menu['fieldlaylout'] = Designer_Config.operations['fieldlaylout'];
function _fieldContorl_Choose(a,name){
//	var callFun = new Function('return window.parent._XForm_GetSysDictObj_' + Designer.instance.fdKey + '();');
	var baseObjs =_FieldsDictVarInfoByModelName;
	var objFieldsInDesign=Designer.instance.fieldPanel.panel.getfieldsInDesign();
	var fileds=[];
	for(var i=0;i<baseObjs.length;i++){
		var f=baseObjs[i];
		//已经出现在设计面板中的属性不需要重新选择
		if(!objFieldsInDesign[f.name]){
			fileds.push(f);
		}
	}
	
	RelatoinFormFieldChoose(document.getElementById(name),document.getElementById(name),function(rtn){
		if(rtn&&rtn.data&&rtn.data[0].id){
			var control=Designer.instance.attrPanel.panel.control;
			var values=control.options.values;
			
			document.getElementById(name).value=rtn.data[0].name;
			values.fieldNames=rtn.data[0].name;
			values.fieldIds=rtn.data[0].id;
			
			values.paramsJSP=_FieldsDictVarInfoByModelNameObj[values.fieldIds].jspParams;
		}
	},fileds);
}
function _Designer_Control_fieldlaylout_OnDraw(parentNode, childNode) {
	if (this.options.values.id == null){
		this.options.values.id = "fd_" + Designer.generateID();
	}
	if(!_Designer_Index_Object.fieldlayout){
		_Designer_Index_Object.fieldlayout=1;
	}
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	var values = this.options.values;
	var inputDom = document.createElement('input');
	inputDom.type='hidden';
	domElement.appendChild(inputDom);
	//domElement.style.display="inline";
	
	// selectDom.style.width = values.width;
	inputDom.id = this.options.values.id;
	
	
	//获取主model的名称 
	inputDom.modelName=window.parent._xform_MainModelName;
	var label = document.createElement("label");
	var labelText="";
	//判断是否从字段列表中选择
	if(Designer.instance.fieldPanel.chooseField){
		labelText=Designer.instance.fieldPanel.chooseField.label;
		this.options.values.fieldNames=labelText;
		this.options.values.fieldIds=Designer.instance.fieldPanel.chooseField.name;
	}
	else if(this.options.values.fieldNames){
		labelText=this.options.values.fieldNames;
	}
	else{
		labelText="基本属性"+_Designer_Index_Object.fieldlayout++;
	}
	inputDom.fieldIds = values.fieldIds;
//	inputDom.formIds = _FieldsDictVarInfoByModelNameObj[values.fieldIds].formIds;
//	inputDom.fieldNames = _FieldsDictVarInfoByModelNameObj[values.fieldIds].label;
//	inputDom.jspParams = _FieldsDictVarInfoByModelNameObj[values.fieldIds].jspParams;
//	values.paramsJSP= _FieldsDictVarInfoByModelNameObj[values.fieldIds].jspParams;
//	inputDom.jspRunProfix = _FieldsDictVarInfoByModelNameObj[values.fieldIds].jspRunProfix;
	
	for(var i=0;i<_FieldsDictVarInfoByModelName.length;i++){
		if(values.fieldIds==_FieldsDictVarInfoByModelName[i].name){
			inputDom.fieldNames=_FieldsDictVarInfoByModelName[i].label;
			inputDom.formIds =_FieldsDictVarInfoByModelName[i].formIds;
			inputDom.jspParams=_FieldsDictVarInfoByModelName[i].jspParams;
			//设置参数页面的路径
			values.paramsJSP=_FieldsDictVarInfoByModelName[i].jspParams;
			inputDom.jspRunProfix=_FieldsDictVarInfoByModelName[i].jspRunProfix;
			break;
		}
	}
	if(values.fieldParams){
		inputDom.fieldParams=values.fieldParams;
	}
	else{
		inputDom.fieldParams="{}";
	}
	this.attrs.fieldNames.label=labelText;
	values.label=labelText;
	label.innerHTML="["+labelText+"]";
	label.style.width='auto';
	domElement.appendChild(label);
}
function _Designer_Control_fieldlaylout_OnDrawEnd(){
	//情况字段面板的值
	Designer.instance.fieldPanel.chooseField='';
	
	if(!Designer.instance.fieldPanel.isClosed){
		//刷新基本属性布局已选属性面板
		Designer.instance.fieldPanel.open();
	}
	//Designer.instance.fieldPanel.open();
}
function _Designer_Control_fieldlaylout_DrawXML(){
	
}
function Designer_Layout_Control_fieldParams_Required_Checkout(msg, name, attr, value, values, control){
	var params={};
	if(value){
		params=JSON.parse(values.fieldParams.replace(/quot;/g,"\""));
	}
	if(!values.fieldIds){
		return false;
	}
	//判断某些字段中是否存在不能为空的参数
	var requiredParams=_FieldsDictVarInfoByModelNameObj[values.fieldIds].requiredParams;
	if(requiredParams){
		var requiredParamsAry= requiredParams.split(",");
		for(var i=0;i<requiredParamsAry.length;i++){
			if(!params[requiredParamsAry[i]]){
				msg.push(_FieldsDictVarInfoByModelNameObj[values.fieldIds].label,","+'必须设置必填参数');
				break;
			}
		}
		if(msg.length>0){
			return false;
		}
	}
	return true;
}
function Designer_Layout_Control_Source_Required_Checkout(msg, name, attr, value, values, control){
	if(values.fieldNames&&values.fieldIds){
		return true;
	}
	msg.push(control.attrs.fieldNames.label,","+'不能为空');
	return false;
}
function _Designer_Control_Attr_fieldlaylout_params_Self_Draw(name, attr, value,
		form, attrs, values, control){
	var html="";
	html+="<a href='#' onclick='_Designer_Control_fieldlaylout_OpenParams(this);' style='text-decoration:underline;margin-left:5px'>设置参数<a>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_fieldlaylout_OpenParams(obj){
	//避免通过这种Designer.instance.control方式取contorl后焦点丢失是失去对象信息
	var control=Designer.instance.attrPanel.panel.control;
	var values=control.options.values;
	if(!(values.fieldNames&&values.fieldIds)){
		alert('请先选择基本属性控件');
		return;
	}
	var paramRtnVal="";
	if(values.fieldParams){
		paramRtnVal=JSON.parse(values.fieldParams.replace(/quot;/g,"\""));
	}
	var dialog=new ModelDialog_Show(Com_Parameter.ContextPath+values.paramsJSP,paramRtnVal,function(rtnVal){
    	// 没有选择函数
		if(!rtnVal||rtnVal=='undefined'){
			return ;
		}
		values.fieldParams=JSON.stringify(
				rtnVal).replace(/"/g,"quot;");
		//保存属性参数
		Designer.instance.attrPanel.panel.resetValues();
    });
	dialog.setWidth("350");
	dialog.show();
}
//监听撤回事件,刷新已选控件列表
DesignerUndoSupport.on("undo",function(control){
	if(!Designer.instance.fieldPanel.isClosed){
		//刷新基本属性布局已选属性面板
		Designer.instance.fieldPanel.open();
	}
});
//监听恢复事件,刷新已选控件列表
DesignerUndoSupport.on("redo",function(control){
	if(!Designer.instance.fieldPanel.isClosed){
		//刷新基本属性布局已选属性面板
		Designer.instance.fieldPanel.open();
	}
});
function ModelDialog_Show(url,data,callback){
	this.AfterShow=callback;
	this.data=data;
	this.width=600;
	this.height=400;
	this.url=url;
	this.setWidth=function(width){
		this.width=width;
	};
	this.setHeight=function(height){
		this.height=height;
	};
	this.setCallback=function(action){
		this.callback=action;
	};
	this.setData=function(data){
		this.data=data;
	};
	
	this.show=function(){
		var obj={};
		obj.data=this.data;
		obj.AfterShow=this.AfterShow;
		Com_Parameter.Dialog=obj;
		var left = (screen.width-this.width)/2;
		var top = (screen.height-this.height)/2;
		
		var winStyle = "resizable=1,scrollbars=1,width="+this.width+",height="+this.height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		var win= window.open(this.url, "_blank", winStyle);
		try{
			win.focus();
		}
		catch(e){
			
		}
		//用window.open 达到模态效果
		window.onfocus=function (){
			try{
				win.focus();
			}catch(e){
				
			}
		};
	    window.onclick=function (){
	    	try{
				win.focus();
			}catch(e){
				
			}
	    };
	};
	
}