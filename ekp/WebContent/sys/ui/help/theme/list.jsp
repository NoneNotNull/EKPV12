<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="path">
		<%-- 路径 --%>
		<ui:menu layout="sys.ui.menu.nav">
			<ui:menu-item text="首页" icon="lui_icon_s_home" href="#" target="_self" />
			<ui:menu-item text="知识中心" href="#" target="_self" />
			<ui:menu-source autoFetch="true" target="_self" href="#">
				<ui:source type="AjaxJson">
					{"url":"/sys/ui/help/menu/pathdata-example.jsp?currId=!{value}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<%@ include file="nav.jsp" %>
		<%@ include file="changeheader.jsp" %>
		
		<%-- 所有分类 --%>
		<div class="lui_list_cate_all" data-lui-switch-class="lui_list_cate_toggle_up">
			<div class="lui_list_cate_all_content">
				<div class="lui_list_cate_all_txt">所有分类-顶部</div>
				<div class="lui_list_cate_toggle"></div>
			</div>
			<ui:popup align="down-left" style="background:white;" >
				<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.cate" render="sys.ui.cate.default"/>
				<ui:event event="show">
					this.element.css('width',this.positionObject.width());
				</ui:event>
			</ui:popup>
		</div>
		<%-- 新建按钮 --%>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="知识中心" />
			<ui:varParam name="button">
				[
					{
						"text": "新建知识",
						"href": "#",
						"icon": "lui_icon_l_icon_1"
					}
				]
			</ui:varParam>				
		</ui:combin>
		<%-- 操作导航 --%>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<ui:content style="padding:0px;" title="当前分类-平面">
					<ui:menu layout="sys.ui.menu.ver.cate.slide">
						<ui:menu-source href="#" target="_self">
							<ui:source type="AjaxJson">
								{"url":"/sys/ui/resources/example.jsp?code=sys.ui.cate"} 
							</ui:source>
						</ui:menu-source>
					</ui:menu>
					<ui:operation href="javascript:void(0);" name="上一级" target="_self" align="left" />
					<ui:operation href="javascript:openPage('listhelp.jsp');" name="样式使用" target="_self" />
				</ui:content>
				
				<ui:content style="padding:0px;" title="所有分类-层级">
					<ui:dataview>
						<ui:source type="AjaxJson">
							{"url":"/sys/ui/resources/example.jsp?code=sys.ui.cate"} 
						</ui:source>
						<ui:render type="Template">
							{$
								<div class="lui_list_nav_curPath_frame">
									<div class="lui_icon_s lui_icon_s_icon_position"></div>
									<div class="lui_list_nav_curPath">{% env.fn.formatText(data[0].text)%}</div>
								</div>
							$}
						</ui:render>
					</ui:dataview>
					<ui:menu layout="sys.ui.menu.ver.default">
						<ui:menu-source href="#" target="_self">
							<ui:source type="AjaxJson">
								{"url":"/sys/ui/resources/example.jsp?code=sys.ui.cate"} 
							</ui:source>
						</ui:menu-source>
					</ui:menu>
				</ui:content>
				
				
				<ui:content title="单层级导航">
					<ul class="lui_list_nav_list">
						<li class="lui_list_nav_selected"><a href="javascript:void(0)" onclick="openQuery();" title="选中样式">选中样式</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></li>
					</ul>
				</ui:content>
				
				<ui:content title="二层级导航">
					<dl class="lui_list_nav_dl">
						<dt class="lui_list_nav_dt_selected"><a href="javascript:void(0)" onclick="openQuery();" title="选中样式">选中样式</a></dt>
						<dd><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dd>
						<dd><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dd>
						<dd><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dd>
					</dl>
					<dl class="lui_list_nav_dl">
						<dt><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dt>
						<dd class="lui_list_nav_selected"><a href="javascript:void(0)" onclick="openQuery();" title="选中样式">选中样式</a></dd>
						<dd><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dd>
						<dd><a href="javascript:void(0)" onclick="openQuery();" title="普通样式">普通样式</a></dd>
					</dl>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">
		<%-- 筛选器 --%>
		<list:criteria>
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject" title="标题" />
			<list:cri-ref key="docStatus" ref="criterion.sys.docStatus" title="文档状态" multi="true" />
			<list:cri-ref key="docCreator" ref="criterion.sys.person" title="创建者" />
			<list:cri-ref key="docDept" ref="criterion.sys.dept" title="所属部门" />
			<list:cri-ref key="docCreated" ref="criterion.sys.calendar" title="创建时间" />
			<list:cri-ref key="fdNumber" ref="criterion.sys.num" title="数字" />
			<list:cri-ref key="fdString" ref="criterion.sys.string" title="字符" />
			<list:cri-group title="其它选项">
				<list:group-ref key="pdocStatus" ref="criterion.sys.docStatus.popup" title="文档状态" multi="true" />
				<list:group-ref key="pdocCreator" ref="criterion.sys.person.popup" title="创建者" />
				<list:group-ref key="pdocDept" ref="criterion.sys.dept.popup" title="所属部门" />
				<list:group-ref key="pdocCreated" ref="criterion.sys.calendar.popup" title="创建时间" />
				<list:group-ref key="pfdNumber" ref="criterion.sys.num.popup" title="数字" />
				<list:group-ref key="pfdString" ref="criterion.sys.string.popup" title="字符" />
			</list:cri-group>
		</list:criteria>
		
		<%-- 操作条 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='width: 70px;'>
						排序方式：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docCreateTime" text="创建时间" value="down" group="sort.list" />
							<list:sort property="docPublishTime" text="发布时间" group="sort.list" />
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3">
							<ui:togglegroup order="0">
							    <ui:toggle icon="lui_icon_s_zaiyao" selected="true" group="tg_1" text="列表" value="columntable"
									onclick="LUI('listview').switchType(this.value);" />
								<ui:toggle icon="lui_icon_s_liebiao" value="rowtable"  group="tg_1" text="摘要" 
									onclick="LUI('listview').switchType(this.value);" />
								<ui:toggle icon="lui_icon_s_tuwen" value="gridtable"  group="tg_1" text="图文" 
									onclick="LUI('listview').switchType(this.value);" />
							</ui:togglegroup>
							<ui:button text="操作确认" onclick="confirm()" order="2"></ui:button>
							<ui:button text="成功提示" onclick="success()" order="2"></ui:button>	
							<ui:button text="失败提示" onclick="failure()" order="2"></ui:button>	
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%-- 视图 --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/ui/help/listview/listdata-example.jsp'}
			</ui:source>
			<list:colTable rowHref="#" name="columntable" target="_self" layout="sys.ui.listview.columntable">
				<list:col-checkbox />
				<list:col-serial /> 
				<list:col-html title="标题" style="text-align:left">
				{$ <span class="com_subject">{%row['docSubject']%}</span> $}
				</list:col-html>
				<list:col-auto props="docAuthor.fdName;docDept.fdName;docPublishTime;docStatus" />
			</list:colTable>
			<list:rowTable rowHref="#" name="rowtable" target="_self">
				<list:row-template ref="sys.ui.listview.rowtable" />
			</list:rowTable>
			<list:gridTable gridHref="#" name="gridtable" target="_self">
				<list:row-template ref="sys.ui.listview.gridtable" />
			</list:gridTable>
		</list:listview> 
		 
	 	<list:paging></list:paging>
	 	
		<script type="text/javascript">
			SYS_SEARCH_MODEL_NAME = "KmReviewMain";
			function confirm(){
				seajs.use(['lui/dialog'], function(dialog){
					dialog.confirm('操作提示');
				});
			}
			function success(){
				seajs.use(['lui/dialog'], function(dialog){
					var loading = dialog.loading();
					setTimeout(function(){
						loading.hide();
						dialog.success('操作成功');
					}, 1000);
				});
			}
			function failure(){
				seajs.use(['lui/dialog'], function(dialog){
					var loading = dialog.loading();
					setTimeout(function(){
						loading.hide();
						dialog.failure('操作失败');
					}, 1000);
				});
			}
		</script>
	</template:replace>
</template:include>