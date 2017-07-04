(function($, win) {

	var NavItem = null;

	// elem 绑定按钮
	function opera(options, elem) {
		this._options = options;
		this._elem = $(elem);
		var that = this;

		this.bind_add = function() {
			this._elem.bind('click', this.add);
		};

		this.bind_del = function() {
			this._elem.bind('click', this.del);
		};

		this.bind_select = function() {
			this._elem.bind('click', this.select);
		};

		this.bind_expand = function() {
			this._elem.bind('click', this.expand);

		};

		// 基础窗口组件
		var baseOptions = {
			title : '选择分类',
			lock : true,
			noFn : function() {
			},
			height : that._options.height || '300px',
			width : that._options.width,
			yesFn : function(naviSelector) {
			}
		};

		var navOptions = {
			dataSource : {
				url : that._options.s_url || KMS.contextPath
						+ 'kms/common/kms_common_portlet/kmsCommonPortlet.do',
				data : {
					s_bean : that._options.s_bean,
					s_method : that._options.s_method,
					s_type : that._options.s_type,
					s_dialog : that._options.s_dialog,
					type : that._options.type
				},
				modelName : that._options.s_modelName,
				// 选择权限类型：01维护，02阅读
				authType : that._options.s_authType,
				extendFilter:that._options.extendFilter,
				isCustom:that._options.s_isCustom
			}
		};

		// 添加
		this.add = function() {

			var addOptions = {
				lock : that._options.lock || true,
				yesFn : function(naviSelector) {
					var selectedCache = naviSelector.selectedCache;
					// 未选择分类~
					if (selectedCache.length == 0) {
						art.artDialog.alert(Kms_MessageInfo["category.select"]
								+ "!");
						return;
					}
					if (selectedCache.last()._data["isShowCheckBox"] == "0") {
						art.artDialog
								.alert(Kms_MessageInfo["category.noLimits"]);
						return;
					}
					var fdCategoryId = selectedCache.last()._data["value"];
					window.open(that._options.open + fdCategoryId);
				}
			};

			$.extend(baseOptions, addOptions);
			// 分类组件
			artDialog.navSelector(Kms_MessageInfo["kms.opera.selectCategory"],
					baseOptions, navOptions);

		};

		// 选择分类`数据源 {fieldId:'',fieldName:'',s_bean:'',s_method:''...}
		this.select = function() {
			var selectOption = {
				yesFn : function(naviSelector) {
					var selectedCache = naviSelector.selectedCache;
					// 未选择分类~
					if (selectedCache.length == 0) {
						art.artDialog.alert(Kms_MessageInfo["category.select"]
								+ "!");
						return;
					}
					if (selectedCache.last()._data["isShowCheckBox"] == "0") {
						art.artDialog
								.alert(Kms_MessageInfo["category.noLimits"]);
						return;
					}
					var fdCategoryId = selectedCache.last()._data["value"];
					var fdCategoryName = selectedCache.last()._data["text"];
					$('input[name="' + that._options.fieldId + '"]')
							.val(fdCategoryId);
					$('input[name="' + that._options.fieldName + '"]')
							.val(fdCategoryName);
				}
			};
			$.extend(baseOptions, selectOption);
			artDialog.navSelector(Kms_MessageInfo["kms.opera.selectCategory"],
					baseOptions, navOptions);
		};

		// 删除
		this.del = function() {
			var checkedList = $('input[name="List_Selected"]:checked');
			var rowsize = checkedList.length;
			if (!rowsize) {
				art.artDialog.alert(Kms_MessageInfo["kms.opera.noSelectData"]);
				return;
			}
			var conf = art.artDialog.confirm(
					Kms_MessageInfo["kms.opera.deleteMsg"], function() {
						var id = [];
						$('input[name="List_Selected"]:checked').each(
								function(i) {
									id[i] = 'List_Selected=' + $(this).val();
								});
						var ids = id.join('&');

						// 显示报错信息 2012-5-17
						$.ajax({
							url : that._options.delUrl,
							cache : false,
							data : ids,
							type : 'post',
							success : function(data) {
								if (data && data['error']) {
									art.artDialog.alert(data['error']);
								} else {
									window.location.reload();// 刷新页面
								}
							},
							error : function(error) {
								// 完善提示信息 2012-12-25
								art.artDialog
										.alert(Kms_MessageInfo["kms.opera.deleteError"]);
							}
						})
					});
			checkList = [];
		};

		// 拓展接口，可以自定义确定事件
		this.expand = function() {
			var expandOption = that._options;
			$.extend(baseOptions, expandOption);
			win.parent.artDialog.navSelector(
					Kms_MessageInfo["kms.opera.selectCategory"], baseOptions,
					navOptions);
		};

	}

	KMS.opera = opera;
}(jQuery, window))