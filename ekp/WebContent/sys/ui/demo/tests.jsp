<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<ui:tabpanel height="240" scroll="true"
			layout="sys.ui.tabpanel.default" id="p_3b7097bd995b2c63cdeb">
			<portal:portlet title="我审批的流程" var-rowsize="6"
				var-myFlow="unExecuted">
				<ui:dataview format="sys.ui.listtable">
					<ui:source ref="km.review.myFlow.unExecuted.source" var-rowsize="6"
						var-myFlow="unExecuted"></ui:source>
					<ui:render ref="sys.ui.listtable.default" var-showTableTitle=""></ui:render>
				</ui:dataview>
				<ui:operation href="/km/review/?categoryId=!{cateid}" name="更多"
					type="more" align="right"></ui:operation>
				<ui:operation
					href="/km/review/km_review_main/kmReviewMain.do?method=add"
					name="新建" type="create" align="right"></ui:operation>
			</portal:portlet>
			<portal:portlet title="常用连接"
				var-fdId="141496e134a2ad035a5796f429390f7b">
				<ui:dataview format="sys.ui.textMenu">
					<ui:source ref="sys.portal.linking.source"
						var-fdId="141496e134a2ad035a5796f429390f7b"></ui:source>
					<ui:render ref="sys.ui.textMenu.default" var-cols=""></ui:render>
				</ui:dataview>
			</portal:portlet>
		</ui:tabpanel>
	</template:replace>  
</template:include>
 
