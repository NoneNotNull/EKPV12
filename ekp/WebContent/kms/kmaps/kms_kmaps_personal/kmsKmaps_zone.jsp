<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.navlink">
	<c:set var="TA" value="${empty param.zone_TA ? 'ta' : param.zone_TA}"/>
	<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
	<template:replace name="title">
		<c:out value="${lfn:message(lfn:concat('kms-kmaps:km.kmap.zone.', TA))}"></c:out>
	</template:replace>
	<template:replace name="content">
		<ui:tabpanel layout="sys.zone.tabpanel.default">
                <ui:content title="${lfn:message(lfn:concat('kms-kmaps:km.kmap.original.', TA)) }" />
                <ui:content title="${lfn:message(lfn:concat('kms-kmaps:km.kmap.create.', TA)) }" />
                <ui:content title="${lfn:message(lfn:concat('kms-kmaps:km.kmap.intro.', TA)) }"  />
                <ui:content title="${lfn:message(lfn:concat('kms-kmaps:km.kmap.eva.', TA)) }"  />
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
                           topic.channel( "map").publish('criteria.changed' ,
                                       { criterions: [{key:"_mydoc" , value:[selectValue]}]});
                     });

                </ui:event>
          </ui:tabpanel>
          <list:listview id="listview" channel="map">
			<ui:source type="AjaxJson">
				{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=listPerson&rowsize=8&personType=other&userId=${userId}&orderby=docPublishTime&ordertype=down'}
			</ui:source>
			<list:rowTable layout="sys.ui.listview.rowtable" 
						name="rowtable" onRowClick="" 
						rowHref="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=view&fdId=!{fdId}"
						style="" target="_blank"> 
						<list:row-template ref="sys.ui.listview.rowtable">
						{
							showOtherProps:"docReadCount;docScore"
						}
						</list:row-template>
				</list:rowTable>
		  </list:listview>
		  <list:paging channel="map"></list:paging>
	</template:replace>
</template:include>
