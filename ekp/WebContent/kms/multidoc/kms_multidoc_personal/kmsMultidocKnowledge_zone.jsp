<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.navlink">
 
	<c:set var="TA" value="${empty param.zone_TA ? 'ta' : param.zone_TA}"/>
	<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
	<template:replace name="title">
		<c:out value="${lfn:message(lfn:concat('kmsMultidoc.kmsMultidocKnowledge.zone.', TA))}"></c:out>
	</template:replace>
	<template:replace name="content">
          <ui:tabpanel layout="sys.zone.tabpanel.default">
                <ui:content title="${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.original.', TA)) }" />
                <ui:content title="${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.create.', TA)) }" />
                <ui:content title="${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.intro.', TA)) }"  />
                <ui:content title="${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.eva.', TA)) }"  />
                <ui:event event="indexChanged" args="data">
                	var selectValue;
                	switch(data.index.after) {
                		case 0 :  selectValue = "myOriginal"; break;
                		case 1 :  selectValue = "myCreate"; break;
                		case 2 :  selectValue = "myIntro"; break;
                		case 3 :  selectValue = "myEva"; break;
                		default : break;
                	}
                      seajs.use("lui/topic", function(topic) {
                           topic.channel( "multidoc").publish('criteria.changed' ,
                                       { criterions: [{key:"mydoc" , value:[selectValue]}]});
                     });

                </ui:event>
          </ui:tabpanel>
         <list:listview channel="multidoc" cfg-criteriaInit="true" >
			<ui:source type="AjaxJson">
				{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=listPerson&rowsize=8&orderby=docPublishTime&ordertype=down&userId=${userId}&personType=other'}
			</ui:source>
			<list:rowTable layout="sys.ui.listview.rowtable"  
				name="rowtable" onRowClick="" rowHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}" 
				style="" target="_blank"> 
				<list:row-template ref="sys.ui.listview.rowtable">
				{
					showOtherProps:"docReadCount;docScore"
				}
				</list:row-template>
			</list:rowTable>
		</list:listview> 
	 	<list:paging channel="multidoc"></list:paging>
	</template:replace>
</template:include>

