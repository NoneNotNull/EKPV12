<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="
	java.util.Iterator,
	com.landray.kmss.sys.ftsearch.config.LksConfigBuilder,
	com.landray.kmss.sys.ftsearch.config.LksConfig,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.sys.config.dict.SysDataDict" %>	
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<link href="${KMSS_Parameter_ResPath}style/common/ftsearch/ftsearch.css" rel="stylesheet" type="text/css" />
<head>

<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript"> 
Com_SetWindowTitle('<bean:message bundle="sys-ftsearch-db" key="search.moduleName" />');
Com_IncludeFile("ftsearch_advanced.css", "style/"+Com_Parameter.Style+"/ftsearch/"); 
//是否确定
function confirmSearch(){
	var sea = confirm('<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.noConfigSet" />');
	return sea;
}
//搜索提交
function CommitSearch(){	 	
	//var url = Com_CopyParameter("<c:url value="/sys/ftsearch/searchBuilder.do?method=search"/>");
	var url ="<c:url value='/sys/ftsearch/searchBuilder.do?method=search'/>";	 
	var target ="";
	//url = Com_SetUrlParameter(url, "modelName", null);
	url = Com_SetUrlParameter(url, "s_target", null);	 
	url = setUrlParameters(url); //设置提交的url
	if(url==null)
		return; 
	var queryString=document.getElementsByName("queryString")[0] ;
	if( queryString.value==''){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.queryString" />');//请填写搜索内容
		queryString.focus();
		return false;
	}
	var modelName=document.getElementsByName("modelName")[0].value;
	if(selAllFlag=='0'){
		if(modelName==''){
			alert('<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.noSelectSearchRange" />');
			return false;
		}
	}
	
	var fromCreateTime =document.getElementsByName("fromCreateTime")[0].value;  
	var toCreateTime =document.getElementsByName("toCreateTime")[0].value;  
	if(fromCreateTime!=""&&toCreateTime!=""&&fromCreateTime.indexOf("-")!=-1){
		   for(var i=0;i<3;i++){
			   fromCreateTime=fromCreateTime.replace("-","");
				toCreateTime=toCreateTime.replace("-",""); 
		} 
	}
	else if(fromCreateTime!=""&&toCreateTime!=""&&fromCreateTime.indexOf("/")!=-1){
		 for(var i=0;i<3;i++){
			fromCreateTime=fromCreateTime.replace("/","");
			toCreateTime=toCreateTime.replace("/","");
		 }
		fromCreateTime=fromCreateTime.substring(4,fromCreateTime.length)+fromCreateTime.substring(0,4);
		toCreateTime=toCreateTime.substring(4,toCreateTime.length)+toCreateTime.substring(0,4);
	} 
	if(fromCreateTime!=""&&toCreateTime!=""&fromCreateTime>toCreateTime){ 
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.fromCreateTime" />');//请注意起始时间不能晚于结束时间
		return false;
	}
	
	var i = url.indexOf("?");
	if(url.length-url.indexOf("?")>1000){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.conditionToLong" />');
		return false;
	}
	else {
		var  myForm=document.forms['sysFtearchBuilderForm'];		 		
		myForm.action=url;
		myForm.method='POST';   
		myForm.submit();
		return true;
	}
}
//设置提交的url 添加参数
function setUrlParameters(url){
	var queryString = document.getElementsByName("queryString")[0].value;
	url = Com_SetUrlParameter(url, "queryString",queryString );
	var modelName = document.getElementsByName("modelName")[0].value;
	url = Com_SetUrlParameter(url, "modelName", modelName);
	var category = document.getElementsByName("categoryId")[0].value;
	url = Com_SetUrlParameter(url, "categoryId", category);
	var mimeType = document.getElementsByName("mimeType")[0].value;
	url = Com_SetUrlParameter(url, "mimeType", mimeType);
	var fromCreateTime = document.getElementsByName("fromCreateTime")[0].value;//fromCreateTime
	url = Com_SetUrlParameter(url, "fromCreateTime", fromCreateTime); 
	var toCreateTime = document.getElementsByName("toCreateTime")[0].value; 
	url = Com_SetUrlParameter(url, "toCreateTime", toCreateTime);
	var creator = document.getElementsByName("creator")[0].value; 
	url = Com_SetUrlParameter(url, "creator", creator); 
	url = Com_SetUrlParameter(url, "type", "1"); //1为高级搜索(即多模块搜索） 否则为普通搜索(单模块搜索)  
	if(selAllFlag=="1"){//全选
		url = Com_SetUrlParameter(url, "flag", selAllFlag); //全选标识
	}
	return url;
} 
//全选标识
var selAllFlag="0";
function selectAll(obj){
	var modelName="";		
	var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value; // 范围个数
	 if(obj.checked){
		 for(var i=0;i<entriesDesignCount;i++){
			document.getElementById("element"+i).checked='checked'; 
		}
			selAllFlag="1";
	}
	else {
		for(var i=0;i<entriesDesignCount;i++){
			document.getElementById("element"+i).checked='';
		}   
		selAllFlag="0";
	}  
	selectElement();
}

//单个的选择
function selectElement(element){
	var modelName="";  
	var flag=true;
	var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value;
		//循环勾选
		for(var i=0;i<entriesDesignCount;i++){
			if( document.getElementById("element"+i).checked){
				modelName+=document.getElementById("element"+i).value+";"; 
			}
		}	 
	 	if(modelName!=""){
			modelName=modelName.substring(0,modelName.length-1);
	 	}
	document.getElementsByName("modelName")[0].value= modelName;
}
//更多条件
/*function openMore(obj){
	var modelName="";
	if(obj.checked){
		$("#moreDiv").style.display='';//如果为更多条件则打开 
	}else {
		$("#moreDiv").style.display='none';//隐藏 
	 	modelName="${entriesConfigName}";//全局设置的搜索
	}
	document.getElementsByName("modelName")[0].value= modelName;
}*/
//清空时间
function clearTime(){
	document.getElementsByName("fromCreateTime")[0].value=""; 
	document.getElementsByName("toCreateTime")[0].value=""; 
	
}
//清空创建者
function clearName(){
	document.getElementsByName("creator")[0].value=""; 
}
</script>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>

</head>
<body>
<script type="text/javascript">
Com_IncludeFile("calendar.js|dialog.js|docutil.js", null, "js");
</script>
<html:form action="/sys/ftsearch/searchBuilder.do" >

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="84" align="center" class="bg_top">
		<table width="90%" border="0" cellspacing="0" cellpadding="0">
	      <tr>
	        <td width="25%" align="left"><img src="${KMSS_Parameter_ResPath}style/common/ftsearch/Search_logo.gif" width="102" height="84" /></td>
	        <td width="75%" align="left"><img src="${KMSS_Parameter_ResPath}style/common/ftsearch/Search_top_t.jpg" width="438" height="84" /></td>
	      </tr>
	    </table>
	</td>
  </tr>
</table>
<%--范围个数--%>
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<%--模块名称--%>
<input type="hidden" name="modelName" value='${param.modelName }' class='inputsgl' size='600'/>
<%--类别--%>
<input type="hidden" name="categoryId" value='${param.categoryId }' /> 
<%--文档类型--%>
<input type="hidden" name="mimeType" />


<%--**********空行********* --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="25"></td>
  </tr>
</table>

<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="table_bk_search">
  <tr>
    <td>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td height="15" colspan="7"></td>
      </tr> 
	  <tr>
        <td width="8%" align="right"><bean:message bundle="sys-ftsearch-db" key="ftsearch.advanced.button.search"/>：&nbsp;</td>
        <td colspan="6" align="left">
			<input name="queryString" value="${queryString }" type="text" class="textfield_search1" id="q5" onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch();"/>
		</td>
		<script>
   			$(function() {
			     $("#q5").autocomplete({
			         source: function(request, response) {
			             $.ajax({
			                 url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=searchTip&q="+encodeURI($("#q5").val()),
			                 dataType: "json",
			                 data: request,
			                 success: function(data) {
			                     response(data);
			                 }
			             });
			         }
			     });
			 });
		</script>	 
	  </tr>
      <tr>
        <td height="10" colspan="7"></td>
      </tr>
		  <tr>
        <td height="10" colspan="7"></td>
      </tr>
      <tr>
      	<td width="8%" align="right">
      		<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.Creator"/>
      	</td>
        <td align="left" valign="middle" width="35%">
			<input type='text'  name='creator' class="textfield_search2" style="width: 85%;"/>
			<a href="#" onclick="Dialog_Address(false, 'creatorName','creator', ';',ORG_TYPE_PERSON);"> 
			   <img src="${KMSS_Parameter_ResPath}style/common/ftsearch/Address.png" width="16" height="16" />
			 </a> 
        	<input type='hidden' name='creatorName'>
        </td>
        <td width="1%">
        	<img src="${KMSS_Parameter_ResPath}style/common/ftsearch/line.gif" width="1" height="18"/>
        </td>
        <td width="10%" align="right">
        	<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.CreateTime"/>&nbsp;<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.fromCreateTime"/>&nbsp;&nbsp;
        </td>
         <td width="20%">
         	 <input type='text' name="fromCreateTime" readonly="true" class="textfield_search2" style="width: 85%"/>
         	  <a href="javascript:void(0);" onclick="selectDate('fromCreateTime')" >
	           	<img src="${KMSS_Parameter_ResPath}style/common/ftsearch/Calendar.png" width="16" height="16" />
	          </a>
         </td>
         <td width="1%">
         	 <bean:message bundle="sys-ftsearch-db" key="search.ftsearch.toCreateTime"/>&nbsp;&nbsp;
         </td>
         <td align="left">
         	<input type='text' name="toCreateTime" readonly="true" class="textfield_search2" style="width: 75%"/>
         	 <a href="javascript:void(0);" onclick="selectDate('toCreateTime')" >
	           <img src="${KMSS_Parameter_ResPath}style/common/ftsearch/Calendar.png" width="16" height="16" />
	         </a>&nbsp;
	         <a href="javascript:void(0);" onclick="clearTime()">
	           <img src="${KMSS_Parameter_ResPath}style/common/ftsearch/del_gray.png" width="16" height="16" />
	         </a>
         </td>
      </tr>
      <tr>
        <td height="15" colspan="7"></td>
      </tr>
    </table>
    
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="1" colspan="4" bgcolor="#e0e0e0"></td>
        </tr>
        <tr>
          <td width="90%" height="30" align="left" bgcolor="#fdfdfd">&nbsp;&nbsp;&nbsp;&nbsp;
          	<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.searchRange"/>
          	<input type='hidden' name='_searchMore' onclick="openMore(this)">
          </td>
          <td width="10%" bgcolor="#fdfdfd">&nbsp;&nbsp;
          	<label>
          		<input type="checkbox" name='checkAllElement' onclick="selectAll(this)" >
	  			<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>
		  	</label>
          </td>
        </tr>
        <tr>
         	<td height="1" colspan="4" bgcolor="#e0e0e0"></td>
        </tr>
        <tr>
          <td height="10" colspan="4"></td>
        </tr>
    </table>
      <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
      	<c:forEach items="${entriesDesign}" var="element" varStatus="status">
			<c:choose>
				<c:when test="${status.first}">
					<tr>
					<td  style="border: 0" width='25%'>
						<label>
							<input id='element${status.index}' type="checkbox"
							 onclick="selectElement(this)"  value='${element['modelName']}'> 
							${element['title']} 
						</label>
					 </td>
				</c:when>
				<c:otherwise>
					<td width=25% style="border: 0">
						<label>
							<input id='element${status.index}' type="checkbox"
							 onclick="selectElement(this)" value='${element['modelName']}'> 
							${element['title']} 
						</label>
					</td>
				</c:otherwise>
			</c:choose>
			<c:if test="${(status.index + 1) % 4 eq 0}">
				</tr>
				<c:if test="${entriesDesignCount % 4 ne 0}">
				<tr>
				</c:if>	 				
			</c:if>
		 </c:forEach>			
		<c:if test="${entriesDesignCount % 4 ne 0}">
			<c:if test="${entriesDesignCount%  4  eq 1}">
				<td width=25% style="border: 0"></td>
				<td width=25% style="border: 0" ></td> 
			</c:if>  
			<c:if test="${entriesDesignCount%  4  ne 1}">
				<td width=25% style="border: 0"></td> 
			</c:if>
			</tr>
		</c:if>
		 </td> 
		</tr> 	
		<tr>
          <td height="10" colspan="5"></td>
        </tr>
        <tr>
          <td height="1" colspan="5" bgcolor="#e0e0e0"></td>
        </tr>
        <tr>
          <td height="60" colspan="5" align="center" valign="middle">
          	<a class="btn_gray_input_b m_l20" href="#">
          		<span>
          			<input type="button" name="button" id="button" value="<bean:message bundle="sys-ftsearch-db" key="ftsearch.advanced.button.search"/>" onclick="return CommitSearch();"/>
          		</span>
          	</a>
          </td>
        </tr>
    </table></td>
  </tr>
</table>
</html:form>
</body>
</html>