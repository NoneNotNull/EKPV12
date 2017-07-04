<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript">
	var isSearch=false;
	var isIn=false;
	function onSlectChange(selectObj) {
		var optVar = selectObj.options[selectObj.selectedIndex].value;
		submitForm("into", optVar);
	}
	function jumpToUp(){
		 var parentSelect = document.getElementsByName("fd_parent")[0];
		 var parentOpt = parentSelect.options[parentSelect.selectedIndex + 1];
		 if(parentOpt!=null){
			 submitForm("into", parentOpt.value);
		 }
	}
	function submitForm(method, currentId) {
		var currentOrg = document.getElementsByName("fd_current");
		if (currentOrg != null)
			currentOrg[0].value = currentId;
		Com_Submit(document.forms[0], method);
	}
	function addResult(id,name){
		if(parent._Add_Address_dialog_data)
			parent._Add_Address_dialog_data(id,name);
	}
	function closeAddress(){
		if(parent._Hide_Address_dialog)
			parent._Hide_Address_dialog();
	}
	function searchCommit(){
		var currentOrg = document.getElementsByName("fd_keyword");
		if(currentOrg!=null && currentOrg[0].value==""){
			alert("<bean:message key="pda.address.search.keyword.isnull" bundle="sys-organization-pda"/>");
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
	function chgActionUrl(){
		var currentOrg = document.getElementsByName("fd_keyword");
		if(isSearch==true && currentOrg!=null && currentOrg[0].value!=""){
			var url = Com_CopyParameter(document.forms[0].action);
			url = Com_SetUrlParameter(url, "method", "search");
			document.forms[0].action = url;
		}
	}
	function changeSummit(obj,isAdd){
		if(isAdd==true){
			isSearch=true;
			if(isIn==false)
				obj.value="";
			isIn=true;
			obj.style.color="black";
			Com_AddEventListener(document.forms[0],"submit",chgActionUrl);
		}else{
			isSearch=false;
			Com_RemoveEventListener(document.forms[0],"submit",chgActionUrl);
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
<form action="<c:url value="/sys/organization/pda/address.do?method=into&isAppflag=${param.isAppflag}"/>" method="post">
<input type="hidden" name="fd_orgtype" value="${fd_orgtype}" />
<input type="hidden" name="fd_current" value="${fd_current}" />

<div class="searchDiv">
	<input name="fd_keyword" class="searchInput" type="search" 
		value='<bean:message key="pda.address.search.input.keyword" bundle="sys-organization-pda"/>' 
		onfocus="changeSummit(this,true);" onkeydown="changeSummit(this,true);" 
		onkeypress="changeSummit(this,true);" onkeyup="changeSummit(this,true);"
		onblur="changeSummit(this,false);"/>
	<div id="div_deleteOpt" class="div_deleteOpt" onclick="clear_input('fd_keyword');"></div>
</div>

<div class="div_banner">
	<div class="div_return" onclick="closeAddress();">
		<div><bean:message key="pda.address.cancel" bundle="sys-organization-pda"/></div>
		<div></div>
	</div>
	<div class="div_parent" id="parentDiv">
		<c:if test="${parentList!=null and fn:length(parentList)>0}"> 
			<nobr><label><bean:message key="pda.address.goto" bundle="sys-organization-pda"/></label>
			<select	name="fd_parent" onchange="onSlectChange(this);" style="max-width: 40%">
			<c:forEach var="parent" items="${parentList}">
				<option value="${parent['id']}">${parent['name']}</option>
			</c:forEach>
			</select>
			</nobr>
		</c:if>
	</div>
	<c:if test="${fd_current!='' && fn:length(parentList)>1}">
		<div class="div_back" onclick="jumpToUp();"></div>
	</c:if>
</div>
<div class="addressDiv">
	<c:if test="${orgList!=null and fn:length(orgList)>0}">
		<ul class="addressList">
			<c:forEach var="org" items="${orgList}">
				<li>
					<div class="itemData">
						<c:set var="classVar" value="manItemData"/>
						<c:choose>
							<c:when test="${org.canExpand=='2'}">
								<c:set var="classVar" value="elmItemData"/>
							</c:when>
							<c:when test="${org.canExpand=='1'}">
								<c:set var="classVar" value="postItemData"/>
							</c:when>
							<c:otherwise>
								<c:set var="classVar" value="orgItemData"/>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${org.isAdd==true}">
								<c:choose>
									<c:when test="${org.canExpand=='0'}">
										<div class="${classVar}" onclick="submitForm('into','${org.id}');"></div>
										<a onclick="submitForm('into','${org.id}');">${org.name}</a>
									</c:when>
									<c:otherwise>
										<div class="${classVar}" onclick="addResult('${org.id}','${org.name}');"></div>
										<a onclick="addResult('${org.id}','${org.name}');">${org.name}</a>
									</c:otherwise>
								</c:choose>
								<div class="addItemData" onclick="addResult('${org.id}','${org.name}');"></div>
							</c:when>
							<c:otherwise>
								<div class="${classVar}" onclick="submitForm('into','${org.id}');"></div>
								<a onclick="submitForm('into','${org.id}');">${org.name}</a>
							</c:otherwise>
						</c:choose>
					</div>
				</li>
			</c:forEach>
		</ul>
	</c:if>
	<c:if test="${orgList==null or fn:length(orgList)<=0}">
		<div class="lab_errorinfo"><bean:message key="return.noRecord"/></div>
	</c:if>
</div>

</form>
</body>
</html>