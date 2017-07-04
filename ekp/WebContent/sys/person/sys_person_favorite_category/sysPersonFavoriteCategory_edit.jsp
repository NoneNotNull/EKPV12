<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="content">
	
		<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
		<ui:content title="${lfn:message('sys-person:favorite.setting') }">
		<ui:toolbar layout="sys.ui.toolbar.default" style="float:right;" count="5">
			<ui:button onclick="SubmitCategoryForm();" title="${lfn:message('button.save') }" text="${lfn:message('button.save') }" />
			<ui:button onclick="AddNewRow();" title="${lfn:message('button.create') }" text="${lfn:message('button.create') }" />
			<ui:button onclick="DeleteCheckedRow();" title="${lfn:message('button.deleteall') }" text="${lfn:message('button.deleteall') }" />
			<%-- <ui:button onclick="CategoryRowUp();" title="上移" text="上移" />
			<ui:button onclick="CategoryRowDown();" title="下移" text="下移" /> --%>
		</ui:toolbar>

		<html:form action="/sys/person/sys_person_favorite_category/sysPersonFavoriteCategory.do?method=update">
		<table id="categoryTable" class="tb_normal " width="100%">
			<tr class="tr_normal_title">
				<td width="5%">
					<input type="checkbox" name="all">
				</td>
				<td width=30%>
					<bean:message bundle="sys-person" key="sysPersonFavoriteCategory.name" />
				</td>
				<td width=50%>
					<bean:message bundle="sys-person" key="sysPersonFavoriteCategory.data" />
				</td>
			</tr>
			<tr style="display:none;" KMSS_IsReferRow="1">
				<td align="center">
					<input type="checkbox" name="categories[!{index}].selected" value="1">
					<input type="hidden" name="categories[!{index}].fdId" value="">
				</td>
				<td>
					<select name="categories[!{index}].fdCategoryModel" onchange="FixCategoryModelSelector();" validate="required" 
							title="<bean:message bundle="sys-person" key="sysPersonFavoriteCategory.name" />"
							subject="<bean:message bundle="sys-person" key="sysPersonFavoriteCategory.name" />">
						<option value=""><bean:message key="page.firstOption" /></option>
					</select>
					<span class="txtstrong">*</span>
				</td>
				<td>
					<xform:dialog 
							propertyId="categories[!{index}].fdCategoryIds" 
							propertyName="categories[!{index}].fdCategoryNames" 
							style="width:100%" 
							textarea="true"
							showStatus="edit">
						OnSelectClicked(this);
					</xform:dialog>
				</td>
			</tr>
			<c:forEach items="${sysPersonFavoriteCategoryAllForm.categories}" var="category" varStatus="vstatus">
			<tr KMSS_IsContentRow="1" style="cursor: pointer;">
				<td align="center">
					<input type="checkbox" name="categories[${vstatus.index}].selected" value="1">
					<input type="hidden" name="categories[${vstatus.index}].fdId" value="${category.fdId }">
				</td>
				<td>
					<input type="hidden" name="categories[${vstatus.index}].fdCategoryModel" 
						value="${category.fdCategoryModel}">
					${modelNameMap[category.fdCategoryModel] }
				</td>
				<td>
					<xform:dialog 
							propertyId="categories[${vstatus.index}].fdCategoryIds" 
							propertyName="categories[${vstatus.index}].fdCategoryNames" 
							style="width:100%"
							textarea="true"
							showStatus="edit">
						OnSelectClicked(this);
					</xform:dialog>
				</td>
			</tr>
			</c:forEach>
		</table>
		</html:form>
		</ui:content>
		</ui:panel>
		
		
		<script>Com_IncludeFile('jquery.js');</script>
		<script>Com_IncludeFile('doclist.js|validator.jsp|validation.js|plugin.js|validation.jsp');</script>
		<script>DocList_Info.push('categoryTable');</script>
		<script>

		var valid = $KMSSValidation(document.forms['sysPersonFavoriteCategoryAllForm']);
		
		$(document).ready(function() {
			$('#categoryTable').delegate("tr[class!='tr_normal_title']", "click", function(event) {
				var row = this;
				if (event.target.tagName == 'TD') {
					var cell = event.target;
					if (cell.cellIndex < 2) {
						var ckb = $(row).find('[name$="selected"]')[0];
						ckb.checked = !ckb.checked;
						FixSelectedCheckbox();
					}
				}
			});
			$('#categoryTable').delegate("[name='all']", "click", function(event) {
				var selected = this.checked;
				$('#categoryTable [name$="selected"]').each(function() {
					this.checked = selected;
				});
			});
			
			$('#categoryTable').delegate('[name$="fdCategoryModel"]', 'change', function(event) {
				var tr = $(event.target).closest('tr');
				tr.find('[name$="fdCategoryIds"], [name$="fdCategoryNames"]').val("");
			});
		});
		function CheckSelectedItems() {
			if ($('#categoryTable [name$="selected"]:checked').length == 0) {
				seajs.use(["lui/dialog"], function(dialog) {
					dialog.alert(window.placeSelectOptionDatas ? placeSelectOptionDatas : "${lfn:escapeJs(lfn:message('page.noSelect'))}");
				});
				return false;
			}
			return true;
		}
		function FixSelectedCheckbox() {
			var all = $('#categoryTable [name="all"]')[0];
			var allchecked = true;
			$('#categoryTable [name$="selected"]').each(function() {
				if (!this.checked) {
					allchecked = false;
					return false;
				}
			});
			all.checked = allchecked;
		}
		function SubmitCategoryForm() {
			//var form = document.forms['sysPersonFavoriteCategoryAllForm'];
			//form.submit();
			if (!valid.validate()) {
				return;
			}
			seajs.use(["lui/dialog"], function(dialog) {
				var loading = dialog.loading('', $('body'));
				$.ajax({
					  type: "POST",
					  url: $('form[name="sysPersonFavoriteCategoryAllForm"]').attr('action'),
					  data: $('form[name="sysPersonFavoriteCategoryAllForm"]').serialize(),
					  dataType: 'json',
					  success: function(data, textStatus, jqXHR) {
						  loading.hide();
						  dialog["success"](data.title, $('body'));
					  },
					  error: function(jqXHR, textStatus, errorThrown) {
						  loading.hide();
						  var msg = result.responseJSON || {title:''};
						  dialog["failure"](msg.title, $('body'));
					  }
				});
			});
		}
		
		function AddNewRow() {
			DocList_AddRow('categoryTable');
			BuildCategoryModelSelector();
			FixSelectedCheckbox();
		}
		function DeleteCheckedRow() {
			if (!CheckSelectedItems()) {
				return;
			}
			seajs.use(["lui/dialog"], function(dialog) {
				dialog.confirm("${lfn:escapeJs(lfn:message('page.comfirmDelete'))}", function(rtn) {
					if (!rtn)
						return;
					$($('#categoryTable [name$="selected"]:checked').get().reverse()).each(function() {
						DocList_DeleteRow($(this).closest('tr')[0]);
						SubmitCategoryForm();
					});
					FixSelectedCheckbox();
				});
			});
		}
		function CategoryRowUp() {
			if (!CheckSelectedItems()) {
				return;
			}
			$('#categoryTable [name$="selected"]:checked').each(function() {
				DocList_MoveRow(-1, $(this).closest('tr')[0]);
			});
		}
		function CategoryRowDown() {
			if (!CheckSelectedItems()) {
				return;
			}
			$('#categoryTable [name$="selected"]:checked').each(function() {
				DocList_MoveRow(1, $(this).closest('tr')[0]);
			});
		}
		function FixCategoryModelSelector() {
			var selectedVal = [];
			$('[name$="fdCategoryModel"]').each(function() {
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
			$('select[name$="fdCategoryModel"]').each(function() {
				var si = this.options.selectedIndex;
				for (var i = this.options.length - 1 ; i >= 0; i --) {
					var opt = this.options[i];
					if (si != i && constains(selectedVal, opt.value)) {
						opt.disabled = true;
					}
				}
			});
		}
		function BuildCategoryModelSelector() {
			$('select[name$="fdCategoryModel"]').each(function() {
				var self = this;
				if ($(self).attr('data-loaded') != 'true') {
					var ms = categoryModels;
					for (var i = 0; i < ms.length; i ++) {
						var m = ms[i];
						var opt = new Option(m.text , m.model);
						self.options.add(opt);
					}
					$(self).attr('data-loaded', 'true');
				}
			});
			FixCategoryModelSelector();
		}
		function OnSelectClicked(sel) {
			var ms = categoryModels;
			var select = $(sel).closest('tr').find('[name$="fdCategoryModel"]');
			var modelName = select.val();
			var name = select[0].name;
			var namePre = name.substring(0, name.lastIndexOf('.'));
			for (var i = 0; i < ms.length; i ++) {
				var m = ms[i];
				if (m.model == modelName) {
					var dialogjs = m.dialogJS;
					if (dialogjs == null) {
						alert(dialogjs);
					}
					dialogjs = dialogjs.replace(/\!\{idField\}/ig, namePre + '.fdCategoryIds');
					dialogjs = dialogjs.replace(/\!\{nameField\}/ig, namePre + '.fdCategoryNames');
					(new Function(dialogjs)).call(this);
					break;
				}
			}
		}
		</script>
		<script>
			var categoryModels = <%=FavoriteCategoryHelp.buildCategoryJson() %>;
		</script>
	</template:replace>
</template:include>