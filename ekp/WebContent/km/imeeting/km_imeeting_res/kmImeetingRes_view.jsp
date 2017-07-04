<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<% response.addHeader("X-UA-Compatible", "IE=edge"); %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
	 pageContext.setAttribute("_isJGEnabled", new Boolean(
			com.landray.kmss.sys.attachment.util.JgWebOffice
					.isJGEnabled()));
     pageContext.setAttribute("ImageW",312);
     pageContext.setAttribute("ImageH",210);
%>
<script>
	function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmImeetingRes.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmImeetingRes.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingRes"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<%--会议室名称--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.fdName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%-- 会议室图片--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.picture"/>
		</td>
		<td width="85%" colspan="3">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"  charEncoding="UTF-8">
				<c:param name="fdKey" value="Attachment" />
				<c:param name="fdMulti" value="false" />
				<c:param name="fdAttType" value="pic" />
				<c:param name="fdImgHtmlProperty" value="width=120" />
				<c:param name="fdModelId" value="${param.fdId }" />
				<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingRes" />
				<%-- 图片设定大小 --%>
				<c:param name="picWidth" value="${ImageW}" />
				<c:param name="picHeight" value="${ImageH}" />
				<c:param name="proportion" value="false" />
				<c:param name="fdLayoutType" value="pic"/>
				<c:param name="fdPicContentWidth" value="${ImageW}"/>
				<c:param name="fdPicContentHeight" value="${ImageH}"/>
				<c:param name="fdViewType" value="pic_single"/>
				
			</c:import>
		</td>
	</tr>
	<tr>
		<%--会议室分类--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.docCategory"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="docCategoryName"  style="width:85%" showStatus="view"></xform:text>
		</td>
	</tr>
	<tr>
		<%--设备详情--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.fdDetail"/>
		</td>
		<td width="85%" colspan="3">
			<xform:textarea property="fdDetail" style="width:85%"></xform:textarea>
		</td>
	</tr>
	<tr>
		<%--地点楼层--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.fdAddressFloor"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdAddressFloor" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--容纳人数--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.fdSeats"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdSeats" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--保管员--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.docKeeper"/>
		</td>
		<td width="85%" colspan="3">
			<xform:address propertyId="docKeeperId" propertyName="docKeeperName" orgType="ORG_TYPE_ALL" style="width:85%" />
		</td>
	</tr>
	<tr>
		<!-- 可使用者 -->
		<td class="td_normal_title" width=15%>
			<bean:message	bundle="km-imeeting" key="kmImeetingRes.authReader" />
		</td>
		<td width="85%" colspan="3">
			<c:out value="${kmImeetingResForm.authReaderNames}" />
		</td>
	</tr>
	<tr>
		<%--是否有效--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.fdIsAvailable"/>
		</td>
		<td width="85%" colspan="3">
			<xform:radio property="fdIsAvailable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>

</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>