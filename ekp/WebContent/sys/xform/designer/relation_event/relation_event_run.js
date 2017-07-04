document.write("<script>Com_IncludeFile('md5-min.js','../sys/xform/designer/relation_event/style/js/');</script>");
//根据字段ID 设置字段值 
function setValueByFormId(formId,val){
		SetXFormFieldValueById(formId,val);
}
function execRelationEvent(bindObj,inputParams, outputParams, params,eventCtrlId){
	
	var paramsJSON = JSON.parse(params.replace(/quot;/g, "\""));
	var inputsJSON = JSON.parse(inputParams.replace(/quot;/g, "\""));
	var outputsJSON = JSON.parse(outputParams.replace(/quot;/g, "\""));
	//搜索条件
	paramsJSON.searchs="[]";

	//设置控件类型
	paramsJSON.controlType="2";
	
	var outs=[];
	var tempOuts={};
	for(var out in outputsJSON){
		var fieldId=outputsJSON[out].fieldId;
		fieldId=fieldId.replace(/\$/g, "");
		if(tempOuts[fieldId]){
			continue;
		}
		tempOuts[fieldId]=true;
		outs.push({"uuId":fieldId});
	}
	paramsJSON.outs=JSON.stringify(outs);
	
	var dataInput=buildInputParams(inputsJSON);
	if(!dataInput){
		return ;
	}
	//传入参数
	paramsJSON.ins = JSON.stringify(dataInput);
	//匹配是否需要分页
	if(/[\d][1]/g.test(paramsJSON.listRule)){
		//页量
		paramsJSON.pageNum=10;
		//页码
		paramsJSON.pageSize=1;
	}
	else{
		//页量
		paramsJSON.pageNum=0;
		//页码
		paramsJSON.pageSize=0;
	}
	if (bindObj.attr("inputParamValues") != paramsJSON.ins) {
		bindObj.attr("inputParamValues", paramsJSON.ins);
	}
	//加密条件信息
	paramsJSON.conditionsUUID=hex_md5(paramsJSON.ins+""+paramsJSON._key);
	
	//执行请求
	$
	.ajax( {
		url : Com_Parameter.ContextPath+"sys/xform/controls/relation.do?method=run",
		type : 'post',
		async : true,//是否异步
		data : paramsJSON,
		success : function(json) {
			//fm_3200f8b0aade9a: Object
			//fieldId: "$fo1$"
			//fieldIdForm: "docStatus"
			//fieldName: "$输出字段1$"
			//fieldNameForm: "文档状态"
			if(!json ||!json.outs){
				return;
			}
			//对结果集进行排序
			json.outs.sort(function(a,b){
				return a.rowIndex-b.rowIndex;
			});
			
			var data=convertData(json,outputsJSON);
			if(data.rows.length==0){
				return;
			}
			//只有一行数据时直接填充,或者多行直接返回时
			if(data.rows.length==1||paramsJSON.listRule=='99'){
				//setValueByRowIndex([0],data,bindObj);
				setValueByDataRows(data.rows,data,bindObj);
				if(document.getElementById("spinner_img_"+eventCtrlId)){
					$("#spinner_img_"+eventCtrlId).remove();
				}
				//触发操作结束事件 作者 曹映辉 #日期 2015年1月4日
				$(document).trigger($.Event("relation_event_setvalue"),eventCtrlId);
				return;
			}
			//var data={};
			//data.headers=[{"formId":formId,"filedId":filedId,"fieldName":fieldName,"fieldNameForm":fieldNameForm},{},{}];		
			//处理结果集返回多行数据的情况
			var objData={};
			objData.data=data;
			objData.win=window;
			//由模板配置决定是否分页
			objData.paramsJSON=paramsJSON;
			objData.outputsJSON=outputsJSON;
		    new ModelDialog_Show(Com_Parameter.ContextPath+"sys/xform/designer/relation_event/relation_event_dialog_list.jsp",objData,function(rtn){
		    	if(!rtn || rtn.length==0){
		    		//window.console.info("dialog没有返回有效数据");
					return;
			    }
		    	//setValueByRowIndex(rtn.checkedValues,rtn.objData.data,bindObj);
		    	setValueByDataRows(rtn.checkedRows,rtn.objData.data,bindObj);
		    	
		    	if(document.getElementById("spinner_img_"+eventCtrlId)){
					$("#spinner_img_"+eventCtrlId).remove();
				}
		    	//触发操作结束事件 作者 曹映辉 #日期 2015年1月4日
				$(document).trigger($.Event("relation_event_setvalue"),eventCtrlId);
		    }).show();
		},
		dataType : 'json',
		beforeSend : function() {
			bindObj
					.after(
							"<img id='spinner_img_"+eventCtrlId+"' align='bottom' src='"
									+ Com_Parameter.ContextPath
									+ "sys/xform/designer/relation/style/img/spinner.gif'></img>");
		},
		complete : function() {
			if(document.getElementById("spinner_img_"+eventCtrlId)){
				$("#spinner_img_"+eventCtrlId).remove();
			}
		},
		error : function(msg) {
			if(document.getElementById("spinner_img_"+eventCtrlId)){
				$("#spinner_img_"+eventCtrlId).remove();
			}
			alert('执行获取数据过程中出错！');
		}
	});
	
	//buildOutPutParams(bindObj,paramsJSON,outputsJSON);

}
function loadEventRows(objData,reLoadTableRows){
	$.ajax( {
		url : Com_Parameter.ContextPath+"sys/xform/controls/relation.do?method=run",
		type : 'post',
		async : true,//是否异步
		data : objData.paramsJSON,
		success : function(json) {
			if(!json ||!json.outs){
				return;
			}
			//对结果集进行排序
			json.outs.sort(function(a,b){
				return a.rowIndex-b.rowIndex;
			});
			
			var data=convertData(json,objData.outputsJSON);
			if(data.rows.length==0){
				alert('已经是最后一页');
				return;
			}
			objData.data=data;
			objData.win=window;
			//重新加载数据
			reLoadTableRows(objData);
			
		},
		dataType : 'json',
		beforeSend : function() {
		},
		complete : function() {
		},
		error : function(msg) {
			alert('执行获取数据过程中出错！');
		}
	});
}
function setValueByDataRows(rows,data,bindObj){
	var bindName=bindObj.attr("name");
	//name为明细表的情况
	if(/\.(\d+)\./g.test(bindName)){
		var rowIndex=bindName.match(/\.(\d+)\./g);
		
		rowIndex=rowIndex?rowIndex:[];
		//明细表ID
		var detailFromId= bindName.match(/\((\w+)\./g)[0].replace("(","").replace(".","");
		
		for(var i=0;i<rows.length;i++){
			for(var j=0;j<data.headers.length;j++){
				
				var fieldIdForm=data.headers[j].fieldIdForm;
				//明细表 同行控件
				if(fieldIdForm&&rowIndex.length>0&&fieldIdForm.indexOf(detailFromId)>=0){
					
					var idxIdForm=fieldIdForm.replace(".",rowIndex[0]);
					
					setValueByFormId(idxIdForm,rows[i][j]);
				}
				else{
					window.console.warn("绑定"+bindName+"为明细表控件,无法输出值到明细表外,或其他明细表内的控件"+fieldIdForm);
				}
			}
		}
		
	}
	//name 非明细表
	else{
		var nomalField={};
		for(var i=0;i<rows.length;i++){
			var detailTableId="";
			var ary =[];
			//是否有明细表
			var hasDetail=false;
			for(var j=0;j<data.headers.length;j++){
				var fieldIdForm=data.headers[j].fieldIdForm;
				if(fieldIdForm.indexOf(".")>0){
					hasDetail=true;
					detailTableId=fieldIdForm.split(".")[0];
					detailFieldId=fieldIdForm.split(".")[1];
					//无效数据设置为""防止出现 undefine
					if(!rows[i][j]){
						rows[i][j]="";
					}
					ary["extendDataFormInfo.value("+detailTableId+".!{index}."+detailFieldId+")"]=rows[i][j];
				}
				else{
					nomalField[fieldIdForm]=nomalField[fieldIdForm]?nomalField[fieldIdForm]:[];
					//非明细表的情况只加非空数据,空数据同一个返回一个空
					if(rows[i][j]){
						nomalField[fieldIdForm].push(rows[i][j]);
					}
				}
			}
			if(hasDetail){
				//往明细表赋值
				var optTB=document.getElementById("TABLE_DL_"+detailTableId);
				DocList_AddRow(optTB,null,ary);
			}
		}
		//普通字段合并多个结果
		for(var prop in nomalField){
			setValueByFormId(prop,nomalField[prop].join(","));
		}
	}
}
/*
function setValueByRowIndex(indexs,data,bindObj){
	
	var bindName=bindObj.attr("name");
	//name为明细表的情况
	if(bindName.indexOf(".")>=0){
		var rowIndex=bindName.match(/\.(\d+)\./g);
		
		rowIndex=rowIndex?rowIndex:[];
		//明细表ID
		var detailFromId= bindName.match(/\((\w+)\./g)[0].replace("(","").replace(".","");
		
		for(var i=0;i<indexs.length;i++){
			for(var j=0;j<data.headers.length;j++){
				
				var fieldIdForm=data.headers[j].fieldIdForm;
				//明细表 同行控件
				if(fieldIdForm&&rowIndex.length>0&&fieldIdForm.indexOf(detailFromId)>=0){
					
					var idxIdForm=fieldIdForm.replace(".",rowIndex[0]);
					
					setValueByFormId(idxIdForm,data.rows[indexs[i]][j]);
				}
				else{
					window.console.warn("绑定"+bindName+"为明细表控件,无法输出值到明细表外,或其他明细表内的控件"+fieldIdForm);
				}
			}
		}
		
	}
	//name 非明细表
	else{
		for(var i=0;i<indexs.length;i++){
			for(var j=0;j<data.headers.length;j++){
				var fieldIdForm=data.headers[j].fieldIdForm;
				
				setValueByFormId(data.headers[j].fieldIdForm,data.rows[indexs[i]][j]);
			}
		}
	}
}
*/
//把列格式数据转换为行格式数据
function convertData(json,outputsJSON){
	var data={};
	data.headers=[];
	data.rows=[];
	data.cloumns=[];
	//最大行数,通常情况下所有列的行数都是相同的
	var maxRows=0;
	for(var obj in outputsJSON){
		//表单字段ID
		//var formId=outputsJSON[obj].fieldIdForm;
		//模板字段ID
		var filedId=outputsJSON[obj].fieldId.replace(/\$/g, "");
		//outputsJSON[obj]的格式{"formId":formId,"filedId":filedId,"fieldName":fieldName,"fieldNameForm":fieldNameForm,"canSearch":true}
		data.headers.push(outputsJSON[obj]);
		var vals=[];
		tempRows=0;
		
		
		for(var idx in json.outs){
			if(filedId == json.outs[idx].fieldId){
				tempRows++;
				vals.push(json.outs[idx].fieldValue);
			}
		}
		if(tempRows>maxRows){
			maxRows=tempRows;
		}
		data.cloumns.push(vals);
	}
	//列转行
	for(var i=0;i<maxRows;i++){
		var row=[];
		for(var j=0;j<data.cloumns.length;j++){
			//data.cloumns[i][j]=data.cloumns[i][j]?data.cloumns[i][j]:"";
			row.push(data.cloumns[j][i]);
		}
		data.rows.push(row);
	}
	
	return data;
}
$(function(){
	$("div[mytype='relation_event']").each(function(i,obj){
		var bindDom= $(obj).attr('bindDom');
		var bindEvent=$(obj).attr('bindEvent');
		if(bindDom.indexOf(".")){
			bindDom=bindDom.substr(bindDom.lastIndexOf(".")+1);
		}
		var myid=$(obj).attr('myid');
		if(myid.indexOf(".")){
			myid=myid.substr(myid.lastIndexOf(".")+1);
		}
		//获取绑定的事件控件对象
		//var bindObj=document.getElementById(bindDom)?$("#"+bindDom):$('[name*='+bindDom+']');
		var bindStr=document.getElementById(bindDom)?"#"+bindDom:'[name*='+bindDom+']';
		if('relation_event_setvalue'==bindEvent){
			$(document).bind(bindEvent,function(event,param1){
				if(param1==bindDom){
					//正在加载时,不需要再次触发
					if(document.getElementById("spinner_img_"+myid)){
						return;
					}
					//事件控件触发
					if($("div[myid='"+bindDom+"']").lenght>0){
						execRelationEvent($("div[myid='"+bindDom+"']"),$(obj).attr("inputParams"),$(obj).attr("outputParams"),$(obj).attr("params"),myid);
					}
					//其他自定义控件触发
					else{
						execRelationEvent($(bindStr),$(obj).attr("inputParams"),$(obj).attr("outputParams"),$(obj).attr("params"),myid);
					}
				}
			});
		}
		else{
			$(document).on(bindEvent,bindStr,function(){
				//正在加载时,不需要再次触发
				if(document.getElementById("spinner_img_"+myid)){
					return;
				}
				execRelationEvent($(this),$(obj).attr("inputParams"),$(obj).attr("outputParams"),$(obj).attr("params"),myid);
				
			});
		}
		
	});
});
