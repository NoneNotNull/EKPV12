<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="useTab" value="false" scope="request"/>
<c:if test="${ param.formName!=null}">
	<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"/>
	<c:set var="currModelName" value="${mainModelForm.modelClass.name}" scope="request"/>
	<c:set var="useTab" value="${param.useTab}" scope="request"/>
</c:if>
<c:if test="${not empty currModelName}">
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
	<c:if test="${mainModelForm.method_GET=='view'}">
		<script type="text/javascript">
			var SysRelation_Loading_Msg = '<bean:message bundle="sys-relation" key="sysRelationMain.list.loading"/>';
			var SysRelation_Loading_Img = document.createElement('img');
			SysRelation_Loading_Img.src = Com_Parameter.ContextPath + "resource/style/common/images/loading.gif";
			var SysRelation_Loading_Div = document.createElement('div');
			SysRelation_Loading_Div.id = "SysRelation_Loading_Div";
			SysRelation_Loading_Div.style.position = "absolute";
			SysRelation_Loading_Div.style.padding = "5px 10px";
			SysRelation_Loading_Div.style.fontSize = "12px";
			SysRelation_Loading_Div.style.backgroundColor = "#F5F5F5";
			var SysRelation_loading_Text = document.createElement("label");
			SysRelation_loading_Text.id = 'SysRelation_loading_Text_Label';
			SysRelation_loading_Text.appendChild(document.createTextNode(SysRelation_Loading_Msg));
			SysRelation_loading_Text.style.color = "#00F";
			SysRelation_loading_Text.style.height = "16px";
			SysRelation_loading_Text.style.margin = "5px";
			SysRelation_Loading_Div.appendChild(SysRelation_Loading_Img);
			SysRelation_Loading_Div.appendChild(SysRelation_loading_Text);
			
			function SysRelation_Loading_Show() {
				document.body.appendChild(SysRelation_Loading_Div);
				SysRelation_Loading_Div.style.top = 200 + document.body.scrollTop;
				SysRelation_Loading_Div.style.left = document.body.clientWidth / 2 + document.body.scrollLeft -50;
			}
			
			function SysRelation_Loading_Hide() {
				SysRelation_Loading_Div.style.display = "none";
				var div = document.getElementById('SysRelation_Loading_Div');
				if (div)
					document.body.removeChild(SysRelation_Loading_Div);
			}
			function sysRelation_LoadIframe() {
				var url='<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />?method=view&fdId=${requestScope.sysRelationMainForm.fdId}&currModelId=${requestScope.currModelId}&currModelName=${requestScope.currModelName}&fdKey=${requestScope.fdKey}&showCreateInfo=${requestScope.showCreateInfo}&frameName=sysRelationContent';
				SysRelation_Loading_Show();
				var tdObj = document.getElementById('sysRelationContent');
				Doc_LoadFrame(tdObj, url);
				Com_AddEventListener(tdObj.getElementsByTagName('iframe')[0], 'load', function() {
					SysRelation_Loading_Hide();
				});
			}
		</script>
		<c:if test="${useTab == true || useTab=='true' }">
			<tr LKS_LabelName='<bean:message bundle="sys-relation" key="sysRelationMain.relation.info" />' style="display:none">
				<td>
		</c:if>
		<table class="tb_normal" width="100%">
			<tr>
				<td id="sysRelationContent" onresize="sysRelation_LoadIframe();" valign="top">
					<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
		</table>
		<c:if test="${useTab == true || useTab=='true' }">
			</td>
			</tr>
		</c:if>
	</c:if>
</c:if>