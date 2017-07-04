<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsResourcePath }/js/kms_filter.js"></script>
<script>
// ekpJS
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
// 移除部分js，解决多次引入jquery导致
Com_IncludeFile("dialog.js|calendar.js", null, "js");
</script>

<script>
	//显示更多
	function showMore(obj) {
		var list = $("#portlet_filterWiki");
		var nextall = $(list).find('br').first().nextAll();
		if ($(obj).text() == '收起') {
			$(obj).text('更多');
			$(obj).attr("title", '更多');
			$(nextall).each( function() {
				$(this).hide();
			});
		} else {
			$(obj).text('收起');
			$(obj).attr("title", '收起');
			$(nextall).each( function() {
				$(this).show();
			});
		}
	}

	// 页面加载默认隐藏更多的内容
	function hideMore() {
		var list = $("#portlet_filterWiki");
		var nextall = $(list).find('br').nextAll();
		$(nextall).each( function() {
			$(this).hide();
		});
	}

	// 积分取整
	function subStr(score){
		var str = score.toString();
		var index = str.indexOf('.');
		if(index>0){
			return str.substring(0,index); 
		}
		return str;
	}

	// 事件绑定
	function bindButton() {
		var options = {
			s_modelName:"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
			s_bean : 'kmsKnowledgeCategoryService',
			s_method : 'getCategoryList',
			open : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=add&fdCategoryId=',
			width : '320px',
			delUrl : '<c:url value ="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=deleteallList&fdCategoryId=${param.fdCategoryId}'
		};

		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();

		var createDoc = new KMS.opera(options, $('.btn_wiki'));
		createDoc.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, $('#delButton'));
		delEvent.bind_del();
	}

	
	$( function() {
		//显示筛选项目
		KMS.filter.filterInit("propFilter", "${param.filterConfigId}",
				"com.landray.kmss.kms.wiki.model.KmsWikiMain",
				"${param.fdCategoryId}",
				"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory", refreshList);
		showBtn();
		//显示更多
		function showMore(obj) {
			var list = $("#portlet_filterWiki");
			var nextall = $(list).find('br').first().nextAll();
			alert($(list).find('br').first()[0].nodeType);
			$(nextall).each( function() {
				alert(this.nodeType);
				$(this).toggle();
			});
			if ($(obj).text() == '收起') {
				$(obj).text('更多');
				$(obj).attr("title", '更多');
			} else {
				$(obj).text('收起');
				$(obj).attr("title", '收起');
			}
			//hideMore();
		}

	});

	/**
	 * 刷新数据列表
	 */
	function refreshList(param){
		var jsonObj = {};
		if(param){
			jsonObj.filterIds = JSON.stringify(param);
		}else{
			jsonObj.filterIds = [];
		}
		KMS.page.listExpand(jsonObj);
	}

	/**
	 * 是否显示属性修改分类转移按钮
	 */
	function showBtn(){
		var isShow = '${param.fdCategoryId}'?"blank":"none";
		$('#editProperty').css("display",isShow);
		$('#changeCategory').css("display",isShow);
		$('#editChangeRight').css("display",isShow);
	}

	/**
	 * 属性修改
	 */
	function editProperty(){
		var docIds= getData();
		if(docIds){
			propertyWindow = art.dialog.open('<c:url value ="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=editProperty&type=property&category=${param.fdCategoryId}&fdId='+docIds, 
				  {title: '编辑属性', width: '730px'  ,lock: true ,opacity: 0 }); 
		}
	}
	
	var propertyWindow;
	function closePropertyWindow(){
		propertyWindow && propertyWindow.close();
		propertyWindow = null;
	}
	
	function getData(){
		var checkedList = $('input[name="List_Selected"]:checked');
		var rowsize = checkedList.length;
		if (!rowsize) {
			art.artDialog.alert(Kms_MessageInfo["kms.opera.noSelectData"]);
			return false;
		}
	
		var id = [];
		var cateIds = [] ;
		$('input[name="List_Selected"]:checked').each(
				function(i) {
					id[i] = $(this).val();
					cateIds[i] = document.getElementById(id[i]).value;
				});
		var temp = null ;
		temp = cateIds[0] ;
		for(var i=0;i<cateIds.length;i++){
			if(temp != cateIds[i]){
				art.artDialog.alert("请选择相同分类数据");
				return false ;
			}
		}
		return  id.join(',');
	}
	function showSuccessMsg(type){}


	function changeTemp(){
		var docIds= getData();
		if(docIds!=null ){
			showConfirm('将会清空词条属性,确定要继续吗？',function(){
				showSelectTemplate("changeTemplate") ;
			},function(){return ;});
		}	 

	}
	function showSelectTemplate(doSomething){
	 	 var paramTemplateId="${templateId}";
	     	if( doSomething=='addDoc' && paramTemplateId.length>0 && hasTemplate=="true")  
	         	window.open('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdTemplateId=" />'+paramTemplateId,'_blank');
	     	else{
	        	 operatorName=doSomething;
	        	 artDialog.navSelector('选择分类', addoptions, navOptions);
	        }
	}

	//分类转移
	function changeTemplateUpdate(templateId) {
		var fdIds= getData();
		var url="kmsWikiMainXMLService&type=4&docIds="+fdIds+"&templateId="+templateId;
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			var obj = rtnData.GetHashMapArray()[0]; 
	 		var count=obj['count'];
	 		if(count==0){
	 			$("#successTag").show();
	 			     setTimeout(function(){
	 			      $("#successTag").hide();
	 			      window.location.reload(); 
	 			    },500);
	 		}else{
			    return ;
	 	 	 }
		});	  
	}
	
	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	var dialogUrl = '${kmsBasePath}/common/jsp/dialog.html';
	var addoptions = {
		lock : false,
		noFn : function() {},
		height : '400px',
		width : '500px',
		background: '#fff', 
	    opacity: 0 ,	 
		yesFn : function(naviSelector) {
			var selectedCache = naviSelector.selectedCache;
			// 未选择分类~
			if (selectedCache.length == 0) {
				showAlert('请选择分类') ;
				return false;
			}
			if(selectedCache.last()._data["isShowCheckBox"]=="0"){
				art.artDialog.alert("您没有当前目录使用权限！");
				return;
			}
			var fdCategoryId = selectedCache.last()._data["value"];
			if(operatorName=="addDoc")
			   window.open('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add&fdTemplateId=' + fdCategoryId);
			if(operatorName=="changeTemplate")
			   changeTemplateUpdate(fdCategoryId) ;
					  
	  	}
	};
	// 分类组件
	var navOptions = {
		dataSource : {
			url : jsonUrl,
			modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
			authType:'02',
			extendFilter:"fdExternalId is null"
		}
	};

	function editChangeRight(){
		 //	var fdid='${param.fdId}';
		 	var fdIds= getData();
		 	if(fdIds=="" || fdIds==null){
				return false ;
			}
			var url="<c:url value="/sys/right/rightDocChange.do"/>";
			url+="?method=docRightEdit&modelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&categoryId=${kmsWikiMainForm.docCategoryId}";
			url+="&fdIds="+fdIds;
			Com_OpenWindow(url,'_blank','height=650, width=800, toolbar=0, menubar=0, scrollbars=1, resizable=1, status=1');
			return;
	}
</script>