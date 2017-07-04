Com_IncludeFile("../../sys/xform/designer/relation/relation_common.js");
Com_IncludeFile('json2.js');
function buildInputParams(inputsJSON){
	var data=[];
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
				alert(formName+" 作为执行条件时为不能为空");
				return false;
			}
			data.push( {
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
				
				data.push( {
					"uuId" : uuid,
					"fieldIdForm" : formId,
					"fieldValueForm" : val[i]
				});
			}
			if(isAllNull && required=="1"){
				alert(formName+" 作为该执行条件时不能为空");
				return false;
			}
		}

	}
	return data;
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