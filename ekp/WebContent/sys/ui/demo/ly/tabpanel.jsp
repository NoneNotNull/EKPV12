<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
	tabpage 样例 Demo <br>
		<center>
		<table border="1" height="600">
			<tr>
				<td width="300px;" >
					<ui:tabpanel style="width:90%;margin-left:15px;" id="sss" height="150" scroll="true"> 
					<%--
						<ui:layout ref="sys.ui.tabpanel.default"></ui:layout>
					 --%>
					 	<%--
						<ui:layout ref="sys.ui.tabpanel.light"></ui:layout>
						 --%>
					 	<ui:layout type="Template">
					 	var extend = (param!=null && param.extend!=null)?('_'+param.extend):'';
					 	extend = "_light"
					 	{$
							<div class='lui_tabpanel{%extend%}_frame'>
								<div class='lui_tabpanel{%extend%}_navs_l'>
									<div class='lui_tabpanel{%extend%}_navs_r'>
										<div class="lui_tabpanel{%extend%}_navs_c clearfloat">
						$}
						for(var i=0;i<layout.parent.contents.length;i++){
							{$
											<div class='lui_tabpanel{%extend%}_navs_item_l' data-lui-mark="panel.nav.frame" data-lui-switch-class="lui_tabpanel{%extend%}_navs_item_selected">
												<div class='lui_tabpanel{%extend%}_navs_item_r'>
													<div class='lui_tabpanel{%extend%}_navs_item_c' data-lui-mark="panel.nav.title">
													</div>
												</div>
											</div>
							$}
						}
						{$			
										</div>
									</div>
								</div>
								<div class="lui_tabpanel{%extend%}_content_l">
									<div class="lui_tabpanel{%extend%}_content_r">
										<div class="lui_tabpanel{%extend%}_content_c" data-lui-mark="panel.contents">
										</div>
									</div>
								</div>
								<div class="lui_tabpanel{%extend%}_footer_l">
									<div class="lui_tabpanel{%extend%}_footer_r">
										<div class="lui_tabpanel{%extend%}_footer_c">
										</div>
									</div>
								</div>
							</div>
						$}
					 	</ui:layout>
						<ui:content title="test1">
							<ui:layout ref="sys.ui.content.default"></ui:layout>
							<ui:dataview format="sys.ui.classic">
								<ui:source ref="sys.ui.demo.source"></ui:source>
							</ui:dataview>
							<ui:operation href="a" name="更多"></ui:operation>
						</ui:content>
						<ui:content title="test2">
							<ui:layout ref="sys.ui.content.default"></ui:layout>
							<ui:dataview format="sys.ui.classic">
								<ui:source ref="sys.ui.demo.source"></ui:source>
							</ui:dataview>
							<ui:operation href="a" name="更多"></ui:operation>
						</ui:content>
					</ui:tabpanel>
					<br><br>
					
					<ui:panel style="width:90%;margin-left:15px;">
						<ui:content title="test3">
							<ui:layout ref="sys.ui.content.default"></ui:layout>
							<ui:dataview format="sys.ui.classic">
								<ui:source ref="sys.ui.demo.source"></ui:source>
							</ui:dataview>
							<ui:operation href="a" name="更多"></ui:operation>
						</ui:content>
					</ui:panel>
				</td>
				<td width="500px;">
					<ui:tabpage style="width:90%;margin-left:15px;">
						<ui:content title="test1">
							内容1
						</ui:content>
						<ui:content title="test2">						
							内容2
						</ui:content>
					</ui:tabpage>
				</td>
				<td width="300px;">
					<ui:accordionpanel style="width:90%;margin-left:15px;">
						<ui:content title="test3">
							内容3
						</ui:content>
						<ui:content title="test4">
							内容4
						</ui:content>
					</ui:accordionpanel>
				</td>
		</table>
			</center>
	</template:replace>
</template:include>