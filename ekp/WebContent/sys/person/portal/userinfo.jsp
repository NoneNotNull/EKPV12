<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<div data-lui-switch-class="lui_portal_header_text_over" class="lui_portal_header_text" onclick="window.open('${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view','_blank')">
	<span class='lui_portal_header_welcome'>${lfn:message('home.welcome')}</span>&nbsp;<span class='lui_portal_header_username'><%= UserUtil.getKMSSUser().getUserName() %></span><div class="lui_icon_s lui_portal_header_icon_arrow"></div>
	<ui:popup align="down-left" borderWidth="${ empty param['popupborder'] ? '2' : param['popupborder'] }" style="background-color:white;">
		<ui:event event="show">
			var img = document.getElementById("__user_info__img__");
			if(img.getAttribute('data-lui-mark')==null){
				img.src = '<person:headimageUrl personId="${KMSS_Parameter_CurrentUserId}" size="90" />';
				img.setAttribute('data-lui-mark', 'loaded');
			}
		</ui:event>
		<script>
			function __sys_logout(){
				if(confirm("${lfn:message('home.logout.confirm')}")) 
					location.href='${ LUI_ContextPath }/logout.jsp';
			}
			function __switchArea(){
				seajs.use(['lui/dialog','lui/jquery'],function(dialog,$){
					dialog.tree('sysAuthAreaSwitchService&id=!{value}',"${lfn:message('dialog.locale.winTitle')}",function(rtnData){
						if(window.console)
							console.log(rtnData);
						if(rtnData && rtnData.value){
							$.get(Com_Parameter.ContextPath + "sys/common/dataxml.jsp?s_bean=sysAuthAreaSwitchService&selectId="+rtnData.value,function(){
								history.go(0);
							});
						}
					});
				});
			}
		</script>
		<div style="width: 260px;padding: 8px;">
		 	<table width="100%">
		 		<tr>
		 			<td width="100">
		 				<img id="__user_info__img__" style="max-width: 90px;"/>
		 			</td>
		 			<td>
		 				<table width="100%">
		 					<tr>
		 						<td width="50%" height="25"><a href="${ LUI_ContextPath }/sys/person" target="_blank"><span class="com_btn_link">${ lfn:message('sys-person:header.msg.setting') }</span></a></td>
		 						
		 						<kmss:ifModuleExist path="/sns/ispace/">
		 							<%request.setAttribute("isExistIspace",true);
		 							%>
		 						</kmss:ifModuleExist>
		 						<td>
		 							<%
		 								Boolean isExistIspace = 
		 										(Boolean)request.getAttribute("isExistIspace");
		 								if(isExistIspace!=null && isExistIspace){
		 									%>
		 										<a href="${ LUI_ContextPath }/sns/ispace" target="_blank"><span class="com_btn_link">${ lfn:message('sys-person:header.msg.zone') }</span></a>
		 									<%
		 								}else{
		 									%>
		 										<a href="<person:zoneUrl personId="${KMSS_Parameter_CurrentUserId}" />" target="_blank"><span class="com_btn_link">${ lfn:message('sys-person:header.msg.zone') }</span></a>
		 									<%
		 								}
		 							%>
		 						</td>
		 					
		 					
		 					</tr>
		 					<tr>
		 						<td height="25"><a href="${ LUI_ContextPath }/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated_person.jsp" target="_blank"><span class="com_btn_link">${ lfn:message('sys-follow:sysFollow.person.my') }</span></a></td> 
		 						<td><a href="javascript:void(0)" onclick="__sys_logout()"><span class="com_btn_link">${ lfn:message('sys-person:header.msg.logout') }</span></a></td>
		 					</tr>
		 				</table>
		 				<div style="height: 5px;border-top: #bbb 1px dotted;"></div>
		 				<table width="100%">
		 					<%
		 					String areaName = UserUtil.getKMSSUser().getAuthAreaName();
		 					if(areaName != null && areaName.trim().length() >0 ){
		 					%>
		 					<tr>
		 						<td valign="top">${ lfn:message('sys-person:header.msg.areaName') }：</td>
		 						<td height="25"> 
		 							<div style="font-weight: bold;">
			 						<a href="javascript:__switchArea()"><%= areaName %></a>
			 						</div>
		 						</td>
		 					</tr>
		 					<%}%>
		 					<%
		 					String[] postName = UserUtil.getKMSSUser().getPostNames();
		 					if(postName != null && postName.length > 0 ){
		 					%>
		 					<tr>
		 						<td valign="top">${ lfn:message('sys-person:header.msg.postName') }：</td>
		 						<td height="25">
		 							<div style="font-weight: bold;">
		 							<%
		 							for(int i=0;i<postName.length;i++){
			 							out.print(postName[i]+"<br>");
		 							}
		 							%>
									</div>
		 						</td>
		 					</tr>	 					
		 					<%}%>
		 					<tr>
		 						<td width="40">${ lfn:message('sys-person:header.msg.deptName') }：</td>
		 						<td height="25"><span style="font-weight: bold;"><%=UserUtil.getKMSSUser().getDeptName()%></span></td>
		 					</tr>
		 					<%--
		 					<tr>
		 						<td>${ lfn:message('sys-person:header.msg.userPoint') }：</td>
		 						<td height="25"><span class="com_number">1234</span></td>
		 					</tr>
		 					--%>
		 				</table>
		 			</td>
		 		</tr>
		 	</table>
		</div>
	</ui:popup>
</div>
	