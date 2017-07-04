<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="stat_key" value="dept.stat"></c:set>
<c:if test="${param['stat_key']!=null && param['stat_key']!=''}">
	<c:set var="stat_key" value="${param['stat_key']}"></c:set>
</c:if>
<template:include ref="default.list">
	<%-- 标签页标题 --%>
	<template:replace name="title">
		<c:out value="${lfn:message('km-imeeting:module.km.imeeting')}"></c:out>
	</template:replace>
	
	<template:replace name="head">
		<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/data/source','lui/menu','lui/toolbar'], 
				function($, dialog , topic, source , menu , toolbar) {
				//新建
				window.addDoc = function(addUrl) {
					Com_OpenWindow('${LUI_ContextPath}' + addUrl,'_blank');	
				};
				//删除
				window.delDoc = function(delUrl){
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							var del_load = dialog.loading();
							$.post('${LUI_ContextPath}' + delUrl,
									$.param({"List_Selected":values},true),function(data){
										if(del_load!=null)
											del_load.hide();
										if(data!=null && data.status==true){
											topic.publish("list.refresh");
											dialog.success('<bean:message key="return.optSuccess" />');
										}else{
											dialog.failure('<bean:message key="return.optFailure" />');
										}
									},'json');
						}
					});
				};
			});
		</script>
	</template:replace>
	
	<%-- 导航路径 --%>
	<template:replace name="path"> 
		<ui:combin ref="kmImeeting.stat.path">
			<ui:varParam name="id" value="pathMenu"></ui:varParam>
			<ui:varParam name="items">
				[{
						text:'<bean:message key="km-imeeting:kmImeetingStat.${stat_key}"/>',
						href:"#"
				}]
			</ui:varParam>
		</ui:combin>
	</template:replace>

	<%-- 左侧导航栏 --%>
	<template:replace name="nav">
		
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-imeeting:kmImeeting.tree.title') }"></ui:varParam>
			<%-- 会议导航 --%>
			<ui:varParam name="button">
				[
				   <kmss:authShow roles="ROLE_KMIMEETING_STAT_MAINTAINER">
					{
						"text": "${lfn:message('km-imeeting:table.kmImeetingStat')}",
						"href":"javascript:addDoc('/km/imeeting/km_imeeting_stat/kmImeetingStat.do?method=add&fdType=${stat_key}');",
						"icon": "lui_icon_l_icon_41"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<c:import url="/km/imeeting/import/nav.jsp" charEncoding="UTF-8">
					<c:param name="key" value="stat"></c:param>
				   	<c:param name="criteria" value=""></c:param>
				</c:import>
			</ui:accordionpanel>
		</div>
	
	</template:replace>
	
	<%-- 右侧列表 --%>
	<template:replace name="content">
		<%-- 操作栏 --%>
		<div class="lui_list_operation">
		<table width="100%">
			<tr>
				<td align="right">
					<ui:toolbar count="3" id="listToolbar"> 
						<kmss:authShow roles="ROLE_KMIMEETING_STAT_MAINTAINER">
							<ui:button text="${lfn:message('button.add')}" 
								onclick="addDoc('/km/imeeting/km_imeeting_stat/kmImeetingStat.do?method=add&fdType=${stat_key}');">
							</ui:button>
							<ui:button text="${lfn:message('button.delete')}" 
								onclick="delDoc('/km/imeeting/km_imeeting_stat/kmImeetingStat.do?method=deleteall');">
							</ui:button>
						</kmss:authShow>
					</ui:toolbar>
				</td>
			</tr>
		</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%-- 列表视图 --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/imeeting/km_imeeting_stat/kmImeetingStat.do?method=list&fdType=${stat_key}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="!{fdUrl}" name="columntable">
				<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
				<list:col-html  title="${ lfn:message('km-imeeting:kmImeetingStat.fdName') }" style="text-align:left">
				 {$ <span class="com_subject" >{%row['fdName']%}</span> $}
				</list:col-html>
				<list:col-auto props="docCreator.fdName;docCreateTime"></list:col-auto>
			</list:colTable>
		</list:listview>
	 	<list:paging></list:paging>
		
	</template:replace>


</template:include>