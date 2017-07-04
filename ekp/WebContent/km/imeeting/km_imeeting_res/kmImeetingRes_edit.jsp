<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<% response.addHeader("X-UA-Compatible", "IE=edge"); %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%
	 pageContext.setAttribute("_isJGEnabled", new Boolean(
			com.landray.kmss.sys.attachment.util.JgWebOffice
					.isJGEnabled()));
     pageContext.setAttribute("ImageW",312);
     pageContext.setAttribute("ImageH",210);
%>
<script>Com_IncludeFile("dialog.js|jquery.js");</script>
<script language="JavaScript">
	//防止没有选择类别而直接进入编辑页面
	var fdModelId='${param.fdModelId}';
	var fdModelName='${param.fdModelName}';
	var url='<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do" />?method=add&categoryId=!{id}&categoryName=!{name}';
	if(fdModelId!=null&&fdModelId!=''){
		url+="&fdModelId="+fdModelId+"&fdModelName="+fdModelName;
	}   
	Com_NewFileFromSimpleCateory('com.landray.kmss.km.imeeting.model.KmImeetingResCategory',url);
	$(document).ready(function (){
		var val ="${kmImeetingResForm.fdIsAvailable}";  
		if(val=='1'||val=='true'){
			document.getElementsByName("fdIsAvailable")[0].checked="checked";
		}else{
			document.getElementsByName("fdIsAvailable")[1].checked="checked";
		}
	});
</script>
<html:form action="/km/imeeting/km_imeeting_res/kmImeetingRes.do">
<div id="optBarDiv">
	<c:if test="${kmImeetingResForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmImeetingResForm, 'update');">
	</c:if>
	<c:if test="${kmImeetingResForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmImeetingResForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmImeetingResForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
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
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"  charEncoding="UTF-8">
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
			 <bean:message bundle="km-imeeting" key="kmImeetingRes.picture.desc" />
			<font color="red">${ImageW}(<bean:message bundle="km-imeeting" key="kmImeetingRes.picture.width" />)*${ImageH}(<bean:message bundle="km-imeeting" key="kmImeetingRes.picture.height" />)</font>							
		</td>
	</tr>
	<tr>
		<%--会议室分类--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.docCategory"/>
		</td>
		<td width="85%" colspan="3">
			<c:if test="${kmImeetingResForm.method_GET=='add'}">
				<html:hidden property="docCategoryId" />
				<xform:text property="docCategoryName" style="width:85%" showStatus="view"></xform:text>
			</c:if>
			<c:if test="${kmImeetingResForm.method_GET=='edit'}">
				<xform:dialog propertyId="docCategoryId" propertyName="docCategoryName" style="width:85%">
					Dialog_SimpleCategory('com.landray.kmss.km.imeeting.model.KmImeetingResCategory','docCategoryId','docCategoryName',false,null,'02');
				</xform:dialog>
			</c:if>
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
			<bean:message bundle="km-imeeting" key="kmImeetingRes.authReader"/>
		</td>
		<td width="35%" colspan="3">
			<xform:address propertyId="authReaderIds" propertyName="authReaderNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
			<div class="description_txt">
				<bean:message	bundle="km-imeeting" key="kmImeetingRes.authReader.tip" />
			</div>
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
<html:hidden property="docStatus" value="30"/>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>