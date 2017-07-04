<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%> 
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" width="95%" sidebar="no">
	<template:replace name="title"> 
		<bean:message bundle="sys-portal" key="table.sysPortalTree"/>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:module.sys.portal') }">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:nav.sys.portal.portlet') }">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:table.sysPortalTree') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<c:choose>
					<c:when test="${ sysPortalTreeForm.method_GET == 'add' }">
						<ui:button text="${lfn:message('button.save') }" order="2" onclick="submitForm('save');">
						</ui:button>
					</c:when>
					<c:when test="${ sysPortalTreeForm.method_GET == 'edit' }">					
						<ui:button text="${lfn:message('button.update') }" order="2" onclick="submitForm('update');">
						</ui:button>							
					</c:when>
				</c:choose>
				<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
				</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<script>
	function SysLinksDialog(idF,nameF) {
		seajs.use(['lui/dialog','lui/jquery'], function(dialog, $){
			dialog.build({
				config : {
						width : 600,
						height : 540,  
						title : "选择系统注册链接",
						content : {
							type : "iframe",
							url : "/sys/person/sys_person_link/sysPersonLink.do?method=dialog&type=hotlink&multi=false"
						}
				},
				callback : function(data) {
					if(data==null) {
						return;
					}
					//AddSelectedNavLink(data);
					document.getElementsByName(idF)[0].value = data[0].url;
					document.getElementsByName(nameF)[0].value = data[0].name;					
				}
			}).show(); 
		});
	}
	</script>
	
	
<html:form action="/sys/portal/sys_portal_tree/sysPortalTree.do">
 
<p class="txttitle"><bean:message bundle="sys-portal" key="table.sysPortalTree"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdName"/>
		</td>
		<td width="35%">
			<xform:text property="fdName" required="true" subject="${ lfn:message('sys-portal:sysPortalTree.fdName') }" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdType"/>
		</td>
		<td width="35%">
			<xform:radio property="fdType" required="true">
					<xform:enumsDataSource enumsType="sys_portal_tree_type" />
			</xform:radio>
		</td>
	</tr> 
	<%--  --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdContent"/>
		</td>
		<td width="85%" colspan="3">
			<table width="100%">
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message  bundle="sys-portal" key="sysHomeNav.display"/>
					</td>
					<td width="85%">
						<label>
							<input type=radio name="fdDisplay" onclick="refreshDisplay();" checked><bean:message bundle="sys-portal" key="sysHomeNav.display.tree"/>
						</label>
						<label>
							<input type=radio name="fdDisplay" onclick="refreshDisplay();"><bean:message bundle="sys-portal" key="sysHomeNav.display.data"/>
						</label>
					</td>
				</tr>
				<tr id="designMode">
					<td colspan="2">
						<table class="tb_noborder" style="margin: 0px;"><tr><td>
							<div id=DIV_Tree style="overflow:auto;height:200px;width:600px;"></div>
						</td></tr></table>
						<div align=right>
							<input type=image src="${KMSS_Parameter_StylePath}icons/up.gif" onclick="resizeTreeDiv(-1);return false;">
							<input type=image src="${KMSS_Parameter_StylePath}icons/down.gif" onclick="resizeTreeDiv(1);return false;">
						</div>
						<div id=DIV_AllControl style="display:none">
							<div style="height:1px;border-bottom: 1px solid #b4b4b4;"></div>
							<span lks_info="EditNode">
								<a onclick="optAddNode();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.createChild"/></a>
								　<bean:message  bundle="sys-portal" key="sysHomeNav.msg.move"/>
								<a onclick="optMoveUp(currentNode);return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.move.up"/></a>
								<a onclick="optMoveUp(currentNode.nextSibling);return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.move.down"/></a>
								<a onclick="optMoveLeft();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.move.left"/></a>
								<a onclick="optMoveRight();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.move.right"/></a>
								<br>
							</span>
							<span lks_info="NewEditNode">
								<br><bean:message  bundle="sys-portal" key="sysHomeNav.msg.normalNode"/>
								<br><bean:message  bundle="sys-portal" key="sysHomeNav.msg.nodeName"/><input name="tmpNodeName" value="" style="width:450px" class="inputsgl">
								<a onclick="selectAppModule();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.selectNode"/></a>
								<br><bean:message  bundle="sys-portal" key="sysHomeNav.msg.url"/><input name="tmpURL" value="" style="width:450px" class="inputsgl">
								<div style="display: none;">
								<br><bean:message  bundle="sys-portal" key="sysHomeNav.msg.target"/>
								<select name="tmpTarget">
									<option value="_top"><bean:message  bundle="sys-portal" key="sysHomeNav.msg.frame.top"/>
									<option value="_blank" selected><bean:message  bundle="sys-portal" key="sysHomeNav.msg.frame.new"/>
								</select>
								</div>
							</span>
							<span lks_info="EditData">
								<br><bean:message  bundle="sys-portal" key="sysHomeNav.msg.dataNode"/>
							</span>
							<br>
							<div align=center>
								<span lks_info="EditNode">
									<a onclick="confirmEditNode();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.ok"/></a>
									<a onclick="optCancel();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.cancel"/></a>
								</span>
								<span lks_info="EditNodeData">
									<a onclick="optDeleteNode();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.delete"/></a>
								</span>
								<span lks_info="NewNode">
									<a onclick="confirmNewNode();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.ok"/></a>
									<a onclick="optCancel();return false;" href=""><bean:message  bundle="sys-portal" key="sysHomeNav.button.cancel"/></a>
								</span>
							</div>
						</div>
					</td>
				</tr>
				<tr style="display:none" id="sourceMode">
					<td colspan="2">
						<div class="txtstrong"><bean:message  bundle="sys-portal" key="sysHomeNav.msg.warning"/></div>
						<html:textarea property="fdContent" style="width:100%;height:200px"/>
					</td>
				</tr>	
			</table>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:common.msg.editors') }</td>
		<td colspan="3">
			<xform:address textarea="true" mulSelect="true" propertyId="fdEditorIds" propertyName="fdEditorNames" style="width:100%;height:90px;" ></xform:address>
		</td>
	</tr> 
	<%-- --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
	<c:if test="${ sysPortalTreeForm.method_GET != 'add' }">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docAlteror"/>
		</td><td width="35%">
			<xform:address propertyId="docAlterorId" propertyName="docAlterorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="view" />
		</td>
	</tr>
	</c:if>
</table>
</center>
<script type="text/javascript">Com_IncludeFile("domain.js");</script>
<script type="text/javascript">Com_IncludeFile("dialog.js");</script>
<script type="text/javascript" src="tree.jsp"></script>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script type="text/javascript">	
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
</script>	
<script>
	$KMSSValidation();
</script>
</html:form>
<br><br>
	</template:replace>
</template:include>