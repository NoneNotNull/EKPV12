<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="person.cfg">
	<template:replace name="content">
		
		<ui:panel id="bookmarkTree" layout="sys.ui.panel.light" toggle="false" scroll="false">
			<ui:content title="${lfn:message('sys-bookmark:table.sysBookmarkMain') }">
			
				<ui:toolbar style="float:right;">
					<ui:button onclick="newCategory();" title="${lfn:message('sys-bookmark:sysBookmark.mechanism.create.cate') }" text="${lfn:message('sys-bookmark:sysBookmark.mechanism.create.cate') }" />
					<ui:button onclick="newBookmark();" title="${lfn:message('sys-bookmark:sysBookmark.mechanism.create.link') }" text="${lfn:message('sys-bookmark:sysBookmark.mechanism.create.link') }" />
				</ui:toolbar>
			
				<table class="tb_simple" width="100%">
					<tr style="border-top: 1px solid #000;">
						<td colspan="2">
							<div id="DIV_Tree" style="width:780px;height:450px;overflow:auto;"></div>
						</td>
					</tr>
					
					<tr data-edit-type="bookmark" style="display: none;border-top: 1px solid #000;">
						<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject" /></td>
						<td>
							<input type="text" name="bookmarkName" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkMain.docSubject') }" subject="${lfn:message('sys-bookmark:sysBookmarkMain.docSubject') }">
							<input type="hidden" name="bookmarkId">
							<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr data-edit-type="bookmark" style="display: none;">
						<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.link" /></td>
						<td><input type="text" name="bookmarkUrl" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkMain.link') }" subject="${lfn:message('sys-bookmark:sysBookmarkMain.link') }">
						<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr data-edit-type="bookmark" style="display: none;">
						<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCategoryId" /></td>
						<td><select name="bookmarkMoveSelect"></select></td>
					</tr>
					<tr data-edit-type="bookmark" style="display: none;">
						<td colspan="2" style="text-align: center;">
							<%-- <a id="bookmarkUrlOpen" class="com_btn_link" href="#" target="_blank"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.link.open" /></a> --%>
							<ui:button id="bookmarkUrlOpen" onclick="bookmarkUrlOpen();" title="${lfn:message('sys-bookmark:sysBookmarkMain.link.open') }" text="${lfn:message('sys-bookmark:sysBookmarkMain.link.open') }" />
							<ui:button onclick="updateBookmark();" title="${lfn:message('button.save') }" text="${lfn:message('button.save') }" />
							<ui:button onclick="deleteBookmark();" title="${lfn:message('button.delete') }" text="${lfn:message('button.delete') }" />
						</td>
					</tr>
					
					<tr data-edit-type="category" style="display: none;border-top: 1px solid #000;">
						<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdName" /></td>
						<td><input type="text" name="categoryName" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkPersonCategory.fdName') }" subject="${lfn:message('sys-bookmark:sysBookmarkPersonCategory.fdName') }">
							<input type="hidden" name="categoryId">
							<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr data-edit-type="category" style="display: none;">
						<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdParentId" /></td>
						<td><select name="categoryMoveSelect"></select></td>
					</tr>
					<tr data-edit-type="category" style="display: none;">
						<td colspan="2" style="text-align: center;">
							<ui:button onclick="updateCategory();" title="${lfn:message('button.save') }" text="${lfn:message('button.save') }" />
							<ui:button onclick="deleteCategory();" title="${lfn:message('button.delete') }" text="${lfn:message('button.delete') }" />
						</td>
					</tr>
				</table>
				
			</ui:content>
		</ui:panel>
		
		<div id="categoryNew" style="display:none;">
			<table class="tb_simple" width="100%" style="margin-top: 8px;">
				<tr>
					<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdName" /></td>
					<td><input type="text" name="newCategoryName" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkPersonCategory.fdName') }" subject="${lfn:message('sys-bookmark:sysBookmarkPersonCategory.fdName') }">
					<span class="txtstrong">*</span>
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdParentId" /></td>
					<td><select name="newCategorySelect"></select></td>
				</tr>
			</table>
		</div>
		<div id="bookmarkNew" style="display:none;">
			<table class="tb_simple" width="100%" style="margin-top: 8px;">
				<tr>
					<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject" /></td>
					<td><input type="text" name="newBookmarkName" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkMain.docSubject') }" subject="${lfn:message('sys-bookmark:sysBookmarkMain.docSubject') }">
					<span class="txtstrong">*</span>
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.link" /></td>
					<td><input type="text" name="newBookmarkUrl" class="inputsgl" style="width:90%;" validate="required" title="${lfn:message('sys-bookmark:sysBookmarkMain.link') }" subject="${lfn:message('sys-bookmark:sysBookmarkMain.link') }">
					<span class="txtstrong">*</span>
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title"><bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCategoryId" /></td>
					<td><select name="newBookmarkSelect"></select></td>
				</tr>
			</table>
		</div>
		
		
		<script type="text/javascript">
			Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|treeview.js");
		</script>
		<script>
		Tree_IncludeCSSFile();
		var LKSTree = null;
		var treeData = null;
		// value text parent cateType
		var categories = ${categories};
		var bookmarks = ${bookmarks};
		var valid = $KMSSValidation();
		
		seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
			$(document).ready(function() {
				generateTree();
			});
			
			function validQuery(select) {
				var result = true;
				$(select).each(function() {
					result = valid.validateElement(this);
					if (!result) {
						return false;
					}
				});
				return result;
			}
			function hideValidQuery(select) {
				$(select).each(function() {
					KMSSValidation_HideWarnHint(this);
				});
			}
			
			function newDialog(id, title, callback) {
				dialog.build({
					id : id + 'Dialog',
					config : {
						width : 500,
						height : 100,
						lock : true,
						cache : true,
						title : title,
						content : {
							type : "Html",
							html : $('#' + id).html(),
							iconType : "",
							buttons : [ {
								name : "${lfn:escapeJs(lfn:message('button.ok'))}",
								value : true,
								focus : false,
								fn : function(value, dialog) {
									dialog.hide(value);
								}
							}]
						}
					},
					callback : callback
				}).one('layoutDone', function() {
					$('input[type="text"]')[0].focus();
				}).show();
			}
			
			function ajaxUpdate(url, data, callback) {
				var loading = dialog.loading('', $('body'));
				$.ajax({
					type : "POST",
					url : url,
					data : $.param(data, true),
					dataType : 'json',
					success : function(result) {
						loading.hide();
						dialog["success"](result.msg, $('body'));
						rebuildTree(result.categories, result.bookmarks);
						if (callback) {
							callback('success');
						}
					},
					error : function(result) {
						loading.hide();
						var msg = [];
						if (result.responseJSON) {
							if (result.responseJSON.msg) {
								msg.push(result.responseJSON.msg);
							}
							var messages = result.responseJSON.message;
							if (messages != null) {
								for (var i = 0 ; i < messages.length; i ++) {
									msg.push(messages[i].msg);
								}
							}
						}
						dialog["failure"](msg.join(""), $('body'));
						if (callback) {
							callback('failure');
						}
					}
				});
			}

			window.newCategory = function() {
				var select = $("[name='newCategorySelect']")[0];
				select.options.length = 0;
				select.options.add(new Option("${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmarkCategory.select'))}", ""));
				addSelectOptions(select, treeData, 0);
				setSelectedOption(select, LKSTree.GetCurrentNode());
				
				newDialog('categoryNew', "${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmark.mechanism.create.cate'))}", function(value, dialog) {
					if (value) {
						if (!validQuery('#categoryNewDialog [name="newCategoryName"]')) {
							dialog.show();
							return;
						}
						var data = {
								categoryName: dialog.element.find('[name="newCategoryName"]').val(),
								parentId: dialog.element.find('[name="newCategorySelect"]').val()
						};
						ajaxUpdate(Com_Parameter.ContextPath 
								+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=updateCatogory', 
								data, function() {
									$('[name="newCategoryName"]').val('');
								});
					}
				});
				hideValidQuery('[name="newCategoryName"]');
			};
			
			window.updateCategory = function() {
				if (!validQuery('[name="categoryName"]'))
					return;
				var data = {
						categoryName: $('[name="categoryName"]').val(),
						categoryId: $('[name="categoryId"]').val(),
						parentId: $('[name="categoryMoveSelect"]').val()
				};
				ajaxUpdate(Com_Parameter.ContextPath 
						+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=updateCatogory', 
						data);
			};
			
			window.deleteCategory = function() {
				var categoryId = $('[name="categoryId"]').val();
				for (var i = 0; i < categories.length; i ++) {
					if (categories[i].value == categoryId && categories[i].children != null && categories[i].children.length > 0) {
						dialog.alert("${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmarkCategory.delete.alert'))}");
						return;
					}
				}
				dialog.confirm("${lfn:escapeJs(lfn:message('page.comfirmDelete'))}", function(value) {
					if (value) {
						ajaxUpdate(Com_Parameter.ContextPath 
								+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=deleteCategory', 
								{categoryId: $('[name="categoryId"]').val()}, clearForm);
					}
				});
			};
			
			window.newBookmark = function() {
				var select = $("[name='newBookmarkSelect']")[0];
				select.options.length = 0;
				select.options.add(new Option("${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmarkCategory.select'))}", ""));
				addSelectOptions(select, treeData, 0);
				setSelectedOption(select, LKSTree.GetCurrentNode());
				
				newDialog('bookmarkNew', "${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmark.mechanism.create.link'))}", function(value, dialog) {
					if (value) {
						if (!validQuery('#bookmarkNewDialog [name="newBookmarkName"], #bookmarkNewDialog [name="newBookmarkUrl"]')) {
							dialog.show();
							return;
						}
						var data = {
								bookmarkName: dialog.element.find('[name="newBookmarkName"]').val(),
								bookmarkUrl: dialog.element.find('[name="newBookmarkUrl"]').val(),
								parentId: dialog.element.find('[name="newBookmarkSelect"]').val()
						};
						ajaxUpdate(Com_Parameter.ContextPath 
								+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=updateBookmark', 
								data, function() {
									$('[name="newBookmarkName"], [name="newBookmarkUrl"]').val('');
								});
					}
				});
				hideValidQuery('[name="newBookmarkName"], [name="newBookmarkUrl"]');
			};
			
			window.updateBookmark = function() {
				if (!validQuery('[name="bookmarkName"], [name="bookmarkUrl"]'))
					return;
				var data = {
						bookmarkName: $('[name="bookmarkName"]').val(),
						bookmarkId: $('[name="bookmarkId"]').val(),
						bookmarkUrl: $('[name="bookmarkUrl"]').val(),
						parentId: $('[name="bookmarkMoveSelect"]').val()
				};
				ajaxUpdate(Com_Parameter.ContextPath 
						+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=updateBookmark', 
						data);
			};
			
			window.deleteBookmark = function() {
				dialog.confirm("${lfn:escapeJs(lfn:message('page.comfirmDelete'))}", function(value) {
					if (value) {
						ajaxUpdate(Com_Parameter.ContextPath 
								+ 'sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=deleteBookmark', 
								{bookmarkId: $('[name="bookmarkId"]').val()}, clearForm);
					}
				});
			};

			function generateTree() {
				if(LKSTree){
					document.getElementById("DIV_Tree").innerHTML = "";
					delete LKSTree;
				}
				LKSTree = new TreeView("LKSTree", "${lfn:escapeJs(lfn:message('sys-bookmark:tree.node.root'))}", document.getElementById("DIV_Tree"));
				var data = buildTreeData(categories, bookmarks);
				generateTreeNodes(LKSTree.treeRoot, data);
				LKSTree.ClickNode = onTreeNodeClick;
				LKSTree.Show();
				treeData = data;
			}
			
			function generateTreeNodes(root, data){
				for(var i = 0; i < data.length; i++){
					var node = new TreeNode();
					node.value = data[i].value;
					node.text = data[i].text == null || data[i].text == '' ? "${lfn:escapeJs(lfn:message('sys-bookmark:tree.node.name.none'))}" : data[i].text;
					node.title = node.text;
					node.isExpanded = true;
					node.nodeType = "node";
					node.cateType = data[i].cateType;
					if (data[i].cateType == 1) {
						node.nodeType = "CATEGORY";
						node.title = node.title + "${lfn:escapeJs(lfn:message('sys-bookmark:sysBookmarkPublicCategory.edit.hint'))}";
					} else if (data[i].cateType == 2) {
						node.nodeType = "CATEGORY_SON";
					}
					if(data[i].url != null) {
						node.parameter = new Array();
						node.parameter[0] = data[i].url;
						if(data[i].target != null){
							node.parameter[1] = data[i].target;
						}
						node.title = node.title + "\r\n" + data[i].url;
					}
					root.AddChild(node);
					if(data[i].children != null && data[i].children.length > 0){
						generateTreeNodes(node, data[i].children);
					}
				} 
			}
			
			function findDataById(list, id) {
				if (id == null) {
					return null;
				}
				for (var i = 0; i < list.length; i ++) {
					if (list[i].value == id) {
						return list[i];
					}
				}
				return null;
			}
			
			function setDataToParentChildren(categories, data) {
				var parent = findDataById(categories, data.parent);
				if (parent == null) {
					return;
				}
				if (parent.children == null) {
					parent.children = [];
				}
				parent.children.push(data);
			}
			
			function buildTreeData(categories, bookmarks) {
				for (var i = 0; i < categories.length; i ++) {
					categories[i].children = []; // 清空信息
				}
				var root = {children: []};
				for (var i = 0; i < categories.length; i ++) {
					var category = categories[i];
					if (category.parent == null) {
						root.children.push(category);
						continue;
					}
					setDataToParentChildren(categories, category);
				}
				for (var i = 0; i < bookmarks.length; i ++) {
					var bookmark = bookmarks[i];
					if (bookmark.parent == null) {
						root.children.push(bookmark);
						continue;
					}
					setDataToParentChildren(categories, bookmark);
				}
				return root.children;
			}
			
			function onTreeNodeClick(node){
				if(typeof(node) == "number")
					node = Tree_GetNodeByID(this.treeRoot, node);
				if (node.value == null)
					return;
				if (node.cateType == 1)
					return;
				this.SetCurrentNode(node);
				fillDataInfo(node);
			}
			
			window.bookmarkUrlOpen = function() {
				var url = $("[name='bookmarkUrl']").val();
				if (url == null || url == '') {
					return false;
				}
				if (url.indexOf('/') == 0) {
					url = Com_Parameter.ContextPath + url.substring(1);
				}
				window.open(url, '_blank');
			};
			/* $("#bookmarkUrlOpen").click(function(event) {
				var url = $("[name='bookmarkUrl']").val();
				if (url == null || url == '') {
					$("#bookmarkUrlOpen").attr('href', '#');
					return false;
				}
				if (url.indexOf('/') == 0) {
					url = Com_Parameter.ContextPath + url.substring(1);
				}
				$("#bookmarkUrlOpen").attr('href', url);
				return true;
			}); */
			
			function fillBookmarkInfo(node) {
				$('[data-edit-type="bookmark"]').show();
				$('[data-edit-type="category"]').hide();
				$("[name='bookmarkName']").val(node.text);
				$("[name='bookmarkId']").val(node.value);
				if (node.parameter != null) {
					$("[name='bookmarkUrl']").val(node.parameter[0]);
					//$("#bookmarkUrlOpen").attr('href', '#').show();
				} else {
					$("[name='bookmarkUrl']").val('');
					//$("#bookmarkUrlOpen").attr('href', '#').hide();
				}
				createSelectOptions(node);
			}
			function fillCategoryInfo(node) {
				$('[data-edit-type="bookmark"]').hide();
				$('[data-edit-type="category"]').show();
				$("[name='categoryName']").val(node.text);
				$("[name='categoryId']").val(node.value);
				createSelectOptions(node);
			}
			
			function fillDataInfo(node) {
				if (node.cateType == 2) {
					fillCategoryInfo(node);
				} else {
					fillBookmarkInfo(node);
				}
			}
			
			function setSelectedOption(select, node) {
				if (node == null)
					return;
				var cate = (node.cateType != 1 && node.cateType != 2) ? node.parent : node;
				if(window.console) {
					console.info("cate", cate);
				}
				if (cate != null && cate.value != null) {
					for (var i = 0; i < select.options.length; i ++) {
						var opt = select.options[i];
						if(window.console) {
							console.info("opt", opt.text, (opt.value == cate.value));
						}
						if (opt.value == cate.value) {
							$(opt).attr('selected', true);
							break;
						}
					}
				}
			}
			
			function createSelectOptions(node) {
				var selfValue = node ? node.value : '';
				var name = node.cateType == 2 ? 'categoryMoveSelect' : 'bookmarkMoveSelect';
				var select = document.getElementsByName(name)[0];
				select.options.length = 0;
				select.options.add(new Option("=== ${lfn:escapeJs(lfn:message('sys-bookmark:tree.node.view.other'))} ===", ""));
				addSelectOptions(select, treeData, 0, selfValue);
				setSelectedOption(select, node.parent);
			}
			function getIndexBlank(index) {
				var blank = "";
				for (var i = 0; i < index; i++) {
					blank += "　　 ";
				}
				return blank;
			}
			function addSelectOptions(select, optData, index, selfValue) {
				if (optData == null)
					return;
				if (index == 0) {
					select.style.width = "300px";
				}
				var blank = getIndexBlank(index);
				for (var i = 0; i < optData.length; i ++) {
					var opt = optData[i];
					if (opt.cateType == null || opt.value == selfValue)
						continue;
					select.options.add(new Option(blank + opt.text, opt.value));
					if (opt.children != null && opt.children.length > 0) {
						addSelectOptions(select, opt.children, index + 1, selfValue);
					}
				}
			}
			
			function rebuildTree(_categories, _bookmarks) {
				window.categories = _categories;
				window.bookmarks = _bookmarks;
				generateTree();
			}
			
			function clearForm(type) {
				if (type == 'success') {
					$("[name='bookmarkName']").val('');
					$("[name='bookmarkId']").val('');
					$("[name='bookmarkUrl']").val('');
					$("[name='categoryId']").val('');
					$("[name='categoryName']").val('');
					$('[data-edit-type="bookmark"]').hide();
					$('[data-edit-type="category"]').hide();
					//$("#bookmarkUrlOpen").attr('href', '').hide();
				}
			}
		});

		
		</script>
	</template:replace>
</template:include>