<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	Com_IncludeFile("jquery.js|treeview.js|json2.js|dialog.js", null, "js");
</script>
<script>
	$( function() {
		var method = '${kmsFtsearchConfigForm.method_GET}';

		// 类别范围
		$('#categoryRange')
				.find('[data-category-range="data-category-range-div"]')
				.each(
						function(i) {
							String
							beanName = "kmsFtSearchCategoryDataBean&selectdId=!{value}&fdId=${kmsFtsearchConfigForm.fdId}&type="
									+ method
									+ "&modelName="
									+ $(this).attr('moduleId')
									+ "&date="
									+ new Date();
							~~ function(beanName, dom, module) {
								window['LKSTree' + i] = new TreeView("LKSTree"
										+ i, module, dom);
								window['LKSTree' + i].isShowCheckBox = true;
								window['LKSTree' + i].isMultSel = true;
								window['LKSTree' + i].isAutoSelectChildren = false;
								var n1, n2;
								n1 = window['LKSTree' + i].treeRoot;
								n1.authType = "01";
								n2 = n1.AppendBeanData(beanName);
								window['LKSTree' + i].Show();

							}
									(beanName, $(this)[0], $(this).attr(
											'moduleTitle'));
						});


		var exceptValue;
		
		// 以下属性范围
		// 构建属性树
		function buildPropertyTree(datas, context) {
			
			exceptValue = [];
			LKSTree_property = new TreeView("LKSTree_property", "文档属性范围",
					$( [ context ].join(''))[0]);
			var n1, n2, n3;
			n1 = LKSTree_property.treeRoot;
			n1.authType = "01";
			LKSTree_property.isShowCheckBox = true;
			for ( var i = 0; i < datas.length; i++) {
				exceptValue[exceptValue.length] = datas[i]['value'];
				var node = new TreeNode(datas[i]['text'], null, null,
						datas[i]['value'],datas[i]['type']);
				node.isChecked = true;
				n1.AddChild(node);
			}
			LKSTree_property.Show();
		}
		// 编辑状态下初始化属性范围
		if (method == 'edit') {
			var datas = ${ftSearchPropertyRange};
			if(window.console){
				console.log('初始数据为:' + datas);
			}
			buildPropertyTree(datas, '#treeview');
		}

		function sysPropFilterAddAfter(rtn) {
			if (rtn) {
				var datas = rtn.GetHashMapArray();
				if (datas.length > 0) {
					if (window.log) {
						console.log(datas);
					}
					buildPropertyTree(datas, '#treeview');
				}
			}
		}

		// 弹出选择dialog
		function sysPropAdd(beanData, title, action) {
			var dialog = new KMSSDialog();
			var lang = {
				optList : '<bean:message key="dialog.optList"/>',
				selList : '<bean:message key="dialog.selList"/>',
				add : '<bean:message key="dialog.add"/>',
				del : '<bean:message key="dialog.delete"/>',
				addAll : '<bean:message key="dialog.addAll"/>',
				delAll : '<bean:message key="dialog.deleteAll"/>',
				moveUp : '<bean:message key="dialog.moveUp"/>',
				moveDown : '<bean:message key="dialog.moveDown"/>',
				ok : '<bean:message key="button.ok"/>',
				cancel : '<bean:message key="button.cancel"/>'
			};
			if (title) {
				lang.title = title;
			}

			if(exceptValue){
				dialog.exceptValue = exceptValue.join(";");
			}
			dialog.Lang = lang;
			dialog.Window = window;
			dialog.SetAfterShow(action);
			dialog.URL = "dialog.html";
			dialog.beanData = beanData;
			dialog.Show(550, 480);
		}

		function sysPropDefineAdd() {
			sysPropAdd(
					"kmsFtSearchPropertyDataBean&type=add",
					'<bean:message bundle="sys-property" key="table.sysPropertyReference" />',
					sysPropFilterAddAfter);
		}

		$('#propertySelect').bind('click', function() {
			sysPropDefineAdd();
		});

	});

	// 提交前拼装各字段的json数据
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {

		var moduleContent = {};
		$('#moduleRange').find(
				'[data-module-range="data_module_range_div"] input:checked')
				.each( function() {
					var val = $(this).val();
					moduleContent[val] = {
						id : val,
						title : $(this).parent().text()
					};
				});
		var categoryContent = [];
		$('#categoryRange').find(
				'[data-category-range="data-category-range-div"]').each(
				function(i, o) {
					if ($(this).children().length == 0)
						return;
					var category = {};
					category['moduleId'] = $(o).attr('moduleId');
					category['moduleTitle'] = $(o).attr('moduleTitle');
					category['category'] = {};
					$(o).find('input[type="checkbox"]:checked').each(
							function(j, k) {
								var val = $(k).val();
								category['category'][val] = {
									id : val,
									title : $(this).parent().text()
								};
							});
					categoryContent.push(category);
				});

		var propertyContent = {};
		$('#propertyRange').find('input[type="checkbox"][checked]').each(
				function(j, k) {
					var val = $(k).val();
					propertyContent[val] = {
						id : val,
						title : $(this).parent().text(),
						type:$(k).parent().attr("title")
					};
				});

		$('input[name="moduleContent"]').val(JSON.stringify(moduleContent));
		$('input[name="categoryContent"]').val(JSON.stringify(categoryContent));
		$('input[name="propertyContent"]').val(JSON.stringify(propertyContent));

		return true;
	};
</script>