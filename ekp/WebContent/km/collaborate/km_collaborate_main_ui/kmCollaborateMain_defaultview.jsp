<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${kmCollaborateMainForm.docSubject} - ${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }"></c:out>
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
		        <%--编辑--%>
		      	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
						 <ui:button text="${lfn:message('button.edit')}" onclick="Com_OpenWindow('kmCollaborateMain.do?method=edit&fdId=${param.fdId}','_self');"/>
			   </kmss:auth>
			    <%--删除--%>
			   <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
					    <ui:button text="${lfn:message('button.delete')}" onclick="confirmDelete('kmCollaborateMain.do?method=delete&fdId=${param.fdId}');"/>
			    </kmss:auth>
		         <%--关闭--%>
			 <ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>

	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }" href="/km/collaborate/" target="_self">
				</ui:menu-item>
		</ui:menu>
	</template:replace>	
	
	
	<%--工作沟通--%>
	<template:replace name="content"> 
			    <script type="text/javascript">
					Com_IncludeFile("dialog.js|docutil.js");
					seajs.use(['lui/dialog'],function(dialog){
						window.confirmDelete = function(delUrl){
							dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
								if(isOk){
									Com_OpenWindow(delUrl,'_self');
								}	
							});
							return;
						};
					});
				</script>
		
				<script type="text/javascript">
				Com_IncludeFile("jquery.js");
				</script>
				<script>
					function CloseWindow(){
						window.close();
					}
					
					$(document).ready(function(){
						$("input[type=checkbox]",document.forms[0]).each(function(){
							this.disabled="disabled";
					     });
						$("#kmfdContent").find("img").each(function (){
							var width= $(this).width();
							var height=$(this).height();
							if(height>100) { $(this).height(100);}
							if(width>100) {$(this).width(Math.round(width*100/height));}
						}).click(function(){
							$(this).width("");
							$(this).height("");
							var width= $(this).width();
							var height=$(this).height();
							if(height>600) 
							   {
								  $(this).height(600);
							      $(this).width(Math.round(width*600/height));
							   }
							$(this).show();
							SetWinHeight(window.parent.document.getElementById("win"));
						}).dblclick( function(){
							$(this).hide();
							var width= $(this).width();
							var height=$(this).height();
							if(height>100) 
							   {
								  $(this).height(100);
							      $(this).width(Math.round(width*100/height));
							   }
							$(this).show();
							
						});
					});
						
				</script>
		<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
		  	<ui:tabpage width="95%" >
				<ui:content  title="${lfn:message('km-institution:kmInstitution.form.tab.main.label')}"  toggle="false">
						<table class="tb_normal" width=95%>
								<tr>
								   <!-- 主题 -->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/></td>
									<td colspan="3">
										<xform:text property="docSubject" style="width:85%" showStatus="view"/>
									<!-- 搞优先级-->
									 <span style="margin-left: 15px">
										<xform:checkbox property="fdIsPriority" >
							   				<xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.highPriority"/></xform:simpleDataSource>
							 			</xform:checkbox>
							 		 </span>	
									</td>
									
								</tr>
								<tr>
								     <!-- 沟通类型-->
								    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/></td>
									<td  colspan=3>
								         	${kmCollaborateMainForm.fdCategoryName}
									</td> 
								</tr>
							    	   <!--来源链接-->
								<c:if test="${not empty kmCollaborateMainForm.fdSourceUrl}">
								<tr>
								     <td class="td_normal_title" width="15%">
										<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdSource" />
									</td>
								    <td>
								      <html:hidden property="fdModelId" />
									  <html:hidden property="fdModelName" />
									  <html:hidden property="fdKey" />
								      <html:hidden property="fdSourceUrl" />
							          <html:hidden property="fdSourceSubject" />
										 <a href="<c:url value="${kmCollaborateMainForm.fdSourceUrl}"/>" target="_blank">${kmCollaborateMainForm.fdSourceSubject}</a>
								   </td>
								</tr>
								</c:if>
								
								<tr style="min-height: 200px;">
								    <!-- 内容-->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/></td>
									<td colspan="3" >
                                            ${kmCollaborateMainForm.fdContent}
									</td>
								</tr>
								<tr>
							    	<!-- 附件-->
								    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.related.attachment"/></td>
									<td  colspan="3">
									    <c:import  url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"  charEncoding="UTF-8" >
									        <c:param name="fdKey" value="attachment"/>
									   </c:import>
									</td>
								</tr>
								<tr>
								    <!-- 参与者,add,edit页面-->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/></td>
									<td  colspan=3>
								    	 <xform:address isLoadDataDict="false" required="true"  style="width:98%" propertyId="participantIds" propertyName="participantNames" orgType='ORG_TYPE_ALL' textarea="true"></xform:address>
									</td>
								</tr>
							</table>
							
							<table class="tb_normal" width=95%>
						    <!-- 通知方式-->
								<tr>
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
									<td colspan="3" >
										<kmss:editNotifyType property="fdNotifyType" />
										<div class="notNull" id="fdNotifyType" style="display:none;padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px;">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
									</td>
								</tr>
								
								<tr>
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
									<!-- 是否催办-->
									<td  colspan="3">
										<xform:select property="fdIsvalidate" value="${kmCollaborateMainForm.fdIsReminders!=null ? kmCollaborateMainForm.fdIsReminders : 'false' }">
											<xform:enumsDataSource enumsType="common_yesno" />
										</xform:select>
							             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<span id="todoDays" class="txtstrong" <c:if test="${!kmCollaborateMainForm.fdIsReminders}">style="display:none"</c:if>>
											<input type="hidden" value="${fdRemindersDay}" name="fdRemindersDay_hidden" id="fdRemindersDay_hidden"/> 
											(<xform:text property="fdRemindersDay" style="width:20px" required="true" validators="min(0)" />
											<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
										</span>
									</td>
								</tr>
								<tr>
								  <!-- 参与者权限-->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating"/></td>
									<td colspan="3">
										<xform:checkbox property="fdPartnerOperating">
										    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/></xform:simpleDataSource>
										</xform:checkbox>&nbsp;&nbsp;&nbsp;&nbsp;
										<xform:checkbox property="fdEditAtt">
										    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdEditAtt"/></xform:simpleDataSource>
										</xform:checkbox>
										<xform:checkbox property="fdIsOnlyView" showStatus="edit">
								            <xform:simpleDataSource value="true"> ${lfn:message("km-collaborate:kmCollaboratePartnerInfo.fdIsOnlyView")}</xform:simpleDataSource>
								  		</xform:checkbox>
									</td>
								</tr>	
								<tr>
								  <!-- 创建者-->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/></td>
									<td width="35%">
									       <c:out value="${kmCollaborateMainForm.docCreatorName}"/>
									</td>
							      <!-- 创建时间-->
									<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/></td>
									<td width="35%">
									       <c:out value="${kmCollaborateMainForm.docCreateTime}"/>
									</td>
								</tr>	
							</table>
				</ui:content>
			</ui:tabpage>
		</html:form>
	</template:replace>
</template:include>
