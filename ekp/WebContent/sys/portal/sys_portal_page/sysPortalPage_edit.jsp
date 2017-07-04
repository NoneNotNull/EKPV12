<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalFooter"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalHeader"%>
<%@page import="java.util.Collection"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.edit" width="95%" sidebar="no">
	<template:replace name="title">
	${ lfn:message('sys-portal:sysPortalPage.msg.title') }
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<c:choose>
					<c:when test="${ sysPortalPageForm.method_GET == 'add' }">
						<ui:button text="${lfn:message('button.save') }" order="2" onclick=" Com_Submit(document.sysPortalPageForm, 'save');">
						</ui:button>
					</c:when>
					<c:when test="${ sysPortalPageForm.method_GET == 'edit' }">					
						<ui:button text="${lfn:message('button.update') }" order="2" onclick=" Com_Submit(document.sysPortalPageForm, 'update');">
						</ui:button>	
						<kmss:auth requestURL="/sys/portal/sys_portal_page/sysPortalPage.do?method=deleteall">
							<ui:button order="3" text="${lfn:message('button.delete') }" onclick="deletePage();">
							</ui:button>
						</kmss:auth> 						
					</c:when>
				</c:choose> 
				<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
				</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="#" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:module.sys.portal') }" href="#" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:table.sysPortalPage') }" href="#" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	<template:replace name="content">
		<html:form action="/sys/portal/sys_portal_page/sysPortalPage.do">
		<script>
		Com_IncludeFile("security.js");
		Com_Parameter.event["confirm"].unshift(function() {
			var xobj = document.getElementById("pageDetails[0].docContent");
			xobj.value = base64Encode(xobj.value);
			return true;
		});
		</script>
		<script type="text/javascript">
			function deletePage(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.confirm("${ lfn:message('sys-portal:sysPortalPage.msg.delete') }",function(val){
						if(val==true){
							location.href = "${LUI_ContextPath}/sys/portal/sys_portal_page/sysPortalPage.do?method=delete&fdId=${sysPortalPageForm.fdId}";
						}
					})
				});
			}
			function selectTheme(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.build({
						config : {
								width : 700,
								height : 500,  
								title : "${ lfn:message('sys-portal:sysPortalPage.msg.selectTheme') }",
								content : {  
									type : "iframe",
									url : "/sys/portal/designer/jsp/selecttheme.jsp"
								}
						},
						callback : function(value, dia) {
							if(value==null){
								return ;
							}
							$("[name='fdTheme']").val(value.ref);
							$("[name='fdThemeName']").val(value.name);
						}
					}).show(); 
				});
			}
			function selectIcon(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.build({
						config : {
								width : 500,
								height : 400,  
								title : "${ lfn:message('sys-portal:sysPortalPage.msg.selectIcon') }",
								content : {  
									type : "iframe",
									url : "/sys/ui/jsp/icon.jsp"
								}
						},
						callback : function(value, dia) {
							if(value==null){
								return ;
							}
							$("#iconPreview").attr("class","lui_icon_l "+value);
							$("[name='fdIcon']").val(value);
						}
					}).show(); 
				});
			}
 
			LUI.ready(function(){
				window.$ = LUI.$;
				
				if("${sysPortalPageForm.fdType}"!="1"){
					if(LUI("pageEdit").navs.length <= 0){
						LUI("pageEdit").on("layoutDone",function(){
							LUI("pageEdit").navs[1].navFrame.hide();
						});
					}else{
						LUI("pageEdit").navs[1].navFrame.hide();
					}					
				}
			});
			
			function onFdTypeChange(val,obj){
				if(val=="1"){
					LUI("pageEdit").navs[1].navFrame.show();
					$("#portal_page_url").hide();
				}else{
					LUI("pageEdit").navs[1].navFrame.hide();
					$("#portal_page_url").show();
				} 
			}
		</script>
		<ui:tabpanel id="pageEdit">
			<ui:content title="${ lfn:message('sys-portal:sysPortalPage.msg.baseInfo')}">
			 	<table class="tb_normal" width=100%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-portal" key="sysPortalPage.fdName"/>
						</td>
						<td width="35%">
							<xform:text property="fdName" subject="${ lfn:message('sys-portal:sysPortalPage.docSubject') }" required="true" style="width:90%" />
						</td>
						<td class="td_normal_title" width=15% rowspan="2">							
							<bean:message bundle="sys-portal" key="sysPortalPage.fdIcon"/>
						</td>
						<td width="35%" rowspan="2">
							<div class="lui_icon_l lui_icon_on ">
								<div id='iconPreview' class="lui_icon_l ${ sysPortalPageForm.fdIcon }">
								</div>
							</div>
							<a href="javascript:void(0)" onclick="selectIcon()">${ lfn:message('sys-portal:sysPortalPage.msg.select') }</a>
							<html:hidden property="fdIcon" style="width:90%" />
						</td>
					</tr>
					<tr>						
						<td class="td_normal_title" width=15%>									
							<bean:message bundle="sys-portal" key="sysPortalPage.fdTitle"/>
						</td>
						<td width="35%">			 
							<xform:text property="fdTitle" htmlElementProperties="placeholder=${ lfn:message('sys-portal:sysPortalPage.msg.titleplaceholder') }" style="width:90%" />
						</td>
					</tr>
					
					 
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-portal" key="sysPortalPage.fdType"/>
						</td>
						<td width="85%" colspan="3">
							<div style="float: left;">
								<xform:radio property="fdType" required="true" onValueChange="onFdTypeChange">
									<xform:enumsDataSource enumsType="sys_portal_page_type" />
								</xform:radio>
							</div>
							<div id="portal_page_url" style="${sysPortalPageForm.fdType == '2' ? '' :'display:none;' }float:left;width: 60%;">
								<xform:text property="fdUrl" style="width: 100%;"></xform:text>
							</div>
						</td> 
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-portal" key="sysPortalPage.fdTheme"/>
						</td>
						<td width="35%" colspan="3">							 
						 	<xform:dialog subject="${ lfn:message('sys-portal:sysPortalPage.fdTheme') }"  style="width:90%" required="true" propertyId="fdTheme" propertyName="fdThemeName">
							selectTheme()
							</xform:dialog>
						</td>
					</tr>
					 
					<tr>
						<td class="td_normal_title" width=15%>
							${ lfn:message('sys-portal:sysPortalPage.msg.uiconfig') }
						</td>
						<td width="35%" colspan="3">							 
						 	<xform:radio property="fdUsePortal">
						 		<xform:simpleDataSource value="true">${ lfn:message('sys-portal:sysPortalPage.msg.useportal') }</xform:simpleDataSource>
						 		<xform:simpleDataSource value="false">${ lfn:message('sys-portal:sysPortalPage.msg.usepage') }</xform:simpleDataSource>
						 	</xform:radio>
						</td>
					</tr>
					<tbody>
						<tr>
							<td class="td_normal_title"  width="15%">${ lfn:message('sys-portal:sysPortalMain.defReader')}</td>
							<td colspan="3">
								<xform:address textarea="true" mulSelect="true" propertyId="defReaderIds" propertyName="defReaderNames" style="width:96%;height:90px;" ></xform:address>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title"  width="15%">${ lfn:message('sys-portal:sysPortalPage.fdReader')}</td>
							<td colspan="3">
								<xform:address textarea="true" mulSelect="true" propertyId="authReaderIds" propertyName="authReaderNames" style="width:96%;height:90px;" ></xform:address>
								<br><span class="com_help">${ lfn:message('sys-portal:sysPortalPage.msg.nreader') } </span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.fdEditor')}</td>
							<td colspan="3">
								<xform:address textarea="true" mulSelect="true" propertyId="authEditorIds" propertyName="authEditorNames" style="width:96%;height:90px;" ></xform:address>
								<br><span class="com_help">${ lfn:message('sys-portal:sysPortalMain.msg.nadmin') } </span>
							</td>
						</tr> 
					</tbody>
				</table>
			</ui:content>
			<ui:content title="${ lfn:message('sys-portal:sysPortalPage.msg.pageEdit')}" id="designerPanel">
				<portal:designer scene="portal" style="width:100%;height:430px" property="pageDetails[0].docContent"/>
			</ui:content>
		</ui:tabpanel> 
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />
		<script type="text/javascript">	
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		</script>		
		<script>
		$KMSSValidation(document.forms['sysPortalPageForm']);
		</script>
		</html:form>
	</template:replace>
</template:include>