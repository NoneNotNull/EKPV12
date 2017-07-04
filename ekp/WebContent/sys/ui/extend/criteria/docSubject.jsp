<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%
	Map<String, String> map = (Map) request
			.getAttribute("criterionAttrs");
	Boolean hasTitle = StringUtil.isNotNull(map.get("title"))  ? true : false;

	String title = "";
	if (hasTitle) {
		title = map.get("title");
	} else {
		title = ResourceUtil.getString("ui.criteria.docSubject",
				"sys-ui");
	}
	request.setAttribute("criterion_docSubject_title",title);
%>
<list:cri-criterion title="${lfn:message('sys-ui:ui.criteria.docSubject') }" expand="true" type="lui/criteria/criterion_input_selected!Criterion" key="docSubject" multi="true">
	<list:varDef name="title"></list:varDef>
	<list:varDef name="selectBox">
		<list:box-select type="lui/criteria/criterion_input_selected!CriterionSelectBox">
			<list:varDef name="select">
				<list:item-select type="lui/criteria/criterion_input_selected!TextInput" cfg-placeholder="${criterion_docSubject_title}">
				</list:item-select>
			</list:varDef>
		</list:box-select>
	</list:varDef>
</list:cri-criterion>

