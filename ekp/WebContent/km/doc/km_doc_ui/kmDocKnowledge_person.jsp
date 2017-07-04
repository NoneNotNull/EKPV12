<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
try {
%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-doc:module.km.doc') }"></c:out>
	</template:replace>
	<template:replace name="content">
		
		<list:criteria id="criteria1" expand="true">
			<%-- <list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref> --%>
			<list:cri-criterion title="${lfn:message('km-doc:kmDoc.myhome.doc') }" key="selfdoc"> 
				<list:box-select>
					<list:item-select id="mydoc1" cfg-required="true" cfg-defaultValue="create">
						<ui:source type="Static">
						    [{text:'${lfn:message('km-doc:kmDoc.myhome.doc.create') }', value:'create'},
						    {text:'${lfn:message('km-doc:kmDoc.myhome.doc.author') }', value:'author'},
						    {text:'${lfn:message('km-doc:kmDoc.myhome.doc.evaluation') }', value:'evaluation'},
						    {text:'${lfn:message('km-doc:kmDoc.myhome.doc.introduce') }', value:'introduce'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
							var vals = evt.values;
							if (vals.length > 0 && vals[0] != null) {
								var val = vals[0].value;
								if (val == 'create' || val == 'author') {
									LUI('status1').setEnable(true);
								} else {
									LUI('status1').setEnable(false);
								}
							}
						</ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('sys-doc:sysDocBaseInfo.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select id="status1">
						<ui:source type="Static">
							[{text:'${ lfn:message('status.draft')}', value:'10'},
							{text:'${ lfn:message('status.examine')}',value:'20'},
							{text:'${ lfn:message('status.refuse')}',value:'11'},
							{text:'${ lfn:message('status.discard')}',value:'00'},
							{text:'${ lfn:message('status.publish')}',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		
		<%@ include file="/km/doc/km_doc_ui/kmDocKnowledge_listview.jsp" %>
	</template:replace>
</template:include>
<%
} catch (Exception e) {
	e.printStackTrace();
}
%>