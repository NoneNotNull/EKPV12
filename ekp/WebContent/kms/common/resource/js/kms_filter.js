/*
 * 列表筛选项
 */

KMS.filter = {

	// 是否多选查询
	selectMore : false,

	// 筛选项id与val的数组集合
	beanParm : [],

	// 当前点击筛选项id
	settingId : '',

	filterParm : {},

	refreshFunc : null,

	filterArea : null,

	// 初始化筛选
	filterInit : function(id, filterConfigId, modelName, templateModelId,
			templateModelName, refreshFunc) {

		var str = [];
		str
				.push("<div class='title2 title2_2 m_t20 c'  id='selectByCondition'  >");
		str.push("<h2 class='h2_2'   >")
		str.push(Kms_MessageInfo["kms.filter.caseSelect"]);
		str.push("</h2><div class='btns_box'>");
		str
				.push("<div class='btn_a'><a title='"
						+ Kms_MessageInfo["kms.filter.query"]
						+ "' href='javascript:void(0)'  style='display:none' id='searchBtn' onclick='searchMulti()'><span>"
						+ Kms_MessageInfo["kms.filter.query"]
						+ "</span></a></div>");
		str
				.push("<div class='btn_c' ><a title='"
						+ Kms_MessageInfo["kms.filter.multiple"]
						+ "' href='javascript:void(0)' onclick='setSelectMore(this)'><span>"
						+ Kms_MessageInfo["kms.filter.multiple"]
						+ "</span></a></div>");
		str.push("</div></div>");
		var header = $(str.join(''));
		var filter = $("<div>").attr("id", "filter").css("position", "static")
				.addClass("classify c datagrid");
		$("#" + id).append(header);
		$("#" + id).append(filter);

		this.filterArea = filter;
		this.refreshFunc = refreshFunc;
		this.filterParm.filterConfigId = filterConfigId;
		this.filterParm.modelName = modelName;
		this.filterParm.templateModelId = templateModelId;
		this.filterParm.templateModelName = templateModelName;

		// 加载筛选项
		this.doOption();
	},

	doOption : function(proValue, proKey) {
		var param = {
			s_bean : "sysPropertyFilterService",
			filterConfigId : this.filterParm.filterConfigId,
			mainModelName : this.filterParm.modelName,
			templateId : this.filterParm.templateModelId,
			templateModelName : this.filterParm.templateModelName,
			date : jQuery.now()
		}
		if (proKey) {
			param.proKey = proKey.indexOf("property:") > -1 ? proKey
					.substring(9) : proKey;
			param.proValue = proValue;
		}
		// 判断非分类进入的筛选，不需要在筛选时过滤选项
		if (this.filterParm.filterConfigId && proKey)
			return;
		$.getJSON(KMS.contextPath + "sys/property/jsonp.jsp", param, function(
						data) {
					KMS.filter.doOptionAfter(data, proKey,proValue);
				});
	},

	doOptionAfter : function(data, proKey,proValue) {
		if("" == proKey && "" == proValue){ 
			data = null ;
		}
		var filter = KMS.filter.filterArea;
		var showMore = false;
		if (data) {
			if (!proKey) {
				KMS.filter.data = data;
			}
			for (var i = 0; i < data.length; i++) {
				if (proKey) {
					$("ul>li#filter_" + data[i]["settingId"]).remove();
					if(!proValue){
						return;
					}
				}
				
				var ul = $("<ul>");
				$(ul).addClass("c");
				if (i >= 3) { // 显示3组筛选条件
					$(ul).hide();
					showMore = true;
					filter.append("<font/>");
				}
				var li = $("<li>").attr("id", "filter_" + data[i]["settingId"]);
				li.attr("parent", proKey)
				if (i == 0) {
					li.addClass("none c");
				} else {
					li.addClass("c");
				}
				var titleElem = $("<strong>").text(data[i]["title"] + "：");
				li.append(titleElem);
				var ulItems = $("<ul>").attr("class", "options");
				var liItem = $("<li>")
				ulItems.append(liItem);
				li.append(ulItems);
				var aElem = $("<a>").attr("href", "javascript:void(0)").attr(
						"settingId", data[i]["settingId"]).attr("property",
						data[i]["propertyName"]).attr("displayType",
						data[i]["type"] || '').click(this.noSelectClickEvent);
				aElem.html(Kms_MessageInfo["kms.filter.noLimit"]);
				aElem.addClass('gray');
				liItem.append(aElem);
				var showMoreThisLine = false;
				var options = data[i]["option"];
				var settingId = data[i]["settingId"];
				var property = data[i]["propertyName"];
				var type = data[i]["type"];
				// 筛选类型
				var filterType = KMS.filter.filterType;
				for (var type in filterType) {
					filterType[type]['view'].call(this, data[i], ulItems);
				}
				// 筛选项
				for (var j = 0; j < options.length; j++) {
					liItem = $("<li>")
					var a = $("<a>");
					if (j >= 5) {
						liItem.hide();
						showMoreThisLine = true;
						ulItems.append("<font/>");
					}
					var va = options[j]["value"];
					$(a).click(this.optionClickEvent);
					$(a).text(resetStrLength(options[j]["name"], 12));
					$(a).attr('title', options[j]["name"]);
					$(a).attr('href', 'javascript:void(0)');
					$(a).attr("id", options[j]["value"]).attr("settingId",
							data[i]["settingId"]).attr("property",
							data[i]["propertyName"]).attr("displayType",
							data[i]["type"] || '');
					var checkbox = $("<input type='checkbox' value='" + va
							+ "'  class='myCheckboxClass' id='checkbox_"
							+ options[j]["value"] + "_" + data[i]["settingId"]
							+ "' /> ");
					$(checkbox).click(this.checkboxClickEvent);
					if (!KMS.filter.selectMore) {
						checkbox.hide();
					}
					liItem.append(checkbox);
					liItem.append(a);
					ulItems.append(liItem);
				}
				var more = ("<a href='javascript:void(0);' ><span onclick='showMoreFilter(this)' class='strSpan' >"
						+ Kms_MessageInfo["kms.filter.more"] + " </span></a>");
				if (showMoreThisLine) {
					li.append(more);
				}
				ul.append(li);
				if (proKey) {
					// 级联数据时，判断选项是否为空，不为空才显示
					if (data[i]["option"].length) {
						proKey = proKey.substring(proKey.indexOf(":")+2);
						ul.insertAfter($("a[property*=" + proKey + "]")[0].parentNode.parentNode.parentNode.parentNode);
					}
				} else {
					filter.append(ul);
				}
			}
		}
		var more = (" <a href='javascript:void(0)' onclick='showMoreContidion(this);' id='strHref'><span id='strSpan'>"
				+ Kms_MessageInfo["kms.filter.moreSelect"] + "</span></a>");
		if (showMore) {
			filter.append("<div class='clear' />").append(more)
					.append("<div  class='clear'/>");
		} else {
			filter.append("<div  class='clear'/>");
		}
	},

	// 选择选项事件
	optionClickEvent : function() {

		var parent = $(this).parent();
		// 文本框清空值
		parent.find('input[class=myTreeClassHidden]').val('');
		parent.find('input[class=myTreeClass]').val('');
		// 组合筛选项
		sysProp_doFilter($(this).attr('settingId'), $(this).attr('id'), $(this)
						.attr("property"), $(this).attr("displayType"));
		if (KMS.filter.selectMore) { // 启用多选
			var checkbox = $(this).prev();
			if ($(checkbox).attr('checked')) {
				$(checkbox).attr('checked', false);
				$(this).removeClass('gray');
			} else {
				$(checkbox).attr('checked', true);
				$(this).addClass('gray');
			}
			// 移除级联子选项
			removeChildOption($(this).attr('property'));
			parent.parent().find('a:eq(0)').removeClass('gray');
		} else { // 单选
			parent.parent().children().children().removeClass('gray');
			$(this).addClass('gray');
			// 移除级联子选项
			removeChildOption($(this).attr('property'));
			sysProp_doFilter_refresh();
		}
	},

	// 选择“不限”事件
	noSelectClickEvent : function() {

		var parent = $(this).parent().parent();
		parent.children().children().removeClass('gray');
		$(this).addClass('gray');
		parent.find('input[type=text]').val('');
		// 文本框清空值
		parent.find('input[class=myTreeClassHidden]').val('');
		parent.find('input[class=myTreeClass]').val('');
		if (KMS.filter.selectMore) { // 启动多选
			parent.find('input[type=checkbox]').attr('checked', false);
		}
		// 移除级联子选项
		removeChildOption($(this).attr('property'));
		// 组合筛选项
		sysProp_doFilter($(this).attr('settingId'), $(this).attr('id'), $(this)
						.attr('property'), null);
		if (!KMS.filter.selectMore) {
			sysProp_doFilter_refresh();
		}
	},

	// 点击复选框事件
	checkboxClickEvent : function() {

		var next = $(this).next();
		// 移除级联子选项
		removeChildOption(next.attr('property'));
		// 组合筛选项
		sysProp_doFilter(next.attr('settingId'), next.attr('id'), next
						.attr("property"), next.attr("displayType"));
		if ($(this).attr('checked')) {
			$(next).addClass('gray');
		} else {
			$(next).removeClass('gray');
		}
		$(next).parent().parent().find('a:eq(0)').removeClass('gray');
	},

	filterType : {
		isText : {
			view : function(data, context) {
				if (data["isText"]) { // 模糊查询
					var type = data['type'];
					var property = data['propertyName'];
					var settingId = data["settingId"];
					var textId = "text_" + settingId;
					var textInput = $("<input type='text' settingId="
							+ settingId + " class='myTextClass' title='"
							+ Kms_MessageInfo["kms.filter.input"]
							+ "' size ='8' id='" + textId + "' displayType="
							+ type + " property=" + property + "   /> ");
					textInput.blur(function() {
								checkTextValue(this);
							});
					context.append("&nbsp;");
					context.append(textInput);
					context.append("&nbsp;");
				}
			},
			multiSearch : function(data, vals) {
				if (data['isText']) {
					var settingId = data["settingId"];
					var textId = "text_" + settingId;
					if ($("#" + textId)[0].value.length > 0) {
						var v = ";" + $("#" + textId)[0].value;
						vals = vals + v;
					}
				}
				return vals;
			}
		},
		isRang : {
			view : function(data, context) {
				if (data["isRange"]) {// 区间查询
					var settingId = data["settingId"];
					var type = data['type'];
					var property = data['propertyName'];
					var thisId1 = "text_" + settingId + "_1";
					var thisId2 = "text_" + settingId + "_2";
					var text1 = $("<input type='text' settingId=" + settingId
							+ " class='myTextClass' title='"
							+ Kms_MessageInfo["kms.filter.input"]
							+ Kms_MessageInfo["kms.filter.number"]
							+ "'  size ='8' id='" + thisId1 + "' displayType="
							+ type + " property=" + property + "  /> ");
					var text2 = $("<input type='text' settingId=" + settingId
							+ " class='myTextClass' title='"
							+ Kms_MessageInfo["kms.filter.input"]
							+ Kms_MessageInfo["kms.filter.number"]
							+ "' size ='8' id='" + thisId2 + "' displayType="
							+ type + " property=" + property + "  /> ");
					var butt = $("<input type='button' settingId=" + settingId
							+ " value='" + Kms_MessageInfo["kms.filter.enter"]
							+ "' class='myButtonClass' />");
					butt.click(function() {
								beginSearch(this);
							});
					text1.blur(function() {
								checkRangeValue(this);
							});
					text2.blur(function() {
								checkRangeValue(this);
							});
					context.append("&nbsp;");
					context.append(text1);
					context.append("-");
					context.append(text2);
					context.append("&nbsp;");
					context.append(butt);
				}
			},
			multiSearch : function(data, vals, type) {
				if (data['isRange']) {
					var settingId = data["settingId"];
					var textId1 = "text_" + settingId + "_1";
					var textId2 = "text_" + settingId + "_2";
					var v = ";" + $("#" + textId1)[0].value + ";"
							+ $("#" + textId2)[0].value;
					vals = vals + v;
					type = "BT";
				}
				return vals;
			}
		},
		isOrg : {
			view : function(data, context) {
				if (data["isOrg"]) {
					if (data["dialogJs"]) { // 地址本
						var settingId = data["settingId"];
						context.append("&nbsp;");
						$("<input type='hidden' class='myTreeClassHidden' id='moreOptionId_"
								+ settingId
								+ "' name='moreOptionId_"
								+ settingId + "' />").appendTo(context);
						$("<input size='8' class='myTreeClass' name='moreOptionName_"
								+ settingId + "' />").attr("readonly", "true")
								.attr("property", data["propertyName"]).attr(
										"displayType", data["type"])
								.appendTo(context);
						var aElem = $("<a />").attr("settingId", settingId)
								.attr("dialogJs", data["dialogJs"]).attr(
										"href", "javascript:void(0);").click(
										function() {
											var settingId = KMS.filter.settingId = $(this)
													.attr("settingId");
											var js = $(this)
													.attr("dialogJs")
													.replace(
															"!{mulSelect}",
															KMS.filter.selectMore);
											js = js
													.replace("!{idField}",
															"moreOptionId_"
																	+ settingId);
											js = js.replace("!{nameField}",
													"moreOptionName_"
															+ settingId);
											var customFun = new Function(js);
											customFun();
										});
						aElem.html(Kms_MessageInfo["kms.filter.select"]);
						aElem.appendTo(context);
					}
				}
			},
			multiSearch : function(data, vals) {
				if (data['isOrg']) {
					var settingId = data["settingId"];
					var treeId = "moreOptionId_" + settingId;
					if ($("#" + treeId)[0].value.length > 0) {
						var v = ";" + $("#" + treeId)[0].value;
						vals = vals + v;
					}
				}
				return vals;
			}
		},
		isTree : {
			view : function(data, context) {
				if (data["isTree"]) {
					if (data["dialogJs"]) { // 树
						var settingId = data["settingId"];
						context.append("&nbsp;");
						$("<input type='hidden' class='myTreeClassHidden' id='moreOptionId_"
								+ settingId
								+ "' name='moreOptionId_"
								+ settingId + "' />").appendTo(context);
						$("<input size='8' class='myTreeClass' name='moreOptionName_"
								+ settingId + "' />").attr("readonly", "true")
								.attr("property", data["propertyName"]).attr(
										"displayType", data["type"])
								.appendTo(context);
						var aElem = $("<a />").attr("settingId",
								data["settingId"]).attr("dialogJs",
								data["dialogJs"]).attr("href",
								"javascript:void(0);").click(function() {
							var settingId = KMS.filter.settingId = $(this)
									.attr("settingId");
							var js = $(this).attr("dialogJs").replace(
									"!{mulSelect}", KMS.filter.selectMore);
							js = js.replace("!{idField}", "moreOptionId_"
											+ settingId);
							js = js.replace("!{nameField}", "moreOptionName_"
											+ settingId);
							js = js.replace("&amp;", "&");
							js = js.replace("&amp;", "&");
							var customFun = new Function(js);
							customFun();
						});
						aElem.html(Kms_MessageInfo["kms.filter.select"]);
						aElem.appendTo(context);
					}
				}
			},
			multiSearch : function(data, vals) {
				if (data['isTree']) {
					var settingId = data["settingId"];
					var treeId = "moreOptionId_" + settingId;
					if ($("#" + treeId)[0].value.length > 0) {
						var v = ";" + $("#" + treeId)[0].value;
						vals = vals + v;
					}
				}
				return vals;
			}
		},
		isCalendar : {
			view : function(data, context) {
				if (data["isCalendar"]) {
					if (data["dialogJs"]) { // 日期选择框
						var settingId = data["settingId"];
						context.append("&nbsp;");
						$("<input type='hidden' class='myTreeClassHidden' id='moreOptionId_"
								+ settingId
								+ "' name='moreOptionId_"
								+ settingId + "' />").appendTo(context);
						$("<input size='8' class='myTreeClass' name='moreOptionName_"
								+ settingId + "' />").attr("readonly", "true")
								.attr("property", data["propertyName"]).attr(
										"displayType", data["type"])
								.appendTo(context);
						var aElem1 = $("<a />").attr("settingId",
								data["settingId"]).attr("dialogJs",
								data["dialogJs"]).attr("href",
								"javascript:void(0);").click(function() {
							var settingId = KMS.filter.settingId = $(this)
									.attr("settingId");
							var js = $(this).attr("dialogJs");
							js = js.replace("!{nameField}", "moreOptionName_"
											+ settingId);
							js = js.replace("&amp;", "&");
							js = js.replace("&amp;", "&");
							var customFun = new Function(js);
							console.log(customFun);
							customFun();
						});
						aElem1.html(Kms_MessageInfo["kms.filter.select"]);
						aElem1.appendTo(context);
						context.append("-&nbsp;");
						$("<input size='8' class='myTreeClass' name='toMoreOptionName_"
								+ settingId + "' />").attr("readonly", "true")
								.appendTo(context);
						var aElem2 = $("<a />").attr("settingId",
								data["settingId"]).attr("dialogJs",
								data["dialogJs"]).attr("href",
								"javascript:void(0);").click(function() {
							var settingId = KMS.filter.settingId = $(this)
									.attr("settingId");
							var js = $(this).attr("dialogJs");
							js = js.replace("!{nameField}", "toMoreOptionName_"
											+ settingId);
							js = js.replace("&amp;", "&");
							js = js.replace("&amp;", "&");
							var customFun = new Function(js);
							customFun();
						});
						aElem2.html(Kms_MessageInfo["kms.filter.select"]);
						aElem2.appendTo(context);
					}
				}
			},
			multiSearch : function(data, vals) {
				//
				return vals;
			}
		}
	}
}

// 显示当前筛选项更多选项
function showMoreFilter(obj) {
	var div = $(obj).parent().prev();
	if (KMS.filter.selectMore) {
		$(div).find('font').nextAll().toggle();
	} else {
		$(div).find('font').nextAll().filter('li').toggle();
	}
	if ($(obj).text() == Kms_MessageInfo["kms.filter.folded"]) {
		$(obj).text(Kms_MessageInfo["kms.filter.more"]);
		$(obj).attr("title", Kms_MessageInfo["kms.filter.more"]);
	} else {
		$(obj).text(Kms_MessageInfo["kms.filter.folded"]);
		$(obj).attr("title", Kms_MessageInfo["kms.filter.folded"]);
	}
};

// 显示更多筛选条件
function showMoreContidion(obj) {
	
	var nextall = $("#filter").find('font').nextAll();

	$(nextall).each(function(index) {
		
				if ($(this).get(0).tagName == 'UL'){
					$(this).toggle();
				
				}
					
			});
	if ($('#strSpan').text() == Kms_MessageInfo["kms.filter.folded"]) {
		$('#strSpan').text(Kms_MessageInfo["kms.filter.moreSelect"]);
		$('#strSpan').attr('title', Kms_MessageInfo["kms.filter.moreSelect"]);
	} else {
		$('#strSpan').text(Kms_MessageInfo["kms.filter.folded"]);
		$('#strSpan').attr('title', Kms_MessageInfo["kms.filter.folded"]);
	}
};

// 刷新页面
function sysProp_doFilter_refresh() {
	KMS.filter.refreshFunc(KMS.filter.beanParm);
}

function removeChildOption(property) {
	if (property) {
		$('[parent]').each(function() {
					if ($(this).attr('property') == property) {
						$(this).attr("id").substring(7).attr("property");
						// 递归查找是否有子项
						if (childPropertyName) {
							removeChildOption(childPropertyName);
						}
						sysProp_doFilter_remove(filterId);
						$("ul:has(#filter_" + filterId + ")").remove();
					}
				});
	}
}

// 筛选项刷新
function sysPro_doOptions_refresh(proVal, proKey) {
	KMS.filter.doOption(proVal, proKey);
}

// 组合筛选项
function sysProp_doFilter(settingId, settingVal, property, displayType, func) {
	var beanParm = KMS.filter.beanParm;
	if (settingId) {
		if (beanParm && beanParm.constructor == Array) {
			if (beanParm.length > 0) {
				// beanParm = JSON.parse(beanParm);
				var index = -1;
				for (var i = 0; i < beanParm.length; i++) {
					if (beanParm[i]["settingId"] == settingId) {
						index = i;
						break;
					}
				}
				// 多选
				if (KMS.filter.selectMore) {
					var filterData = KMS.filter.data, filter;
					for (var i = 0; i < filterData.length; i++) {
						if (filterData[i].settingId == settingId) {
							filter = filterData[i];
							break;
						}
					}
					
					if (filter.option && filter.option.length > 0) {
						var vals = "";
						$("a[settingId=" + settingId + "]").each(function() {
									if (this.id
											&& $(this).prev().attr("checked")) {
										vals = vals
												? vals + ";" + this.id
												: this.id;
									}
								})
						settingVal = vals;
					}
				}
				// 删除当前筛选项
				if (index != -1) {
					beanParm.splice(index, 1);
				}
			}
		} else {
			beanParm = [];
		}
		// 为空时为不限，清空当前筛选项数据
		if (settingVal) {
			beanParm.push({
						selectVal : settingVal,
						settingId : settingId,
						property : property,
						type : displayType
					});
		}
		KMS.filter.beanParm = beanParm;
	}
	// 过滤筛选项
	sysPro_doOptions_refresh(settingVal, property);
};

// 移除筛选项
function sysProp_doFilter_remove(settingId) {
	var beanParm = KMS.filter.beanParm;
	if (settingId) {
		if (beanParm) {
			if (beanParm.constructor == Array && beanParm.length != 0) {
				// beanParm = JSON.parse(beanParm);
				var index = -1;
				for (var i = 0; i < beanParm.length; i++) {
					if (beanParm[i]["settingId"] == settingId) {
						index = i;
						break;
					}
				}
				if (index != -1) {
					beanParm.splice(i, 1);
				}
			} else {
				beanParm = new Array();
			}
		}
	}
}

// 清空筛选项
function sysProp_doFilter_clear(func) {
	KMS.filter.refreshFunc(null);
}

// 单行文本筛选
function checkTextValue(obj) {
	var settingId = $(obj).attr('settingId');
	sysProp_doFilter(settingId, $('#text_' + settingId).val(), $(obj)
					.attr('property'), $(obj).attr('displayType'));
	sysProp_doFilter_refresh();
	if ($(obj).val() != '') {
		$(obj).parent().children().removeClass('gray');
	} else
		$(obj).parent().find('a:eq(0)').addClass('gray');
}

// 地址框筛选
function SysProp_FilterSel(data) {
	var settingId = KMS.filter.settingId;
	var e = arguments[1] || window.event;
	var src = e.target || window.event.srcElement;
	var obj = document.getElementsByName("moreOptionName_" + settingId)[0];
	var v = obj.value;

	if (data && settingId) {
		var dat = data.GetHashMapArray();
		if (v != '') {
			sysProp_doFilter(settingId, dat[0].id,
					obj.getAttribute('property'), obj
							.getAttribute('displayType'));
			$(src).parent().children().children().removeClass('gray');
		} else {
			sysProp_doFilter(settingId, '', '', '');
			$(src).parent().find('a:eq(0)').addClass('gray');
		}
		if (!KMS.filter.selectMore) {
			sysProp_doFilter_refresh();
		}
	}
}

// 树型筛选后
function SysProp_Tree_Sel_After(data) {
	var settingId = KMS.filter.settingId;
	var obj = document.getElementsByName("moreOptionName_" + settingId)[0];
	var v = obj.value;
	var e = arguments[1] || window.event;
	var src = e.target || window.event.srcElement;

	if (data && settingId) {
		var dat = data.GetHashMapArray();
		if (v != '') {
			sysProp_doFilter(settingId, dat[0].id,
					obj.getAttribute('property'), obj
							.getAttribute('displayType'));
			$(src).parent().children().removeClass('gray');
		} else {
			sysProp_doFilter(settingId, '', '', '');
			$(src).parent().find('a:eq(0)').addClass('gray');
		}
		if (!KMS.filter.selectMore)
			sysProp_doFilter_refresh();
	}
}

// 日期筛选
function calendar_Sel_After() {
	var settingId = KMS.filter.settingId;
	var text1 = document.getElementsByName("moreOptionName_" + settingId)[0];
	var text2 = document.getElementsByName("toMoreOptionName_" + settingId)[0];
	if (settingId) {
		if (text1.value || text2.value) {
			sysProp_doFilter(settingId, text1.value + ";" + text2.value, text1
							.getAttribute('property'), text1
							.getAttribute('displayType'));
			$(text1).parent().children().removeClass('gray');
		} else {
			sysProp_doFilter(settingId, '', '', '');
			$(text1).parent().find('a:eq(0)').addClass('gray');
		}
		if (!KMS.filter.selectMore) {
			sysProp_doFilter_refresh();
		}

	}
}

// 多选与单选切换
function setSelectMore(obj) {
	var span = $(obj).find('span')[0];
	$('#filter > ul > li > div > a').removeClass('gray');
	$('#filter > ul > li > div').find('a:eq(0)').addClass('gray');
	$('.myTextClass').val("");
	$('.myTreeClass').val("");
	$('.myTreeClassHidden').val("");
	$("ul:has(li[parent])").remove();
	if ($(span).text() == Kms_MessageInfo["kms.filter.multiple"]) {
		KMS.filter.selectMore = true;
		$('.myCheckboxClass').attr('checked', false);
		$('.myCheckboxClass').each(function() {
					var a = $(this).next();
					if ($(a).css('display') != 'none') {
						$(this).show();
					}
				});
		$('#searchBtn').show();
		$('.myButtonClass').hide();
		$('.myTreeClass').attr("size", 23);
		$(span).text(Kms_MessageInfo["kms.filter.onlySelect"]);
		$(span).attr("title", Kms_MessageInfo["kms.filter.onlySelect"]);
	} else {
		KMS.filter.selectMore = false;
		$('.myCheckboxClass').hide();
		$('#searchBtn').hide();
		$('.myButtonClass').show();
		$('.myTreeClass').attr("size", 8);
		$(span).text(Kms_MessageInfo["kms.filter.multiple"]);
		$(span).attr("title", Kms_MessageInfo["kms.filter.multiple"]);
	}
	sysProp_doFilter_clear();// 清空查询条件
}

/** ******** 浮点筛选项 ********* */

function beginSearch() {
	if (!KMS.filter.selectMore) {
		sysProp_doFilter_refresh();
	}
}

function checkRangeValue(obj) {
	var settingId = $(obj).attr("settingId");
	var v1 = $('#text_' + settingId + '_1').val();
	var v2 = $('#text_' + settingId + '_2').val();
	var val = $.trim(v1) + ";" + $.trim(v2);
	if (!checInputkDigit(v1)) {
		alert(Kms_MessageInfo["kms.filter.rightNumber"]);
		$('#text_' + settingId + '_1').val('');
		$('#text_' + settingId + '_1').focus();
		return false;
	}
	if (!checInputkDigit(v2)) {
		alert(Kms_MessageInfo["kms.filter.rightNumber"]);
		$('#text_' + settingId + '_2').val('');
		$('#text_' + settingId + '_2').focus();
		return false;
	}
	sysProp_doFilter(settingId, val, $(obj).attr('property'), $(obj)
					.attr('displayType'));
	if ($.trim(obj.value) != '')
		$(obj).parent().children().removeClass('gray');
	if ($.trim(v1) == '' && $.trim(v2) == '')
		$(obj).parent().find('a:eq(0)').addClass('gray');
}

// 数字校验
function checInputkDigit(s) {
	var strArray = s.split(".");
	if ($.trim(s) == '')
		return true;
	if (strArray.length == 1) {
		return isDigit(s);
	}
	if (strArray.length == 2) {
		return isDigit2(s);
	}
	return false;
}

function isDigit(s) { // 校验整数
	var patrn = /^-?[1-9][0-9]{0,9}$|^0$/;
	if (!patrn.exec(s))
		return false;
	return true;
}

function isDigit2(s) { // 校验小数
	var patrn = /^-?[1-9]+\d*[\.\d]?\d{0,10}$|^-?0\.\d*$/; // 最大可允许十位小数
	if (!patrn.exec(s))
		return false;
	return true;
}

/** ******** 浮点筛选项 end********* */

// 多选查询点击事件
function searchMulti() {
	var data = KMS.filter.data;
	for (i = 0; i < data.length; i++) {
		var isOptions = data[i]["option"];
		var settingId = data[i]["settingId"];
		var property = data[i]['propertyName'];
		var displayType = "IN";
		var vals = "";
		if (isOptions) {
			for (var j = 0; j < isOptions.length; j++) {
				var va = isOptions[j]["value"];
				// 修正jquery选择器不能取得ID中带“;”的对象 郭昌平
				var domEle = document.getElementById("checkbox_" + va + "_"
						+ settingId);
				if (domEle.checked) {
					var v = ";" + domEle.value;
					vals = vals + v;
				}
			}
		}
		var filterType = KMS.filter.filterType;
		for (var type in filterType) {
			vals = filterType[type]['multiSearch'].call(this, data[i], vals,
					displayType);
		}

		if (vals) {
			vals = vals.substring(1);
		}
		// sysProp_doFilter(settingId, vals, property, displayType);
	}
	sysProp_doFilter_refresh();
};
