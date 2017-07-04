<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-doc:module.km.doc') }"></c:out>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				moduleTitle="${ lfn:message('km-doc:module.km.doc') }" 
				href="/km/doc/" 
				modelName="com.landray.kmss.km.doc.model.KmDocTemplate" 
				categoryId="${param.categoryId }" />
		</ui:combin>
	</template:replace>
	<template:replace name="nav">
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.km.doc.model.KmDocTemplate" 
				href="/km/doc/" />
		</ui:combin>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-doc:module.km.doc') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMDOC_CREATE">
					{
						"text": "${ lfn:message('km-doc:kmDoc.create.title') }",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_1"
					}
					</kmss:authShow>
				]
			</ui:varParam>				
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
			 	<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
					   href="/km/doc/?categoryId=!{value}"
						modelName="com.landray.kmss.km.doc.model.KmDocTemplate"/>
				</ui:combin>
				<ui:content style="padding:0px;" title="${lfn:message('sys-category:menu.sysCategory.index') }">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.km.doc.model.KmDocTemplate" 
							href="/km/doc/"
							categoryId="${param.categoryId }" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align="left"/>
					</c:if>	
					<ui:operation href="javascript:openPage('${LUI_ContextPath }/km/doc/km_doc_knowledge/kmDocKnowledge_preview.jsp')" name="${lfn:message('sys-category:menu.sysCategory.overview') }" target="_self" />
				</ui:content>
				<ui:content title="${ lfn:message('list.search') }">
				<ul class='lui_list_nav_list'>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docIsIntroduced','1');">${lfn:message('km-doc:kmDoc.tree.introduced')}</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();LUI('criteria1').setValue('docStatus', '30');">${ lfn:message('list.alldoc') }</a></li>
				</ul>
				</ui:content>
				<ui:content title="${ lfn:message('list.otherOpt') }">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=km/doc" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">  
		<list:criteria id="criteria1">
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<list:cri-criterion title="${ lfn:message('km-doc:kmDoc.kmDocKnowledge.my') }" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select> 
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('sys-doc:sysDocBaseInfo.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select cfg-defaultValue="30">
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
			<list:cri-auto modelName="com.landray.kmss.km.doc.model.KmDocKnowledge" 
				property="docAuthor;docDept;docCreateTime;docProperties" />
			<list:cri-criterion title="${ lfn:message('km-doc:kmDoc.tree.othersearch')}" key="docIsIntroduced"> 
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
						    [{text:'${ lfn:message('km-doc:kmDoc.tree.introduced') }', value:'1'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		
		<%@ include file="/km/doc/km_doc_ui/kmDocKnowledge_listview.jsp" %>
	</template:replace>
</template:include>
