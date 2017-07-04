<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript">

	function addResult(id,name){
		if(parent._Add_Address_dialog_data)
			parent._Add_Address_dialog_data(id,name);
	}
	
	function searchCommit(){
		var currentOrg = document.getElementsByName("fd_keyword");
		if(currentOrg!=null && currentOrg[0].value==""){
			alert('<bean:message key="pda.address.search.keyword.isnull" bundle="sys-organization-pda"/>');
			return false;
		}
		Com_Submit(document.forms[0], "search");
	}
	
	function resizeIframe(){
		var addHeight=getObjectHeight(document.body);
		var parHeight=getObjectHeight(parent.document.body);
		var iframeHeight=addHeight>parHeight?addHeight:parHeight;
		parent.document.getElementById("addressIframe").height=iframeHeight;
		parent.scrollTo(0, 1);
	}
	function changeSummit(obj,isAdd){
		if(isAdd==true){
			obj.style.color="black";
		}
		var optVar=document.getElementById("div_deleteOpt");
		if(optVar!=null){
			if(obj.value.trim()==""){
				optVar.style.display="none";
			}else{
				optVar.style.display="block";
			}
		}
	}
	function clear_input(inpName){
		var inputObj=document.getElementsByName(inpName)[0];
		inputObj.value="";
		changeSummit(inputObj,false);
		inputObj.focus();
	}
	function getObjectHeight(obj){
		var clientHeight=obj.offsetHeight;
		if(clientHeight==null || clientHeight==0)
			clientHeight=obj.clientHeight?obj.clientHeight:clientHeight;
		return clientHeight;
	}
	
	Com_AddEventListener(window,"load",resizeIframe);
</script>
</head>
<body>
<form action="<c:url value="/sys/organization/pda/address.do?method=search&isAppflag=${param.isAppflag}"/>" method="post">
	<input type="hidden" name="fd_orgtype" value="${fd_orgtype}" />
	
<div class="searchDiv">
	<input name="fd_keyword" class="searchInput" type="search" value="${fd_keyword}" 
		onfocus="changeSummit(this,true);" onkeydown="changeSummit(this,true);" 
		onkeypress="changeSummit(this,true);" onkeyup="changeSummit(this,true);"/>
	<div id="div_deleteOpt" class="div_deleteOpt" onclick="clear_input('fd_keyword');"></div>
</div>

<div class="div_banner">
	<div class="div_keywordInfo">
		<label>
		<bean:message key="pda.address.search.keyword" bundle="sys-organization-pda"/>
		<c:choose >
			<c:when test="${fn:length(fd_keyword)>7}">${fn:substring(fd_keyword, 0,7)}...</c:when>
			<c:otherwise>${fd_keyword}</c:otherwise>
		</c:choose>
		</label>
	</div>
	<div class="div_close" onclick="Com_Submit(document.forms[0], 'into');">&nbsp;</div>
</div>
<div class="addressDiv">
	<c:if test="${searchList!=null && fn:length(searchList)>0 }">
		<ul class="addressList">
			<c:forEach items="${searchList}" var="org">
				<li>
					<div onclick="addResult('${org.id}','${org.name}');" class="itemData">
						<div class="${classVar}"></div> 
						${org.name}<c:if test="${org.summary!=null && org.summary!=''}">&nbsp;&nbsp;|&nbsp;&nbsp;${org.summary}</c:if>
						<div class="addItemData"></div>
					</div>
				</li>
			</c:forEach>
		</ul>
	</c:if>
	<c:if test="${searchList==null || fn:length(searchList)<=0 }">
		<div class="lab_errorinfo"><bean:message key="pda.address.search.noResult" bundle="sys-organization-pda"/></div>
	</c:if>
	<c:if test="${limit=='1'}">
		<div class="lab_errorinfo"><bean:message key="pda.address.search.limit" bundle="sys-organization-pda"/></div>
	</c:if>
</div>

</form>
</body>
</html>