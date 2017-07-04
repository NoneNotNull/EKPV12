
Com_IncludeFile("kmsMessageInfo.jsp", KMS.kmsResourcePath+"/jsp/", 'js',true);
// JS模板缓存map
var js_template = {};

// document初始化
$(document).ready(function() {

	// 初始化js模板
	(function() {
		var jsTmplNodes = $('.js_tmpl');
		for (var c = 0, len = jsTmplNodes.length; c < len; c++) {
			var node = jsTmplNodes[c];
			if (node.id) {
				js_template[node.id] = node.innerHTML;
			}
		}
	}());

	// 切换搜索范围
	(function() {
		var curRange,
		// 当前的搜索范围
		searchModelClass = "", rangeSet = $(".search_box li.range a");
		rangeSet.each(function(index, domEle) {
					var rangeEle = $(domEle);
					// 保存当前选中的搜索标签页
					if (rangeEle.hasClass("on"))
						curRange = rangeEle;
					// 绑定鼠标点击事件
					rangeEle.click(function(event) {
								var thisEle = $(this);
								if (!thisEle.hasClass("on")) {
									thisEle.addClass("on");
									curRange.removeClass("on");
									curRange = thisEle;
									// 更改当前的搜索范围
									searchModelClass = curRange.attr("rel");
								}
								// 阻止链接的默认行为
								return false;
							});

				});

		if (curRange) {
			searchModelClass = curRange.attr("rel");
		}

		if (!curRange) {
			curRange = rangeSet.eq(0);
			curRange.addClass("on");
		}

		// 搜索输入框绑定Enter事件
		$("#searchTextInput").bind('keydown', function(event) {
					if (event.keyCode == 13) {
						$("#btnSearch").click();
					}
				});

		// 绑定搜索按钮
		$("#btnSearch").click(function() {
			// 搜索关键词
			var searchText = $("#searchTextInput").val();
			var searchModel = $("#searchModel").val();
			var searchActionUrl;
			if("third"==searchModel){
				searchActionUrl = KMS.contextPath
				+ "kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=index";
			}else{
				searchActionUrl = KMS.contextPath
						+ "sys/ftsearch/searchBuilder.do?method=search";
			}
			
			if (!searchModelClass.equals("")) {
				searchActionUrl += "&modelName=" + searchModelClass;
			} else {
				searchActionUrl += "&type=1&ftHome=true";
			}

			if (searchText.equals("") || searchText.equals(Kms_MessageInfo["kms.common.search.input"])) {
				//showAlert(Kms_MessageInfo["kms.common.search.empty"]);
				//return;
				searchText = "*";
			}
			searchActionUrl += "&queryString=" + encodeURIComponent(searchText);
			window.open(searchActionUrl, "_blank");
		});

		$("#btnSearchAdvance").click(function() {
			window
					.open(
							KMS.contextPath
									+ "sys/ftsearch/sys_ftsearch_result/sysFtsearchAdvanced.do?method=sysFtsearchAdvanced",
							"_blank");
		});

	}());

	$(document).bind("contextmenu", function(e) {
				return false;
			});

});

// ///////////////////////////////////////

function changePwd(userId) {
	var url = KMS.contextPath
			+ "sys/organization/sys_org_person/chgPersonInfo.do?method=chgMyPwd&fdId="
			+ userId;
	window.open(url, "_blank");
}

function logout() {
	art.artDialog.confirm(Kms_MessageInfo["kms.common.logout"], function() {
				location.href = KMS.contextPath + 'logout.jsp';
			});
}
// 显示Alert
function showAlert(content) {
	// art.artDialog.alert(content);
	art.artDialog({
				content : content,
				height : '50px',
				width : '250px',
				id : 'showAlertID',
				icon : "warning",
				lock : true,
				background : '#fff', //
				opacity : 0, //
				yesFn : function() {
				},
				yesVal : Kms_MessageInfo["button.enter"]

			});
}
// 显示confirm
function showConfirm(content, yesFn, noFn) {
	// art.artDialog.confirm(content, yesFn, noFn);
	art.artDialog({
				content : content,
				height : '50px',
				width : '250px',
				id : 'showAlertID',
				icon : "question",
				lock : true,
				background : '#fff', //
				opacity : 0, //
				yesFn : yesFn,
				noFn : noFn
			});
}
function closeThisWindow() {
	content = Kms_MessageInfo["kms.common.closeAlter"];
	showConfirm(content, function() {
		try {
			var win = window;
			for (var frameWin = win.parent; frameWin != null && frameWin != win; frameWin = win.parent) {
				if (frameWin["Frame_CloseWindow"] != null) {
					frameWin["Frame_CloseWindow"](win);
					return;
				}
				win = frameWin;
			}
		} catch (e) {
		}
		try {
			top.opener = top;
			top.close();
		} catch (e) {
		}
	}, true);
}