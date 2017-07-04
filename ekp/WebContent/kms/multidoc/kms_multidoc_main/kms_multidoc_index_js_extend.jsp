<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link type="text/css" rel="stylesheet"
	href="${kmsContextPath}kms/multidoc/resource/js/datagrid/assets/datagrid.css" />
<style type="text/css">
.gray {
	background: yellow;
}
</style>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsContextPath}kms/multidoc/resource/js/lib/mootools.js"></script>
<script
	src="${kmsContextPath}kms/multidoc/resource/js/lib/curvycorners.js"></script>
<script src="${kmsContextPath}kms/multidoc/resource/js/iecss3.js"></script>
<script
	src="${kmsContextPath}kms/multidoc/resource/js/datagrid/datagrid.js"></script>
<script src="${kmsResourcePath }/js/kms_filter.js"></script>
<script src="${kmsResourcePath }/js/kms_accordian.js"></script>
<script>Com_IncludeFile("dialog.js|calendar.js");</script>
<script type="text/javascript">
	//类别一行个数
	var param1=10; 
	//是否是分类模板
	var hasTemplate="${hasTemplate}";
	function showMore1(obj, num) {
		var nextall = $(".text_list").find('a');
		if ($(obj).text() == '收起') {
			$('#br1').replaceWith("");
			for (jj = num; jj < nextall.length; jj++) {
				$(nextall[jj]).hide();
			}
			$(".text_list").css('height','56px');
			$(obj).text('更多');
			$(obj).attr("title", '更多');
		} else {
			for (jj = num; jj < nextall.length; jj++) {
				$(nextall[jj]).show();
			}
			$(".text_list").css('height','auto');
			$(obj).text('收起');
			$(obj).attr("title", '收起');
		}
	}
	function hideMore1(num) {
		var nextall = $(".text_list").find('a');
		for (kk = num; kk < nextall.length; kk++) {
			$(nextall[kk]).hide();
		}
	}

	function showMore1Button(){
		var size= '<%=((List) request.getAttribute("docTemplateList")).size()%>'; 
		 if( parseInt(size)>param1){
	       $('#templates').prepend("<a  hidefocus='true' id='strHref1'  href='javascript:void(0)' onclick='showMore1(this,"+param1+")' class='more2'  >更多</a>") ;
	       hideMore1(param1);
	   	 }
	 }
	
	//类名太长的，简短表示
	function getShortName(longname) {
		var n = '';
		if (longname.length > 8) {
			n = longname.substring(0, 6) + '...';
		} else {
			n = longname;
		}
		return n;
	}
	
	function backToParent(obj){
		window.open("<c:url value='/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index2&templateId="+obj.id+"' />","_self");
	}
	function backToParentOther(obj){
		window.open("<c:url value='/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index2&filterConfigId=${filterConfigId}&optionId="+obj.id+"' />","_self");
	}
	function searchCombine(){
		Com_OpenWindow("kmsMultidocKnowledge.do?method=search","_self");
	}
	
	function gotoIndex(){
	    window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module' />","_self");
	}
	
	function gotoMultidocCenter(){
	    window.open("<c:url value='/kms/common/kms_common_main/kmsCommonMain.do?method=module&fdId=${param.fdId}' />","_self");
	}
	
	function gotoFilter(){
		window.open("<c:url value='/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&stype=extend&sfilterConfigId=${filterConfigId}&fdId=${param.fdId}' />","_self");
	}
	
	var kmDoc_dataGrid = null;
	//开始
	$(document).ready(function() {
		//显示文档数量
		showDocNum();
		//显示分类按钮
		showMore1Button();
		//显示按条件查询
		showSelectByCondition();
		//判断是否显示属性修改按钮
		showPropertyUpdateBtn();
		//显示筛选项目
		KMS.filter.filterInit("propFilter", "${param.filterConfigId}",
			"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge",
			"${param.templateId}",
			"com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate", refreshList);
		//显示列表框
		showDataGrid();
	});

	/**
	 * 刷新数据列表
	 */
	function refreshList(param) {
		var jsonObj = {};
		if (param) {
			kmDoc_dataGrid.setParameter({
				filterIds: JSON.stringify(param)
			});
		} else {
			kmDoc_dataGrid.setParameter({
				filterIds: []
			});
		}
		kmDoc_dataGrid.refresh();
	}
	
	// 显示文档数量 
	function showDocNum() {
		$(".text_list a").each(function(i) {
			if (this.id) {
				var that = this;
				var tid = "";
				if (hasTemplate == "true") tid = this.id;

				$.getJSON(KMS.contextPath + "kms/multidoc/kms_multidoc_main/jsonp.jsp", {
					bean: "kmsHomeMultidocService",
					meth: "calculateDocCount",
					filterConfigId: "${filterConfigId}",
					templateId: tid,
					optionId: this.id,
					date: jQuery.now()
				}, function(json) {
					var s = $(that).children()[0];
					$(s).find('span').html("（" + json.count + "）");
				});
			}
		});

	}

	function showDataGrid() {
		kmDoc_dataGrid = new DataGrid('kmsDocList', 'filter', {
			selectable: true,
			columnModel: [{
				header: '题目',
				dataIndex: 'docSubject'
			}, {
				header: '所属分类',
				dataIndex: 'kmsMultidocTemplate'
			}, {
				header: '创建者',
				dataIndex: 'docCreator'
			}, {
				header: '创建时间',
				dataIndex: 'docCreateTime'
			}, {
				header: '浏览次数',
				dataIndex: 'docReadCount'
			}, {
				header: '点评分',
				dataIndex: 'docScore'
			}, {
				header: '部门',
				dataIndex: 'docDept'
			}],
			dataSource: {
				url: KMS.contextPath + 'kms/multidoc/kms_multidoc_main/jsonp.jsp',
				data: {
					bean: "kmsHomeMultidocService",
					meth: "findDoc",
					filterConfigId: "${param.filterConfigId}",
					templateId: "${param.templateId}",
					propertyId: "${param.propertyId}",
					optionId: "${param.optionId}"
				}
			}
		});
	}

	
	function hideSelectTemplate() {
		$('#propFilter').hide();
	}

	function showSelectTemplate(doSomething) {
		var paramTemplateId = "${templateId}";
		if (doSomething == 'addDoc' && paramTemplateId.length > 0 && hasTemplate == "true") window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=" />' + paramTemplateId, '_blank');
		else {
			operatorName = doSomething;
			artDialog.navSelector('选择分类', addoptions, navOptions);
		}
	}

	/**
	 * 是否显示属性修改按钮
	 */
	function showPropertyUpdateBtn() {
		var isShow = '${param.templateId}' ? "blank" : "none";
		$('#editProperty').css("display", isShow);
	}
	/**
	 * 属性修改
	 */
	function editProperty() {
		var docIds = findSelectId();
		if (docIds) {
			propertyWindow = art.dialog.open('kmsMultidocKnowledge.do?method=editProperty&type=property&templateId=${param.templateId}&fdId=' + docIds, {
				title: '编辑属性',
				width: '730px',
				lock: true,
				opacity: 0
			});
		}
	}

	function findSelectId() {
		var checkList = kmDoc_dataGrid.options.checkList;
		var rowsize = checkList.length;
		if (!rowsize) {
			showAlert('没有选择操作数据！');
			return null;
		}
		var data = kmDoc_dataGrid.options.data;
		var values = "";
		var id, template, item;
		outerloop: for (var i = 0; i < rowsize; i++) {
			id = checkList[i];
			for (item in data) {
				if (data[item].fdId == id) {
					if (template && template != data[item].kmsMultidocTemplate) {
						showAlert('请选择相同分类数据！');
						return null;
					}
					if (!template) {
						template = data[item].kmsMultidocTemplate;
					}
				}
			}
			values += checkList[i];
			values += ",";
		}
		return values;
	}

	var propertyWindow;

	function closePropertyWindow() {
		propertyWindow && propertyWindow.close();
		propertyWindow = null;
	}

	function showSuccessMsg(type) {}

	function showSelectByCondition() {
		var paramTemplateId = "${templateId}";
		if (hasTemplate == "true") {
			if (paramTemplateId == null || paramTemplateId == "") {
				$('#selectByCondition').hide();
				$('#propFilter').hide();
			}
		}
	}

	function deleteDoc() {
		var baseURI = '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall" />';
		kmDoc_dataGrid.deleteDataRows(baseURI);
	}

	function changeTemp() {
		var docIds = kmDoc_dataGrid.findSelectedDoc();
		if (docIds != null) {
			showConfirm('将会清空文档属性,确定要继续吗？', function() {
				showSelectTemplate("changeTemplate");
			}, function() {
				return;
			});
		}
	}
	//分类转移

	function changeTemplateUpdate(templateId) {
		var fdIds = kmDoc_dataGrid.findSelectedDoc();
		var url = "kmsMultidocKnowledgeXMLService&type=4&docIds=" + fdIds + "&templateId=" + templateId;
		var data = new KMSSData();
		data.SendToBean(url, function defaultFun(rtnData) {
			var obj = rtnData.GetHashMapArray()[0];
			var count = obj['count'];
			if (count == 0) {
				$("#successTag").show();
				setTimeout(function() {
					$("#successTag").hide();
					window.location.reload();
				}, 500);
			} else {
				return;
			}
		});
	}
	
	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	var dialogUrl = '${kmsBasePath}/common/jsp/dialog.html';
	var addoptions = {
		lock: false,
		noFn: function() {},
		height: '400px',
		width: '500px',
		background: '#fff',
		opacity: 0,
		yesFn: function(naviSelector) {
			//debugger;
			var selectedCache = naviSelector.selectedCache;
			// 未选择分类~
			if (selectedCache.length == 0) {
				showAlert('请选择分类');
				return false;
			}
			if (selectedCache.last()._data["isShowCheckBox"] == "0") {
				art.artDialog.alert("您没有当前目录使用权限！");
				return;
			}
			var fdCategoryId = selectedCache.last()._data["value"];
			if (operatorName == "addDoc") window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=' + fdCategoryId);
			if (operatorName == "changeTemplate") changeTemplateUpdate(fdCategoryId);

		}
	};
	// 分类组件
	var navOptions = {
		dataSource: {
			url: jsonUrl,
			modelName: 'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
			authType: '02',
			extendFilter: "fdExternalId is null"
		}
	};

	$( function() {

		//  手风琴分类概览
		var accordian = new Accordian(
				$('#accordian'),
				{
					width : $('#accordian').width(),
					meta : [ {
						dataSource : {
							url : KMS.basePath
									+ "/common/kms_common_portlet/kmsCommonPortlet.do?method=execute",
							data : {
								s_bean : $('#accordian').attr('s_bean'),
								fdCategoryId : $('#accordian').attr(
										'fdCategoryId') || '',
								s_rowsize : $('#accordian').attr('s_rowsize') || ''
							}
						}
					} ]
				});
	})
	
	function docListPage(fdTemplateId) {
		window.open(
				"${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?"
						+ "method=index&stype=extend&fdId=${param.fdId}&templateId="
						+ fdTemplateId + "&filterType=template", "_self");
	}
</script>

<script id="portlet_doc_index_latest_tmpl" type="text/template">
{$
<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
<div class="box2">
	<ul class="l_a m_t10" id="latestDocList">
$}
		for(var i = 0;i<data.length;i++){
{$
			<li>
				<a href="${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId={%data[i].fdId%}" target="_blank" id="{%data[i].fdId%}">{%data[i].docSubject%}&nbsp;&nbsp;{%data[i].docPublishTime%}</a>
			</li>
$}
		}
{$
	</ul>
</div>
$}
</script>

<script id="portlet_doc_index_hot_tmpl" type="text/template">
{$
<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
<div class="box2">
	<ul class="l_a m_t10" id="hotDocList">
$}
		for(var i = 0;i<data.length;i++){
{$
			<li>
				<a href="${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId={%data[i].fdId%}" target="_blank" id="{%data[i].fdId%}">{%data[i].docSubject%}&nbsp;&nbsp;{%data[i].docReadCount%}次</a>
			</li>
$}
		}
{$
	</ul>
</div>
$}
</script>