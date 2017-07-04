<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.SpringBeanUtil,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	java.util.ArrayList,
	java.util.List,
	java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>

<%
IXMLDataBean lbpmOptHandlerTreeService = (IXMLDataBean) SpringBeanUtil.getBean("lbpmOptHandlerTreeService");
RequestContext requestInfo = new RequestContext(request);
List results = lbpmOptHandlerTreeService.getDataList(requestInfo);
List orgList = new ArrayList();
List ids = new ArrayList();
int size = results.size();
for (int i = 0; i < size; i ++) {
	Map org = (Map) results.get(i);
	if (ids.contains(org.get("id"))) {
		continue;
	}
	orgList.add(org);
	ids.add(org.get("id"));
}
request.setAttribute("orgList", orgList);
%>


<script type="text/javascript">

function addResult(id,name){
	if(parent._Add_Address_dialog_data)
		parent._Add_Address_dialog_data(id,name);
}
function closeAddress(){
	if(parent._Hide_Address_dialog)
		parent._Hide_Address_dialog();
}
function resizeIframe(){
	var addHeight=getObjectHeight(document.body);
	var parHeight=getObjectHeight(parent.document.body);
	var iframeHeight=addHeight>parHeight?addHeight:parHeight;
	parent.document.getElementById("addressIframe").height=iframeHeight;
	parent.scrollTo(0, 1);
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

<div class="div_banner">
	<div class="div_return" onclick="closeAddress();">
		<div><bean:message key="pda.address.cancel" bundle="sys-organization-pda"/></div>
		<div></div>
	</div>
</div>


<div class="addressDiv">
	<c:if test="${orgList!=null and fn:length(orgList)>0}">
		<ul class="addressList">
			<c:forEach var="org" items="${orgList}">
				<li>
					<div class="itemData">
						<div class="elmItemData" onclick="addResult('${org.id}','${org.name}');"></div>
						<a onclick="addResult('${org.id}','${org.name}');">${org.name}</a>
						<div class="addItemData" onclick="addResult('${org.id}','${org.name}');"></div>
					</div>
				</li>
			</c:forEach>
		</ul>
	</c:if>
	<c:if test="${orgList==null or fn:length(orgList)<=0}">
		<div class="lab_errorinfo"><bean:message key="return.noRecord"/></div>
	</c:if>
</div>

</body>
</html>