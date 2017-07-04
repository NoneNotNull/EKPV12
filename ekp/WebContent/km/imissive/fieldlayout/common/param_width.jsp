<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<tr>
	<td class="td_normal_title" width=40%>宽度(百分比或像素,如80%或200px))</td>
	<td><input type='text' id='control_width' class='inputsgl'
			   style="width: 80%" storage="true"
			   value="${param.defaultWidth==null?'45%':param.defaultWidth}" /></td>
</tr>
