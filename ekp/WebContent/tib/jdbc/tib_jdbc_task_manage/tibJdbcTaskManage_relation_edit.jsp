<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/zDialog.js"></script>

<tr LKS_LabelName="<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.mappingRelation"/>">
  <td>
	<table id="TABLE_DocList" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
		<td align="center" width="3%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.number"/></td>
		<td align="center" width="18%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.name"/></td>
		<td align="center" width="14%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdUseExplain"/></td>
		<td align="center" width="59%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.synchronizationType"/></td>
		<td align="center" width="6%">
			<img src="${KMSS_Parameter_StylePath}icons/add.gif" alt="<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.add"/>"
			     onclick="add_row('TABLE_DocList')" style="cursor: hand">
		</td>
	</tr> 
	
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1"></td>
		<!--  映射名称 -->
		<td align="center">
			<input type="hidden" id="tibJdbcRelationListForms[!{index}].fdSyncType" name="tibJdbcRelationListForms[!{index}].fdSyncType"/>
			<xform:dialog style="width:95%;float:left;" required="true"
					propertyId="tibJdbcRelationListForms[!{index}].tibJdbcMappManageId" propertyName="tibJdbcRelationListForms[!{index}].tibJdbcMappManageName"
					dialogJs="TibJdbcMapp_treeDialog('tibJdbcRelationListForms[!{index}].tibJdbcMappManageId','tibJdbcRelationListForms[!{index}].tibJdbcMappManageName');"></xform:dialog>
		</td>
		
		<!-- 用途说明   -->
		<td align="center">
		<input type="textarea" id="tibJdbcRelationListForms[!{index}].fdUseExplain" name="tibJdbcRelationListForms[!{index}].fdUseExplain" 
		            value="${tibJdbcRelationListForms.fdUseExplain}"  class="inputsgl" style="width:85%" >
		</td>
		
		<!-- 同步方式  -->
		<td style="padding:0px;margin:0px;" class="tdPadding">
		  <table class="tb_normal" width="100%" border="0px;">
			  <tr id="tr_tibJdbcRelationListForms[!{index}].fdSyncSelectType">
				  <td width='10%'>
					  <select style="float:left;" id="tibJdbcRelationListForms[!{index}].fdSyncSelectType" name="tibJdbcRelationListForms[!{index}].fdSyncSelectType"  disabled="true"  onchange="getMappInfor(this.id);">
					      <option value="1">全量同步</option>
					      <option value="2">增量同步</option>
					      <option value="3">日志同步</option>
					  </select>
				  </td>
			  </tr>
		 </table> 
		</td>
		
		<!-- 上下移动排序 -->
		<td>
			<img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/up.gif"/>" onclick="DocList_MoveRow(-1);">
			<img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/down.gif"/>" onclick="DocList_MoveRow(1);">
		    <img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/delete.gif"/>" onclick="DocList_DeleteRow();">
		</td>	
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibJdbcTaskManageForm.tibJdbcRelationListForms}" var="tibJdbcRelationListForms" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		<td>
		   <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].fdSyncType" name="tibJdbcRelationListForms[${vstatus.index}].fdSyncType" value='${tibJdbcRelationListForms.fdSyncType }'/>
		   <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].fdId" name="tibJdbcRelationListForms[${vstatus.index}].fdId" value='${tibJdbcRelationListForms.fdId }'/>
		   <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].tibJdbcTaskManageId" name="tibJdbcRelationListForms[${vstatus.index}].tibJdbcTaskManageId" value='${tibJdbcRelationListForms.tibJdbcTaskManageId }'/>
		     <xform:dialog style="width:95%;float:left;" required="true"
				propertyId="tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageId" propertyName="tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageName"
				dialogJs="TibJdbcMapp_treeDialog('tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageId','tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageName');"></xform:dialog>
		</td>
		
		<!-- 用途说明 -->
		<td  align="center">
		   <input type="textarea" id="tibJdbcRelationListForms[${vstatus.index}].fdUseExplain" name="tibJdbcRelationListForms[${vstatus.index}].fdUseExplain" 
		            value="${tibJdbcRelationListForms.fdUseExplain}"  class="inputsgl" style="width:85%" >
		</td>
		
		<!-- 同步方式  -->
		<td style="padding: 0px;">
		  <table class="tb_normal" width="100%" border="0">
			  <tr id="tr_tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType">
				  <td width='10%'>
					  <select id="tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType" 
					  		name="tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType"  
					  		disabled="true" onchange="getMappInfor(this.id);"
					  		style="float:left;">
					      <option value="1">全量同步</option>
					      <option value="2">增量同步</option>
					      <option value="3">日志同步</option>
					  </select>
				  </td>
			  </tr>
		 </table> 
		</td>
		
		<!-- 上下移动排序 -->
		<td >
			<img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/up.gif"/>" onclick="DocList_MoveRow(-1);">
			<img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/down.gif"/>" onclick="DocList_MoveRow(1);">
		    <img style="cursor:pointer"  class="optStyle" src="<c:url value="/resource/style/default/icons/delete.gif"/>" onclick="DocList_DeleteRow();">
		</td>
	</tr>
	</c:forEach>	
</table>
</td>
<script type="text/javascript">
Com_IncludeFile("dialog.js|jquery.js|data.js");
Com_IncludeFile("json2.js", null, "js");
Com_IncludeFile("jdbcFormula.js","${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/","js",true);
Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
</script>
<script type="text/javascript">
var dataSourceMap="";
var flag=true;
var currentRow="";

//映射选择器
function TibJdbcMapp_treeDialog(id,name) {
	var t_bean="tibJdbcMappManageBeanService&parentId=!{value}&type=cate";
	var d_bean="tibJdbcMappManageBeanService&selecteId=!{value}&type=func";
	var s_bean="tibJdbcMappManageBeanService&keyword=!{keyword}&type=search";
	var data = {
		idField : id,
		nameField : name,
		treeBean : t_bean,
		treeTitle :'<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.tibJdbcManageCategoryDataTree" />',
		dataBean : d_bean,
		action : function(rtn){
			if(rtn && rtn.GetHashMapArray().length>0){
				if(id!=null && id.length>0){
					var startIndex = id.indexOf("[");
					var endIndex = id.indexOf("]");
					if(startIndex!=null && endIndex!=null){
						var rowNum = id.substring(startIndex+1,endIndex);
					    clearMappInfor(rowNum);
						if($("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").attr("disabled")){
						    $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").attr("disabled",false);
						      getMappInfor(id);
						}else{
							$("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").attr("value","1");
						}
					}
				}
			}
		},
		searchBean : s_bean,
		winTitle : '<bean:message bundle="tib-jdbc" key="tibJdbcTaskManage.tibJdbcManageCategoryDataWinTitle" />'
	};
	TIB_SysUtil.tibTreeDialog(data);
}


//构建下拉框选项
function setTabField(fieldInfo){
	var optionHtml="";
	    optionHtml+="<option value=''>==请选择==</option>";
 if(fieldInfo!=null && fieldInfo.length>0){
	  for(var i=0;i<fieldInfo.length;i++){
		  optionHtml+="<option value="+fieldInfo[i]+">";
		  optionHtml+=""+fieldInfo[i]+"";
		  optionHtml+="</option>";
	  }
 }
 return optionHtml;
}

//构建下拉框选项
function setTabConnectField(fieldInfo){
	var optionHtml="";
	    //optionHtml+="<option value=''>==请选择==</option>";
 if(fieldInfo!=null && fieldInfo.length>0){
	  for(var i=0;i<fieldInfo.length;i++){
		  optionHtml+="<option value="+fieldInfo[i]+">";
		  optionHtml+=""+fieldInfo[i]+"";
		  optionHtml+="</option>";
	  }
 }
 return optionHtml;
}


//同步数据前先把目标表内容清空，再插入数据
function clearMappInfor(rowNum){
	  //先去掉先前的数据源
    $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().nextAll().remove();
     //先去掉先前构建的目标表
    $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().nextAll().remove();
    var fullSyncHtml = "<td><span><input type='checkbox' id='tibJdbcRelationListForms["+rowNum+"].fullDelId' name='tibJdbcRelationListForms["+rowNum+"].fullDelId' value='1'/>每次同步前是否删除目标表数据</span></td>";
    $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().append(fullSyncHtml);
}

//得到当前表的字段信息
function editFormFieldFunction(rowNum){
	var sourceSql = $("input[name='tibJdbcRelationListForms["+rowNum+"].sourceSql']").val();
	var dbId = $("input[name='tibJdbcRelationListForms["+rowNum+"].dbId']").val();
	var idField = "tibJdbcRelationListForms["+rowNum+"].deleteCondition";
	var deleteCondition = $("input[name='"+ idField +"']").val();
	//if (deleteCondition != "") {
		//sourceSql = "select * from ("+ sourceSql +") as queryDelTab where "+ deleteCondition;
	//}
	var dbId=$("input[id='tibJdbcRelationListForms[" + rowNum+ "].dbId']").val();
	var sourceSql=$("input[id='tibJdbcRelationListForms[" + rowNum+ "].sourceSql']").val();
	var url = "tibJdbcLoadTableFieldService&dbId=" + dbId + "&sourceSql="+ sourceSql;
	    currentRow=rowNum;
    var data = new KMSSData();
        data.SendToBean(url, function(rtn){destionTabelField(rtn, dbId, sourceSql, deleteCondition, idField);});
}

function destionTabelField(rtn, dbId, sourceSql, deleteCondition, idField) {
	var mapArray = rtn.GetHashMapArray();
	var tableInfoHtml = "<table border=0 class='tb_normal'>";
	var fieldInfo=[];
	var tempInfo="";
	if (mapArray != null && mapArray.length > 0) {
		var obj = eval("(" + mapArray[0].key0 + ")");
		var fieldName="";
		var dataType="";
		for ( var key in obj) {
			if (key != null && key != undefined) {
				for ( var i = 0; i < obj[key].length; i++) {
					fieldName =eval("(" + obj[key][i] + ")").fieldName;
					dataType =eval("(" + obj[key][i] + ")").dataType;
					tempInfo='{'+'"' + "name" + '"' + ":" +'"' +fieldName+ '"'+ "," 
					            +'"' + "label" + '"' + ":" +'"' +fieldName+ '"'+","
					            +'"' + "type" + '"' + ":" +'"' +dataType+ '"'+ '}';
					fieldInfo.push(JSON.parse(tempInfo));
				}
		 }
		}
	}
	Formula_DialogInput(idField, idField, fieldInfo, null, callBackFunction, null, null, dbId, sourceSql, deleteCondition);		
}


function  callBackFunction(rtn){
	if(rtn!=null&&rtn.data.length>0){
		var condtion= rtn.data[0].name;
		$("input[id='tibJdbcRelationListForms["+currentRow+"].deleteCondition']").attr("value",condtion);
	}
}

// 通过 方式的不同,生成对应的 方式表
function getMappType(rowNum,selectType, fdSyncType){
	var manageId = $("input[name='tibJdbcRelationListForms["+rowNum+"].tibJdbcMappManageId']").val();
	var data = new KMSSData();
    data.SendToUrl(Com_Parameter.ContextPath +
		"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=queryObjectById&manageId="+ manageId+"&rowNum="+rowNum+"&selectType="+selectType,
		function(http_request){afterCallbackFunction(http_request, fdSyncType);}, false);
}

// 方式回调函数
function afterCallbackFunction(http_request, fdSyncType){
	  var mapArray  =  http_request.responseText;
  if(mapArray!=null && mapArray.length>0){
       mapArray =eval("("+mapArray+")");
	   var tableInfoHtml="";
	   var rowNum=mapArray[0];
	   var editInfoHtml="<img src='${KMSS_Parameter_StylePath}icons/edit.gif'";
           editInfoHtml+="alt='<bean:message key="button.edit"/>' ";
       var eventfoHtml=" onclick='editFormFieldFunction("+rowNum+");' style='cursor: hand'>";
	   var dbId=mapArray[1];
	   var obj=mapArray[2];
	       obj=eval("("+obj+")");
	   var selectVal=$("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").find("option:selected").val(); 
       var sourceField="";
	   var targetTabHtml="";   
	   var targetTabHtml_log = "";
		if(selectVal=='2'){
		    var fieldList=mapArray[4];
		    sourceField=setTabField(fieldList);
		}

		for(var key in obj){ 
	   	   if(key!=null && key!=undefined){
	   		   var fieldInfoArr = obj[key];
	   		   var primaryKeyField="";
	   		   var pkFieldValue="";
	   		   var otherField="";
	   		   var havePkFlag=false;
	   		   var tempField="";
	   		   if(fieldInfoArr!=null && fieldInfoArr!=undefined && fieldInfoArr.length>0){
	       		   for(var j=0;j<fieldInfoArr.length;j++){
	                     var fieldName = fieldInfoArr[j].fieldName;
	            		 var primaryKey= fieldInfoArr[j].primaryKey;
	            		 if(primaryKey=='1'){
            			     havePkFlag=true;
            			     pkFieldValue=fieldName;
            			     primaryKeyField+="<option value='"+fieldName+"' selected='selected'>"+fieldName+"</option>";
	                	  }else{ 
                    	    if(j==0){
                		      tempField=fieldName;
                    	    }
                		     otherField+="<option value='"+fieldName+"'>"+fieldName+"</option>";
	                      }
	           	    }
		         }
		          if(!havePkFlag){
		        	  pkFieldValue=tempField;
			      }
			   var tabInfor=key+"("+pkFieldValue+")";
		           targetTabHtml+="<input style='width:180px;' style='cursor:pointer;' title='可双击编辑，并确保类似主键类型字段' type='text' id='tibJdbcRelationListForms["+rowNum+"]."+key+"''  value="+tabInfor+" name='tibJdbcRelationListForms["+rowNum+"]."+key+"''  ondblclick='showSelect(this);' readonly='readonly' class='inputread'/>";
		           targetTabHtml+="<select  style='display: none;' id='tibJdbcRelationListForms["+rowNum+"]."+key+".fieldPk' name='tibJdbcRelationListForms["+rowNum+"]."+key+".fieldPk'  style='display:none;' onblur ='doChange(this)';>";
		           targetTabHtml+=(primaryKeyField+otherField);
		           targetTabHtml+="</select>&nbsp;&nbsp;&nbsp;";
		           targetTabHtml_log+="<input style='width:180px;' type='text' title='不可编辑，此处不影响任务同步' id='tibJdbcRelationListForms["+rowNum+"]."+key+"''  value="+tabInfor+" name='tibJdbcRelationListForms["+rowNum+"]."+key+"'' readonly='readonly' class='inputread'/>";
		           targetTabHtml_log+="<select  style='display: none;' id='tibJdbcRelationListForms["+rowNum+"]."+key+".fieldPk' name='tibJdbcRelationListForms["+rowNum+"]."+key+".fieldPk'  style='display:none;' onblur ='doChange(this)';>";
		           targetTabHtml_log+=(primaryKeyField+otherField);
		           targetTabHtml_log+="</select>&nbsp;&nbsp;&nbsp;";
	   	   }
		  }
		  
	      if(selectVal=='2'){
              var sourceSql=mapArray[3];
	    	  tableInfoHtml+="<tr><td width='10%'>源表 </td>";
	    	  tableInfoHtml+="<td width='35%'>时间戳： <input type='hidden' id='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime' name='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime'/>";
			  if(sourceField!=null && sourceField.length>0){
	  		      tableInfoHtml+="<select id='tibJdbcRelationListForms["+rowNum+"].filter'  name='tibJdbcRelationListForms["+rowNum+"].filter'>";
			  }else{
	  		      tableInfoHtml+="<select id='tibJdbcRelationListForms["+rowNum+"].filter' disabled='true' name='tibJdbcRelationListForms["+rowNum+"].filter'>";
			  }
		      tableInfoHtml+=sourceField;
		      tableInfoHtml+="</select></td>";
		      
		      tableInfoHtml+="<td width='55%'>删除条件:<input class='inputsgl' onblur='deleteConditionBlur(this.value, "+ rowNum +")' type=text id='tibJdbcRelationListForms["+rowNum+"].deleteCondition' name=tibJdbcRelationListForms["+rowNum+"].deleteCondition>";
		      tableInfoHtml+=editInfoHtml;
		      tableInfoHtml+=" id=tibJdbcRelationListForms["+rowNum+"]."+key+"|"+dbId;
		      tableInfoHtml+=eventfoHtml+"&nbsp;";
		      // 添加查询图片
		      tableInfoHtml+='<img style="cursor:pointer" onclick="queryDelData(\''+rowNum+'\');" src="'+Com_Parameter.ContextPath+'resource/style/default/images/form/search.png" /></td>';
		      tableInfoHtml+="<input type='hidden' id='tibJdbcRelationListForms["+rowNum+"].sourceSql' name='tibJdbcRelationListForms["+rowNum+"].sourceSql' >";
		      tableInfoHtml+="<input type='hidden' id='tibJdbcRelationListForms["+rowNum+"].dbId' name='tibJdbcRelationListForms["+rowNum+"].dbId' value="+dbId+">";
		      tableInfoHtml+="</tr>";
		      tableInfoHtml+="<tr ><td width='10%'>目标表</td>";
		      tableInfoHtml+="<td id='tibJdbcRelationListForms["+rowNum+"].targetTab' colspan=2>";
		      tableInfoHtml+=targetTabHtml;
		      tableInfoHtml+="</td></tr>";

  		    //先去掉先前的数据源
  	         $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().nextAll().remove();
  	         
  	         //先去掉先前构建的目标表
  	         $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().nextAll().remove();
  	         
  	         $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().after(tableInfoHtml);
  	         var dataHtml="<td  colspan=6></td>";
  	         $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().after(dataHtml);	
             $("input[id='tibJdbcRelationListForms[" +rowNum+"].sourceSql']").attr("value",sourceSql);
            
		  }else if(selectVal=='3'){
			  var sourceFieldHtml="源主键：<select title='必须确保类似主键类型字段' style='width:80px;' onchange='sourceIdChange(this)' id='tibJdbcRelationListForms["+rowNum+"].sourcePk'  name='tibJdbcRelationListForms["+rowNum+"].sourcePk'>";
		      //构建源表下拉框
		      var sourceFieldArray=mapArray[4];
		      if(sourceFieldArray!=null && sourceFieldArray.length>0){
		    	  var sourceFieldOption =setTabConnectField(sourceFieldArray);
		              sourceFieldHtml+=sourceFieldOption;
		              sourceFieldHtml+="</select><font color=red>*</font>";
			  } 
			  //日志表字段
			  tableInfoHtml+="<tr><td width='10%'>日志表</td>";
  		      tableInfoHtml+="<td width='23%'>tib_jdbclog_<select style='width:60px;' id='tibJdbcRelationListForms["+rowNum+"].logTabName'  name='tibJdbcRelationListForms["+rowNum+"].logTabName'>";
  		      tableInfoHtml+="</select><font color=red>*</font></td>";
  		      tableInfoHtml+="<td width='23%'>"+ sourceFieldHtml +"</td>";
  		      tableInfoHtml+="<td width='23%'>操作类型：<input type='text' readonly='readonly' class='inputread' style='width:85px;cursor:pointer;' ondblclick='logOptChange(this, true);' onblur='logOptChange(this, false)' id='tibJdbcRelationListForms["+rowNum+"].operationType' name='tibJdbcRelationListForms["+rowNum+"].operationType' value='删:0;增:1;改:2'></td>";
  		      tableInfoHtml+="<td width='20%'>KEY：<input type='text' class='inputsgl' style='width:75px;' value='' id='tibJdbcRelationListForms["+rowNum+"].key' name='tibJdbcRelationListForms["+rowNum+"].key'></td>";
  		      tableInfoHtml+="</tr>";
  		      tableInfoHtml+="<tr><td width='10%'>目标表</td>";
		      tableInfoHtml+="<td id='tibJdbcRelationListForms["+rowNum+"].targetTab' colspan=4>";
		      tableInfoHtml+=targetTabHtml_log;
		      tableInfoHtml+="</td>";
		      
	         //数据源
	         var tempHtml="";
		     var dbArray=mapArray[3];
		     if(dbArray!=null && dbArray.length>0){
		          var currDb="";
		          var optionVal="";
		          var optionText="";
	              tempHtml+="<td colspan='4'>日志表数据源：<select id='tibJdbcRelationListForms["+rowNum+"].dbName'  name='tibJdbcRelationListForms["+rowNum+"].dbName' onchange='getLogTab(this);'>";
	              var checkedLogDB = "";
	              if (fdSyncType != null) {
	            	  checkedLogDB = fdSyncType.logDB;
		          } else {
		        	  checkedLogDB = dbId;
			      }
	              for(var j=0;j<dbArray.length;j++){
	                  currDb = dbArray[j];
	                  optionVal=currDb[0];
	                  optionText=currDb[1];
	                  // 让日志表数据源值选中
	                  if (checkedLogDB == optionVal) {
	                	  tempHtml+="<option value="+optionVal+" selected='selected'>";
		              } else {
		            	  tempHtml+="<option value="+optionVal+">";
			          }
	                  tempHtml+=""+optionText+"";
	               	  tempHtml+="</option>";
	          	  }
	              tempHtml+="</select></td>";
		      } 
		      
                //先去掉先前的数据源
                $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().nextAll().remove();
                
                //先去掉先前构建的目标表
                $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().nextAll().remove();
                var dataHtml=tempHtml;
                $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().parent().after(tableInfoHtml);
                $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().after(dataHtml);	
                var obj=$("select[id='tibJdbcRelationListForms["+rowNum+"].dbName']");
                if(obj!=null && obj.length>0){
                   var tempObj=$(obj).get(0);
           	        getLogTab(tempObj);
                }
	     } 
    }
}

// 增量删除条件失去焦点事件
function deleteConditionBlur(deleteCondition, rowNum) {
	var sourceSql = $("input[name='tibJdbcRelationListForms["+rowNum+"].sourceSql']").val();
	var dbId = $("input[name='tibJdbcRelationListForms["+rowNum+"].dbId']").val();
	if (deleteCondition != "") {
		sourceSql = "select * from ("+ sourceSql +") as queryDelTab where "+ deleteCondition;
	}
	var data = new KMSSData();
	data.SendToBean("tibJdbcDeleteValidateBean&dbId="+ dbId +"&sourceSql="+sourceSql, tibjdbc_DCBlurCall);
}

function tibjdbc_DCBlurCall(rtnData) {
	var rtnObj = rtnData.GetHashMapArray()[0];
	var result = rtnObj["result"];
	if ("false" == result) {
		var errorStr = rtnObj["errorStr"];
		alert("删除条件填写错误，请改正，否则会对同步造成错误，错误信息为："+ errorStr);
	}
}

// 日志同步 操作类型改变事件
function logOptChange(thisObj, flag) {
	if (flag) {
		$(thisObj).removeAttr("readonly");
		$(thisObj).removeClass("inputread");
		$(thisObj).addClass("inputsgl");
	} else {
		$(thisObj).attr("readonly", "readonly");
		$(thisObj).removeClass("inputsgl");
		$(thisObj).addClass("inputread");
	}
}

function sourceIdChange(thisObj) {
	thisObj.value;	
}

//显示目标表中主键下拉框
function  showSelect(obj){
  var id = obj.id;
  $("input[id='"+id+"']").hide();
  var selectId = id+".fieldPk";
  $("select[id='"+selectId+"']").show();
  $("select[id='"+selectId+"']").focus();
}

//表主键发生变化处理
function doChange(obj){ 
	var selectId=obj.id;
	var tempArray=selectId.split(".");
	var indexNum=selectId.lastIndexOf(".");
	var inputId = selectId.substring(0,indexNum);
	var selectOption = $(obj).find("option:selected").val();
	var inputValue=tempArray[1]+"("+selectOption+")";
	$("input[id='"+inputId+"']").attr("value",inputValue);
	$("input[id='"+inputId+"']").show();
	$("select[id='"+selectId+"']").hide();
}


//显示日志表
function setLogTabs(rtn) {
	var mapArray = null;
	var rtnValue = rtn.responseText;
	if (rtnValue) {
		// 同步传输回来的数据
		mapArray = eval("("+rtn.responseText+")");//.GetHashMapArray();
	}
	if (mapArray != null && mapArray.length > 0) {
		var tableInfoHtml = "";
		for ( var i = 0; i < mapArray.length; i++) {
			tableInfoHtml += "<option id='" + mapArray[i].name + "' value='"
					+ mapArray[i].name + "' >" + mapArray[i].name + "</option>";
		}
		 
		$("select[id='tibJdbcRelationListForms["+currentRow+"].logTabName']").children().remove();
		$("select[id='tibJdbcRelationListForms["+currentRow+"].logTabName']").append(tableInfoHtml);
	}
}

//根据日志源选项取加载日志表下拉框
function getLogTab(obj){
	var id = obj.id;
	id=$.trim(id);
	var startIndex = id.indexOf("[");
	var endIndex = id.indexOf("]");
	if(startIndex!=null && endIndex!=null){
		currentRow = id.substring(startIndex+1,endIndex);
	}
	$("select[id='tibJdbcRelationListForms["+currentRow+"].logTabName']").children().remove();
	var dbId = $(obj).find("option:selected").val();
	if(dbId.length<1 ||dbId==null){
		//alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
		return false;
	}
	//var url = "tibJdbcLoadDBTablService&dbId=" +dbId+"&tabType=sysLog";
	var data = new KMSSData();
	//data.SendToBean(url, setLogTabs);
	data.SendToUrl(Com_Parameter.ContextPath +
			"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getLogTabName&dbId=" 
			+ dbId +"&tabType=sysLog", setLogTabs, false);
}

//获取所选择的映射信息
function getMappInfor(id, fdSyncType){
	if(id!=null && id.length>0){
		id=$.trim(id);
		var startIndex = id.indexOf("[");
		var endIndex = id.indexOf("]");
		if(startIndex!=null && endIndex!=null){
			var rowNum = id.substring(startIndex+1,endIndex);
			var selectVal=$("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").find("option:selected").val(); 

			//1全量同步  2增量同步   3日志同步
			 if(selectVal=='1'){
				 clearMappInfor(rowNum);
			}else{
				$("#tibJdbcRelationListForms["+rowNum+"].fullDelId").remove();
				getMappType(rowNum,selectVal, fdSyncType);
			}
		}
	}
}

//选择类型选择器 
function jdbcMappingSelector(obj){
	//获取当前选择的行号
	var rowNum= $(obj).parent().prev().text();
	var diag=new Dialog();
	   IMAGESPATH='${KMSS_Parameter_ContextPath}tib/jdbc/resource/images/';
	   diag.Drag=true;
	   diag.Width = 850;
	   diag.Height = 300;
	   diag.OKEvent =function(){
			   var doc =diag.innerFrame.contentWindow.document;
		       var id=$(doc).find("input[name='List_Selected']:checked").val();
		       var manageName=$(doc).find('input[name="List_Selected"]:checked').parent().parent().children("td:eq(2)").text();
               var tempId="tibJdbcRelationListForms["+(rowNum-1)+"].tibJdbcMappManageId";
               var tempName="tibJdbcRelationListForms["+(rowNum-1)+"].tibJdbcMappManageName";
			       $("input[id="+tempId+"]").attr("value",id);
			       $("input[id="+tempName+"]").val(manageName);
			   diag.close();	
		   };
	   diag.Title = "查看数据";
	   diag.URL = "${KMSS_Parameter_ContextPath}tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=list&forward=jdbcManageChooser&rowNum="+rowNum;
	   diag.show();
}

//动态增加表格行
function add_row(index){
	DocList_AddRow();
	var trArray=$("#"+index).children("tbody>tr:gt(1)");
	$.each(trArray, function(i, n) {
      var currentTr= $(this);
         $(currentTr).children("td:eq(3)").css("padding","0px");
	});
}

$(document).ready(function(){
	    var trArray=$("#TABLE_DocList").children("tbody").children("tr:gt(1)");
		if(trArray!=null && trArray.length>0){
		   $(trArray).each(function(rowNum){
               var fdSyncType=$(this).children("td:eq(1)").children("input[id='tibJdbcRelationListForms["+rowNum+"].fdSyncType']").val(); 
               //设置增量方式下拉框可以修改
               $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").attr("disabled",false);  
               if(fdSyncType!=null && fdSyncType!=undefined && fdSyncType.length>0 ){
                   fdSyncType=eval("("+fdSyncType+")");
		           //增量方式
		           var selectType= fdSyncType.syncType;
		           var id="tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType";
		           $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").attr("value",selectType);
		           getMappInfor(id, fdSyncType);
		           setValue(fdSyncType,rowNum);
 	           }
			});
       }
  });

//设置日志数据源下拉框选项
function setDataSource(rowNum){
	 if(flag){
       flag=false;
	   getDBDatasource();
     }
    if (dataSourceMap != null && dataSourceMap.length > 0){
	         var dataSourceHtml="<td>";
	         var dbId="";
	         var dbValue="";
	         var tempHtml="日志表数据源: <select id='tibJdbcRelationListForms["+rowNum+"].dbName'   name='tibJdbcRelationListForms["+rowNum+"].dbName' onchange='getLogTab(this);'>";
	       for(var j=0;j<dataSourceMap.length;j++){
             dbId = dataSourceMap[j].id;
             dbValue=dataSourceMap[j].value;
             tempHtml+="<option value="+dbId+">";
             tempHtml+=""+dbValue+"";
             tempHtml+="</option>";
           }
            dataSourceHtml+= tempHtml+"</td>";
	        $("select[id='tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType']").parent().after(dataSourceHtml);	
     } 
}


function setValue(fdSyncType,rowNum){
	   var selectType= fdSyncType.syncType;
	   if(selectType =='1'){
		    var isDel = fdSyncType.isDel;
          if(isDel=='1'){
         	 $("input[id='tibJdbcRelationListForms["+rowNum+"].fullDelId']").attr("checked", true);
          }else{
         	 $("input[id='tibJdbcRelationListForms["+rowNum+"].fullDelId']").attr("checked", false);
          }
	    }else if(selectType=='2'){
 		 var filter = fdSyncType.filter;
 		 var lastUpdateTime = fdSyncType.lastUpdateTime;
 		 var deleteCondition = fdSyncType.deleteCondition;
         var lastUpdateTime = fdSyncType.lastUpdateTime;

         //设置该表的过滤字段被选中
         $("select[id='tibJdbcRelationListForms["+rowNum+"].filter']").attr("value",filter);
         $("select[id='tibJdbcRelationListForms["+rowNum+"].filter']").attr("title","最后一次同步时间为："+ lastUpdateTime);
         $("select[id='tibJdbcRelationListForms["+rowNum+"].filter']").attr("disabled",false);
         
         $("input[id='tibJdbcRelationListForms["+rowNum+"].deleteCondition']").attr("value",deleteCondition);
         $("input[id='tibJdbcRelationListForms["+rowNum+"].deleteCondition']").attr("disabled",false);
         
         $("input[id='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime']").attr("value",lastUpdateTime);
         $("input[id='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime']").attr("disabled",false);
         
 	  }else if(selectType=='3'){
 		 var logTabName = fdSyncType.logTabName;
         var operationType = fdSyncType.operationType;
         var keyWord=fdSyncType.key;
         var logDB= fdSyncType.logDB;
         var sourcePk= fdSyncType.sourcePk;
         if(operationType!=null && operationType!=undefined && operationType.length>0){
        	 var tempAdd='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.add"/>';
        	 var tempModify='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.modify"/>';
        	 var tempDelete='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.delete"/>';
        	     operationType=operationType.replace('ADD',tempAdd).replace('UPDATE',tempModify).replace('DELETE',tempDelete);
           }
	     $("select[id='tibJdbcRelationListForms["+rowNum+"].dbName']").attr("value",logDB);
	     $("select[id='tibJdbcRelationListForms["+rowNum+"].dbName']").attr("disabled",false);
	       
         //设置该表被选中的日志表
         $("select[id='tibJdbcRelationListForms["+rowNum+"].logTabName']").attr("value",logTabName.replace("tib_jdbclog_", ""));
         $("select[id='tibJdbcRelationListForms["+rowNum+"].logTabName']").attr("disabled",false);
         
         //设置该表的操作类型
         $("input[id='tibJdbcRelationListForms["+rowNum+"].operationType']").attr("value",operationType);
         $("input[id='tibJdbcRelationListForms["+rowNum+"].operationType']").attr("disabled",false);
          
  	     //设置该表的key
         $("input[id='tibJdbcRelationListForms["+rowNum+"].key']").attr("value",keyWord);
         $("input[id='tibJdbcRelationListForms["+rowNum+"].key']").attr("disabled",false);
         
         //设置源表的主键被选中
     	 $("select[id='tibJdbcRelationListForms["+rowNum+"].sourcePk']").attr("value",sourcePk);
     	 $("select[id='tibJdbcRelationListForms["+rowNum+"].sourcePk']").attr("disabled",false);
 	 	}
	 	
 	  var targetTab = fdSyncType.targetTab;
 	  var targetTabHtml="";
 	   if(targetTab!=null && targetTab.length>0){
      	  for(var j=0;j<targetTab.length;j++){
            var currentObj = targetTab[j];
            var tabName=currentObj.targetTabName;
            var fieldPk=currentObj.fieldPk;
            var tabInfor=tabName+"("+fieldPk+")";
            $("input[id='tibJdbcRelationListForms["+rowNum+"]."+tabName+"']").attr("value",tabInfor);
            $("select[id='tibJdbcRelationListForms["+rowNum+"]."+tabName+".fieldPk']").attr("value",fieldPk);
          }
      }
      //$("td[id='tibJdbcRelationListForms["+rowNum+"].targetTab']").children().remove();
      //$("td[id='tibJdbcRelationListForms["+rowNum+"].targetTab']").append(targetTabHtml);
}

function getDBDatasource(){
	var url = "tibJdbcLoadDBDataSourceService";
	var data = new KMSSData();
	data.SendToBean(url, dbDataSourceFunction);
}

function dbDataSourceFunction(rtn) {
	  dataSourceMap = rtn.GetHashMapArray();
}

// 查询删除数据前100条
function queryDelData(rowNum) {
	var sourceSql = $("input[name='tibJdbcRelationListForms["+rowNum+"].sourceSql']").val();
	var dbId = $("input[name='tibJdbcRelationListForms["+rowNum+"].dbId']").val();
	var deleteCondition = $("input[name='tibJdbcRelationListForms["+rowNum+"].deleteCondition']").val();
	if (deleteCondition != "") {
		sourceSql = "select * from ("+ sourceSql +") as queryDelTab where "+ deleteCondition;
	}
	var diaog = new Dialog();
	IMAGESPATH = '${KMSS_Parameter_ContextPath}tib/jdbc/resource/images/';
	diaog.Drag = true;
	diaog.Width = 850;
	diaog.Height = 450;
	diaog.Title = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.viewData"/>';
	diaog.URL = Com_Parameter.ContextPath +"tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=getDelData&dbId="
			+ dbId + "&sourceSql=" + sourceSql;
	diaog.show();
}

</script>
			
		
	
