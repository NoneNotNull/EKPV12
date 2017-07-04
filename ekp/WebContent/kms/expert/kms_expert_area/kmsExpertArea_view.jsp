<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<tr>
	<th width=15% >${param.areaMessage }：</th>
	<td width=85% colspan="3">
		<c:out value="${kmsExpertInfoForm.fdKmsExpertAreaListForms[param.index].fdCategoryName}" />
	</td>
</tr>
