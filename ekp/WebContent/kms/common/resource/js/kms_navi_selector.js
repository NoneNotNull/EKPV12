/*
 * ! KMS Navigation Selector JS Component Copyright 2010,
 * Landray(http://www.landray.com.cn) Description:
 * NaviSelector旨在实现多级ajax分类导航式目录式选择功能，常用的场景是 用于选择知识分类、爱问分类级各种分类选择，风格直观明了，相比传统的目录
 * 树形控件，用户体验、友好性更棒。
 * 
 * Requires: [ kms.js, jquery.js ] Author: yangf@landray.com.cn Date: 2011/8/18
 * 11:39 Version: v1.0 增加全局参数doc，用于页面iframe布局ie6兼容使用 by hongzq 20120114
 */

;  
(function(jq, doc) {

	var NaviSelector = EventTarget.extend({ // 继承自EventTarget

		categoryAuthIds : "",
		allNavItem : null,
		// 读取有权限查看的父分类ID
		loadAuthNodesValue : function(options) {
			var authType = options.dataSource.authType || "02";
			this.categoryAuthIds = new KMSSData()
					.AddBeanData("sysSimpleCategoryAuthList&modelName="
							+ options.dataSource.modelName + "&authType="
							+ authType).GetHashMapArray();
		},

		// context为NaviSelector所在的dom结构，可能是document.body也可能是一个div...
		constructor : function(context, options) {
			
			if(!options.isCustom){
				// 读取所有有权限id
				this.loadAuthNodesValue(options);
			}

			this.options = {
				// dataSource: { url: 'URL', data: {}} // 设置获取数据的url及参数
				fontSize : "13px", // 默认字体大小
				size : 8, // 默认显示选项个数
				bindingField : {
					fdId : "fdId",
					fdName : "fdName"
				},
				single : false
				// 单列模式
			};
			this.ctx = jq(context);
			// 当前展现的选择域
			this.nvCache = [];
			// cache数组，用于缓存当前选择的项目
			this.selectedCache = [];
			// 可以显示的选择框位置，默认是从第一个到第三个，即最多显示三个选择框
			this.slot = [1, 3];
			// 继承父类构造函数
			this.base(options);
			// 无阻塞样式引入
			this.loadStyle();
			var opts = this.options;
			// 计算每个选择区域的默认显示高度
			this._nvHeight = 27 * opts.size;
			// 初始化html结构
			this.mainBox = jq(doc.createElement('div'));
			this.mainBoxClear = jq(doc.createElement('div'));
			//高版本jquery不支持className设置--故修改
			this.mainBoxClear.attr('class', 'clear');
			this.mainBox.append(this.mainBoxClear);
			this.navInfoBox = jq(doc.createElement('p'));
			this.navInfoBox.attr('class', 'tips_classify');
			this.navInfoBox.css("display", "none");
			this.messageInfo = jq(doc.createElement('p'));
			this.messageInfo.attr('class', 'tips_classify');
			this.messageInfo.css("display", "none");
			this.ctx.append(this.mainBox);
			this.ctx.append(this.navInfoBox);
			this.ctx.append(this.messageInfo);
			this.ctx.addClass("nav_wrapper");
			this.ctx.css("height", this._nvHeight);
			return this;
		},

		// 启动NaviSelector
		setup : function() {
			this.loadData();
			return this;
		},

		// 加载数据并呈现选择项目
		loadData : function(params) {
			// 复制参数
			var dataSource = this.options.dataSource;
			var categoryId = "";
			if (params) {
				categoryId = params.fdId;
			}
			if(dataSource.isCustom){
				 if(params){
					 dataSource.data.fdId = params.fdId;
				 }
				 jq.extend(true, params, dataSource.data);
						jq.ajax( {
							type : "GET",
							url : dataSource.url,
							data : dataSource.data,
							cache : false,
							beforeSend : this.onBeforeSend.binding(this),
							success : this.onSuccessLoad.binding(this),
							error : this.onErrorLoad.binding(this)
						});
			}else{
				var authType = dataSource.authType || "02";
				
				var list = new KMSSData()
				.AddBeanData("sysSimpleCategoryTreeService&modelName="
						+ dataSource.modelName + "&authType=" + authType
						+ "&categoryId=" + categoryId).GetHashMapArray();
				if (list.length > 0) {
					this.renderData(list);
				}
			}
		},

		onBeforeSend : function(xmlHttp) {
		},

		onErrorLoad : function(xmlHttp, textStatus, error) {
			alert(error);
		},

		onSuccessLoad : function(data, textStatus, xmlHttp) {
			if (data && jq.isArray(data) && data.length > 0) {
				this.renderData(data);
			}
		},

		renderData : function(data) {
			// 计算当前的层级
			var len = this.nvCache.length;
			var level = len + 1;
			// 当分类至少有两级的时候，显示箭头
			if (len > 0) {
				this._addArrRightIcon(this.nvCache[len - 1]);
			}

			// 当前选择区域超出限定的可显示的选择区域
			if (this.slot[1] <= this.nvCache.length) {
				var toBeHidden = this.nvCache[this.slot[0] - 1];
				if (toBeHidden["arrRight"])
					toBeHidden["arrRight"].hide();
				toBeHidden["selArea"].hide();
				this.slot[0] += 1;
				this.slot[1] += 1;
				// 添加滚动按钮
				this._addScrollBtn();
			}

			var div = jq(doc.createElement("div"));
			div.addClass("nav_selector");
			var ulist = jq(doc.createElement("ul"));
			if (level > 1)
				this._addNoSelectionItem(ulist, div, level);
			for (var i = 0, len = data.length; i < len; i++) {
				if (this.options.dataSource.isCustom || this._checkAuth(data[i])) {
					var lstItem = jq(doc.createElement("li"));
					lstItem.html("<a href=\"javascript:void(0)\" id=\""
							+ data[i]["value"] + "\" title=\""
							+ data[i]["text"] + "\">" + data[i]["text"]
							+ "</a>");
					ellipsis(lstItem);
					// 创建一个NaviItem结构
					var navItem = new NaviItem();
					navItem._nav = div;
					navItem._elem = lstItem;
					navItem._data = data[i];
					navItem._level = level;

					// 绑定事件
					lstItem.bind("click", this.onItemClick.binding(this,
									lstItem, navItem));
					lstItem.bind("dblclick", this.onItemDblclick.binding(this,
									lstItem, navItem));
					lstItem.bind("mouseover", this.onItemMouseover.binding(
									this, lstItem));
					lstItem.bind("mouseout", this.onItemMouseout.binding(this,
									lstItem));
					ulist.append(lstItem);
				}
			}

			ulist.css("font-size", this.options.fontSize)
					// .css("overflow-y", "auto")
					.css("height", this._nvHeight);
			div.css("height", this._nvHeight);
			div.append(ulist);
			div.level = level;
			div.insertBefore(this.mainBoxClear);
			// 将构造的选择区域加入缓存
			this.nvCache.push({
						"arrRight" : null,
						"selArea" : div
					});
		},

		// 判断该分类下是否有子分类的权限
		_checkAuth : function(nodeValue) {
			if (nodeValue["isShowCheckBox"] != "0") {
				return true;
			}
			// 若节点自身没有权限，则判断是否需要显示
			var value = nodeValue["value"];
			for (var i = 0; i < this.categoryAuthIds.length; i++) {
				if (this.categoryAuthIds[i]["v"] == value) {
					return true;
				}
			}
			return false;
		},

		// 增加不选项
		_addNoSelectionItem : function(wrapper, div, level) {
			var lstItem = jq("<li><a href=\"javascript:void(0)\">"
					+ Kms_MessageInfo["kms.navi.noSelect"] + "</a></li>");
			lstItem.addClass("focus");
			lstItem.appendTo(wrapper);

			// 创建一个NaviItem结构
			var navItem = new NaviItem();
			navItem._nav = div;
			navItem._elem = lstItem;
			navItem._data = null;
			navItem._level = level;
			navItem._isNoSelect = true;

			this.noSelectItem = navItem;
			lstItem.bind("click", this.onItemClick.binding(this, lstItem,
							navItem));
			lstItem.bind("mouseover", this.onItemMouseover.binding(this,
							lstItem));
			lstItem
					.bind("mouseout", this.onItemMouseout
									.binding(this, lstItem));

		},

		_addArrRightIcon : function(nv) {
			var yPos = (this._nvHeight - 18) / 2;
			nv.arrRight = jq("<span class=\"arrow_right\"></span>").css(
					"margin-top", yPos).insertBefore(this.mainBoxClear);
		},

		// 添加滚动按钮，用于切换选择区域
		_addScrollBtn : function() {
			if (!this.hasScrollBtn) {
				var yPos = (this._nvHeight - 44) / 2;
				// 兼容ie6.7
				this.scrollLeftBtn = jq('<div></div><a href="javascript:void(0)" class="scroll_left" title="'
						+ Kms_MessageInfo["kms.navi.left"] + '"></a>');
				this.scrollLeftBtn.css("top", yPos);
				this.scrollRightBtn = jq('<div></div><a href="javascript:void(0)" class="scroll_right" title="'
						+ Kms_MessageInfo["kms.navi.right"] + '"></a>');
				this.scrollRightBtn.css("top", yPos);
				this.scrollLeftBtn.insertBefore(this.mainBoxClear);
				this.scrollRightBtn.insertBefore(this.mainBoxClear);
				this.scrollLeftBtn.click(this.onScrollLeftBtnClick
						.binding(this));
				this.scrollRightBtn.click(this.onScrollRightBtnClick
						.binding(this));
				this.hasScrollBtn = true;
			}
		},

		// 改变当前选择的分类信息
		_changeSelectRangeInfo : function() {
			var htmlcode = "<strong>" + Kms_MessageInfo["kms.navi.category"]
					+ "：</strong>";
			for (var c = 0, len = this.selectedCache.length; c < len; c++) {
				var nav = this.selectedCache[c];
				htmlcode += '<a href="#" title="">' + nav._data["text"]
						+ '</a>';
				if (c < len - 1)
					htmlcode += "&gt;";
			}
			this.navInfoBox.html(htmlcode);
		},

		onScrollLeftBtnClick : function() {
			if (this.slot[1] <= 3)
				return;
			var slotDownNv = this.nvCache[this.slot[0] - 1];
			var slotUpNv = this.nvCache[this.slot[1] - 1];

			if (slotUpNv) {
				slotUpNv["selArea"].hide();
				if (slotUpNv["arrRight"])
					slotUpNv["arrRight"].hide();
			}

			this.slot[0] -= 1;
			this.slot[1] -= 1;

			slotDownNv = this.nvCache[this.slot[0] - 1];
			slotUpNv = this.nvCache[this.slot[1] - 1];
			slotDownNv["selArea"].show();
			if (slotDownNv["arrRight"])
				slotDownNv["arrRight"].show();
			if (slotUpNv) {
				if (slotUpNv["arrRight"])
					slotUpNv["arrRight"].hide();
			}
		},

		onScrollRightBtnClick : function() {
			if (this.slot[1] > this.nvCache.length - 1)
				return;
			var slotDownNv = this.nvCache[this.slot[0] - 1];
			var slotUpNv = this.nvCache[this.slot[1] - 1];

			if (slotUpNv["arrRight"])
				slotUpNv["arrRight"].show();
			slotDownNv["selArea"].hide();
			if (slotDownNv["arrRight"])
				slotDownNv["arrRight"].hide();

			this.slot[0] += 1;
			this.slot[1] += 1;

			slotUpNv = this.nvCache[this.slot[1] - 1];
			slotUpNv["selArea"].show();
			if (slotUpNv["arrRight"])
				slotUpNv["arrRight"].hide();
		},

		onItemClick : function(elem, navItem, event) {
			var level = navItem._level, data = navItem._data, isNoSelect = navItem._isNoSelect, s_trash = null, nv_trash = null, curSelected = null;
			// 设置导航选择路径
			this.setAllNavItem(navItem);

			if (isNoSelect) {
				this.noSelectItem = navItem;
				// this.noSelectItem._elem.addClass("focus");
			}

			elem.addClass("focus");
			this.navInfoBox.show();
			// 当前所选项不在缓存中，即要替换当前缓存数组的值
			if (!this.selectedCache.contains(navItem)) {
				curSelected = this.selectedCache[level - 1];
				// 将当前选中的项目存入缓存，并删除失去选择区域的项目，放到垃圾数组
				if (isNoSelect) {
					s_trash = this.selectedCache.splice(level - 1,
							this.selectedCache.length - level + 1);
				} else {
					s_trash = this.selectedCache.splice(level - 1,
							this.selectedCache.length - level + 1, navItem);
				}

				jq.log(	[level - 1, this.selectedCache.length - level + 1,
								navItem].join(", "), "info");
				nv_trash = this.nvCache.splice(level, this.nvCache.length
								- level);

				// 将已经不被选中的区域从DOM中移除
				for (var c = 0, ntl = nv_trash.length; c < ntl; c++) {
					var nv_tmp = nv_trash[c];
					if (nv_tmp["arrRight"])
						nv_tmp["arrRight"].remove();
					nv_tmp["selArea"].remove();
				}

				if (level >= 1) {
					if (this.nvCache[level - 1].arrRight)
						this.nvCache[level - 1].arrRight.remove();
				}

				if (curSelected) {
					curSelected._elem.removeClass("focus");
				}

				if (!isNoSelect && this.noSelectItem) {
					this.noSelectItem._elem.removeClass("focus");
					this.noSelectItem = null;
				}

				// 改变分类选择信息
				this._changeSelectRangeInfo();

				this.showMessageInfo(data || this.allNavItem._data);

				// 请求下一级的数据
				if (!isNoSelect && !this.options.single) {
					this.loadData({
								"fdId" : data["value"]
							});
					jq.log(Kms_MessageInfo["kms.navi..load"] + "...", "info");
				}
			}

			this.fireEvent("onSelectItem", navItem);
		},

		showMessageInfo : function(data) {
			if (data["isShowCheckBox"] == "0") {
				var htmlcode = "<strong style='color:red;'>"
						+ Kms_MessageInfo["kms.navi.msg"]
						+ "：</strong><span style='color:red;'>"
						+ Kms_MessageInfo["category.noLimits"] + "!</span>";
				this.messageInfo.html(htmlcode);
				this.messageInfo.show();
			} else {
				this.messageInfo.hide();
			}
		},

		onItemDblclick : function(elem, navItem, event) {
			var bindingField = this.options.bindingField;
			var data = navItem._data;
			// 绑定数据与表单域
			if (bindingField && data) {
				Object.forEach(bindingField, function(field, key) {
							var selector = ["input[name=", field, "]"].join("");
							jq(selector).val(data[key]);
						}, this);
			}
		},

		onItemMouseover : function(elem, event) {
			elem.addClass("on");
		},

		onItemMouseout : function(elem, event) {
			elem.removeClass("on")
		},

		// 当点击外部确定按钮的时候可以调用些函数，
		// 可以取得自动绑定表单域字段或返回选择的值
		clickOkButton : function() {
			
			var bindingField = this.options.bindingField;
			var selectedItem = this.selectedCache[this.selectedCache.length - 1];
			var data = selectedItem._data;
			// 绑定数据与表单域
			if (data.fdValue && bindingField) {
				Object.forEach(bindingField, function(field, key) {
							var selector = ["input[name=" + field + "]"]
									.join("");
							jq(selector).val(data[key]);
						}, this);
			}
		},

		loadStyle : function() {
			// 样式文件名缓存于数组中，防止多次动态引入样式 by hongzq 2013-2-5
			if (KMS.styleFile.indexOf('navi_selector.css')) {
				var thisScript;
				(function(script, me) {
					for (var i in script) {
						if (script[i].src
								&& script[i].src.indexOf('kms_navi_selector') !== -1)
							thisScript = script[i];
					};
				}(document.getElementsByTagName('script'), thisScript));
				var link = document.createElement('link');
				link.rel = 'stylesheet';
				link.href = KMS.themePath + '/navi_selector.css';
				thisScript.parentNode.insertBefore(link, thisScript);
			}
			KMS.styleFile.include('navi_selector.css');
		},
		
		setAllNavItem : function(navItem) {
			if (this.allNavItem) {
				var level = navItem._level;
				var allLevel = this.allNavItem._level;
				while (allLevel > 0) {
					allLevel--;
					if (this.allNavItem._level >= level) {
						this.allNavItem = this.allNavItem._parent;
					} else {
						break;
					}
				}
				if (!navItem._isNoSelect) {
					navItem._parent = this.allNavItem;
					this.allNavItem = navItem;
				}
			} else {
				this.allNavItem = navItem;
			}
		}

	});

	// 私有构造器，用于表示的选中项的的结构
	function NaviItem() {
		this._nav = null;
		this._elem = null;
		this._data = null;
		this._level = null;
		this._isNoSelect = false;
	}

	function ellipsis(el) {
		el = jq(el);
		el.css({
					"white-space" : "nowrap",
					"overflow" : "hidden"
				});
		if ("textOverflow" in doc.documentElement.style
				|| "OTextOverflow" in doc.documentElement.style) {
			el.css({
						"text-overflow" : "ellipsis",
						"-o-text-overflow" : "ellipsis"
					});
		}

	}
	KMS.styleFile = new Array();
	KMS.NaviSelector = NaviSelector;
}(jQuery, window.top.document));