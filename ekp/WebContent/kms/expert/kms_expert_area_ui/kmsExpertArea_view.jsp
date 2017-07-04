<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<tr>
	<td class="td_normal_title" width=10% >
			${param.areaMessage }：
	</td>
	<td>
			<c:out value="${kmsExpertInfoForm.fdKmsExpertAreaListForms[param.index].fdCategoryName}" />			
	</td>
</tr>