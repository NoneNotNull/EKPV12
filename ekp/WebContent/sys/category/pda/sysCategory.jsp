<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript">
	function onSlectChange(selectObj) {
		var optVar = selectObj.options[selectObj.selectedIndex].value;
		submitForm("list", optVar);
	}
	function submitForm(method, currentId) {
		var currentCate = document.getElementsByName("categoryId");
		if (currentCate != null)
			currentCate[0].value = currentId;
		Com_Submit(document.forms[0], method);
	}
	function addResult(id,name){
		var isApp = "${param.isAppflag}";
		var creatUrlObj = document.getElementsByName("fdCreateUrl");
		var creatUrl = creatUrlObj[0].value.replace(/!\{cateid\}/gi, id);
		if(creatUrl.indexOf("/")==0)
			creatUrl = Com_Parameter.ContextPath + creatUrl.substring(1);
		location = Com_SetUrlParameter(creatUrl,"isAppflag",isApp);
	}
	function gotoList(fdId){
		var hrefUrl='';
		if(fdId!=''){
			hrefUrl='<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=view&fdId="/>'+fdId;
		}else{
			hrefUrl='<c:url value="/third/pda/index.jsp"/>';
		}
		location = hrefUrl;
	}
</script>
<title><bean:message key="pda.cate.select" bundle="sys-category-pda"/></title>
</head>
<body>
<form
	action="<c:url value="/sys/category/pda/sysCategory.do?method=list&isAppflag=${param.isAppflag}&modelName=${param.modelName}"/>"
	method="post">
	<input type="hidden" name="fdCreateUrl"	value="${fdCreateUrl}" /> 
	<input type="hidden" name="categoryId" value="" />
	<input type="hidden" name="topCateIds" value="${topCateIds}" />
	<input type="hidden" name="authCateIds" value="${authCateIds}" />

<div class="div_banner">
<c:if test="${param['isAppflag']!='1'}">
	<div class="div_return" onclick="gotoList('${sessionScope["S_CurModule"]}');">
		<div>
			<c:choose>
				<c:when test="${sessionScope['S_CurModuleName']==null}">
					<bean:message key="phone.banner.homepage" bundle="third-pda"/>
				</c:when>
				<c:when test="${fn:length(sessionScope['S_CurModuleName'])>4}">
					${fn:substring(sessionScope['S_CurModuleName'],0,3)}..
				</c:when>
				<c:otherwise>
					${sessionScope['S_CurModuleName']}
				</c:otherwise>
			</c:choose>
		</div>
		<div></div>
	</div>
</c:if>
<div id="parentDiv" class="div_parent">
	<c:if test="${parentList!=null and fn:length(parentList)>0}">
		<select name="fd_parent" onchange="onSlectChange(this);"
			style="max-width: 50%">
			<option value="" 
				<c:if test="${param['categoryId']==null || param['categoryId']=='' }">
					 selected="selected" 
				</c:if>
			><bean:message key="pda.cate.sign" bundle="sys-category-pda"/></option>
			<c:forEach var="parent" items="${parentList}">
			<c:choose>
				<c:when test="${param['categoryId']!=null && param['categoryId']!='' && param['categoryId']== parent['value']}">
					<option value="${parent['value']}" selected="selected">${parent['text']}</option>
				</c:when>
				<c:otherwise>
					<option value="${parent['value']}">${parent['text']}</option>
				</c:otherwise>
			</c:choose>
			</c:forEach>
		</select>
	</c:if>
</div>
</div>
<div class="addressDiv">
<c:if
	test="${dataList!=null and fn:length(dataList)>0}">
	<ul class="addressList">
		<c:forEach var="cate" items="${dataList}">
			<li>
				<c:choose>
					<c:when test="${cate.nodeType=='TEMPLATE'}">
						<div class="itemData" onclick="addResult('${cate.value}','${cate.text}');">
						<a onclick="addResult('${cate.value}','${cate.text}');">${cate.text}</a>
						</div>
					</c:when>
					<c:otherwise>
						<div class="itemData" onclick="submitForm('list','${cate.value}');">
							<div class="cateItemData" 
								onclick="submitForm('list','${cate.value}');">
								<a onclick="submitForm('list','${cate.value}');">${cate.text}</a>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</li>
		</c:forEach>
	</ul>
</c:if> 
<c:if test="${dataList==null or fn:length(dataList)<=0}">
	<div class="lab_errorinfo"><bean:message key="return.noRecord" /></div>
</c:if>
</div>
</form>
</body>
</html>