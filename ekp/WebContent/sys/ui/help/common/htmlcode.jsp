<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div>
	<span style="margin:0px 20px 0px 10px; line-height:30px;" class="com_subhead">显示样例</span>
	<a class="com_btn_link" style="cursor:pointer;line-height:30px;"
		onclick="var o = LUI.$(this.parentNode).find('.sys_ui_help_code'); if(o.is(':visible')) o.hide();else o.show();">
		查看源码
	</a>
	<div style="border: 1px yellow solid; padding: 2px;">
		${code}
	</div>
	<div style="margin-right:5px;">
		<textarea style="width:100%; height:300px; display:none; margin-top:5px;"
			class="sys_ui_help_code"><c:out value="${fn:trim(code)}" /></textarea>
	</div>
</div>
