<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.navlink">
	<c:set var="TA" value="${empty param.zone_TA ? 'ta' : param.zone_TA}"/>
	<c:set var="userId" value="${empty param.userId ? KMSS_Parameter_CurrentUserId : param.userId}"/>
	<template:replace name="title">
		<c:out value="${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.', TA))}"/>
	</template:replace>
	<template:replace name="content">
		<ui:tabpanel layout="sys.zone.tabpanel.default">
                <ui:content title="${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.create.', TA))}" />
                <ui:content title="${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.perfect.', TA))}" />
                <ui:content title="${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.intro.', TA))}"  />
                <ui:content title="${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.eva.', TA))}"  />
                <ui:event event="indexChanged" args="data">
                	var selectValue;
                	switch(data.index.after) {
                		case 0 :  selectValue = "myCreate"; break;
                		case 1 :  selectValue = "myEd"; break;
                		case 2 :  selectValue = "myIntro"; break;
                		case 3 :  selectValue = "myEva"; break;
                		default : break;
                	}
                      seajs.use("lui/topic", function(topic) {
                           topic.channel( "wiki").publish('criteria.changed' ,
                                       { criterions: [{key:"_mydoc" , value:[selectValue]}]});
                     });

                </ui:event>
          </ui:tabpanel>
		  <list:listview channel="wiki" >
				<ui:source type="AjaxJson">
					{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=listPerson&userId=${userId}&personType=other&rowsize=8&orderby=docPublishTime&ordertype=down'}
				</ui:source>
				<list:rowTable layout="sys.ui.listview.rowtable" 
					name="rowtable" onRowClick="" rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}" 
					style="" target="_blank" isDefault="true">
					<list:row-template ref="sys.ui.listview.rowtable">
						{showOtherProps:'docPublishTime,editTimes,docReadCount,docScore'}
					</list:row-template>
				</list:rowTable> 
			</list:listview> 
		 	<list:paging channel="wiki"></list:paging>
	</template:replace>
</template:include>