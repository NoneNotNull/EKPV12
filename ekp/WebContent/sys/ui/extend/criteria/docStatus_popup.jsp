<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<list:group-popup title="${lfn:message('sys-doc:sysDocBaseInfo.docStatus') }" multi="false" expand="false" key="status">
		<list:varDef name="title"></list:varDef>
		<list:varDef name="selectBox">
			<list:varDef name="select">
				<list:item-select type="lui/criteria/select_panel!CriterionSelectDatas">
					<ui:source type="Static">
						[
							{text:'${lfn:message('status.draft') }', value:'10'},
							{text:'${lfn:message('status.examine') }', value:'20'},
							{text:'${lfn:message('status.refuse') }', value:'11'},
							{text:'${lfn:message('status.discard') }', value:'00'},
							{text:'${lfn:message('status.expire') }', value:'40'},
							{text:'${lfn:message('status.publish') }', value:'30'}
						]
					</ui:source>
				</list:item-select>
			</list:varDef>
		</list:varDef>
	</list:group-popup>
