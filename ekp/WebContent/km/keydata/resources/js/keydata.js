/***********************************************/
Com_RegisterFile("keydata.js");
//Com_IncludeFile('keydata_dialog.js','/km/keydata/resources/js/',null,true);
Com_IncludeFile('dialog.js');
/**********************************************************/

function __CallKeydataOnValueChange(idField, nameField, fn) {
	alert(111);
	var rtn = [];
	var objs = __GetKeydataFields(idField, nameField);
	for (var i = 0; i < objs.length; i ++) {
		rtn[i] = objs[i].value;
	}
	// 修正IE某些情况下，显示问题。在自定义表单中，可能会出现选择丢失情况。
	for (var i = 0; i < objs.length; i ++) {
		objs[i].style.display = 'none';
		objs[i].style.display = '';
	}
	debugger;
	if (fn) {fn(rtn, objs);}
	
}

function __GetKeydataFields(idField, nameField) {
	var rtn = [];
	rtn[0] = typeof(idField) == 'string' ? document.getElementsByName(idField)[0] : idField;
	rtn[1] = typeof(nameField) == 'string' ? document.getElementsByName(nameField)[0] : nameField;
	return rtn;
}

function __openKeydataWindow(propertyId,propertyName,keydataType,treeTitle,winTitle,fn){
	Dialog_Tree(false, propertyId, propertyName, ',', 'kmKeydataExtendService&parentId=!{value}&keydataType='+keydataType, treeTitle, null, 
			fn, '${param.fdId}', null, null, winTitle);
}

function selectKeydata(idFieldName,nameFieldName,keydataType,fn){
	var url = Com_Parameter.ResPath+"jsp/frame.jsp";
	url = Com_SetUrlParameter(url, "url",Com_Parameter.ContextPath+"km/keydata/base/kmKeydataBase.do?method=select&keydataType="+keydataType);
	var rtnVal = showModalDialog(url, null, "dialogWidth:550px;status:no;");
	
	//seajs('lui/dialog',function(dialog){dialog.iframe});

	if (rtnVal == undefined) {
		rtnVal = window.returnValue;
	}
	if(rtnVal==null)return ;
	//var fdSelectValue = document.getElementById('reportSettingForm.reportSettingFieldsFormList['+index+'].fdSelectValue');
	//var reportEnumSettingId = document.getElementById('reportSettingForm.reportSettingFieldsFormList['+index+'].reportEnumSettingId');
	var idField = document.getElementsByName(idFieldName)[0];
	var nameField = document.getElementsByName(nameFieldName)[0];
	if(rtnVal["fdId"]==null){
		idField.value="";
		nameField.value="";
		return ;
	}
	nameField.value=rtnVal["fdName"];
	idField.value=rtnVal["fdId"];
	if(fn){
		fn();
	}
	
}

function getKeydataDivPos(evt,showObj){
	var sWidth=showObj.width();var sHeight=showObj.height();
	x=evt.pageX;
	y=evt.pageY+10;
	if(y+sHeight>$(window).height()){
		y-=sHeight;
	}
	if(x+sWidth>$(document.body).outerWidth(true)){
		x-=sWidth;
	}
	return {"top":y,"left":x};
}

window.ajax_getKeydataTypes = function(tableObj){
	var dataTypes_select = tableObj.find('select')[0];
	$(tableObj.find('select')[0]).empty();
	$.ajax({
		url : "/km/keydata/base/kmKeydataBase.do?method=getKeydataTypes",
		contentType : false,
		processData : false,
		type : "GET",
		success : function(data) {
			
			$.each($.parseJSON(data), function(i,item){
				$("<option />").attr("value",item.type).text(item.name).appendTo(dataTypes_select);
			});
			
			//alert(tableObj.find('select')[0].value);
			ajax_getKeydatas(tableObj);
			}
		});
};

function buildDivContent(divObj,keydataId){
	var html = "";
	$.ajax({
		url : "/km/keydata/base/kmKeydataBase.do?method=getKeydataJson&keydataId="+keydataId,
		contentType : false,
		processData : false,
		type : "GET",
		success : function(data) {
		debugger;
		//	$.each($.parseJSON(data), function(i,item){
				var dataJson = $.parseJSON(data);
				var detailUrl = dataJson.detailUrl;
				var attrs = dataJson.attrs;
				debugger;
					$.each(attrs, function(j,att_item){
						html += att_item.title+"："+att_item.value+"<br>";
					}
				);
					html += "<a href='"+detailUrl+"' target='_blank'>更多"+"</a><br>";
					html += "<a href=\"javascript:void(0);\" onclick=\"hideKeydataDiv(this);\">关闭</a>";
		//	});
			$(divObj).html(html);
			//alert(tableObj.find('select')[0].value);
			}
		});
	
}

function showKeydataDiv(obj,keydataId){
	
	var divObj = $(obj).parent().find("div").get(0);
	buildDivContent(divObj,keydataId);
	$(divObj).css(getKeydataDivPos(window.event,$(divObj))).css('display','block');
}


function hideKeydataDiv(obj){
	//alert($(obj).parent().css('display'));
	$(obj).parent().css('display','none');
	
}

