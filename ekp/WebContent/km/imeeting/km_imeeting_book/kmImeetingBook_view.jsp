<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
		<html:form action="/km/imeeting/km_imeeting_book/kmImeetingBook.do"  styleId="bookform">
			<html:hidden property="fdId" />
			<html:hidden property="docCreatorId" />
			<table class="tb_normal" width="98%" style="margin-top: 15px;">
				<tr>
					<td colspan="4" class="com_subject" style="font-weight: bold;">基础信息</td>
				</tr>
				<tr>
	     			<%--会议名称--%>
	              	<td width="15%" class="td_normal_title" >
	              		<bean:message bundle="km-imeeting" key="kmImeetingBook.fdName" />
	              	</td>
	              	<td width="85%" colspan="3" >
	              		<xform:text property="fdName"  style="width:90%"></xform:text>
	              	</td>
	            </tr>
				<tr>
					<%--召开时间/结束时间--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingBook.fdHoldDate" />
					</td>
					<td width="35%" >
						<xform:datetime property="fdHoldDate" dateTimeType="datetime" validators="after"></xform:datetime>
					</td>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingBook.fdFinishDate" />
					</td>
					<td width="35%" >
						<xform:datetime property="fdFinishDate" dateTimeType="datetime" validators="after"></xform:datetime>
					</td>
				</tr>
				<tr>
	     			<%--备注--%>
	              	<td width="15%" class="td_normal_title"  valign="top">
	              		<bean:message bundle="km-imeeting" key="kmImeetingBook.fdRemark" />
	              	</td>
	              	<td width="85%" colspan="3" >
	              		<xform:textarea property="fdRemark"  style="width:90%"/>
	              	</td>
	            </tr>
	            <tr>
					<td colspan="4" class="com_subject" style="font-weight: bold;">会议室信息</td>
				</tr>
				<tr>
					<%--会议地点--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingBook.fdPlace" />
					</td>
					<td width="35%"  >
						<input type="hidden" name="fdPlaceId" value="${kmImeetingBookForm.fdPlaceId }">
						<input type="hidden" name="fdPlaceName" value="${kmImeetingBookForm.fdPlaceName }">
						<c:out value="${res.fdName}"></c:out>
					</td>
					<%--保管员--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.docKeeper" />
					</td>
					<td width="35%" >
						<c:out value="${res.docKeeper.fdName}"></c:out>
					</td>
				</tr>
				<tr>
					<%--地点楼层--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdAddressFloor" />
					</td>
					<td width="35%" >
						<c:out value="${res.fdAddressFloor}"></c:out>
					</td>
						<%--容纳人数--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdSeats" />
					</td>
					<td width="35%" >
						<c:out value="${res.fdSeats}"></c:out>
					</td>
				</tr>
				<tr>
					<%--设备详情--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdDetail" />
					</td>
					<td width="85%" colspan="3" >
						<c:out value="${res.fdDetail}"></c:out>
					</td>
				</tr>
			</table>
		</html:form>
	</template:replace>
</template:include>