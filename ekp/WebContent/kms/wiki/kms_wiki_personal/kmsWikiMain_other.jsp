<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	<list:criteria id="kmsWikiCriteria" expand="true" >
		<c:if test="${empty TA}">
			<c:set value="ta" var="TA"/>
		</c:if>		 
		<%--与TA相关--%>
		<list:cri-criterion title="${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.', TA))}" key="_mydoc" multi="false">
			<list:box-select>
				<list:item-select cfg-defaultValue="myCreate" cfg-required="true">
					<ui:source type="Static">
						[{text:"${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.create.', TA))}", value:'myCreate'},
						{text:"${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.perfect.', TA))}", value:'myEd'},
						{text:"${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.intro.', TA))}",value:'myIntro'},
						{text:"${lfn:message(lfn:concat('kms-wiki:kmsWikiMain.zone.eva.', TA))}",value:'myEva'}]
					</ui:source>
				</list:item-select>
			</list:box-select>
		</list:cri-criterion>
	</list:criteria>
    <div class="lui_list_operation">
		<table width="100%">
			<tr>
				<td style='color: #979797;width: 45px;text-align: center'>
					${ lfn:message('kms-wiki:kmsWiki.list.orderType') }：
				</td>
				<%--排序按钮  --%>
				<td>
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
						<list:sort property="docPublishTime" text="${lfn:message('kms-wiki:kmsWiki.list.orderDocPublishTime') }" group="sort.list"></list:sort>
						<list:sort property="fdLastModifiedTime" text="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }" group="sort.list" value="down"></list:sort>
						<list:sort property="fdVersion" text="${lfn:message('kms-wiki:kmsWiki.rightInfo.addVersionTimes') }" group="sort.list"></list:sort>
						<list:sort property="docReadCount" text="${lfn:message('kms-wiki:kmsWiki.list.readCountTimes') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</td>
				<%--操作按钮  --%>
				<td align="right">
					<ui:toolbar count="4">
						<%-- 新增--%>
						<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
							<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="1"></ui:button>
						</kmss:auth>
					</ui:toolbar>
				</td>
			</tr>
		</table>
	</div>
	<ui:fixed elem=".lui_list_operation"></ui:fixed>
	<list:listview id="listview" >
		<ui:source type="AjaxJson">
			{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=listPerson&userId=${param.userId}&personType=other'}
		</ui:source>
		<list:colTable layout="sys.ui.listview.columntable" name="columntable"
			rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
			<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_col_tmpl.jsp"  %>
		</list:colTable>
	</list:listview>
 	<list:paging></list:paging>
	<script>
	//新建
	function addDoc() {
		seajs.use(['lui/dialog'], function(dialog) {
			dialog
					.simpleCategoryForNewFile(
							'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
							'/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=!{id}',
							false,null,null,'${param.categoryId}',null,null,{'fdTemplateType':'2,3'});
		});
	}
	</script>