<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="java.util.List"%>
<c:if test="${empty kmsExpertInfoForm.fdName }">
	<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmsExpertInfoForm.fdOutName}" />
		<c:param name="fdModelId" value="${kmsExpertInfoForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.kms.expert.model.KmsExpertInfo" />
	</c:import>
</c:if>
<c:if test="${!empty kmsExpertInfoForm.fdName }">
	<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmsExpertInfoForm.fdName}" />
		<c:param name="fdModelId" value="${kmsExpertInfoForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.kms.expert.model.KmsExpertInfo" />
	</c:import>
</c:if>
<script type="text/javascript">Com_IncludeFile("treeview.js|doclist.js|dialog.js");</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
window.onload=function()
{
	LKSTree = new TreeView("LKSTree", "${kmsExpertInfoForm.fdDeptName}", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	n1.nodeType = ORG_TYPE_DEPT;
	n1.AppendBeanData("kmsExperDepartView&fdId=${kmsExpertInfoForm.fdPersonId}",
		"<c:url value="/kms/expert/kms_person_info/kmsPersonInfo.do?method=view&fdId=!{value}" />",null,false,null);
	LKSTree.Show();
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('kmsExpertInfo.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>	
	<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=delete&fdId=${param.fdId}"	requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsExpertInfo.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">
	<bean:message bundle="kms-expert" key="kmsExpert.expertInfo.title" />
</p>
<center>
	<table class="tb_normal" width=95%>
		<html:hidden name="kmsExpertInfoForm" property="fdId" />
    <tr>
      <td class="td_normal_title" colspan="4">
        <bean:message bundle="kms-expert" key="kmsExpert.expertInfo.summaryinfo" />
      </td>     
    </tr>
    <tr>
		<td width=50% valign="middle" align="center" colspan="2" id="_person_td">
        	<table class="tb_noborder" width="100%">
        		<tr>
        			<td align="left" valign="top" width="200" height="160">
	        			<c:if test="${not empty kmsExpertInfoForm.attachmentForms.spic.attachments}">
							  <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8"> 
					       	  <c:param name="fdKey" value="spic"/>
					          <c:param name="fdAttType" value="pic"/>
		  					  <c:param name="fdShowMsg" value="false"/>
							  <c:param name="fdMulti" value="false"/>
					          <c:param name="fdImgHtmlProperty" value="width=150 height=150"/>
					          <c:param name="formBeanName" value="kmsExpertInfoForm" />
					          <c:param name="fdModelId" value="${param.fdId }"/>
					          <c:param name="fdModelName" value="com.landray.kmss.kms.expert.model.KmsExpertInfo"/>
					          </c:import>
				         </c:if>
				         <c:if test="${empty kmsExpertInfoForm.attachmentForms.spic.attachments}">
				         	<img style="width: 150;height: 150px"class=optStyle src="${KMSS_Parameter_StylePath}expert/head.jpg" />
					     </c:if>
        			</td>
        			<td valign="top">
        				<BR><b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.name" /></b>
				        <c:if test="${empty kmsExpertInfoForm.fdName }">
					        <bean:write name="kmsExpertInfoForm" property="fdOutName" /><br>
				        </c:if>
				        <c:if test="${!empty kmsExpertInfoForm.fdName }">
					        <bean:write name="kmsExpertInfoForm" property="fdName" /><br>
				        </c:if>
				        <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></b>
				        <bean:write name="kmsExpertInfoForm" property="fdDeptName" /><br>
				        <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></b>
						<% 
					  		List postList = (List)request.getAttribute("posts");
						    if(postList.size()!=0){
					  	%>     	 	
						<c:forEach items="${posts}" var="post"  varStatus="status">
				        	<c:out value="${post}" /><br>
				        	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>        	
				        </c:forEach>
				        <%
						    }
						%>
						<br>
				        <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.sex" /></b>
				        	<sunbor:enumsShow value="${(kmsExpertInfoForm.fdSex==null||kmsExpertInfoForm.fdSex=='')?'1':kmsExpertInfoForm.fdSex}" enumsType="kmsExpert_personInfo_sex" />
						<BR>
						<br><br>
        			</td>
        		</tr>
        		<tr>
	         		<td colspan="2">
	         			<hr>
	        		</td>
        		</tr>
	      		<tr>
	         		<td colspan="2">
	         			<table class="tb_noborder" width="100%">
	         				<tr>
	         					<td width="50%">
				         			<b><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdMobile" /></b>
        							<bean:write name="kmsExpertInfoForm" property="fdMobileNo" /><br>
							    </td>
						        <td width="50%">
				    		        <b><bean:message bundle="kms-expert" key="kmsExpert.comtele" /></b>
        							<bean:write name="kmsExpertInfoForm" property="fdWorkPhone" /><br>
							    </td>
							<tr>
								<td>
							       	<b><bean:message bundle="kms-expert" key="kmsExpert.qq" /></b>
									<bean:write name="kmsExpertInfoForm" property="fdQqNumber" />
							   		<c:if test="${!empty kmsExpertInfoForm.fdQqNumber}">
										<a target="blank" href="http://wpa.qq.com/msgrd?V=1&amp;Uin=${kmsExpertInfoForm.fdQqNumber}&amp;Menu=yes">
										<img align="absMiddle" border="0" src="http://wpa.qq.com/pa?p=1:${kmsExpertInfoForm.fdQqNumber}:1" /></a> 
							        </c:if>
							        <br>
							    </td>
							    <td>
							    	<c:if test="${kmsExpertInfoForm.fdPersonType}">
									     <b><bean:message bundle="kms-expert" key="kmsExpert.rtx" /></b>
									     <bean:write name="kmsExpertInfoForm" property="fdRtxNo" />
									</c:if>   
							    </td>
							</tr>
							<tr>
								<td>
							      	<b><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdEmail" /></b>
        							<bean:write name="kmsExpertInfoForm" property="fdEmail" /><br>
								</td>
								<td> 
							        <b><bean:message bundle="kms-expert" key="kmsExpert.msn" /></b>
							        <bean:write name="kmsExpertInfoForm" property="fdMsnNumber" /><br>
								</td>
					     	</tr>
					     </table>
	        		</td>
	        	</tr>
        	</table>
		</td>
		<td width=50% valign="top" colspan="2">
			<table class="tb_noborder" width="100%">
				<tr>
					<td>
						<div id="_dept_div" style="overflow: auto;width: 100%;height: 200px;"><div id="treeDiv"></div></div>
					</td>
				</tr>
			</table>
		<script>
		function SetDivSize() {
			var div = document.getElementById("_dept_div");
			var td = document.getElementById("_person_td");
			div.style.width = td.offsetWidth - 2 + 'px';
			div.style.height = td.offsetHeight + 'px';
		}
		function SetDivWidth() {
			var div = document.getElementById("_dept_div");
			var td = document.getElementById("_person_td");
			div.style.width = td.offsetWidth - 2 + 'px';
		}
		Com_AddEventListener(window, 'load', SetDivSize);
		Com_AddEventListener(window, 'resize', SetDivWidth);
		</script>
  		</td>
    </tr> 
    <tr>
      <td class="td_normal_title" colspan="4">
        <bean:message bundle="kms-expert" key="kmsExpert.expertInfo.title" />
      </td>     
    </tr>
	<tr>
	  <td width=15% class="td_normal_title">
			<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />
		</td>
		<td width=35% colspan="3">
			<bean:write name="kmsExpertInfoForm" property="kmsExpertTypeName" />
	  </td>
	  <%--
      <td class="td_normal_title" width=15%>
        <bean:message bundle="kms-expert" key="table.kmsExpertInfo.personType" />
      </td>
      <td width=35%>
        <sunbor:enumsShow bundle="kms-expert" enumsType="expertInfo_expertType_innerOuter" value="${kmsExpertInfoForm.fdPersonType}" />
      </td>
       --%>
	</tr>
	<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
		<c:import url="/kms/expert/kms_expert_area/kmsExpertArea_view.jsp"
			charEncoding="UTF-8">
			<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
			<c:param name="index" value="${vstatus.index}" />
		</c:import>
	</c:forEach>
	<%--				
	<tr>	
			
		<td width=15% class="td_normal_title">
			<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdWikiCategoryName" />
		</td>
		<td width=35%>
			<bean:write name="kmsExpertInfoForm" property="kmsWikiCategoryNames" />
		</td>
		
		<td width=15% class="td_normal_title">
			<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAskCategoryName" />
		</td>
		<td width=35%>
			<bean:write name="kmsExpertInfoForm" property="kmsAskCategoryNames" />
		</td>
	</tr>
	--%>
	
	<tr>
    	<td width=15% class="td_normal_title">
    		<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdOrder" />
    	</td>
    	<td colspan="3">
    		<bean:write name="kmsExpertInfoForm" property="fdOrder" />
    	</td>
    </tr>
	<TR>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdBackground" />
		</td>
		<td width=35% colspan=3 heitht="100%">
			<bean:write name="kmsExpertInfoForm" property="fdBackground" />
		</td>
	</TR>
	
	</table><br>
	 <c:if test="${kmsExpertInfoForm.fdPersonType=='true' }">
	        <%@ include file="/kms/expert/kms_expert_info/kmInterfixInfo_view.jsp"%>
     </c:if>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
