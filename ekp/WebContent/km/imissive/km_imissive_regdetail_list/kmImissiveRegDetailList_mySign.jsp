<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script>
seajs.use(['theme!form','theme!list']);
</script>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div>
     <list:criteria id="regDetailCriteria">
	      <list:cri-ref key="docSubject" ref="criterion.sys.docSubject"> 
		  </list:cri-ref>
		   <list:cri-criterion title="我的登记单" key="fdStatus" multi="true" channel="true" expand="true">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'待查阅', value:'0'},{text:'待签收',value:'1'},{text:'已签收',value:'2'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
		 </list:cri-criterion>
	 </list:criteria>
	<div class="lui_list_operation">
		<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
		</div>
		<div style="float:left">
			<div style="display: inline-block;vertical-align: middle;">
				<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
					<list:sort property="docCreateTime" text="创建时间" group="sort.list" value="down"></list:sort>
				</ui:toolbar>
		</div>
		</div>
		<div style="float:left;">	
			<list:paging layout="sys.ui.paging.top" > 		
			</list:paging>
		</div>	
	</div>
	<ui:fixed elem=".lui_list_operation"></ui:fixed>
	<list:listview id="listview">
		<ui:source type="AjaxJson">
				{url:'/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&owner=true&mySign=true'}
		</ui:source>
		<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
		</list:colTable>
	</list:listview> 
</div>
</html:form> 
</template:replace>
</template:include>