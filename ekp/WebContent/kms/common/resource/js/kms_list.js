;
(function($) {

	/**
	 * 列表分页
	 */
	function Page(id) {
		 
		var list;
		var that = this;
		
		this.getPortlets = function(){
			if(!!!list){
				//tab下portlet列表
				var portletId = $('#' + id).attr('portlet');
				list = $("#" + portletId + " div[portlet='" + portletId + "']");
				//如果tab下portlet列表为空，则尝试区当前对象
				if(!list.size()){
					list = $("#" + id);
				}
			}
			return list;
			
		};

		// 当前portlet
		this.curPortlet;

		// 初始化当前portlet
		this.init = function() {
			that.getPortlets().each(
					function(i, obj) {
						var portlet = $(this);
						var param = KMS_JSON(portlet.attr("parameters"));
						if (portlet.css('display') == "block") {
							that.curPortlet = portlet;
						}
					});
		};

		// 更改portlet参数，渲染
		this.reRender = function(portlet, para) {
			var param = KMS_JSON(portlet.attr("parameters"));
			var beanParm = KMS_JSON(param.kms.beanParm);
			$.extend(beanParm, para);
			param.kms.beanParm = JSON.stringify(beanParm);
			portlet.attr("parameters", JSON.stringify(param));
			portlet.attr("load", false);
			eval(" " + param.kms.renderer + "('" + param.kms.id + "');");
		};

		// 翻页函数
		this.setPageTo = function(pageno, rowsize) {
			that.init();
			var curPoletSet = that.curPortlet;
			var para = {
				pageno : pageno,
				rowsize : rowsize
			};
			that.reRender(curPoletSet, para);
			// KMS_TAB_PORTLET_CHANGE(tab_portlet, curPoletSet.id);
		};

		// 页面跳转
		this.jump = function() {
			that.init();
			var id = that.curPortlet.attr("id");
			var pnom="";
			var rnom="";
			var inputs = document.getElementById(id).getElementsByTagName('input');
			for(var i=0;i<inputs.length;i++){
				if(inputs[i].getAttribute('id')=='_page_pageno'){
					pnom=inputs[i].value;
					break;
				}
			}
			for(var j=0;j<inputs.length;j++){
				if(inputs[j].getAttribute('id')=='_page_rowsize'){
					rnom=inputs[j].value;
					break;
				}
			}
			  if(pnom==""||rnom==""){
				  alert("请输入完整的页面信息");
			  }else{					
					 if (!(/(^[1-9]\d*$)/.test(pnom))){
						 alert("请输入正确页码");
					     }else if (!(/(^[1-9]\d*$)/.test(rnom))){
					     alert("请输入正确条数"); 
					       }else if(pnom.length>4||rnom.length>4){
						   alert("请输入小于10000的数字")
					         }else{
						   that.setPageTo(pnom,rnom);
					   }
			  }
		}

		// 根据流程状态筛选列表
		this.setWorkflowStatus = function(obj) {
			that.init();
			var portlet = that.curPortlet;
			var para = {
				flowStatus : obj.value
			};
			that.reRender($(portlet), para);
		};

		// 根据文档状态筛选列表
		this.setDocStatus = function(obj) {
			that.init();
			var portlet = that.curPortlet;
			var para = {
				fdStatus : obj.value
			};
			that.reRender($(portlet), para);
		};

		// 根据分类id筛选列表
		this.listDocByCate = function(templateId) {
			that.getPortlets().each(
					function(i, obj) {
						var portlet = $(obj);
						var param = KMS_JSON(portlet.attr("parameters"));;
						var portletId = portlet.attr("id");
						var para = {
							fdCategoryId : templateId
						};
						var beanParm = KMS_JSON(param.kms.beanParm);
						$.extend(beanParm, para);
						param.kms.beanParm = JSON.stringify(beanParm);
						portlet.attr("parameters", JSON.stringify(param));
						portlet.attr("load", false);
						eval(" " + param.kms.renderer + "('" + param.kms.id
								+ "');");
					});
		};

		// 扩展，传递json对象，异步刷新列表
		this.listExpand = function(jsonObj) {
			that.getPortlets().each(
					function(i, obj) {
						var portlet = $(obj);
						var param = KMS_JSON(portlet.attr("parameters"));;
						var portletId = portlet.attr("id");
						var para = jsonObj;
						var beanParm = KMS_JSON(param.kms.beanParm);
						$.extend(beanParm, para);
						param.kms.beanParm = JSON.stringify(beanParm);
						portlet.attr("parameters", JSON.stringify(param));
						portlet.attr("load", false);
						eval(" " + param.kms.renderer + "('" + param.kms.id
								+ "');");
					});
		};

		return function() {
			return {
				jump : that.jump,
				setPageTo : that.setPageTo,
				setDocStatus : that.setDocStatus,
				setWorkflowStatus : that.setWorkflowStatus,
				listDocByCate : that.listDocByCate,
				listExpand : that.listExpand
			}
		};

	};

	/**
	 * checkBox全选反选
	 */
	function ListCheck(context, toggle, fieldName) {
		var toggle = $(toggle), context = $(context)
		fieldName = fieldName || "List_Selected";
		var checkBox = null, checkList = context
				.find("input[type=checkbox][name=" + fieldName + "]"), cl = checkList.length;
		var that = this;
		toggle.bind("click", function() {
					for (var c = 0; c < cl; c++) {
						checkBox = checkList[c];
						if (checkBox.checked != this.checked) {
							$(checkBox).trigger("click");
							// checkBox.checked = this.checked;
						}
					}
				});
		this.reset = function() {
			checkList = context.find("input[type=checkbox][name=" + fieldName
					+ "]");
			cl = checkList.length;
			toggle[0].checked = false;
			return this;
		};

		// 返回选择的值
		this.getListSelected = function() {
			var listSelected = [], n = 0;
			for (var c = 0; c < cl; c++) {
				checkBox = checkList[c];
				if (checkBox.checked) {
					listSelected[n++] = checkBox.value;
				}
			}
			return listSelected;
		};
	};

	/**
	 * 根据分类选择过滤文档
	 */
	function listDocByCate(tab_portlet, templateId) {
		$('#' + tab_portlet + " div[portlet='" + tab_portlet + "']").each(
				function(i, obj) {
					var portlet = $(obj);
					var param = KMS_JSON(portlet.attr("parameters"));;
					var portletId = portlet.attr("id");
					var para = {
						fdCategoryId : templateId
					};
					var beanParm = KMS_JSON(param.kms.beanParm);
					$.extend(beanParm, para);
					param.kms.beanParm = JSON.stringify(beanParm);
					portlet.attr("parameters", JSON.stringify(param));
					portlet.attr("load", false);
					eval(" " + param.kms.renderer + "('" + param.kms.id + "');");
				});
	}

	/**
	 * 列表模板加载完の回调函数，随皮肤可重写
	 */
	function listCallBack(id) {
		// 多选框初始化
		KMS.listCheck = new ListCheck("#" + [id, "tbObj"].join("-"), "#"
						+ [id, "listcheck"].join("-"));
		// 分页初始化
		KMS.page = new Page(id)();
		// 绑定按钮
		typeof bindButton == 'undefined' ? '' : bindButton();

	};

	KMS.ListCheck = ListCheck;
	KMS.Page = Page;
	KMS.listCallBack = listCallBack;

}(jQuery));