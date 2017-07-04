Com_IncludeFile("dialog.js");
Com_IncludeFile('json2.js');
Com_IncludeFile("../../sys/xform/designer/relation/relation_common.js");

Designer_AttrPanel.comTextDraw = function(name, attr, value, form, attrs,
		values, control) {
	var width = "95%";
	if (attr.operate) {
		width = "auto";
	}
	if (attr.width) {
		width = attr.width;
	}
	var html = " <input type='text' style='width:" + width
			+ "' class='attr_td_text' id='" + name + "' name='" + name;
	if (attr.value != value && value != null) {
		html += "' value='" + value;
	} else {
		html += "' value='" + attr.value;
	}
	if (attr.readOnly) {
		html += "' readOnly='" + attr.value;
	}

	html += "'>";
	// html+="<input type='hidden' name='"+name+"_id' id='"+name+"_id'/>"
	if (attr.operate) {
		//Designer_Lang.relation_select_choose 选择
		html += "&nbsp;<a href='#' onclick='" + attr.operate + "(this,\""
				+ name + "\");'>"+Designer_Lang.relation_select_choose+"</a>";
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

var RelationSource = function() {
	var self = this;
	this.init = function() {
		//获取扩展点中数据源
		// this.extStyle='';
		$.ajax( {
			url : Com_Parameter.ContextPath+"sys/xform/controls/relation.do?method=source",
			type : 'post',
			async : false,//同步请求
			success : function(json) {

				self.source = json;
			},
			dataType : 'json',

			error : function(msg) {
				alert('扩展点中数据源出错');
			}
		});
	};
	this.GetUUID = function() {

		return self.sourceUUID;
	};
	this.GetSourceByUUID = function(uuid) {

		for ( var i = 0; i < self.source.length; i++) {
			if (uuid == self.source[i].sourceUUID) {

				return self.source[i];
			}
		}

		return null;
	};
	// 设置控件属性面板选项数组
	this.GetOptionsArray = function() {
		var sourceOptions = [];

		sourceOptions.push( {
			'text' : Designer_Lang.relation_select_pleaseChoose,
			'value' : ''
		});
		for ( var i = 0; i < self.source.length; i++) {

			sourceOptions.push( {
				"name" : self.source[i].sourceName,
				"text" : self.source[i].sourceName,
				"value" : self.source[i].sourceUUID
			});
		}
		return sourceOptions;
	};
	this.init();
};

//获取所有数据源
var relationSource = new RelationSource();



//isMast 是否强制加载
function loadTemplate(key, source,callBack,isMast){
	
	var control = Designer.instance.attrPanel.panel.control;
	if(!isMast){
		
		if(control.attrs.template.value){
			if(!control.attrs.template.varInfo){
				control.attrs.template.varInfo=GetVarInfoByControl(control,control.attrs.template.value);
			}
			callBack(control.attrs.template.value,control.attrs.template.varInfo);
			return;
		}
	}
	
	$.ajax( {
		type : "post",
		async : false,//是否异步
		url : Com_Parameter.ContextPath
				+ "sys/xform/controls/relation.do?method=template",
		data : {
			"_source" : source,
			"key" : key
		},
		dataType : "json",
		success : function(data) {
			
			if(!data){
				alert('业务函数模板不能为空');
				return ;
			}
			if(!data.outs||data.outs.length==0){
				alert("函数模板中输出参数不能为空");
				return;
			}
			
			control.attrs.template.value =data;// JSON.stringify(data).replace(/"/g,"quot;");
			control.attrs.template.varInfo=GetVarInfoByControl(control,data);
			
			callBack(data,control.attrs.template.varInfo);
		},
	error : function(msg) {
		alert('加载模板出错');
		
	}
	});
	
}
function GetVarInfoByControl(control,template) {
	//var template = JSON.parse(control.attrs.template.value.replace(/quot;/g,"\""));
	//var template =control.attrs.template.value;// JSON.parse(control.attrs.template.value.replace(/quot;/g,"\""));
	var varInfo = [];
	for ( var i = 0; i < template.outs.length; i++) {
		var field = template.outs[i];

		var fieldName = field.fieldName ? field.fieldName : field.fieldId;
		fieldName = fieldName ? fieldName : field.uuId;

		var fieldId = field.uuId;

		varInfo.push( {
			"name" : fieldId,
			"label" : fieldName,
			"type" : 'String'
		});
	}
	control.attrs.template.varInfo=varInfo;
	return varInfo;
}


function RelatoinFormFieldChoose(idField,nameField, action,varInfo) {
	var dialog = new KMSSDialog();
	dialog.BindingField(idField, nameField);
	if(!varInfo){
		varInfo=Designer.instance.getObj(true);
	}
	dialog.Parameters = {
		varInfo : varInfo
	};
	dialog
			.SetAfterShow( function(rtn) {
				action(rtn);
			});
	dialog.URL = Com_Parameter.ContextPath
			+ "sys/xform/designer/relation/relation_formfields_tree.jsp?t="+(new Date());
	dialog.Show(380, 480);

}
function Open_Relation_Fields_Tree(idField,nameField,varInfo,callback){
	var dialog = new KMSSDialog();
	dialog.BindingField(idField, nameField);
	dialog.Parameters = {
		varInfo :varInfo
	};
	dialog
			.SetAfterShow( function(rtn) {
				callback(rtn);
			});

	dialog.URL = Com_Parameter.ContextPath
			+ "sys/xform/designer/relation/relation_fields_tree.jsp?t="+(new Date());
	dialog.Show(380, 480);
}
function Relation_ShowButton(){
	Designer.instance.attrPanel.panel._changed = true;
	Designer.instance.attrPanel.panel.showBottom();
}
