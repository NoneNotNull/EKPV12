<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>	
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="com.sunbor.web.tag.Page" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.ftsearch.config.LksField,
	com.landray.kmss.sys.ftsearch.search.LksHit,
	java.util.Map,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.sys.config.dict.SysDataDict,
	com.landray.kmss.sys.relation.util.SysRelationUtil" %>
<script type="text/javascript">
Com_IncludeFile("ftsearch_result.css", "style/"+Com_Parameter.Style+"/relation/");
Com_IncludeFile("optbar.js|list.js");
Com_SetWindowTitle('<bean:message bundle="sys-relation" key="sysRelationMain.fdOtherUrl.select" />');	
function CommitSearch(fname){ 
	var url ="<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search"/>";
	
	var target = "${param.s_target}";
	if(document.getElementsByName("modelName")[0].value == ""){
		url = Com_SetUrlParameter(url, "modelName", "${entriesConfigName }"); 
	}else{
		url = Com_SetUrlParameter(url, "modelName", document.getElementsByName("modelName")[0].value); 
	}
	
	url = Com_SetUrlParameter(url, "s_target", null);
	url = Com_SetUrlParameter(url, "queryString", document.getElementsByName("queryString")[0].value);
	if(url==null){
		return;
	}
	var queryString=document.getElementsByName("queryString")[0] ;
	if( queryString.value==''){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.queryString" />');//请填写搜索内容
		queryString.focus();
		return false;
	}
	var i = url.indexOf("?");
	if(url.length-url.indexOf("?")>1000)
	{
		alert('<bean:message bundle="sys-search" key="search.conditionToLong" />');
	}
	else{
		if(target=="") {
			
			Com_OpenWindow(url,"_self");
		}
		else {
			Com_OpenWindow(url, target);
		}
	}
}
//旧版高级搜索
function advancedSearch(){
	if(document.getElementById("modelName")){
		Com_OpenWindow('<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do" />?method=advancedSearchPage&modelName='+document.getElementById("modelName").value,"_self");
	}else{
		Com_OpenWindow('<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do" />?method=advancedSearchPage',"_self");
	}	
}
//高级搜索
function advancedSearchs(){ 
	var queryString=encodeURIComponent(document.getElementById("queryString").value);
	if(document.getElementById("modelName")){
		Com_OpenWindow('<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do" />?method=sysFtsearchAdvanced&modelName='+document.getElementById("modelName").value+"&queryString="+queryString,"_self");
		
	}else{
		Com_OpenWindow('<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do" />?method=sysFtsearchAdvanced&queryString='+document.getElementById("queryString").value,"_self");
	}	 
}


var returnValueArrs = {};
function createOtherUtlArr(){
	return {fdSubjet:"",fdLinkUrl:"",fdCreator:"",fdCreateTime:""};
}
//点击确定
function doOK(){
	var isChecked = false;
	var otherUrlCheckBox = document.getElementsByName("otherUrlCheckBox");
	var hidden_subject=document.getElementsByName("hidden_subject");
	var hidden_linkUrl=document.getElementsByName("hidden_linkUrl");
	var hidden_creator=document.getElementsByName("hidden_creator");
	var hidden_createTime=document.getElementsByName("hidden_createTime");  
	var otherUrlArr = returnValueArrs[hidden_linkUrl];
	if(typeof otherUrlArr =="undefined")otherUrlArr = createOtherUtlArr();	
	for(var i = 0; i< otherUrlCheckBox.length; i++){
		if(otherUrlCheckBox[i].checked){
			var otherUrlArr = returnValueArrs[hidden_linkUrl[i].value];
		 	if(typeof otherUrlArr =="undefined")otherUrlArr = createOtherUtlArr();	
		 	otherUrlArr.fdSubjet = hidden_subject[i].value;
		 	otherUrlArr.fdLinkUrl = hidden_linkUrl[i].value;
		 	otherUrlArr.fdCreator = hidden_creator[i].value;
		 	otherUrlArr.fdCreateTime = hidden_createTime[i].value;
		 	returnValueArrs[otherUrlArr.fdLinkUrl] = otherUrlArr;
			isChecked = true; 			 
		}
	}
	if(!isChecked){
		alert("<bean:message key='dialog.requiredSelect' />");
		return;
	} 
	window.returnValue = returnValueArrs;
	window.close();
} 

//全选checkbox
function doSelectAll(num){
	var checkBoxAll=document.getElementsByName("checkboxAll");
	var checkSpan=document.getElementById("checkSpan_"+num);
	var otherUrlCheckBox = document.getElementsByName("otherUrlCheckBox");
	 if(checkSpan.value=="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>"){
		for(var i=0;i<otherUrlCheckBox.length;i++){
			otherUrlCheckBox[i].checked='checked';
		} 		 
		document.getElementById("checkSpan_2").value="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.disSelect'/>";
		checkBoxAll[0].checked='checked';
	 }
	 else {
		 for(var i=0;i<otherUrlCheckBox.length;i++){
			otherUrlCheckBox[i].checked='';
		} 	 
		document.getElementById("checkSpan_2").value="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>"; 
		checkBoxAll[0].checked='';
	}
}
//单选checkbox
function doSelectElement(element){ 
	var flag=true;  
	if(!element.checked){  
		flag=false; 
	}
	else if(element.checked){
		var otherUrlCheckBox = document.getElementsByName("otherUrlCheckBox");	 
		for(var i=0;i<otherUrlCheckBox.length;i++){
			if(!otherUrlCheckBox[i].checked){
				flag=false;
			}
		} 
	} 
	var checkBoxAll=document.getElementsByName("checkboxAll"); 
	if(flag){//全选中
		document.getElementById("checkSpan_2").value="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.disSelect'/>";
		checkBoxAll[0].checked='checked';
	}
	else {
		document.getElementById("checkSpan_2").value="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>"; 
		checkBoxAll[0].checked='';
    }
}
</script> 
<%---获取搜索信息--%>
<% Page queryPage = (Page)request.getAttribute("queryPage");%>
<DIV id='mainBody'>
<h3><bean:message bundle="sys-relation" key="sysRelationEntry.fdType1" /></h3>
<DIV class='wi9'>
</DIV>
<div class="fm1">
	<bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.secordStep" />
	<div class="l1"></div>
</div>
<div style="width: 100%;margin: 0 45px 0 45px;">
 <DIV class='bt' > 
		<c:if test="${not empty queryPage}">
			 <table   width="100%">
			  <tr>
			  <td width="3%">
			  <div class='ml10'>
			  <IMG  src="${KMSS_Parameter_StylePath}ftsearch/dot_orange.jpg"/></div>
			  </td> 
			  <td width="28%" style="">
			  <span style="color: blue"><bean:message bundle="sys-ftsearch-db" key="search.resultcount" /></span>
			  <span style="color: red"><b><%=queryPage.getTotalrows()%></b></span>
			  <span style="color: blue"><bean:message bundle="sys-ftsearch-db" key="search.filecount" /></span> </td> 
			  <td width="70%" style="text-align: right">	
			  <% if (queryPage.getTotalrows()>1){ %>
			  <%--分页---%> 		
			  <div class="pages page_margin" >
				<span class="postPages">
					<sunbor:page name="queryPage" pagenoText="pagenoText1" pageListSize="10" pageListSplit="">
						<sunbor:leftPaging><b>&lt;<bean:message key="page.thePrev"/></b></sunbor:leftPaging>
						{11}
						<sunbor:rightPaging><b><bean:message key="page.theNext"/>&gt;</b></sunbor:rightPaging>
						<% if (((Page)request.getAttribute("queryPage")).getTotal() > 1){ %>
							<span style="margin-top:-1px;height: 20px;">{9}</span>
							<img src="${KMSS_Parameter_StylePath}icons/go.gif" border=0 title="<bean:message key="page.changeTo"/>"
							 	onclick="{10}" style="cursor:pointer">
						<% } %>
					</sunbor:page>
				</span> 
			</div> 
			<% }%>
			</td>
			</tr>
			</table>  
		</c:if> 
 </DIV> 
 <%--如果查询无数据--%>
<% if (queryPage.getTotalrows()==0){ %>	 
	<div style="height: 50px"></div>
	<c:if test="${ not empty mapSet['queryString']}" >
	<div style="margin-left: 40px;width: 50%">
	<div style="width:10%;float: left;"><img alt="" src="${KMSS_Parameter_StylePath}ftsearch/alert.jpg"></div> 
	<div  style="width: 90%;float: left;margin-top: 10px;font-size: 16px">
	<b><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.sorry" /><span style="color: red">${mapSet['queryString']}</span><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.about" /></b></div>
	</div>
	 <div style="margin-left: 40px;width: 50%">
	 <div style="width:10%;float: left;"></div>
	 <div  style="width: 90%;float: left;margin-top: 10px;font-size: 16px">
	 <b><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.advice" /></b> 
	 <ul>
	 <li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.checkWrong" /></li>
	 <li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.deleteSome" /></li>
	 </ul> 
	 </div> 
	</div>
	</c:if>
	<div style="height: 70px"></div> 
<% }

else  
{ %>
<%--如果查询有数据--%>
	<div style="width: 100%" class='content_margin'>
	 
	<%--标题 时间 创建者 所属模块--%>
	<%for(int i=0;i<queryPage.getList().size();i++){
		LksHit lksHit = (LksHit)queryPage.getList().get(i);
		Map lksFieldsMap = lksHit.getLksFieldsMap();
		LksField link = (LksField)lksFieldsMap.get("linkStr");
		LksField title = (LksField)lksFieldsMap.get("title");
		LksField subject = (LksField)lksFieldsMap.get("subject");
		LksField content = (LksField)lksFieldsMap.get("content");
		LksField fileName = (LksField)lksFieldsMap.get("fileName");
		LksField fullText = (LksField)lksFieldsMap.get("fullText");

		LksField keyword = (LksField)lksFieldsMap.get("keyword");
		LksField modelName = (LksField)lksFieldsMap.get("modelName");
		LksField category= (LksField)lksFieldsMap.get("category");
		LksField creator = (LksField)lksFieldsMap.get("creator");
		LksField createTime = (LksField)lksFieldsMap.get("createTime");
		if (link != null) {
			request.setAttribute("linkUrl",link.getValue());
		} else {
			request.setAttribute("linkUrl","");
		}
		
		String otherUrlSubjet = subject==null?"":subject.getValue();
		if(StringUtil.isNull(otherUrlSubjet)){otherUrlSubjet=title==null?"":title.getValue();}
		if(StringUtil.isNull(otherUrlSubjet)){otherUrlSubjet=fileName==null?"":fileName.getValue();}
		//主题中加了样式，如：<strong class="lksHit">主题</strong>
		//如果含有样式，去掉样式
		if(StringUtil.isNotNull(otherUrlSubjet)){
			otherUrlSubjet = SysRelationUtil.replaceStrongStyle(otherUrlSubjet);
		}
	%> 
	 <div > 	 
	 	<input type="checkBox" name="otherUrlCheckBox" onclick="doSelectElement(this)" >
		<input type='hidden' name='hidden_subject' value='<%=otherUrlSubjet%>'/>
		<input type='hidden' name='hidden_linkUrl' value='<%=link==null?"":link.getValue() %>'/>
		<input type='hidden' name='hidden_creator' value='<%=creator==null?"":creator.getValue() %>'/>
		<input type='hidden' name='hidden_createTime' value='<%=createTime==null?"":createTime.getValue()%>'/>	
			
		<a target='_blank' href='<c:url value="${linkUrl}"/>'>
		<span class="postdesc fz16">		
		<%=subject==null?"":subject.getValue()%><%=title==null?"":title.getValue()%><%=fileName==null?"":fileName.getValue()%></span></a>
		&nbsp;&nbsp; 
		<%if(creator!=null) {%>
		<span  class='font_blue fz13' ><%---创建者--%>
		<bean:message bundle="sys-ftsearch-db" key="search.search.creators" />
		<%out.println(creator.getValue());}%> 
		</span>
		 &nbsp;<%---时间格式--%>
		<%if(createTime!=null){
		%>			
		<span  class='font_blue fz13'><bean:message bundle="sys-ftsearch-db" key="search.search.createDates" />	
		<% 	
			out.println(createTime.getValue());
		%>
		</span>
		 &nbsp; &nbsp;
		<%} 
		%>
		
		<span class='font_blue fz13' >
		<bean:message bundle="sys-ftsearch-db" key="search.search.modelNames" />
		<%if (modelName != null){out.println(ResourceUtil.getString(SysDataDict.getInstance().getModel(SysRelationUtil.replaceStrongStyle(modelName.getValue())).getMessageKey()));}%>
		</span> 
	</div>

	<%if(content!=null){%>
	<!--
	<div class='font_blue fz13'>
		<%//=content.getValue()%>
	</div>
	-->
	<%}%>
	<%if(fullText!=null){%>
	<!--
	<div class='font_blue fz13'>
		<%//=fullText.getValue()%>
	</div>
	-->
	<%}%>

	<%--链接
	<div class='linkUrl'  class="mt3" >
		<a target="_blank" href='<c:url value="${linkUrl}"/>'><span style="font-size: 16px">http://${mapSet['host']}${KMSS_Parameter_ContextPath}${linkValue}</span></a>
	</div> --%>
	<p></p>
	<%}%>
	</div>
<% } %>
<%---全选---%>
<% if (queryPage.getTotalrows()!=0){ %>	
	<div style="width: 100%" class='content_margin' style="margin-top: -5px;">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	 	<tr>
		 	<td><input type="checkbox" name='checkboxAll' onclick="doSelectAll('2')">
			<span id='checkSpan_2'   
			value='<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>' style="color: red" >
				<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/></span>
			</td>
			<td width="70%" style="padding-right: 5px">
				<%--分页--%>
				<% if (queryPage.getTotalrows()>1){ %>
				  <%--分页---%> 		
				  <div class="pages page_margin">
					<span class="postPages">
						<sunbor:page name="queryPage" pagenoText="pagenoText1" pageListSize="10" pageListSplit="">
							<sunbor:leftPaging><b>&lt;<bean:message key="page.thePrev"/></b></sunbor:leftPaging>
							{11}
							<sunbor:rightPaging><b><bean:message key="page.theNext"/>&gt;</b></sunbor:rightPaging>
							<% if (((Page)request.getAttribute("queryPage")).getTotal() > 1){ %>
								<span style="margin-top:-1px;height: 20px;">{9}</span>
								<img src="${KMSS_Parameter_StylePath}icons/go.gif" border=0 title="<bean:message key="page.changeTo"/>"
								 	onclick="{10}" style="cursor:pointer">
							<% } %>
						</sunbor:page>
					</span> 
				</div> 
				<% }%>
			</td>
		</tr> 
	</table> 
	</div>
<%}%>
<DIV class='f12 stripe' ></DIV>
<%--范围--%>
<DIV class="range" >
<DIV class="range_out" style="margin-top: 2px" >
	<bean:message bundle="sys-ftsearch-db" key="search.range" />
</DIV>
<DIV class="range_inner">
<table width="80%">
	<c:if test="${titleList == null}">
		<tr>
			<td>
				<bean:message bundle="sys-ftsearch-db" key="search.moduleName.none"/>
			</td>
		</tr>
	</c:if>
	<c:if test="${titleList != null}">
		<c:forEach items="${titleList}" var="element" varStatus="status">
			<c:choose>
				<c:when test="${status.first}">
					<tr>
						<td width=20% >
						 	${element['title']}
					 	</td>
				</c:when>
				<c:otherwise>
						<td width=20%  > 
							${element['title']}
						</td>
				</c:otherwise>
			</c:choose>
			<c:if test="${(status.index + 1) % 5 eq 0}">
				</tr>
				<c:if test="${titleListSize % 5 ne 0}">
				<tr>
				</c:if>					
			</c:if>
		</c:forEach>
		<c:if test="${titleListSize % 5 ne 0}">
				<c:if test="${titleListSize%  5  eq 1}">
					<td width=25%></td>
					<td width=25%></td> 
				</c:if>  
				<c:if test="${titleListSize%  5  ne 1}">
					<td width=25%></td> 
				</c:if>
				</tr>
		</c:if>
	</c:if>
</table> 
<br>
<center>
<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="doOK();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="btnopt" value="<bean:message key="button.back"/>" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'sys/relation/otherurl/ftsearch/searchBuilder.do?method=sysFtsearchAdvanced', '_self');" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" class="btnopt" value="<bean:message key="button.close" />" onclick="Com_CloseWindow();" />
</center>
</DIV>
</DIV>
</div>
<DIV class="l2" style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#ffffff,endColorStr=#DBE8FA)">
</DIV>
</DIV>
<%@ include file="/resource/jsp/edit_down.jsp"%>