<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/tib/common/resource/plumb/jsp/includePlumb.jsp" %>
<script type="text/javascript"
	src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/zDialog.js"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/jdbc-jsplumb.js"></script>
<script type="text/javascript">
Com_IncludeFile("dialog.js", null, "js");
Com_IncludeFile("json2.js", null, "js");
Com_IncludeFile("tools.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);

//选择类型
function categoryJs(){
	Dialog_Tree(false, 'docCategoryId', 'docCategoryName', ',', 
		'tibJdbcMappCategoryTreeService&parentId=!{value}', 
		'<bean:message key="table.tibJdbcMappCategory" bundle="tib-jdbc"/>', 
		null, null, '${tibJdbcMappManageForm.fdId}', null, null, 
		'<bean:message  bundle="tib-jdbc" key="table.tibJdbcMappCategory"/>');
}

$(document).ready(function(){
		init_setInParams();
	   //设置源数据源SQL
       var fdDataSourceSql= $("textarea[name='fdDataSourceSql']").text();
       $("#fd_sourceSql").attr("value",fdDataSourceSql);
       
       //设置目标数据源被选中的表
       var fdMappConfigJson = $("input[name='fdMappConfigJson']").val();//'${tibJdbcMappManageForm.fdMappConfigJson}';
       if(fdMappConfigJson!=null && fdMappConfigJson.length>0){
    	   var tabNameJson=JSON.parse(fdMappConfigJson);
    	   var tableInfoHtml="";
           for(var key in tabNameJson){
               if(key!=null && key!=undefined){
            	   tableInfoHtml+="<option id='"+key+"' value='"+key+"' >"+key+"</option>";
               }
            }
      	 	 $('#have_selected_tableList').append(tableInfoHtml);
       }

   	   getSourceTables();
   	
        //生成目标映射数据表
  	   getTableFielInfor();
  	 
     //生成源映射数据表
     if(fdDataSourceSql!=null && fdDataSourceSql.length>0){
  	      getTableField();
      }

	 
      //设置字段连线
       jsPlumb.deleteEveryEndpoint();
       setTimeout("jsPlumbDemo.init();",50);
       setTimeout("setFieldLinked();",50);
  });


function  setFieldLinked(){
 var fdMappConfigJson = $("input[name='fdMappConfigJson']").val();//'${tibJdbcMappManageForm.fdMappConfigJson}';
    if(fdMappConfigJson!=null && fdMappConfigJson.length>0){
 	   var tabNameJson=JSON.parse(fdMappConfigJson);
 	   var tableInfoHtml="";
        for(var key in tabNameJson){
            if(key!=null && key!=undefined){
         	   for(var i=0;i<tabNameJson[key].length;i++){
                      var fieldInfo=tabNameJson[key][i];
                      var fieldName = fieldInfo.fieldName;
                      var mappFieldName =fieldInfo.mappFieldName;
                      key=$.trim(key);
                      setFieldLinkedLine(key,fieldName,mappFieldName);
                }
             }
          }
      }
      //查看页面时,取消编辑连线上的操作事件
      jsPlumb.unbind("dblclick");
      $("._jsPlumb_endpoint").unbind("mousedown");
      $(".ui-draggable").attr("disabled", true);
}

function setFieldLinkedLine(targetTab,targetField,soureField){
	    //查找目标字段所在的位置
         var trArray= $('#mapp_'+targetTab+'>tbody>tr');
         
         var targetSpan;
        if(trArray!=null && trArray.length>0){ 
	         for(var i=1;i<trArray.length;i++){
	            //var contentValue = $(trArray[i]).children("td:eq(1)").text();
	            //var targetFieldName = contentValue.substring(0,contentValue.indexOf("("));
	           var targetFieldName=$(trArray[i]).children("td:eq(1)").text();
	           if($.trim(targetField) == $.trim(targetFieldName)){
	                targetSpan = $(trArray[i]).children("td:eq(0)").children("span");//$(tdArray[i]);
	                break;
	           }
	         }
        }
          
      //查找源字段所在的位置  
         var sourceSpan;
         var sourceTrArr = $("#source_table_field>tbody>tr");
         if(sourceTrArr!=null && sourceTrArr.length>0){
	          for(var j=0;j<sourceTrArr.length;j++){
	             // var sourceContentVal = $(sourceTdArr[j]).text();
	             // var sourceFieldName = sourceContentVal.substring(0,sourceContentVal.indexOf("("));
	              var sourceFieldName =$(sourceTrArr[j]).children("td:eq(3)").text();
	             if($.trim(soureField) == $.trim(sourceFieldName)){
	                 sourceSpan = $(sourceTrArr[j]).children("td:eq(4)").children("span");//$(sourceTdArr[j]);
	                 break;
	              }
	           }
         }
         
          //得到源字段和目标字段所在的连接点
          if(targetSpan!=null && sourceSpan!=null ){
 	           var endpointTarget =jsPlumb.getEndpoints(targetSpan);
 	           var endpointSource =jsPlumb.getEndpoints(sourceSpan);
 	           if(endpointTarget!=null && endpointSource!=null){
 	              jsPlumb.connect({source:endpointSource[0],target:endpointTarget[0],deleteEndpointsOnDetach:false });
 	           }
 	          //endpointTarget.cleanupListeners();
 	          //endpointSource.cleanupListeners();
          }
}

function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}

function clearDataSourceSql(){
	$("#fd_sourceSql").attr("value","");
}

</script>

<html:form action="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do">

<div id="optBarDiv">
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
	<!-- 
<input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('tibJdbcMappManage.do?method=edit&fdId=${param.fdId}&type=view','_self');">
 -->
</kmss:auth>
<kmss:auth
	requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('tibJdbcMappManage.do?method=edit&fdId=${param.fdId}&type=view','_self');">
</kmss:auth>

<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
<input type="button" value="<bean:message key="button.delete"/>" onclick="if(!confirmDelete())return;Com_OpenWindow('tibJdbcMappManage.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth>
<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

	<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcMappManage" /></p>
	<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcMappManage.docSubject" /></td>
			<td width="35%" colspan="3"><xform:text property="docSubject"
				style="width:85%" /></td>
		</tr>

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcMappManage.fdIsEnabled" /></td>
			<td width="35%"><xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio></td>

			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcMappManage.docCategory" /></td>
			<td width="35%"><xform:dialog required="true"
				propertyId="docCategoryId" propertyName="docCategoryName"
				dialogJs="categoryJs()"></xform:dialog></td>
		</tr>

		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tibJdbcDataSet"/>
			</td>
			<td width="35%">
				<input type="hidden" name="fdDataSource" value="${tibJdbcMappManageForm.fdDataSource }"/>
				<input type="hidden" name="tibJdbcDataSetId" value="${tibJdbcMappManageForm.tibJdbcDataSetId }"/>
				${tibJdbcMappManageForm.tibJdbcDataSetName }
			</td>

			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSource" /></td>
			<td width="35%"><xform:select
				property="fdTargetSource" onValueChange="getSourceTables();"
				style="float: left;" showStatus="readOnly"
				value="${fdTargetSource }" required="true">
				<xform:beanDataSource serviceBean="compDbcpService"
					selectBlock="fdId,fdName" orderBy="" />
			</xform:select></td>
		</tr>
		<tr>
			<td colspan="2" style="padding: 0px;" valign="top">
				 <table  width="100%" height="100%" style="background-color: #99CCFE">
					<tr id="inParamValueBefore">
						<td colspan="2">
							<textarea rows="1" cols="" readonly="readonly" name="fdDataSetSql" 
								style="width:100%;background-color: #99CCFE;">${tibJdbcMappManageForm.fdDataSetSql }</textarea>
							<textarea id="fd_sourceSql" name="fdDataSourceSql" 
								style="display:none;width:100%">${tibJdbcMappManageForm.fdDataSourceSql }</textarea>
						</td>
					</tr>
					<tr valign=middle>
				        <td colspan="2" align=center>
					        <span><input type="button" class="btnopt" align="middle" value='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.preview"/>'  onclick="getTableData();"/></span>
				        </td>
	       			</tr> 
				</table>
			 </td>

			<td colspan="2" style="padding: 0px;" valign="top">
			<table class="tb_normal" width="100%" style="background-color: #FEFECC">
				<tr>
					<td width=100%><bean:message bundle="tib-jdbc"
						key="tibJdbcMappManage.targetTables" /></td>
				</tr>
	
				<tr>
					<td width="100%"><select id="dest_tableList"
						name="dest_tableList" multiple="multiple"
						style="height: 105px; width: 600px; background-color: #FEFECC">
					</select></td>
				</tr>
	
				<tr>
					<td width=100% align=left style="background-color: #FEFECC"><bean:message
						bundle="tib-jdbc" key="tibJdbcMappManage.haveSelectedTables" /></td>
				</tr>
	
				<tr>
					<td width="100%"><select id="have_selected_tableList"
						name="have_selected_tableList" multiple="multiple"
						style="width: 600px; background-color: #FEFECC">
					</select></td>
				</tr>
	
				<tr>
					<td valign=middle width=100% align=center
						style="background-color: #FEFECC"><span><input
						type="button" align="middle"
						value='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.extraction"/>'
						disabled="disabled" onclick="getTableFielInfor();" /></span></td>
				</tr>
			</table>
			</td>
		</tr>
</table>

<table class="tb_normal" width=95%>
	<tr>
	    <td width="42%" style="border: none;">       	  	
	         <table id="source_table_field" border=0 align="right" class="tb_normal"></table>	      
	    </td>
	    <td width="15%" style="border: none;"></td>
        <td width="43%" style="border: none;" border=0>	
			<div id="_dest_table_field"></div>
		</td>
    </tr> 
</table>
	</center>

	<html:hidden property="fdTargetSourceSelectedTable" />
<html:hidden property="fdMappConfigJson" value="${tibJdbcMappManageForm.fdMappConfigJson}"/>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script type="text/javascript">
$KMSSValidation();


function init_setInParams() {
	var tibJdbcDataSetId = $("input[name='tibJdbcDataSetId']").val();
	if ("" != tibJdbcDataSetId) {
		var data = new KMSSData();
		data.SendToBean("tibJdbcDataSetJsonBean&funcId="+ tibJdbcDataSetId, init_setInParams_back);
	}
}

function init_setInParams_back(rtnData) {
	var dataObj = rtnData.GetHashMapArray()[0];
	var fdDataJson = dataObj["dataJson"];
	var fdDataSourceSql = $("textarea[name='fdDataSourceSql']").text();
	addInParams(fdDataJson, fdDataSourceSql);
}

//添加传入参数
function addInParams(fdDataJson, fdDataSourceSql) {
	var inJsonObj = $.parseJSON(fdDataJson)["in"];
	for (var len = inJsonObj.length, i = len - 1; i >= 0 ; i--) {
		var value = "";
		if (fdDataSourceSql) {
			var regArr = fdDataSourceSql.match(/\s(\S+)\s*=(\S+)(\s|$)/g);
			for (var j = 0, len = regArr.length; j < len; j++) {
				var columnArr = regArr[j].split("=");
				var tagNameTemp = columnArr[0].trim();
				if (inJsonObj[i].columnName == tagNameTemp) {
					if ("varchar" == inJsonObj[i].ctype) {
						value = columnArr[1].trim().substr(1, columnArr[1].trim().length - 2);
					} else {
						value = columnArr[1].trim();
					}
				}
			}
		}
		var html = "<tr><td width='30%'>"+ inJsonObj[i].tagName +
			"</td><td>"+ value +"</td></tr>";
		$("#inParamValueBefore").after(html);
	}
}


var tabNameArr=new Array();
var objJson={};
function setTabJson(){
  if(tabNameArr!=null && tabNameArr.length>0){
       for(var i=0;i<tabNameArr.length;i++){
    	   objJson[tabNameArr[i]] = [];
         }
    }
}
   
function  getFieldDetailInfo( fieldContent){
  if(fieldContent!=null && fieldContent.length>0){
       var startIndex = fieldContent.indexOf("(");
       var endIndex = fieldContent.lastIndexOf(")");
       var fieldInfo = fieldContent.substring(startIndex+1,endIndex);
       var fieldInfoArray= fieldInfo.split(",");
       return fieldInfoArray;
  }
       return null;
}

//保存处理
function saveInfo(){
    //处理连线字段信息
	getLinkedLineInfo();
	//选中的目标表
	 var selectedTabName = tabNameArr.join(",");
	 document.tibJdbcMappManageForm.elements['fdTargetSourceSelectedTable'].value=selectedTabName;
     Com_Submit(document.tibJdbcMappManageForm, 'save');
}
 
//处理拉线两端的字段数据
function getLinkedLineInfo(){
    //设置Json模板
	setTabJson();
	
    //得到所有的连线
    var obj = jsPlumb.getAllConnections();
    var connInfo;
  
 if(obj!=null && obj.jsPlumb_DefaultScope.length>0){
   var jsonObj=objJson;//JSON.parse(objJson);
       connInfo= obj.jsPlumb_DefaultScope;
   for(var i=0;i<connInfo.length;i++){
	 //得到目标节点所属的表名称
		var belongTabName = $(connInfo[i].target[0].parentNode).parent().parent().children("tr:eq(0)").text();//$(connInfo[i].target[0].parentNode).parent().parent().attr("id");

		// 验证当前表是否被删除
		var currentTab = $("table[id='mapp_" + belongTabName + "']");
		if (currentTab == null || currentTab.length < 1) {
			continue;
		}

		// 得到目标字段名称
		var targetFieldName =$(connInfo[i].target[0].parentNode).parent().children("td:eq(1)").text();
		
		// 得到源字段名称
        var sourceFieldName =$(connInfo[i].source[0].parentNode).parent().children("td:eq(3)").text();
		var sourceTabName =$(connInfo[i].source[0].parentNode).parent().children("td:eq(0)").text(); 
           
		// 获得连线的颜色
		var painStyle = connInfo[i].getPaintStyle();

		// 得到关于目标字段的字段类型，长度等信息
         var targeFieldInfoArr=new Array(2);
         var targetFieldDataType=$(connInfo[i].target[0].parentNode).parent().children("td:eq(2)").text();
         targeFieldInfoArr[0]=targetFieldDataType;
         targeFieldInfoArr[1]= $(connInfo[i].target[0].parentNode).parent().children("td:eq(3)").text(); 
    
    var fieldInfo = jsonObj[belongTabName];
    
    //该字段值是必须还是非必须
    var requirType="";
    var primaryKey="";
    if(targeFieldInfoArr[1].toUpperCase()=='PRIMARY'){
   	 primaryKey='1';
   	 requirType='1';
     }else{
   	 primaryKey='0';
	     requirType= targeFieldInfoArr[1]=='notNull'?'1':'0';
     };
	 var fieldTemp="";
    if(fieldInfo!=null &&fieldInfo.length>0){
	   	fieldTemp+='{' + '"' + "fieldName" + '"' + ":" + '"'
					   + targetFieldName + '"' + "," + '"' + "dataType" + '"'
					   + ":" + '"' + targeFieldInfoArr[0] + '"' + "," + '"'
					   + "required" + '"' + ":" + '"' + requirType + '"' + ","
					   + '"' + "primaryKey" + '"' + ":" + '"' + primaryKey
					   + '"' + "," + '"' + "mappFieldName" + '"' + ":" + '"'
					   + sourceFieldName + '"' +","
			           + '"' + "tabName" + '"' +  ":" +'"' + sourceTabName
					   + '"'+ '}';
	         jsonObj[belongTabName].push(JSON.parse(fieldTemp));
	  }else{
		fieldTemp='{' + '"' + "fieldName" + '"' + ":" + '"'
					   + targetFieldName + '"' + "," + '"' + "dataType" + '"'
					   + ":" + '"' + targeFieldInfoArr[0] + '"' + "," + '"'
					   + "required" + '"' + ":" + '"' + requirType + '"' + ","
					   + '"' + "primaryKey" + '"' + ":" + '"' + primaryKey
					   + '"' + "," + '"' + "mappFieldName" + '"' + ":" + '"'
					   + sourceFieldName + '"' +","
			           + '"' + "tabName" + '"' +  ":" +'"' + sourceTabName
					   + '"'+ '}';
		  jsonObj[belongTabName].push(JSON.parse(fieldTemp));
 	 }
     }
        //$('fdMappConfigJson').attr("value",JSON.stringify(jsonObj));
   	 document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value=JSON.stringify(jsonObj);
   }else{
       //设置源表的边框为红色
        alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.noLinkFieldsMessage"/>');
   }
}
	
//获得目标数据库中的表
function getSourceTables(){
	var dbId = document.getElementsByName("fdTargetSource")[0].value;
	if(dbId.length<1 ||dbId==null){
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
		return false;
	}
	var url = "tibJdbcLoadDBTablService&dbId=" +dbId;
	var data = new KMSSData();
	    //data.SendToBean(url, afterCallbackFunction);
	data.SendToUrl(Com_Parameter.ContextPath +
				"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getTargetDBTab&dbId="+ dbId,
				afterCallbackFunction, false);
	
}
	
//显示目标数据库表
 function afterCallbackFunction(http_request){
	 var mapArray  =  http_request.responseText;
	    mapArray =JSON.parse(mapArray);
	   if(mapArray!=null && mapArray.length>0){
           var tableInfoHtml="";
           for(var i=0;i<mapArray.length;i++){
             tableInfoHtml+="<option id='"+mapArray[i].name+"' value='"+mapArray[i].name+"'  >"+mapArray[i].name+"</option>";
           }
           //先删除原来的表
          $("#dest_tableList tr:gt(0)").remove();
          $("#dest_tableList").append(tableInfoHtml);
        }
  }



//设置已经选中的表
function selectedTable(thisObj){
 if($(thisObj).val()!=null && $(thisObj).val().length>0){	
        var tabName=$(thisObj).val();
        var selectedTab=new Array();
        var tableInfoHtml="";
        var tableInfoHtml="";
        var options = $("select[name='have_selected_tableList'] option");
        if(options.length >0){
              var index=0;
            for(var i=0;i<options.length;i++){
            	++index;
                var optionVal = $(options[i]).val();
                if($.trim(tabName)==$.trim(optionVal)){
                         return false;
	               }
            }
            if(index>=options.length){
               tableInfoHtml+="<option id='"+tabName+"' value='"+tabName+"' >"+tabName+"</option>";
          	    $("#have_selected_tableList").append(tableInfoHtml);
             }
         }else{
       	     tableInfoHtml+="<option id='"+tabName+"' value='"+tabName+"'  >"+tabName+"</option>";
       	     $("#have_selected_tableList").append(tableInfoHtml);
          }
 }
}
		 
//删除当前行
function deleteCurrentRow(){
	 var TabId =$('#have_selected_tableList').find("option:selected").val();
     $("#have_selected_tableList option[id='"+TabId+"']").remove();
     $("table[id='"+TabId+"']").remove();
}

		
//查询目标数据库表中字段的详细信息
function getTableFielInfor(){
  var tableName="";
  tabNameArr = new Array();
  var options = $("select[name='have_selected_tableList'] option");
  if(options!=null  && options.length>0){
	  for(var i=0;i<options.length;i++){
          var optionVal = $(options[i]).val();
          tableName+=optionVal+",";
		  tabNameArr.push(optionVal);
      }
	  	 
	 if(tableName!=null && tableName.length>0){
		 tableName=tableName.substring(0,tableName.length-1);
	  }
	  
	 var dbId = document.getElementsByName("fdTargetSource")[0].value;
	 if(dbId.length<1 ||dbId==null){
			alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
			return false;
	 }
	 
	if(tableName.length<1 ||tableName==null){
		   alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tablesSourceMessageTip"/>');
            return false;
	}
	
	var data = new KMSSData();
		data.SendToUrl(Com_Parameter.ContextPath +
					"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getTabFieldInfo&dbId="+ dbId+"&tableName="+tableName, 
					destionTabelField, false);
   }
}

//显示目标表中的字段信息
function destionTabelField(http_request){
	// 以下得到保存好的映射数据，为了获取字段初始化值，by qiujh
	var fdMappConfigJsonObj = document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value;
	var tabNameJsonObj = null;
	if (fdMappConfigJsonObj != null && fdMappConfigJsonObj.length > 0) {
		tabNameJsonObj = JSON.parse(fdMappConfigJsonObj);
	}
	var fdMappConfigJson =  http_request.responseText;
	if(fdMappConfigJson!=null && fdMappConfigJson.length>0){
	 	   var tabNameJson=JSON.parse(fdMappConfigJson);
	 	   //var tableInfoHtml="<table>";
	 	   var tableInfoHtml="";
           var obj=tabNameJson[0];
           for(var key in obj){
        	   if(key!=null && key!=undefined){
	        	   // 字段信息，包括字段初始化值
	   			   var tableInfo = null;
	   			   if (tabNameJsonObj != null) {
	   				   tableInfo = tabNameJsonObj[key];
	   			   }
        		   //tableInfoHtml+="<tr><td><table id='mapp_"+key+"' border=0 class='tb_normal' width='100%'>";
        		   tableInfoHtml+="<table id='mapp_"+key+"' border=0 class='tb_normal' width='90%'>";
                   tableInfoHtml+="<tr  class='td_normal_title'><td align=center colspan=5>"+ key+"</td></tr>";
                   
                   for(var i=0;i<obj[key].length;i++){

                	    var columnObj = eval("(" + obj[key][i] + ")");
	   					var fieldValue = columnObj.fieldName;
	   					// 遍历取字段初始化值
	   					var fieldInitData = "";
	   					if (tableInfo != null) {
	   						for (var j = 0, len = tableInfo.length; j < len; j++) {
	   							var fieldInfo = tableInfo[j];
	   							if (fieldValue == fieldInfo.fieldName) {
	   								fieldInitData = fieldInfo.fieldInitData;
	   								break;
	   							}
	   						}
	   						
	   					}
                      //tableInfoHtml+="<tr align=right><td class='tright'>"+eval("("+obj[key][i]+")").fieldName+"("+eval("("+obj[key][i]+")").dataType+","+eval("("+obj[key][i]+")").isNull+")</td></tr>";
                      tableInfoHtml+="<tr><td width='2'><span style='height:20px;line-height:20px;' class='tright'>&nbsp;</span></td>";
                      tableInfoHtml+="<td>"+eval("("+obj[key][i]+")").fieldName+"</td><td>"+eval("("+obj[key][i]+")").dataType+"</td><td>"+eval("("+obj[key][i]+")").isNull+"</td>"
                     				 +"<td>"+fieldInitData+"</td></tr>";
                   }
                   //tableInfoHtml+="</table></tr><div heigh=20></div>";
                   //tableInfoHtml+="</table></td></tr>";
                   tableInfoHtml+="</table><p>&nbsp;</p>";
               }
           }
           //tableInfoHtml+="</table>";
           $("#_dest_table_field").children().remove();
           $("#_dest_table_field").append(tableInfoHtml);
           $("#_destTableField").css("display","block");
           //checkJsPlumbInit();
	      }
}
	
//查看源数据库表数据
 function  getTableData(){
   var dbId = document.getElementsByName("fdDataSource")[0].value;
   if(dbId.length<1 ||dbId==null){
	   alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
	return false;
   }
   var fd_sourceSql = $("#fd_sourceSql").val();
      if(fd_sourceSql==null ||fd_sourceSql.length<1){
    	  alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceSqlMessageTip"/>');
          return false;
       }
      var diag=new Dialog();
	  IMAGESPATH='${KMSS_Parameter_ContextPath}tib/jdbc/resource/images/';
	  diag.Width = 850;
	  diag.Height = 450;
	  diag.Title = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.viewData"/>';
	  diag.URL = "${KMSS_Parameter_ContextPath}tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getData&dbId="+dbId+"&sourceSql="+fd_sourceSql;
	  diag.show();
}

	 
//获取源数据库表的字段信息
function getTableField(){ 
       var fd_sourceSql = $("#fd_sourceSql").val();
	   var dbId = document.getElementsByName("fdDataSource")[0].value;
	if(dbId.length<1 ||dbId==null){
		   alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');  
			return false;
	  }
	  
       if(fd_sourceSql==null ||fd_sourceSql.length<1){
    	   alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceSqlMessageTip"/>');
           return false;
        }
       
	var data = new KMSSData();
     data.SendToUrl(Com_Parameter.ContextPath +
			"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getTabFieldInfo&dbId="+ dbId+"&sourceSql="+fd_sourceSql, 
			afterFieldFunction, false);
}


//显示源数据表信息
function afterFieldFunction(http_request){
	var fdMappConfigJson =  http_request.responseText;
	if(fdMappConfigJson!=null && fdMappConfigJson.length>0){
	 	   var tabNameJson=JSON.parse(fdMappConfigJson);
	 	   var tableInfoHtml="";
	 	   var fd_message_1='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.allowNull"/>';
	 	   var fd_message_2='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.dataType"/>';
	 	   var fd_message_3='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.columnName"/>';
	 	       tableInfoHtml="<tr align='center'><td style='display:none;'>tableName</td><td class='td_normal_title'>"+fd_message_1+"</td><td class='td_normal_title'>"+fd_message_2+"</td><td class='td_normal_title' colspan='2'>"+fd_message_3+"</td></tr>";
		   var obj=tabNameJson[0];
           for(var key in obj){
        	   if(key!=null && key!=undefined){
                   for(var i=0;i<obj[key].length;i++){
                        if(key!=null && key!=undefined){
                        	var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
                        	var tmpBlank="";
                        	if(isChrome)tmpBlank="&nbsp;";
                    	  // tableInfoHtml+="<tr height=20  align=left><td class='tleft'>"+eval("("+obj[key][i]+")").fieldName+"("+eval("("+obj[key][i]+")").dataType+","+eval("("+obj[key][i]+")").isNull+")</td></tr>";
                    		tableInfoHtml+="<tr align=left><td height=10 style='display:none;'>"+eval("("+obj[key][i]+")").tabName+"</td><td>"+eval("("+obj[key][i]+")").isNull+"</td><td>"+eval("("+obj[key][i]+")").dataType+"</td><td>"+eval("("+obj[key][i]+")").fieldName+"</td><td width='2'><span style='height:20px;line-height:20px;' class='tleft'>"+tmpBlank+"</span></td></tr>";
                           }
                    }
               }
           }
	      
	    $("#source_table_field tr").remove();
	    $("#source_table_field").append(tableInfoHtml);
	    $("#_source_table_field").css("display","block");
	    //checkJsPlumbInit();
	}
}


function checkJsPlumbInit(){
	$("div[class='_jsPlumb_endpoint  ui-draggable ui-droppable']").remove();
	var sourceTr= $("#source_table_field>tbody>tr");
	var desTab=$("#_dest_table_field").children("table");
	var sourceFlag=false;
	var desFlag=false;
	if(sourceTr!=null && sourceTr.length>0){
		sourceFlag=true;
	}

	if(desTab!=null && desTab.length>0){
		desFlag=true;
	}
	
	if(sourceFlag && desFlag){
		//清空原来的连线节点
		 jsPlumb.deleteEveryEndpoint();
		 jsPlumbDemo.init();
	}
}
</script>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>