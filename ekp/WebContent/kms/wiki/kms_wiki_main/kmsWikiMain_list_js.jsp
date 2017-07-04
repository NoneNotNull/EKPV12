<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>Com_Parameter.IsAutoTransferPara = true;</script>
<script language="JavaScript">
	  Com_IncludeFile("dialog.js");
</script>
<script language="JavaScript">
	var operatorName="" ;
	//新建
	function createNewWindow(){
		var fdCategoryId = "${param.fdCategoryId}";
		if(fdCategoryId == null || fdCategoryId == ""){
			operatorName="addDoc" ;
			//选择分类模板
			artDialog.navSelector('选择模板', addoptions, navOptions);
		}else{
			Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=add&fdCategoryId='+fdCategoryId);
		}
	}

	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
	var dialogUrl = '${kmsBasePath}/common/jsp/dialog.html';
	var addoptions = {
				lock : false,
				noFn : function() {},
				height : '400px',
				width : '500px',
				background: '#fff', // 背景色
			    opacity: 0,	// 透明度
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

					var categoryId = selectedCache.last()._data["value"];
					if(operatorName=="addDoc")
						window.open('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add&fdCategoryId=' + categoryId);
					if(operatorName=="changeTemplate"){
						var select = document.getElementsByName("List_Selected");
						var values="" ;
						for(var i=0;i<select.length;i++) {
							if(select[i].checked){
								values+=select[i].value;
								values+=",";
							}
						}
						updateExtendFilePath(values,categoryId) ;
					}
			  }
			};
	// 分类组件
	var navOptions = {
				dataSource : {
					url : jsonUrl,
					data : {
						s_bean : 'kmsWikiCategoryTree',
						s_method : 'getCategoryList',
						type : 'all'
					},
					modelName:"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
					authType:'02'
				}
			};

	function selectTemplate(doSomething){
		  operatorName=doSomething;
		  artDialog.navSelector('选择分类', addoptions, navOptions);
	  }

	function updateExtendFilePath(fdIds,templateId){
	    //ajax 
		var url="kmsWikiMainXMLService&type=4&docIds="+fdIds+"&templateId="+templateId ;
		var data = new KMSSData(); 
		data.SendToBean(url,function (rtnData){ 
			 var obj = rtnData.GetHashMapArray()[0]; 
	 		 var count=obj['count'];
	 		 if(count==0){
	 	 		 alert('操作成功') ;
	 	 	 }else{
	 	 		alert('操作失败') ;
	         }
		});	  
	}
		
</script>