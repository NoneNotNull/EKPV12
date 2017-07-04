<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-smissive:table.kmSmissiveMain') }"></c:out>
	</template:replace>
	<template:replace name="content">  
		<list:criteria id="criteria1" expand="true">
			<list:cri-criterion title="${ lfn:message(lfn:concat('km-smissive:smissive.Doc.', TA)) }" key="tadoc" multi="false">
				<list:box-select>
					<list:item-select id="tadoc1" cfg-required="true" cfg-defaultValue="create">
						<ui:source type="Static">
							[{text:'${ lfn:message(lfn:concat('km-smissive:smissive.create.', TA)) }', value:'create'}
							,{text:'${ lfn:message(lfn:concat('km-smissive:smissive.sign.', TA)) }', value: 'sign'}]
						</ui:source>
						<ui:event event="selectedChanged" args="evt">
								var vals = evt.values;
								if (vals.length > 0 && vals[0] != null) {
									var val = vals[0].value;
									if (val == 'create') {
										LUI('status1').setEnable(true);
										LUI('status2').setEnable(false);
									} else{
									    LUI('status1').setEnable(false);
										LUI('status2').setEnable(true);
									}
								}
							</ui:event>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select id="status1">
						<ui:source type="Static">
							[{text:'${ lfn:message('status.draft')}',value:'10'}
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
					<list:item-select id="status2">
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
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/smissive/km_smissive_main/kmSmissiveMainIndex.do?method=listChildren&userid=${zone_user.fdId}'}
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
				
			});
		</script>	 
	</template:replace>
</template:include>
