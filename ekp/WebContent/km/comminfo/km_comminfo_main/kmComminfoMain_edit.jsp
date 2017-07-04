<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/comminfo/km_comminfo_main/kmComminfoMain.do" onsubmit="return validateKmComminfoMainForm(this);">
<div id="optBarDiv">
	<c:if test="${kmComminfoMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmComminfoMainForm, 'update');">
	</c:if>
	<c:if test="${kmComminfoMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmComminfoMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmComminfoMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="km-comminfo" key="table.kmComminfoMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	
	<tr>
		<%-- 主题 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docSubject"/>
		</td><td width=35%>
			<html:text property="docSubject" styleClass="inputsgl"	style="width:90%;"
			onkeypress="if(event.keyCode==13){event.keyCode=0;return false;}"/>
			<span class="txtstrong">*</span>
		</td>
		<%-- 所属类别 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCategoryId"/>
		</td>
		<td width=35%>
			<html:select property="docCategoryId">
				<c:forEach items="${categoryList}" var="kmComminfoCategory" >
					<html:option value="${kmComminfoCategory.fdId }" >${kmComminfoCategory.fdName }</html:option>
				</c:forEach>
			</html:select>
		</td>
	</tr>
	
	<tr>
		<%-- 提交者 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreatorId"/>
		</td>
		<td width=35%>
			<html:hidden property="docCreatorId" /> 
			<c:out value="${kmComminfoMainForm.docCreatorName}" />
		</td>
		<%-- 提交时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoMainForm.docCreateTime}" />
		</td>
	</tr>
		<tr>
			<!-- 排序号 -->
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-comminfo" key="kmComminfoMain.fdOrder" />
			</td>
			<td width=35% colspan="3">
				<xform:text property="fdOrder" style="width:8%;" />
			</td>
		</tr>
		<%-- 资料内容 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.docContent"/>
		</td><td width=85% colspan="3">
			<kmss:editor property="docContent" height="500" />
		</td>
	</tr>
	<%-- 附件机制 --%>
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="km-comminfo" key="kmComminfo.documentEnclosure" />
		</td>
		<td width="85%"  colspan="3">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment"/>
			</c:import>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmComminfoMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>