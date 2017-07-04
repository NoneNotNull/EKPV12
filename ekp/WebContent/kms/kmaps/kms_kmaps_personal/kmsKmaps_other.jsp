<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:criteria id="kmsKmapsCriteria" expand="true">
			<c:if test="${empty TA}">
				<c:set var="TA" value="ta"/>
			</c:if>		
			<%--与TA相关--%>
			<list:cri-criterion title="${lfn:message(lfn:concat('kms-kmaps:km.kmap.zone.', TA)) }" key="_mydoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myOriginal" cfg-required="true">
						<ui:source type="Static">
							[
							{text:"${lfn:message(lfn:concat('kms-kmaps:km.kmap.original.', TA)) }", value:'myOriginal'},
							{text:"${lfn:message(lfn:concat('kms-kmaps:km.kmap.create.', TA)) }", value: 'myCreate'},
							{text:"${lfn:message(lfn:concat('kms-kmaps:km.kmap.eva.', TA)) }",value:'myEva'},
							{text:"${lfn:message(lfn:concat('kms-kmaps:km.kmap.intro.', TA)) }",value:'myIntro'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
	     <%-- 按钮 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='color: #979797;width: 39px'>
						${lfn:message('kms-kmaps:km.kmap.listOrder')}：
					</td>
					<%--排序按钮  --%>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
							<list:sort property="kmsKmapsMain.docReadCount" text="${lfn:message('kms-kmaps:km.kmap.readCount')}" group="sort.list"></list:sort>
						</ui:toolbar> 
					</td>
					<%--操作按钮  --%>
					<td align="right">
						<ui:toolbar count="3"> 
							<%-- 新增--%>
							<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
								<ui:button text="${lfn:message('button.add')}" onclick="addMaps()"></ui:button>
							</kmss:auth>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=listPerson&personType=other&userId=${param.userId}'}
			</ui:source>
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=view&fdId=!{fdId}"> 
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docSubject')}" headerStyle="width:40%" style="text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['docSubject']%}</span>
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docCreator')}" >
					{$
						<span class="com_author">{%row['docCreator.fdName']%}</span>  
					$}
				</list:col-html>
				<list:col-auto props="docCategory.fdName;docCreateTime"></list:col-auto>
			</list:colTable>
			
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
<script>
//新建

function addMaps() {
	seajs.use(['lui/dialog'], function(dialog) {
		dialog
				.simpleCategoryForNewFile(
						'com.landray.kmss.kms.kmaps.model.KmsKmapsCategory',
						'/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add&categoryId=!{id}',
						false,null,null,'${param.categoryId}');
	});
}
</script>
