<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content"> 
		<script type="text/javascript">
			Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js", null, "js");
			
			function showCategoryTreeDialog() {
				var dialog = new KMSSDialog(false, false);
				var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>');
				node.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all", null, null, null, '${sysBookmarkPublicCategoryForm.fdId}');
				dialog.winTitle = '<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>';
				dialog.BindingField('fdParentId', 'fdParentName');
				dialog.Show();
				return false;
			}
			
			function getSaveData(){
				var cfg ={};
				LUI.$("#_bookmark_main :input").each(function(){
					var thisObj = LUI.$(this);
					cfg[thisObj.attr('name')] = thisObj.val();
				});
				return cfg;
			}
	seajs.use(['lui/jquery'], function($) {	
			Com_AddEventListener(window, "load", function(){
				var S_Valudator = $GetKMSSDefaultValidation(null);
				LUI.$("input[name='fdName']").each(function(){
					 S_Valudator.addElements(this);
				 });
				//保存按钮事件
				LUI.$("#_save").click(function(){
					if(!S_Valudator.validate()){
						return ;
					}
					var xdata = getSaveData();
					LUI.$.post(Com_Parameter.ContextPath+"sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do?method=save",
							LUI.$.param(xdata,true),function(json){
								if(json != null && json.status == true){
									if(parent._bookmark_cate_refresh){
										parent._bookmark_cate_refresh(true);
									}
								}else{
									seajs.use(['lui/dialog'],function(dialog){
										dialog.failure('<bean:message key="return.optFailure" />');
									});
								}
							},"json");
				});
				//取消按钮事件
				LUI.$("#_close").click(function(){
					if(parent._bookmark_cate_refresh){
						parent._bookmark_cate_refresh(false);
					}
				});
			});

	});
		</script>
		<table class="tb_simple" id="_bookmark_main" width=100%>
			<tr>
				<td colspan="2" align="right" style="padding-right: 5%;border-bottom: 1px #ccc solid;">
					<ui:button text="${lfn:message('button.ok')}"  id="_save"></ui:button>
						&nbsp;&nbsp;&nbsp;
					<ui:button text="${lfn:message('button.cancel')}"  id="_close" styleClass="lui_toolbar_btn_gray"></ui:button>
				</td>
			</tr>
			<tr>
				<td colspan="2" >
						&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			<%-- 分类名称 --%>
			<tr>
				<td class="td_normal_title" width=20%>
					<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdName"/>
				</td>
				<td>
					<xform:text property="fdId" showStatus="noShow"></xform:text>
					<xform:text property="fdName" required="true" isLoadDataDict="false" subject="${lfn:message('sys-bookmark:sysBookmarkPersonCategory.fdName') }" style="width: 94%;" ></xform:text>
				</td>
			</tr>
			<%-- 所属类别 --%>
			<tr>
				<td class="td_normal_title" width=20%>
					<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdParentId"/>
				</td>
				<td>
					<xform:dialog propertyId="fdParentId" propertyName="fdParentName" style="width:95%" 
						dialogJs="showCategoryTreeDialog();"></xform:dialog>
				</td>
			</tr>
			<%-- 排序号 --%>
			<tr>
				<td class="td_normal_title" width=20%>
					<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdOrder"/>
				</td>
				<td>
					<xform:text property="fdOrder" style="width:94%"/>
				</td>
			</tr>
		</table>
	</template:replace>
</template:include>
