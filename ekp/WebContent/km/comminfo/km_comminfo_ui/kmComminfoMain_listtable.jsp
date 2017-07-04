<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/comminfo/km_comminfo_main/kmComminfoMainIndex.do?method=list&categoryId=${param.categoryId}'}
			</ui:source>
			  <!-- 列表视图 -->	
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial> 
				<list:col-html   title="${ lfn:message('km-comminfo:kmComminfoMain.docSubject') }" style="text-align:left">
				{$ <span class="com_subject">{%row['docSubject']%}</span> $}
				</list:col-html>
				<list:col-auto props="docCategory;docCreator;docCreateTime"></list:col-auto>
			</list:colTable>
		</list:listview> 
		
		<list:paging></list:paging>	 