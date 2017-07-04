<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-imissive:kmImissive.tree.title') }"></c:out>
	</template:replace>
   <template:replace name="path"> 
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-item text="公文交换" href="/km/imissive/km_imissive_reg/index.jsp" target="_self">
				<ui:menu-item text="发文管理" href="/km/imissive/index.jsp" target="_self"></ui:menu-item>
				<ui:menu-item text="收文管理" href="/km/imissive/km_imissive_receive_main/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="签报" href="/km/imissive/km_imissive_sign_main/index.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<div class="lui_list_nav_frame">
	      <ui:accordionpanel>
				<c:import url="/km/imissive/import/nav.jsp" charEncoding="UTF-8">
				   <c:param name="key" value="regdetail"></c:param>
				    <c:param name="criteria" value="regDetailCriteria"></c:param>
				</c:import>
		  </ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">  
	    <list:criteria id="regDetailCriteria">
	      <list:cri-ref key="docSubject" ref="criterion.sys.docSubject"> 
		  </list:cri-ref>
		  <list:cri-auto modelName="com.landray.kmss.km.imissive.model.KmImissiveRegDetailList" property="fdStatus" expand="true"/>
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
					{url:'/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&owner=true'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>
	 	<script type="text/javascript">
	 	  var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.imissive.model.KmImissiveRegDetailList";
	 	</script>
	</template:replace>
</template:include>
