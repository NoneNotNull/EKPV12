<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script type="text/javascript"
	src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<script
	src="${KMSS_Parameter_ResPath}js/jquery-ui/src/jquery.ui.core.js"></script>
<script
	src="${KMSS_Parameter_ResPath}js/jquery-ui/src/jquery.ui.widget.js"></script>
<script
	src="${KMSS_Parameter_ResPath}js/jquery-ui/src/jquery.ui.position.js"></script>
<script type="text/javascript"
	src="${KMSS_Parameter_ResPath}js/jquery-ui/src/jquery.ui.autocomplete.js"></script>
<script>
	Com_IncludeFile("jquery.ui.core.css", "style/common/jquery-ui/");
	Com_IncludeFile("jquery.ui.theme.css", "style/common/jquery-ui/");
	Com_IncludeFile("jquery.ui.autocomplete.css", "style/common/jquery-ui/");
	Com_IncludeFile("treeview.js|json2.js|data.js", null, "js");
</script>
<script>
	var searchScopeId = "";
	//初始化页面
	$( function init() {
		~~ function loadUserInfoTips() {
			if ($('#userInfoTips').length > 0
					&& $('#topBanner_info_tmpl').length > 0) {
				$
						.ajax( {
							url : '${kmsResourcePath}/jsp/get_json_feed.jsp?s_bean=kmsCommonPortlet&s_method=getUserToolTips',
							cache : false,
							success : function(data) {
								var tmpl = $('#topBanner_info_tmpl').html();
								if ($.getTemplate(tmpl)) {
									var html = $.getTemplate(tmpl).render(data);
									$('#userInfoTips').html(html);
								}
							}
						});
			}
		}();

		//初始搜索选项
		initSearchRange();

		/**
		 * 点击搜索事件
		 */
		$('#ftSearchBtn').bind('click', onSearch);

		//切换筛选范围事件
		$("#lui_search a").bind('click', function(e) {
			//初始搜索选项
				initSearchRange(this.rel);
				var searchText = $("#q5").val();
				//searchScopeId = e.srcElement.getAttribute("rel");
				searchScopeId = this.rel;
				//执行搜索
				search(searchText);
			});

		$("input[name=proInput]").bind('blur', function(e) {
			doSearch();
		});

	});

	//页面头部搜索
	function onSearch() {
		var searchText = $("#q5").val();
		//执行搜索
		search(searchText);
	}

	function initSearchRange(id) {
		var configId = id || "${configId}";
		searchScopeId = configId;
		var beanName = "kmsFtSearchIndexDataBean&selectdId=!{value}&fdId="
				+ configId + "&type=";
		//模块筛选树
		generateTree1("LKSTree1", beanName + "module", $('#module')[0], '按模块');
		//属性筛选树
		generateTree2("LKSTree2", beanName + "property", $('#property')[0],
				'按属性选择');
		//分类筛选树
		generateTree3("LKSTree3", beanName + "category", $('#category')[0],
				'按分类');
		//属性输入筛选
		generateProInput(configId);
	}

	function generateProInput(configId) {
		var beanUrl = "kmsFtSearchIndexDataBean&text=true&type=property&fdId="
				+ configId;
		var rtnVal = new KMSSData().AddBeanData(beanUrl).GetHashMapArray();
		var len = rtnVal.length;
		for ( var i = 0; i < len; i++) {
			var html = "<div class='textDiv'><span>" + rtnVal[i].text
					+ "：</span><input name='proInput' title='" + rtnVal[i].text
					+ "' id='" + rtnVal[i].id + "'/></div>";
			$('#propertyText').append(html);
		}
	}

	var LKSTree1, LKSTree2, LKSTree3;
	function generateTree1(LKSTreeName, beanName, dom, title) {

		LKSTree1 = new TreeView(LKSTreeName, title, dom);
		LKSTree1.isShowCheckBox = true;
		LKSTree1.isMultSel = true;
		LKSTree1.isAutoSelectChildren = false;
		LKSTree1.OnNodeCheckedPostChange = this.clickNodeEvent;
		var n1, n2;
		n1 = LKSTree1.treeRoot;
		n1.authType = "01";
		n2 = n1.AppendBeanData(beanName);
		LKSTree1.Show();
	}

	function generateTree2(LKSTreeName, beanName, dom, title) {

		LKSTree2 = new TreeView(LKSTreeName, title, dom);
		LKSTree2.isShowCheckBox = true;
		LKSTree2.isMultSel = true;
		LKSTree2.isAutoSelectChildren = false;
		LKSTree2.OnNodeCheckedPostChange = this.clickNodeEvent;
		var n1, n2;
		n1 = LKSTree2.treeRoot;
		n1.authType = "01";
		n2 = n1.AppendBeanData(beanName);
		LKSTree2.Show();
	}

	function generateTree3(LKSTreeName, beanName, dom, title) {

		LKSTree3 = new TreeView(LKSTreeName, title, dom);
		LKSTree3.isShowCheckBox = true;
		LKSTree3.isMultSel = true;
		LKSTree3.OnNodeCheckedPostChange = this.clickNodeEvent;
		//LKSTree3.isAutoSelectChildren = false;
		var n1, n2;
		n1 = LKSTree3.treeRoot;
		n1.authType = "01";
		n2 = n1.AppendBeanData(beanName);
		LKSTree3.Show();
	}

	var searchFilter = {
		sortType : getSortType()
	};

	/**
	 * 执行搜索
	 */
	function doSearch() {
		//加入搜索范围id
		searchFilter.searchScopeId = searchScopeId;
		searchFilter.filterString = getPropertyFilter();
		searchFilter.categoryFilter = getCategoryFilter();
		searchFilter.modelFilter = getModelFilter();
		refreshList();
	}

	/**
	 * 搜索
	 */
	function search(searchText) {
		if (!searchText
				|| searchText
						.equals(Kms_MessageInfo["kms.common.search.input"])) {
			searchText = "*";
		}
		searchFilter = {
			pageno : 0,
			rowsize : 10,
			facetFields : 'modelName',
			sortType : getSortType(),
			queryString : searchText || '*',
			facetFilterCates : "",
			facetFilterModel : ""
		};
		doSearch();
	}

	//点击页面底部按钮搜索
	function commitSearch() {
		//执行搜索
		search($("input[name=queryString]").val());
	}

	/**
	 * 封面搜索
	 */
	function facetSearch(modelName, categoryId, facetType) {
		if (categoryId) {
			//分面已选择分类
			if (searchFilter.facetFilterCates) {
				searchFilter.facetFilterCates = searchFilter.facetFilterCates
						+ "," + categoryId;
			} else {
				searchFilter.facetFilterCates = categoryId;
			}
		}
		searchFilter.facetFilterModel = modelName;
		searchFilter.facetFields = "category";

		//执行搜索
		doSearch();
	}

	/**
	 * 条件列表删减
	 */
	function deleteCondition(modelName, categoryId, facetType) {
		if (categoryId) {
			var selected = searchFilter.facetFilterCates;
			searchFilter.facetFilterCates = selected.substring(0, selected
					.indexOf(categoryId))
					+ categoryId;
		} else {
			searchFilter.facetFilterCates = "";
		}

		//执行搜索
		doSearch();
	}

	function clearCondition(facetType, id) {
		switch (facetType) {
		case "module":
			$('#module').find('input').each( function() {
				if (this.checked) {
					this.checked = false;
				}
			});
			break;
		case "category":
			$('#category').find('input').each( function() {
				if (this.checked) {
					this.checked = false;
				}
			});
			break;
		}
		//执行搜索
		doSearch();
	}

	function clearFilter(name, id) {
			debugger;
		id = id.replace(/\./g,"\\.").replace(";","\\;");
		$('input[value='+id+']').each( function() {
			if (this.checked) {
				this.checked = false;
			}
		});
		$('input#' + id).each( function() {
			this.value = "";
		});
		//执行搜索
		doSearch();
	}

	//返回全部
	function comeBackFacet() {
		search($("#q5").val());
		//search(searchFilter.queryString);
	}

	//结果中搜索
	function searchOnResult() {
		var resultText = $("#q6").val();
		var searchText = $("#q5").val();
		if (!resultText || resultText == "*") {
			showAlert(Kms_MessageInfo["kms.common.search.empty"]);
			return;
		}
		if (resultText) {
			searchText = searchText + "&" + resultText;
		}
		//执行搜索
		search(searchText);
	}

	//排序搜索
	function sortResult(e) {

		if (e.className != "btn_a_selected") {
			$(".btn_a_selected").toggleClass("btn_a");
			$(".btn_a_selected").toggleClass("btn_a_selected");
			$(e).toggleClass("btn_a_selected");
			$(e).toggleClass("btn_a");

			searchFilter.sortType = getSortType();
			//执行搜索
			doSearch();
		}
	}

	/**
	 * 选择搜索范围搜索
	 */
	function selectByRange(e) {
		if (event.srcElement.nodeName != "INPUT") {
			if (e.firstChild.checked) {
				e.firstChild.checked = false;
			} else {
				e.firstChild.checked = true;
			}
		}
		//设置条件
		searchFilter.searchFields = getFieldFilter();
		//执行搜索
		doSearch();
	}

	/**
	 * 选择搜索范围搜索
	 */
	function clickNodeEvent(node) {

		if (!searchFilter) {
			searchFilter = {};
		}
		//设置条件
		searchFilter.facetFields = "modelName";
		searchFilter.facetFilterCates = "";
		searchFilter.facetFilterModel = "";

		//执行搜索
		doSearch();
	}

	//获取分类条件
	function getCategoryFilter() {
		var selectCategory = [];
		$('#category').find('input:checked').each( function() {
			var vals = $(this).val();
			if (vals && vals.split(';').length > 0) {
				var val = vals.split(';');
				selectCategory[selectCategory.length] = val[1];
			}
		});
		return selectCategory.join(",");
	}

	//获取的属性条件
	function getPropertyFilter() {
		var pro = "";
		$('#property').find('input:checked').each( function() {
			var vals = $(this).val();
			if (vals) {
				var val = vals.split(';');
				if (val.length > 1) {
					//pro.field.push(val[0]);
				//pro.value.push(val[1]);
				pro = pro + val[0] + "=" + val[1] + ",";
			}
		}
	}	);
		$('#propertyText').find('input:text').each( function() {
			var val = $(this).val();
			if (val) {
				var id = $(this).attr("id");
				pro = pro + id + "=" + val + ",";
			}
		})
		return pro;
	}

	//搜索模块条件
	function getModelFilter() {
		var selectModel = [];
		$('#module').find('input:checked').each( function() {
			var vals = $(this).val();
			if (vals) {
				selectModel.push(vals);
			}
		});
		return selectModel.join(";");
	}

	function showFilterHTML(name, showTitle) {
		var selectModel = {
			title : [],
			text : [],
			value : [],
			id:[]
		};
		$('#' + name).find('input:checked').each( function() {debugger;
			var text = this.parentElement.getAttribute("title");
			var value = this.getAttribute("value");
			if (text && value) {
				selectModel.text.push(showTitle);
				selectModel.value.push(text);
				selectModel.id.push(value);
			}
		});
		return showHTML(selectModel, showTitle);
	}
	function showFilterProTextHTML(name, showTitle) {
		
		var selectModel = {
			text : [],
			value : [],
			id:[]
		};
		$('#' + name).find('input:text').each( function() {
			var text = this.title;
			var value = this.value;
			var id = this.id;
			if (text && value) {
				selectModel.text.push(text);
				selectModel.value.push(value);
				selectModel.id.push(id);
			}
		});
		return showHTML(selectModel, name);
	}

	function showHTML(selectModel, name) {
		var len = selectModel.id.length;
		var html = "";
		for ( var i = 0; i < len; i++) {
			html += "<span class='condit'>" + selectModel.text[i].trim() + ":"
					+ selectModel.value[i].trim()
					+ "</span><a class='cancel_condit' name='" + name
					+ "' id='" + selectModel.id[i]
					+ "' href='#' onclick='clearFilter(this.name,this.id)'/>";
		}
		return html;
	}

	//获取搜索字段条件
	function getFieldFilter() {
		var search = [];
		$('#field').find('input:checked').each( function() {
			var vals = $(this).val();
			if (vals) {
				search.push(vals);
			}
		});
		return search.join(";");
	}

	//获取排序类型
	function getSortType() {
		var sortType = "score";
		if ($("#time").attr("class") == "btn_a_selected") {
			sortType = "time";
		}
		return sortType;
	}

	/**
	 * 打开搜索内容
	 */
	function readDoc(fdDocSubject, fdModelName, fdCategory, fdUrl,
			fdSystemName, positionInPage) {

		document.getElementById("fdDocSubject").value = fdDocSubject;
		document.getElementById("fdModelName").value = fdModelName;
		document.getElementById("fdCategory").value = fdCategory;
		document.getElementById("fdUrl").value = fdSystemName + "\u001D"
				+ fdUrl;
		//alert($("fdUrl").value);
		document.getElementById("fdModelId").value = Com_GetUrlParameter(fdUrl,
				"fdId");
		var queryString = Com_GetUrlParameter(window.location.href,
				"queryString");
		document.getElementById("fdSearchWord").value = queryString;
		var pageno = Com_GetUrlParameter(window.location.href, "pageno");
		var rowsize = Com_GetUrlParameter(window.location.href, "rowsize");
		if (pageno == null || pageno == "")
			pageno = 1;
		if (rowsize == null || rowsize == "")
			rowsize = 10;
		var position = parseInt(pageno - 1) * parseInt(rowsize)
				+ parseInt(positionInPage) + 1;
		document.getElementById("fdHitPosition").value = position;
		var sysFtsearchReadLogForm = document
				.getElementById("sysFtsearchReadLogForm");

		sysFtsearchReadLogForm.submit();
		return null;
	}

	// 点击热词或相关搜索词查询
	function searchWord(e) {
		var queryString = $(e).text();
		search(queryString);
	}

	/**
	 * 刷新数据列表
	 */
	function refreshList() {
		KMS.page.listExpand(this.searchFilter);
	}

	function listCallBack(id) {
		if (!searchFilter) {
			searchFilter = {};
			searchFilter.queryString = $("input[name=queryString]").val();
		}
		KMS.listCallBack(id);
	}
	/**
	 * 分页
	 */
	function listPage(pageno, rowsize, totalrows) {
		seajs.use('lui/topic', function(topic) {
			topic.publish("list.changed", {
				"page" : {
					"currentPage" : pageno,
					"pageSize" : rowsize,
					"totalSize" : totalrows
				}
			});

			topic.subscribe('paging.changed', function(evt) {
				topic.publish("list.changed", {
					"page" : {
						"currentPage" : evt.page[0]['value'][0],
						"pageSize" : evt.page[1]['value'][0],
						"totalSize" : totalrows
					}
				});
				KMS.page.setPageTo(evt.page[0]['value'][0],
						evt.page[1]['value'][0]);
			});

		});
	}
</script>