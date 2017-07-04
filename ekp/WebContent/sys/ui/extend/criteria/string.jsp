<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:cri-criterion title="${lfn:message('sys-ui:ui.criteria.string') }" multi="false" expand="false" key="docSubject">
	<list:varDef name="title"></list:varDef>
	<list:varDef name="selectBox">
	<list:box-select>
		<list:varDef name="select">
			<list:item-select type="lui/criteria/criterion_input!TextInput">
			</list:item-select>
		</list:varDef>
	</list:box-select>
	</list:varDef>
</list:cri-criterion>