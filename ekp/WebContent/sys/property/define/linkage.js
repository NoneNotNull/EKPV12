Com_RegisterFile("linkage.js");
Com_IncludeFile("data.js|jquery.js");

/**
 * 下拉框联动事件类
 */

//页面初始化
$(document).ready(function(){
	var len = _values.length;
	for(var i=0;i<len;i++){
		initControl(_values[i][2],_values[i][0],_values[i][1]);
	}
});

/**
 * 初始化绑定筛选项
 * @param defineId
 * @param parentValue
 * @param defaultValue
 * @return
 */
function initControl(defineId,parentValue,defaultValue){
	var values = findData(defineId,parentValue);
	buildItem(values,defineId,defaultValue);
}

/**
 * 事件绑定筛选项
 * @param defineId
 * @return
 */
function eventListen(defineId){
	var src = event.srcElement;
	var values = findData(defineId,src.value);
	buildItem(values,defineId);
};

//ajax查找数据
function findData(defineId,pValue){
	var data = new KMSSData();
	var beanData = "sysPropertyOptionListService&fdDefineId="+defineId+"&pValue="+pValue;
	data.AddBeanData(beanData);
	return data.GetHashMapArray();
}

/**
 * 构建选项
 * @param values
 * @param targetDefineId
 * @param defaultValue
 * @return
 */
function buildItem(values,targetDefineId,defaultValue){
	var len = values.length-1;
	if(len<0)return;
	var type = values[len].displayType;
	var structureName = values[len].structureName;
	
	switch (type)
	{
		case "select":{
			if(this.method!='view'){
				var target = $(document.getElementsByName(structureName)[0]);
				//判断不是第一次加载
				if(event && event.type!="readystatechange"){
					target.val("").trigger('change');
				}
				target.empty();
				target.append("<option value=''>==请选择==");
				for(var i=0;i<len;i++){
					target.append("<option value='"+values[i].value+"'>"+values[i].text);
				}
				target.val(defaultValue);
			}else{
				for(var i=0;i<len;i++){
					if(values[i].value == defaultValue){
						$("#"+targetDefineId).prepend(values[i].text);
						break;
					}
				}
			}
			break;
		}
		case "radio":{
			var target = $("#"+targetDefineId);
			var isDisabled = this.method=='add'||this.method=='edit'?"":"disabled";
			$("#"+targetDefineId+"> nobr").remove();
			for(var i=len-1;i>-1;i--){
				if(defaultValue==values[i].value){
					target.prepend("<nobr><label><input type='radio' name='"+structureName +
						"' value='"+values[i].value+"'"
						+" checked />" +values[i].text+"&nbsp;</label></nobr>");
				}else{
					target.prepend("<nobr><label><input type='radio' name='"+structureName + 
							"' value='"+values[i].value+"' "+isDisabled+" />" +values[i].text+"&nbsp;</label></nobr>");
				}
			}
			//判断不是第一次加载
			if(event && event.type!="readystatechange"){
				var structureNameVal = structureName.replace(".","\\.").replace("(","\\(").replace(")","\\)");
				//[checked=true]
				$("input[name="+structureNameVal+"]").attr("checked",false).trigger('click');
			}
			try{
				var fun = eval("fun_"+targetDefineId);
				if(typeof(fun)=="function"){
					fun();
				}
			}catch(e){}
			break;
		}
		case "checkbox":{
			var target = $("#"+targetDefineId);
			var isDisabled = this.method=='add'||this.method=='edit'?"":"disabled";
			$("#"+targetDefineId+"> nobr").remove();
			for(var i=len-1;i>-1;i--){
				if(defaultValue && defaultValue.split(";").contains(values[i].value)){
					target.prepend("<nobr><label><input type='checkbox' name='_"+structureName +
						"' value='"+values[i].value+"'" + " onclick=__cbClick('"+structureName+"','null',false,null);"
						+" checked "+isDisabled+" />" +values[i].text+"&nbsp;</label></nobr>");
				}else{
					target.prepend("<nobr><label><input type='checkbox' name='_"+structureName + 
							"' onclick=__cbClick('"+structureName+"','null',false,null);" +
							" value='"+values[i].value+"' "+isDisabled+" />" +values[i].text+"&nbsp;</label></nobr>");
				}
			}
			break;
		}
		case "input":{
			break;
		}
	}
};
