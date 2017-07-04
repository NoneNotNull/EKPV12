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
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
</script>
<script type="text/javascript">
Com_SetWindowTitle('<bean:message bundle="sys-ftsearch-db" key="search.moduleName" />');
Com_IncludeFile("ftsearch_advanced.css", "style/"+Com_Parameter.Style+"/relation/"); 


//是否确定
function confirmSearch(){
	var sea = confirm('<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.noConfigSet" />');
	return sea;
}
//搜索提交
function CommitSearch(){	 	
	//var url = Com_CopyParameter("<c:url value="/sys/ftsearch/searchBuilder.do?method=search"/>");
	var url ='<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search"/>';	 
	var target ="";
	url = Com_SetUrlParameter(url, "modelName", null);
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
	var modelName=document.getElementsByName("modelName")[0].value ;
	var _searchMore=document.getElementsByName("_searchMore")[0] ;
	if( _searchMore.checked&&modelName==""){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.modelNameTitle" />');//请选择应用模块 
		return false;
	}
	if(!_searchMore.checked&&"${entriesConfigCount}"=="0"&&!confirmSearch()){
		//没有设置是否确定搜索
		return false;
	}

	
	var fromCreateTime =document.getElementById("fromCreateTime").value; 
	
	var toCreateTime =document.getElementById("toCreateTime").value;  
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
		alert('<bean:message bundle="sys-search" key="search.conditionToLong" />');
		return false;
	}
	else {
		var   myForm=document.forms['sysFtearchBuilderForm'];		 		
		myForm.action=url;
		myForm.method='POST';   
		myForm.submit();
		return true;
	}
}
//设置提交的url 添加参数
function setUrlParameters(url){
	var queryString = document.getElementById("queryString").value;
	url = Com_SetUrlParameter(url, "queryString",queryString );
	var modelName = document.getElementById("modelName").value;
	url = Com_SetUrlParameter(url, "modelName", modelName);
	var category = document.getElementById("category").value;
	url = Com_SetUrlParameter(url, "category", category);
	var mimeType = document.getElementById("mimeType").value;
	url = Com_SetUrlParameter(url, "mimeType", mimeType);
	var fromCreateTime = document.getElementById("fromCreateTime").value;//fromCreateTime
	url = Com_SetUrlParameter(url, "fromCreateTime", fromCreateTime); 
	var toCreateTime = document.getElementById("toCreateTime").value; 
	url = Com_SetUrlParameter(url, "toCreateTime", toCreateTime);
	url = Com_SetUrlParameter(url, "type", "1"); //1为高级搜索 否则为普通搜索
	var creator = document.getElementById("creator").value; 
	url = Com_SetUrlParameter(url, "creator", creator); 
	return url;
}
//全选
function selectAll(obj){
	var modelName="";		
	var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value; // 范围个数
	 if(obj.checked){
	 for(var i=0;i<entriesDesignCount;i++){
		document.getElementsByName("element"+i)[0].checked='checked';
		modelName+=document.getElementsByName("element"+i)[0].value+";";
	} 
		modelName=modelName.substring(0,modelName.length-1);
	
	}
	else {
		for(var i=0;i<entriesDesignCount;i++){
			document.getElementsByName("element"+i)[0].checked='';
		}  
		modelName="";
	}  
	 document.getElementsByName("modelName")[0].value= modelName;
}

//单个的选择
function selectElement(element){
	var modelName="";  
	var checkAll=document.getElementById("checkBoxAll");
	var flag=true;
	var entriesDesignCount=document.getElementsByName("entriesDesignCount")[0].value;
	if(!element.checked){ //如果不勾选
		checkAll.value='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>';
		document.getElementsByName("checkAllElement")[0].checked='';
		//循环勾选
		for(var i=0;i<entriesDesignCount;i++){
			if( document.getElementsByName("element"+i)[0].checked){
				modelName+=document.getElementsByName("element"+i)[0].value+";"; 
			}
		}
			 
	}
	else if(element.checked){			
		for(var i=0;i<entriesDesignCount;i++){
			if(!document.getElementsByName("element"+i)[0].checked){
				flag=false;
			}
			else {
				modelName+=document.getElementsByName("element"+i)[0].value+";";  
			} 
		}
		if(flag){ 
			checkAll.value='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.disSelect"/>';
			document.getElementsByName("checkAllElement")[0].checked='checked';
		}  
	} 
		modelName=modelName.substring(0,modelName.length-1);
		document.getElementsByName("modelName")[0].value= modelName;
}

//更多条件
function openMore(obj){
	var modelName="";
	if(obj.checked){
		$("moreDiv").style.display='';//如果为更多条件则打开 
	     //checkbox选择的搜索
	}
	else {
	 $("moreDiv").style.display='none';//隐藏 
	  modelName="${entriesConfigName}";//全局设置的搜索
	}
	 document.getElementsByName("modelName")[0].value= modelName;

}
//返回对象
function $(id){
		return document.getElementById(id);
} 
//清空时间
function clearTime(){
	document.getElementById("fromCreateTime").value=""; 
	document.getElementById("toCreateTime").value=""; 
	
}
//清空创建者
function clearName(){
	document.getElementById("creator").value=""; 
}


</script>
</head>
<body>
<script type="text/javascript">
Com_IncludeFile("calendar.js|dialog.js|docutil.js", null, "js");
</script>

<html:form action="/sys/ftsearch/searchBuilder.do" >
<center>
<DIV id='mainBody'>
<h3><bean:message bundle="sys-relation" key="sysRelationEntry.fdType1" /></h3>
<%--范围个数--%>
<input type='hidden'  name ='entriesDesignCount'  value='${entriesDesignCount}' />
<%--模块名称--%>
<input type="hidden" name="modelName" value='${entriesConfigName }' class='inputsgl' size='600'/>
<%--类别--%>
<input type="hidden" name="category" /> 
<%--文档类型--%>
<input type="hidden" name="mimeType" />
<%--创建者--%>  
<%--顶部--%>
<DIV class='wi9'>
</DIV>
<div class="fm1">
	<bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.firstStep" />
	<div class="l1"></div>
</div>
<DIV  class="ftc wi6">
<%--搜索框--%>
<DIV  id="tabs">
	<input name="queryString" style="width:98%" class="searchInput inputsgl"   value='${queryString}' 
	 	   onkeydown="if (event.keyCode == 13 && this.value !='') CommitSearch();" >
</DIV>
<%--搜索按钮--%>
<DIV  id="tabs" style="float:right;width:9%; margin-top: 28px" >
	<a href="#" title="" onclick="return CommitSearch();" ><span class='fz13'>
	<bean:message bundle='sys-ftsearch-db' key='search.ftsearch.button'/></span></a> 
</DIV>
</DIV>
  
<DIV style="width: 59%;margin-bottom: 10px;margin-top: -20px;margin-left: -60px;">
<%--更多条件--%>
	<DIV style="float: left;margin-left: 0px">
		<label>
		<input type='checkbox' name='_searchMore' onclick="openMore(this)">
		<bean:message bundle='sys-ftsearch-db' key='search.ftsearch.moreCondition'/>
		</label>
	</DIV>
	<DIV style="float:left;text-align: left;width: 80%;margin-left: 0px;display: none" >
	<DIV id='more' style="width: 3%;float: left;margin-top: 3px;"> 
		<img border="0" src="${KMSS_Parameter_StylePath}ftsearch/file.jpg"  /> 
	</DIV>
	<DIV  id='more' style="width: 10%;float: left;margin-top:3px;  ">
		<span><bean:message bundle='sys-ftsearch-db' key='search.ftsearch.searchRange'/></span>
	</DIV>
	<DIV id='more' style="width: 87%;float:right; "> 
	 <table style="width: 80%">
	 <tr  > 
	 	<td nowrap> 
	 	<c:if test="${entriesConfigCount eq '0'}">
	 		<span><bean:message bundle='sys-ftsearch-db' key='search.ftsearch.noConfig'/></span>
	 	</c:if>
	 	<c:if test="${entriesConfigCount<4}">
	 	<c:forEach items="${entriesConfig}" var="element" varStatus="status">
	 		${element['title']}
	 	</c:forEach>
	 	</c:if>
	 	<%---有箭头--%>
	 	<c:if test="${entriesConfigCount>4}">
	 	<a  href='#'><img border="0" src="${KMSS_Parameter_StylePath}ftsearch/al.jpg"  /></a> 
	 	<c:forEach items="${entriesConfig}" var="element" varStatus="status">
	 		${element['title']}
	 	</c:forEach> 
	 	<a  href='#'><img border="0" src="${KMSS_Parameter_StylePath}ftsearch/ar.jpg"  /></a>  
	 	</c:if>
	 	
	 	</td>  
	 </tr>
	 <tr><td></td></tr>
	 </table>
	</DIV>		
</DIV>	

</DIV>
<%--更多条件--%>
<DIV style="width: 59%;margin-top: 4px;display: none;margin-left: -60px" id='moreDiv' >
	<DIV>
		 <table class="tb_normal" width="100%">
			<tr> 
			<%--创建者--%>
				<td width="15%" style="height: 40" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.Creator"/></td>
				<td style="height: 40">
					<input type='hidden' name='creatorName'>
					<input type='text'   name='creator' class="inputsgl" style="width:80%"  />
					 <a href="#" onclick="Dialog_Address(more, 'creatorName','creator', ';',ORG_TYPE_PERSON);"> 
						<bean:message key="dialog.selectOrg" /></a> 
					<a href=# onclick="clearName()"><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.clearTime"/></a>
				</td>
			</tr>
			<tr>
			<%--创建时间--%>
				<td width="15%" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.CreateTime"/></td>
				<td> 
				<div>
					<table border="0" width="400">
						<tr>
							<td style="text-align: left; border: none;">
								<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.fromCreateTime"/>
								<input type='text' name="fromCreateTime" readonly="true" class="inputsgl" style="width:100px;"/>
								<nobr>
								<a href="javascript:void(0);" onclick="selectDate('fromCreateTime')" ><bean:message key="dialog.selectTime" /></a>
								</nobr>
								
								<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.toCreateTime"/>
								<input type='text' name="toCreateTime" readonly="true" class="inputsgl" style="width:100px;" />
								<nobr>
								<a href="javascript:void(0);" onclick="selectDate('toCreateTime')" ><bean:message key="dialog.selectTime" /></a>
								</nobr>
								<nobr>
								<a href="javascript:void(0);" onclick="clearTime()"><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.clearTime"/></a>
						   		</nobr>
						   	</td>
						</tr>
					</table>
				</div> 
				</td>
			</tr>
			<tr> 
			<td colspan="2"><%--搜索范围---%>
				<div style="margin-top: 5px">
					<div style="float: left;margin-left: 6px;margin-top: 5px"><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.searchRange"/></div>
					<div style="float: right;margin-right: 5px"  > 
					<input type="checkbox" name='checkAllElement' onclick="selectAll(this)" >
					 <span id='checkBoxAll' value='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>' style="color: red">
	  				<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/></span>
	  				</div>
	  				<br><br><%--搜索范围开始--%> 
	  				<div style="width: 100%;text-align: center;">
	  					<table style="width:97%" class="tb_dotted">
					  		<c:forEach items="${entriesDesign}" var="element" varStatus="status">
							<c:choose>
								<c:when test="${status.first}">
									<tr>
									<td  style="border: 0" width='25%'>
									<input id='element${status.index}' type="checkbox" } 
									 onclick="selectElement(this)"  value='${element['modelName']}'> 
									${element['title']} 
									 </td>
								</c:when>
								<c:otherwise>
									<td width=25% style="border: 0">
									<input id='element${status.index}' type="checkbox"} 
									 onclick="selectElement(this)" value='${element['modelName']}'> 
									${element['title']} 
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
						 	</div> 
						 </td> 
						 </tr> 		
	  					</table><%--搜索范围结束--%> 
	  					<br>
	  				</div>
				</div>
			</td>
			</tr> 
		</table><%--创建者创建时间搜索范围结束--%> 
	</DIV>
</DIV>
<DIV class="l2" style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#ffffff,endColorStr=#DBE8FA)">
</DIV>
</DIV>
</center>
</html:form>
</body>
</html>