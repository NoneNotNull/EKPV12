<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/zDialog.js"></script>
<tr LKS_LabelName="<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.mappingRelation"/>">
  <td>
	<table id="TABLE_DocList" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
		<td align="center" width="3%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.number"/></td>
		<td align="center" width="20%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.name"/></td>
		<td align="center" width="16%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdUseExplain"/></td>
		<td align="center" width="60%"><bean:message bundle="tib-jdbc" key="tibJdbcMappManage.synchronizationType"/></td>
	</tr>
	
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1"></td>
		
		<!--  映射名称 -->
		<td rowspan="50" align="center">
			 <input type="hidden" id="tibJdbcRelationListForms[!{index}].fdSyncType" name="tibJdbcRelationListForms[!{index}].fdSyncType" />
			 <xform:dialog style="width:85%;float:left;" required="true" showStatus="readOnly"
			 propertyId="TibJdbcMapp_treeDialog('tibJdbcRelationListForms[!{index}].tibJdbcMappManageId" propertyName="tibJdbcRelationListForms[!{index}].tibJdbcMappManageName" dialogJs="categoryJs()"></xform:dialog>
		</td>
		
		<!-- 用途说明   -->
		<td >
		<input type="textarea" id="tibJdbcRelationListForms[!{index}].fdUseExplain" name="tibJdbcRelationListForms[!{index}].fdUseExplain" 
		            value="${tibJdbcRelationListForms.fdUseExplain}"  class="inputsgl" style="width:85%" >
		</td>
		
		<!-- 同步方式  -->
		<td >
		  <table class="tb_normal">
			  <tr id="tr_tibJdbcRelationListForms[!{index}].fdSyncSelectType">
				  <td >
					  <select id="tibJdbcRelationListForms[!{index}].fdSyncSelectType" name="tibJdbcRelationListForms[!{index}].fdSyncSelectType"  disabled="true"  onchange="getMappInfor(this.id);">
					      <option value="1">全量同步</option>
					      <option value="2">增量同步</option>
					      <option value="3">日志同步</option>
					  </select>
				  </td>
			  </tr>
		 </table> 
		</td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibJdbcTaskManageForm.tibJdbcRelationListForms}" var="tibJdbcRelationListForms" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		
		<td>
		 <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].fdSyncType" name="tibJdbcRelationListForms[!{index}].fdSyncType" value='${tibJdbcRelationListForms.fdSyncType}'/>
		 <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].fdId" name="tibJdbcRelationListForms[${vstatus.index}].fdId" value='${tibJdbcRelationListForms.fdId }'/>
		 <input type="hidden" id="tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageId" name="tibJdbcRelationListForms[!{index}].tibJdbcMappManageId" value='${tibJdbcRelationListForms.tibJdbcMappManageId}'/>
		 <xform:text property="tibJdbcRelationListForms[${vstatus.index}].tibJdbcMappManageName" style="width:85%" />
		</td>
		
		<td >
			${tibJdbcRelationListForms.fdUseExplain}
		</td>
		
		<!-- 同步方式  -->
		<td style="padding: 0px;">
		  <table class="tb_normal" width="100%" border="0">
			  <tr id="tr_tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType">
				  <td width='10%'>
					  <select id="tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType" name="tibJdbcRelationListForms[${vstatus.index}].fdSyncSelectType"  disabled="true"  onchange="getMappInfor(this.id);">
					      <option value="1">全量同步</option>
					      <option value="2">增量同步</option>
					      <option value="3">日志同步</option>
					  </select>
				  </td>
			  </tr>
		 </table> 
		</td>
	</tr>
	</c:forEach>
	
</table>
</td>
<script type="text/javascript">
Com_IncludeFile("dialog.js|jquery.js|data.js|doclist.js");
Com_IncludeFile("json2.js", null, "js");
Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
var dataSourceMap="";
var tempFieldId="";
var currentRow="";
var flag=true;

$(document).ready(function(){
  var trArray=$("#TABLE_DocList").children("tbody").children("tr:gt(1)");
  if(trArray!=null && trArray.length>0){
   $(trArray).each(function(rowNum){
      var fdSyncType=$(this).children("td:eq(1)").children("input[id=tibJdbcRelationListForms["+rowNum+"].fdSyncType]").val();
      if(fdSyncType!=null && fdSyncType!=undefined && fdSyncType.length>0 ){
             fdSyncType=eval("("+fdSyncType+")");
         var selectType= fdSyncType.syncType;
         var id="tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType";
             $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").attr("value",selectType);
             //构建映射表格
             getMappInfor(id);
             setValue(fdSyncType,rowNum);
       }
    });
 }
});


function setValue(fdSyncType,rowNum){
	  var selectType= fdSyncType.syncType;
	  if(selectType=='1'){
	    var isDel = fdSyncType.isDel;
        if(isDel=='1'){
           	$("input[id=tibJdbcRelationListForms["+rowNum+"].fullDelId]").attr("checked", true);
        }else{
           	$("input[id=tibJdbcRelationListForms["+rowNum+"].fullDelId]").attr("checked", false);
        }
	        $("input[id=tibJdbcRelationListForms["+rowNum+"].fullDelId]").attr("disabled","true");
	  } else if(selectType=='2'){
 		 var filter = fdSyncType.filter;
 		 var deleteCondition = fdSyncType.deleteCondition;
         var lastUpdateTime = fdSyncType.lastUpdateTime;

         //设置该表的过滤字段被选中
         $("span[id=tibJdbcRelationListForms["+rowNum+"].filter]").text(filter);
         $("td[id=tibJdbcRelationListForms["+rowNum+"].lastUpdateTime.title]").attr("title","最后一次同步时间为："+ lastUpdateTime);
         $("span[id='tibJdbcRelationListForms["+rowNum+"].deleteCondition']").text(deleteCondition);
         $("span[id=tibJdbcRelationListForms["+rowNum+"].lastUpdateTime]").text(lastUpdateTime);
         
 	  }else if(selectType=='3'){
 		 var logTabName = fdSyncType.logTabName;
         var operationType = fdSyncType.operationType;
         var keyWord=fdSyncType.key;
         var logDB= fdSyncType.logDB;
         var sourcePk= fdSyncType.sourcePk;

         if (dataSourceMap != null && dataSourceMap.length > 0){
             var selectedLogDB="";
	         for(var j=0;j<dataSourceMap.length;j++){
	            dbId = dataSourceMap[j][0];
	            if($.trim(logDB)==$.trim(dbId)){
		            selectedLogDB=dataSourceMap[j][1];
	                 break;
	              }
	         }
		     $("span[id='tibJdbcRelationListForms["+rowNum+"].dbName']").text(selectedLogDB);
          } 
         
         if(operationType!=null && operationType!=undefined && operationType.length>0){
        	 var tempAdd='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.add"/>';
        	 var tempModify='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.modify"/>';
        	 var tempDelete='<bean:message  bundle="tib-jdbc" key="tibJdbcTaskManage.delete"/>';
        	     operationType=operationType.replace('ADD',tempAdd).replace('UPDATE',tempModify).replace('DELETE',tempDelete);
           }
	       
         //设置该表被选中的日志表
         $("span[id=tibJdbcRelationListForms["+rowNum+"].logTabName]").text(logTabName);
         
         //设置该表的操作类型
         $("span[id=tibJdbcRelationListForms["+rowNum+"].operationType]").text(operationType);
          
  	     //设置该表的key
         $("span[id=tibJdbcRelationListForms["+rowNum+"].key]").text(keyWord);
         
         //设置源表的主键被选中
     	 $("span[id=tibJdbcRelationListForms["+rowNum+"].sourcePk]").text(sourcePk);
 	  }

 	  //设置目标表信息
 	   var targetTab = fdSyncType.targetTab;
 	   var targetTabHtml="";
 	   if(targetTab!=null && targetTab.length>0){
      	  for(var j=0;j<targetTab.length;j++){
            var currentObj = targetTab[j];
            var tabName=currentObj.targetTabName;
            var fieldPk=currentObj.fieldPk;
            var tabInfor=tabName+"("+fieldPk+")";
                targetTabHtml+= "<input style='width:220px;' type='text' id='tibJdbcRelationListForms["+ rowNum+ "]."+ tabName+ "''  value="+tabInfor+ " name='tibJdbcRelationListForms["+ rowNum+ "]."+ tabName+ "''  readonly='readonly' class='inputread'/>";
         }
      }
      $("td[id='tibJdbcRelationListForms["+rowNum+"].targetTab']").children().remove();
      $("td[id='tibJdbcRelationListForms["+rowNum+"].targetTab']").append(targetTabHtml);
}

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
						if($("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").attr("disabled")){
						    $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").attr("disabled",false);
						      getMappInfor(id);
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

//获取所选择的映射信息
function getMappInfor(id){
	if(id!=null && id.length>0){
		    id=$.trim(id);
		var startIndex = id.indexOf("[");
		var endIndex = id.indexOf("]");
		if(startIndex!=null && endIndex!=null){
			var rowNum = id.substring(startIndex+1,endIndex);
			var manageId=$("input[id=tibJdbcRelationListForms["+rowNum+"].tibJdbcMappManageId]").val();
			var selectType=$("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").find("option:selected").val(); 
			var data = new KMSSData();
		        data.SendToUrl(Com_Parameter.ContextPath +
					"tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=queryObjectById&manageId="+ manageId+"&rowNum="+rowNum+"&selectType="+selectType,
					afterCallbackFunction, false);
		}
	}
}

//动态构建映射表格
function afterCallbackFunction(http_request) {
	var mapArray = http_request.responseText;
	if (mapArray != null && mapArray.length > 0) {
		mapArray = eval("(" + mapArray + ")");
		var tableInfoHtml = "";
		var rowNum = mapArray[0];
		var dbId = mapArray[1];
		var obj = mapArray[2];
		    obj = eval("(" + obj + ")");
		var selectVal = $("select[id=tibJdbcRelationListForms[" + rowNum+ "].fdSyncSelectType]").find("option:selected").val();
		var sourceField = "";
		var targetTabHtml = "";
		if(selectVal =='1'){
		   var fullSyncHtml = "<td><span><input type='checkbox' id='tibJdbcRelationListForms["+rowNum+"].fullDelId' name='tibJdbcRelationListForms["+rowNum+"].fullDelId' value='1'/>每次同步前是否删除目标表数据</span></td>";
			   $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").parent().parent().append(fullSyncHtml);
	    }else if (selectVal == '2') {
			var sourceSql=mapArray[3];
			tableInfoHtml += "<tr><td width='10%'>源表 </td>";
			tableInfoHtml+="<td width='35%' id='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime.title'>时间戳： <input type='hidden' id='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime' name='tibJdbcRelationListForms["+rowNum+"].lastUpdateTime'/>";
	    	  
			if(sourceField!=null && sourceField.length>0){
	  		      tableInfoHtml+="<span id='tibJdbcRelationListForms["+rowNum+"].filter'  name='tibJdbcRelationListForms["+rowNum+"].filter'>";
			 }else{
	  		      tableInfoHtml+="<span id='tibJdbcRelationListForms["+rowNum+"].filter' name='tibJdbcRelationListForms["+rowNum+"].filter'>";
			 }
			
			tableInfoHtml += sourceField;
			tableInfoHtml += "</span></td>";
			tableInfoHtml+="<td width='55%'>删除条件：<span id='tibJdbcRelationListForms["+rowNum+"].deleteCondition' name=tibJdbcRelationListForms["+rowNum+"].deleteCondition></span></td>";
		    tableInfoHtml+="</tr>";
		    
		    tableInfoHtml+="<tr ><td>目标表</td>";
		    tableInfoHtml+="<td colspan=6 id='tibJdbcRelationListForms["+rowNum+"].targetTab'>";
		    tableInfoHtml+="</td></tr>";
 	        $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").parent().parent().after(tableInfoHtml);

		} else if (selectVal == '3') {
		   var sourceFieldHtml="source_id：<span id='tibJdbcRelationListForms["+rowNum+"].sourcePk'  name='tibJdbcRelationListForms["+rowNum+"].sourcePk'></span>";
		   dataSourceMap=mapArray[3];
		   //日志表字段
		   tableInfoHtml+="<tr><td width='10%'>日志表 </td>";
	       tableInfoHtml+="<td width='20%'><span  id='tibJdbcRelationListForms["+rowNum+"].logTabName'  name='tibJdbcRelationListForms["+rowNum+"].logTabName'>";
	       tableInfoHtml+="</span></td>";
	       tableInfoHtml+="<td width='25%'>"+ sourceFieldHtml +"</td>";
	       tableInfoHtml+="<td width='25%'>操作类型：<span id='tibJdbcRelationListForms["+rowNum+"].operationType' name='tibJdbcRelationListForms["+rowNum+"].operationType'></span></td>";
	       tableInfoHtml+="<td width='20%'>KEY：<span id='tibJdbcRelationListForms["+rowNum+"].key' name='tibJdbcRelationListForms["+rowNum+"].key'></span></td>";
	       tableInfoHtml+="</tr>";
	       tableInfoHtml+="<tr><td width='10%'>目标表</td>";
	       tableInfoHtml+="<td  colspan=4 id='tibJdbcRelationListForms["+rowNum+"].targetTab'>";
	       tableInfoHtml+="</td>";
	       var tempHtml="<td colspan='4'>日志表数据源：<span id='tibJdbcRelationListForms["+rowNum+"].dbName'  name='tibJdbcRelationListForms["+rowNum+"].dbName'></td>";
           $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").parent().parent().after(tableInfoHtml);
           $("select[id=tibJdbcRelationListForms["+rowNum+"].fdSyncSelectType]").parent().after(tempHtml);	
		}
	}
}
		
//选择类型选择器 
function jdbcMappingSelector(obj) {
	//获取当前选择的行号
	var rowNum = $(obj).parent().prev().text();
	var diag = new Dialog();
	IMAGESPATH = '${KMSS_Parameter_ContextPath}tib/jdbc/resource/images/';
	diag.Drag = true;
	diag.Width = 850;
	diag.Height = 300;
	diag.OKEvent = function() {
		var doc = diag.innerFrame.contentWindow.document;
		var id = $(doc).find("input[name='List_Selected']:checked").val();
		var manageName = $(doc).find('input[name="List_Selected"]:checked').parent().parent().children("td:eq(2)").text();
		var tempId = "tibJdbcRelationListForms[" + (rowNum - 1)+ "].tibJdbcMappManageId";
		var tempName = "tibJdbcRelationListForms[" + (rowNum - 1)+ "].tibJdbcMappManageName";
		    $("input[id=" + tempId + "]").attr("value", id);
		    $("input[id=" + tempName + "]").val(manageName);
		    diag.close();
	};
	diag.Title = "查看数据";
	diag.URL = "${KMSS_Parameter_ContextPath}tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=list&forward=jdbcManageChooser&rowNum="+ rowNum;
	diag.show();
}

function add_row(index) {
	DocList_AddRow();
}
</script>
			
		
	
