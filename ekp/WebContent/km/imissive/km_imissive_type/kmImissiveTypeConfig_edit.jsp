<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	  <ui:content title="${lfn:message('sys-follow:sysFollow.config.category')}">
		<table id="categoryTable" class="tb_normal " width="100%">
		    <tr class="tr_normal_title">
				<td colspan="3">
					<ui:button onclick="submitCategory();" title="${lfn:message('button.save')}" text="${lfn:message('button.save')}" />
					<ui:button onclick="AddNewRow();" title="${lfn:message('button.create')}" text="${lfn:message('button.create')}" />
					<ui:button onclick="DeleteCheckedRow();" title="${lfn:message('button.delete')}" text="${lfn:message('button.delete')}" />
				</td>
			</tr>
			<tr class="tr_normal_title">
				<td width="5%">
					<input type="checkbox" name="all">
				</td>
				<td width=30%>
					序号
				</td>
				<td width=50%>
					名称
				</td>
			</tr>
			<!--基准行 -->
			<tr style="display:none;" KMSS_IsReferRow="1">
				<td align="center">
					<input type="checkbox" name="categories[!{index}].selected" value="1">
					<input type="hidden" name="categories[!{index}].fdId" value="">
				</td>
				<td>
				    <input type="text" name="categoryModule[!{index}].fdOrder" value="">
				</td>
				<td>
				    <input type="text" name="categoryModule[!{index}].fdName" value="">
				</td>
			</tr>
			<c:forEach items="${rtnCategoryMap}" var="category" varStatus="vstatus">
			<tr KMSS_IsContentRow="1" >
				<td align="center">
					<input type="checkbox" name="categories[${vstatus.index}].selected" value="1">
					<input type="hidden" name="categories[${vstatus.index}].fdId" value="${category.value.fdId }">
				</td>
				<td>
					<input type="text" name="categoryModule[${vstatus.index}].fdOrder" 
						value="${category.value.fdOrder}">
				</td>
				<td>
				     <input type="text" name="categoryModule[${vstatus.index}].fdName" 
						value="${category.value.fdName}">
				</td>
			</tr>
			</c:forEach>
		</table>
	  </ui:content>
		
		<script>Com_IncludeFile("dialog.js");</script>
		<script>Com_IncludeFile('jquery.js');</script>
		<script>Com_IncludeFile('doclist.js|validator.jsp|validation.js|plugin.js|validation.jsp');</script>
		<script>DocList_Info.push('categoryTable');</script>
		<script>
		var cateValidator = $KMSSValidation(document.getElementById("categoryTable"));
		
		$(document).ready(function() {
			//全选
			$('#categoryTable').delegate("[name='all']", "click", function(event) {
				var selected = this.checked;
				$('#categoryTable [name$="selected"]').each(function() {
					this.checked = selected;
				});
			});
			//临时数组保存分类订阅的模块
			$('input[name$="fdId"]').each(function() {
				followedArray.push($(this).val());
			});
			
			$('#categoryTable').delegate('select[name$=".fdModule"]', 'change', function(event) {
				var tr = $(event.target).closest('tr');
				tr.find('[name^="categoryIds"], [name^="categoryNames"]').val("");
			});
		});
		function CheckSelectedItems() {
			if ($('#categoryTable [name$="selected"]:checked').length == 0) {
				seajs.use(["lui/dialog"], function(dialog) {
					dialog.alert(window.placeSelectOptionDatas ? placeSelectOptionDatas : "${lfn:message('page.noSelect')}");
				});
				return false;
			}
			return true;
		}
		//计算被删除分类订阅的模块
		function getDeleteModelNames(){
			
			//被删除的分类的订阅数组
			if (followedArray.length <= 0)
				return [];
			var followDeleteModelNames = [];
			var saveString = "";
			$('[name$="fdId"]').each(function() {
				saveString += $(this).val() + ",";
			});
			for(var i = 0; i < followedArray.length; i ++) {
				if(saveString.indexOf(followedArray[i]) == -1) {
					followDeleteModelNames.push(followedArray[i]);
				}
			}
			return followDeleteModelNames;
		
		}
		function submitCategory() {
			if(!cateValidator.validate())
				return;
			seajs.use(['lui/dialog'],function(dialog){
				var _followConfig = getFollowCategoryConfig();
				var loading = dialog.loading();
				var config = {	
						followConfig: _followConfig,
						followDeleteModelNames:getDeleteModelNames()
				};
				$.ajax({
					url: '${ LUI_ContextPath}/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do?method=update',
					type: 'POST',
					dataType: 'json',
					async: false,
					data: config,
					success: function(data, textStatus, xhr) {
						loading.hide();
						if (data && data['flag'] === true) {
							dialog.success("${lfn:message('return.optSuccess')}", $("#categoryTable"));
						}else {
							dialog.failure("${lfn:message('return.optFailure')}", $("#categoryTable"));
						}
					},
					error: function(xhr, textStatus, errorThrown) {
						loading.hide();
						dialog.failure("${lfn:message('return.optFailure')}", $("#categoryTable"));
					}
				});
			});
		}
		function getFollowCategoryConfig(){
			var followConfig = [];
			var hasNoSelect = false;
			$("#categoryTable").find('tr[class!=tr_normal_title]').each(
				function() {
					var  _fdFollowIds = $(this).find("[name^='fdOrder']").val(),
					    _fdFollowNames = $(this).find("[name^='fdName']").val();
						followConfig.push({
							fdFollowIds: _fdFollowIds,
							fdFollowNames: _fdFollowNames
						});
				}
			);
			if(hasNoSelect) 
				return "hasNoSelect";
			return JSON.stringify(followConfig);
		}
		
		function AddNewRow() {
			DocList_AddRow('categoryTable');
		}
		function DeleteCheckedRow() {
			if(!CheckSelectedItems())
				return false;
			seajs.use(["lui/dialog"], function(dialog) {
				dialog.confirm("${lfn:message('sys-follow:sysFollow.config.confirm.delete')}", function(rtn) {
					if(!rtn) return;
					$($('#categoryTable [name$="selected"]:checked').get().reverse()).each(function() {
						DocList_DeleteRow($(this).closest('tr')[0]);
					});
					submitCategory();
					FixCategoryModelSelector();
				});
			});
		}
		//让已选的失效
		function FixCategoryModelSelector() {
			var selectedVal = [];
			$('[name$="fdModule"]').each(function() {
				selectedVal.push($(this).val());
			});
			var constains = function(array, item) {
				for (var i = 0; i < array.length; i ++) {
					if (array[i] == item) {
						return true;
					}
				}
				return false;
			};
			$('select[name$="fdId"]').each(function() {
				var si = this.options.selectedIndex;
				for (var i=0 ; i<this.options.length; i ++) {
					var opt = this.options[i];
					if (si != i && constains(selectedVal, opt.value)) {
						opt.disabled = true;
					} else if(!constains(selectedVal, opt.value)) {
						opt.disabled = false;
					}
				}
			});
		}
		</script>
		
		<script>
			//已经订阅的分类的modelname数组
			var followedArray = [];
			
		</script>
	</template:replace>
</template:include>