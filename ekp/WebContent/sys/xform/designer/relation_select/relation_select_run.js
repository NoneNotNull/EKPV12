document.write("<script>Com_IncludeFile('json2.js');</script>");
document.write("<script>Com_IncludeFile('select2.js|select2.css','../sys/xform/designer/relation_select/select2/');</script>");
document.write("<script>Com_IncludeFile('select2_locale_zh-CN.js','../sys/xform/designer/relation_select/select2/');</script>");
document.write("<script>Com_IncludeFile('md5-min.js','../sys/xform/designer/relation_event/style/js/');</script>");
$( function() {
	
	//非明细表内控件初始化
	$('select[mytype="relation_select"]').each(function(){
		if(this.name.indexOf("!{index}")>=0){
			return;
		}
		$(this).select2({dropdownAutoWidth:true});
	});
	//明细表内控件 有明细表的 table-add 事件触发初始化
	$(document).on('table-add','table[showStatisticRow]',function(row){
		
		$(this).find('select[mytype="relation_select"]').each(function(){
			
			$(this).select2({dropdownAutoWidth:true});//.on('select2-focus',function(){alert('abc');});
			
		});
	});
	
	//控件点击是操作
	$(document).on('select2-focusnodrop', '[mytype="relation_select"]', function() {
		
		var control = this;
		
		var controlid = $(control).attr('myid');
		var inputParams = $(control).attr('inputParams');
		var outputParams = $(control).attr('outputParams');
		var params = $(control).attr('params');

		relation_select_run(control, inputParams, outputParams, params);
	});
	
	//控件change时操作
	$(document).on('change', '[mytype="relation_select"]', function() {
		var control = this;
		///var controlid = $(control).attr('myid');
		//var ids = getIdsbyControlId(controlid);

		var text = $(control).find('option:selected').text();
		SetXFormFieldValueById($(control).attr('textName'), text);
		//SetXFormFieldValueById(ids.idvalue, $(control).val());
	});
});
function relation_select_run(control, inputParams, outputParams, params) {	
	/*
	 * var data = { "_source" : "s", "_key" : "key", "ins" : [] };
	 */
	var data = JSON.parse(params.replace(/quot;/g, "\""));
	data.ins = [];
	var inputsJSON = JSON.parse(inputParams.replace(/quot;/g, "\""));
	var outputsJSON = JSON.parse(outputParams.replace(/quot;/g, "\""));
	var hiddenValue = outputsJSON["hiddenValue"].uuId;
	var textValue = outputsJSON["textValue"].uuId;
	//构建输出参数
	var outs=[];
	var outsAry=(hiddenValue+textValue).match(/\$[^\$]+\$/g);
	outsAry=outsAry?outsAry:[];
	var temoOuts={};
	for(var i=0;i<outsAry.length;i++){
		var outsUuId=outsAry[i].replace(/\$/g, "");
		//去掉重复的输出参数
		if(temoOuts[outsUuId]){
			continue;
		}
		temoOuts[outsUuId]=true;
		outs.push({"uuId":outsUuId});
	}
	data.outs=JSON.stringify(outs);
	
	
	
	//构建输入参数
	for ( var uuid in inputsJSON) {
		var formId = inputsJSON[uuid].fieldIdForm;
		var required=inputsJSON[uuid]._required;
		var formName=inputsJSON[uuid].fieldNameForm;
		formId = formId.replace(/\$/g, "");
		var val="";
	
		
		
		//参数在明细表内 
		if(formId.indexOf(".")>=0){
			var indexs=control.name.match(/\.(\d+)\./g);
			indexs=indexs?indexs:[];
			var detailFromId=formId.split(".")[0];
		
			
			//控件在明细表内,并且是在相同的明细表 取同行控件的值
			if(indexs.length>0 && control.name.indexOf(detailFromId)>=0){
				
				formId=formId.replace(".",indexs[0]);
				val = GetXFormFieldValueById_ext(formId,true);
			}
			else{
				//参数在其他其他明细表中 去所有行的数据
				var fieldId=formId.split(".")[1];
				val = GetXFormFieldValueById_ext(fieldId);
			}
			
		
			
		}
		else{
			//获取字段的值
			val = GetXFormFieldValueById_ext(formId,true);
			
		}
		if(val&&val.length==0){
			if(required=="1"){
				alert(formName+" 作为该下拉框执行条件时为不能为空");
				return;
			}
			data.ins.push( {
				"uuId" : uuid,
				"fieldIdForm" : formId,
				"fieldValueForm" : ""
			});
		}
		else{
			//是否所有值为空
			var isAllNull=true;
			for(var i=0;i<val.length;i++){
				if(val[i]){
					isAllNull=false;
				}
				
				data.ins.push( {
					"uuId" : uuid,
					"fieldIdForm" : formId,
					"fieldValueForm" : val[i]
				});
			}
			if(isAllNull && required=="1"){
				alert(formName+" 作为该下拉框执行条件时不能为空");
				return;
			}
		}

	}
	//把json数字 字符串化
	data.ins = JSON.stringify(data.ins);// .replace(/"/g,"'");
	data.conditionsUUID=hex_md5(data.ins+""+data._key);
	// 校验传入参数是否相同，相同则无需重复加载
	if ($(control).attr("inputParamValues") == data.ins) {
		$(control).select2("open");
		return;
	}
	$(control).attr("inputParamValues", data.ins);
	
	$
			.ajax( {
				url : Com_Parameter.ContextPath+"sys/xform/controls/relation.do?method=run",
				type : 'post',
				async : true,//是否异步
				data : data,
				success : function(json) {
					//增加排序防止出现 id和name错乱
					if(json.outs){
						json.outs.sort(function(a,b){
							return a.rowIndex-b.rowIndex;
						});
					}
					var values = relation_getFiledsById(json, hiddenValue);
					var texts = relation_getFiledsById(json, textValue);
					
					if (values && texts) {
						var html = "<option value=''>==请选择==</option>";
						for ( var i = 0; i < values.length; i++) {
							html += "<option value='" + values[i] + "'>"
									+ texts[i] + "</option>";
							
						}

						$(control).html(html);
						//$(control).select2("data",[{id: "1", text: "b"},{id: "2", text: "c"}]);
						$(control).select2("open");


					}
				},
				dataType : 'json',
				beforeSend : function() {
					$(control)
							.after(
									"<img align='bottom' src='"
											+ Com_Parameter.ContextPath
											+ "sys/xform/designer/relation_select/select2/select2-spinner.gif'></img>");
				},
				complete : function() {
					
					$(control).next().remove();

					// $(control).select2('open');
				// $(control).remove("<span><img
				// src='"+Com_Parameter.ContextPath+"sys/xform/designer/relation_select/select2/select2-spinner.gif'></img></span>");
				},
				error : function(msg) {
					$(control).next().remove();
					
					alert('执行获取数据过程中出错！');
				}
			});
}
function relation_getFiledsById(result, script){
	var res=[];
	var rows=0;
	var cols=0;
	var tables=[];
	if(!result || !result.outs){
		return res;
	}
	//把传出结果变成字段数组
	for ( var i = 0; i < result.outs.length; i++) {
		var op = result.outs[i];
		var uuid = op.uuId ? op.uuId : op.fieldId;
		
		if(!res[uuid]){
			cols++;
			res[uuid]=[];
		}
		res[uuid].push(op);
		//取表达式中 最大的数据行作为有效行
		if(script.indexOf("$"+uuid+"$") != -1 && res[uuid].length>rows){
			rows=res[uuid].length;
		}
			
	}
	var rtn=[];
	for(var i=0;i<rows;i++){
		
		rtn.push(relation_getFiledById(i,res,script));
	}
	return rtn;
}
function relation_getFiledById(row,result, script) {
	
	script=script.replace(/\$[^\$]+\$/g,function(id){
		
		for ( var attr in result) {
			//row取的是最大的长度的属性数据，其他不足该长度的属性直接设置为空
			if(result[attr].length<=row){
				continue ;
			}
			var op = result[attr][row];
			
			var uuid = op.uuId ? op.uuId : op.fieldId;
			
			if (id == "$"+uuid+"$") {
				return op.fieldValue;
			}
		}
		//找不到表达式对应的值直接设置为空
		return "";
	});
	
	return script;
}
/**
 * 
 * @param id
 * @param allMatch 是否精确匹配
 * @return
 */
function GetXFormFieldById_ext(id,allMatch) {
	var forms = document.forms;
	obj = [];
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			if(!elems[j].name){
				continue;
			}
		
			if(allMatch){
				//考虑地址本带 .id .name等情况
				var reg = new RegExp("^extendDataFormInfo\\.value\\("+id+"(\\.id)?\\)$","ig");
				//alert(elems[j].name +"   "+elems[j].name.match(reg));
				if(elems[j].name==id || (elems[j].name).match(reg)){
					obj.push(elems[j]);
				}
			}
			else{
				if(elems[j].name.indexOf(id)> -1){
					obj.push(elems[j]);
				}
			}
		}
	}
	return obj;
}
/**********************************************************
功能：自定义表单根据控件ID获取对象值

参数：
	id           ：ID
	nocache      ：不用缓存
返回值：
	值数组
**********************************************************/
function GetXFormFieldValueById_ext(id,allMatch) {
	var rtn = [];
	var objs = GetXFormFieldById_ext(id,allMatch);
	for (var i = 0; i < objs.length; i ++) {
		//单选框 只选择已经选中的
		if(objs[i]&&objs[i].type&&objs[i].type=='radio'){
			if(!objs[i].checked){
				continue;
			}
		}
		rtn.push(objs[i].value);
	}
	return rtn;
}
