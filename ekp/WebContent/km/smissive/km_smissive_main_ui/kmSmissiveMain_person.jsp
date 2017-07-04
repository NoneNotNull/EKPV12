<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-smissive:table.kmSmissiveMain') }"></c:out>
	</template:replace>
	<template:replace name="content">  
		<list:criteria id="criteria1" expand="true">
			<list:cri-criterion title="${ lfn:message('km-smissive:smissive.Doc.my') }" key="selfdoc" multi="false">
				<list:box-select>
					<list:item-select id="mydoc1" cfg-required="true" cfg-defaultValue="create">
						<ui:source type="Static">
							[{text:'${ lfn:message('km-smissive:smissive.create.my') }', value:'create'}
							,{text:'${ lfn:message('km-smissive:smissive.approval.my') }',value:'approval'}
							, {text:'${ lfn:message('km-smissive:smissive.approved.my') }', value: 'approved'}
							,{text:'${ lfn:message('km-smissive:smissive.sign.my') }', value: 'sign'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
							var vals = evt.values;
							if (vals.length > 0 && vals[0] != null) {
								var val = vals[0].value;
								if (val == 'create') {
									LUI('status1').setEnable(true);
									LUI('status2').setEnable(false);
								} else if (val == 'approved'||val == 'sign') {
								    LUI('status1').setEnable(false);
									LUI('status2').setEnable(true);
								}else {
									LUI('status1').setEnable(false);
									LUI('status2').setEnable(false);
								}
							}
						</ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select id="status1" cfg-enable="true">
						<ui:source type="Static">
							[{text:'${ lfn:message('status.draft')}', value:'10'}
							,{text:'${ lfn:message('status.examine')}',value:'20'}
							,{text:'${ lfn:message('status.refuse')}',value:'11'}
							,{text:'${ lfn:message('status.discard')}',value:'00'}
							,{text:'${ lfn:message('status.publish')}',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select  id="status2" cfg-enable="false">
						<ui:source type="Static">
							[{text:'${ lfn:message('status.examine')}',value:'20'}
							,{text:'${ lfn:message('status.refuse')}',value:'11'}
							,{text:'${ lfn:message('status.discard')}',value:'00'}
							,{text:'${ lfn:message('status.publish')}',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='width: 70px;'>
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docCreateTime" text="${lfn:message('km-smissive:kmSmissiveMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
							<list:sort property="docPublishTime" text="${lfn:message('km-smissive:kmSmissiveMain.docPublishTime') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
					<ui:toolbar count="3">
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp"
								charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
							</c:import>
							<kmss:authShow roles="ROLE_KMSMISSIVE_CREATE">
							<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add" requestMethod="GET">
							<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>
							</kmss:auth>
							<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="3"></ui:button>
							</kmss:auth>
							</kmss:authShow>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
								<c:param name="authReaderNoteFlag" value="2" />
							</c:import>							
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
								<c:param name="docFkName" value="fdTemplate" />
								<c:param name="cateModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
							</c:import>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/smissive/km_smissive_main/kmSmissiveMainIndex.do?method=listChildren'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-html  title="${ lfn:message('km-smissive:kmSmissiveMain.docSubject') }" style="text-align:left">
				  {$ <span class="com_subject" title="{%row['docSubject']%}" >{%row['docSubject']%}</span> $}
				</list:col-html>
				<list:col-auto props="fdFileNo;docAuthor.fdName;fdMainDept.fdName;docPublishTime;docStatus"></list:col-auto>
			</list:colTable>
			<list:rowTable isDefault="false"
				rowHref="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=!{fdId}" name="rowtable" >
				<list:row-template ref="sys.ui.listview.rowtable">
				</list:row-template>
			</list:rowTable>
		</list:listview>
	 	<list:paging></list:paging>	 
	 	<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//新建
				window.addDoc = function() {
						dialog.simpleCategoryForNewFile(
								'com.landray.kmss.km.smissive.model.KmSmissiveTemplate',
								'/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=!{id}',false,null,null,'${param.categoryId}');
				};
				//删除
				window.delDoc = function(){
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
							window.del_load = dialog.loading();
							$.post('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				window.delCallback = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
			});
		</script>	 
	</template:replace>
</template:include>
