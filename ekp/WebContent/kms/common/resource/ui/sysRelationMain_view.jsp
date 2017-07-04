<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
			SysRelation_Loading_Msg = '<bean:message bundle="kms-common" key="kms.commoc.list.loading"/>';
			SysRelation_Loading_Img = document.createElement('img');
			SysRelation_Loading_Img.src = Com_Parameter.ContextPath + "resource/style/common/images/loading.gif";
			SysRelation_Loading_Div = document.createElement('div');
			SysRelation_Loading_Div.id = "SysRelation_Loading_Div";
			SysRelation_Loading_Div.style.position = "absolute";
			SysRelation_Loading_Div.style.padding = "5px 10px";
			SysRelation_Loading_Div.style.fontSize = "12px";
			SysRelation_Loading_Div.style.backgroundColor = "#F5F5F5";
			SysRelation_loading_Text = document.createElement("label");
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
			function sysRelation_LoadIframe(td, url) {
				//显示请等待
				SysRelation_Loading_Show();
				if(typeof(td)=="string"){
					var tdObj = document.getElementById(td);
				}else{
					var tdObj = td;
				}
				var iframe = document.getElementById('sysRelationContentListFrame');
				//if(iframe.src==""){
					 iframe.src = url;
				//} 
				//去掉请等待
				 Com_AddEventListener(iframe, 'load', function() {
				 	SysRelation_Loading_Hide();
				 });

			}
 </script>
 
 <tr KMS_TR_TAG="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />"  style="display:none"
	SHOW_NUM="false" onclick="sysRelation_LoadIframe(this, '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsSysRelationMain.do" />?method=view&fdId=${requestScope.sysRelationMainForm.fdId}&currModelId=${requestScope.currModelId}&currModelName=${requestScope.currModelName}&fdKey=${requestScope.fdKey}&showCreateInfo=${requestScope.showCreateInfo}&frameName=sysRelationContent');" valign="top">	
							<td>
                           
<c:if test="${not empty currModelName}"> 
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
	<c:if test="${requestScope.mainModelForm.method_GET=='view'}">
		<table   width="100%">
			<tr>
				<td id="sysRelationContent" onresize="sysRelation_LoadIframe(this, '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsSysRelationMain.do" />?method=view&fdId=${requestScope.sysRelationMainForm.fdId}&currModelId=${requestScope.currModelId}&currModelName=${requestScope.currModelName}&fdKey=${requestScope.fdKey}&showCreateInfo=${requestScope.showCreateInfo}&frameName=sysRelationContent');" valign="top">
					<iframe  id="sysRelationContentListFrame"  src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
		</table>
	</c:if>
</c:if>
 </td>
 </tr>	