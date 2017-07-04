<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/ckeditor/ckeditor.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/catalogSlide/catalogSlide.js"></script>
<script type="text/javascript"
	src="${kmsResourcePath }/js/kms_docUtil.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/ckeditor/plugins/category/editorCategory.js"></script>
<script type="text/javascript"
	src="${kmsBasePath}/wiki/resource/rangy/selectAnchor.js"></script>
<script type="text/javascript"
	src="${kmsBasePath }/wiki/resource/qtip/jquery.qtip.js"></script>
<script type="text/javascript"
	src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>
	// 缩放窗口目录自适应 by hongzq 2012-5-11
	window.onresize = function() {
		var scrollContent = $('#sidecatalog');
		var top = (document.body.clientHeight - scrollContent.height());
		var left = parseInt($('#main').offset().left
				+ $('.content3').width())
				+ 20;
		scrollContent.css({'top':top,'left':left});
		scrollContent.attr('top', top);

		/*弹出框定位*/
		$('#side-catalog-content').css({
			'left' : parseInt($('#sidecatalog').css('left')) + 30,
			'bottom' : 48
		});
	};
	$(document).ready(
			function() {
				// 更新目录信息---子目录
				CKEDITOR_EXTEND.refresh(document.getElementById('contentDiv'),
						document.getElementById("side-title-list"), true);
				CKEDITOR_EXTEND.refresh(document.getElementById('contentDiv'),
						document.getElementById("catalog_ul"), true, true);
				if('${fdEnable}' == '1'){// 是否启用段落点评
					// 绑定快捷操作事件
					selectAnchor(document.getElementById('share_div'), $('.edit_page').toArray(),
							share);
				}
				// 绑定段落点评事件
				bindEvaluationEvent();

				showTags();
			});

	function bindEvaluationEvent() {
		$('img[e_id]').each(function(index) {
			$(this).qtip({
				content: {
					url: '<c:url value='/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=view&e_id='/>'+$(this).attr('e_id')
				},
				show: 'mouseover',
				hide: 'mouseout',
				style: {
					width : {
						min : 300,
						max : 500
					},
					name: 'cream'// Inherit from preset style,
				}
			});
		})
	}

	//展开目录\收起目录
	function option_Catalog(thisObj) {
		var catalog_ul = document.getElementById("catalog_ul");
		var li_arr = catalog_ul.childNodes;
		if (thisObj.className == "catalog_holder") {
			// 读取子目录，重新渲染目录
			CKEDITOR_EXTEND.refresh(document.getElementById('contentDiv'),
					document.getElementById("catalog_ul"), true);
			document.getElementById("optionCatelogBtn").innerHTML = "收起";
			document.getElementById("optionCatelogBtn").className = "catalog_unholder";
		} else {
			// 收起
			for ( var i = 0; i < li_arr.length; i++) {
				if ('1' != li_arr[i].getAttribute('categoryIndex'))
					li_arr[i].style.display = "none";
			}
			document.getElementById("optionCatelogBtn").innerHTML = "展开";
			document.getElementById("optionCatelogBtn").className = "catalog_holder";
		}
	}

	//查看历史版本
	function viewAllVersion() {
		var subject = '${kmsWikiMainForm.docSubject}';
		Com_OpenWindow(
				'kmsWikiMain.do?method=listAllVersion&fdId=${param.fdId}&fdFirstId=${kmsWikiMainForm.fdFirstId}&docSubject=' + encodeURIComponent(subject),
				'_blank');
	}

	//右侧的目录div
	function optionSideBar(thisObj) {
		openCatelog(thisObj);
	}

	function openCatelog(thisObj) {
		if (thisObj.className == "sidebar") {
			document.getElementById("side-catalog-content").style.display = "block";
			document.getElementById("sidebar").className = "sidebar_hide";
		} else {
			document.getElementById("side-catalog-content").style.display = "none";
			document.getElementById("sidebar").className = "sidebar";
		}
	}

	//上移
	function upCatelog() {
		var pannal = document.getElementById("side-title-panel");
		var cateli = document.getElementById('side-title-list');

		//移动
		pannal.scrollTop = pannal.scrollTop - 35 > 0 ? pannal.scrollTop - 35
				: 0;

		//alert("滚动值:"+pannal.scrollTop + "外层高度：" + pannal.offsetHeight + "内层高度:" + cateli.offsetHeight);
		if (pannal.offsetHeight + pannal.scrollTop < cateli.offsetHeight) {
			//上移过程中，显示下移按钮
			document.getElementById("side-catalog-down").className = "";
		}

		if (pannal.scrollTop == 0) {
			//隐藏上移按钮
			document.getElementById("side-catalog-up").className = "disable";
		}
	}

	//下移
	function downCatelog() {
		var pannal = document.getElementById('side-title-panel');
		var cateli = document.getElementById('side-title-list');

		//移动
		pannal.scrollTop = pannal.scrollTop + 35;

		//alert("滚动值:"+pannal.scrollTop + "外层高度：" + pannal.offsetHeight + "内层高度:" + cateli.offsetHeight);
		if (pannal.offsetHeight + pannal.scrollTop < cateli.offsetHeight) {
			//显示上移按钮
			document.getElementById("side-catalog-up").className = "";
		} else {
			//下移到底，隐藏下移按钮
			document.getElementById("side-catalog-down").className = "disable";
		}
	}

	function checkDelete() {
		showConfirm(
				"你确定要删除此版本吗？",
				function() {
					Com_OpenWindow(
							'kmsWikiMain.do?method=delete&fdId=${kmsWikiMainForm.fdId}',
							'_self');
				}, true);
	}

	//转移词条
	function checkChangeCategory() {
		if (confirm("词条所有版本分类都将转移，是否继续？")) {
			var url = "<c:url value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=openCategoryDialog' />&fdId=${kmsWikiMainForm.fdId}&fdFirstId=${kmsWikiMainForm.fdFirstId}";
			var rtnVal = Dialog_PopupWindow(Com_Parameter.ContextPath
					+ "resource/jsp/frame.jsp?url=" + encodeURIComponent(url),
					'500', '300', null);
		}
	}

	// 跟上一版本快捷比较
	function compareLastVersion(fdLastId) {
		if (fdLastId) {
			var url = "kmsWikiMain.do?method=compareVersion&secondId=${param.fdId}&firstId="
					+ fdLastId;
			window.open(url, "_blank");
		}
	}

	function wikiLink(obj) {
		$
				.ajax( {
					url : '${kmsResourcePath}/jsp/get_json_feed.jsp',
					data : {
						"s_bean" : "kmsHomeWikiService",
						"s_method" : "getWikiByName",
						"docSubject" : encodeURIComponent(obj.innerHTML)
					},
					cache : false,
					dataType : "json",
					success : function(data) {
						if (data['fdId']) {
							var href = '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=" />'
									+ data['fdId'] + '&id=' + data['id'];
							window.open(href, '_blank');
						}
					},
					error : function(error) {
						alert(error);
					}
				});
	}

	//显示属性
	function showPropertyList() {
		var $propertyList = $('#propertyList');
		var img = $('#imgShow');
		var word = $('#wordShow');
		if ($(word).text() == '收起') {
			$(word).text('展开');
			img[0].src = '${kmsResourcePath }/img/ic_cocl.gif';
		} else {
			$(word).text('收起');
			img[0].src = '${kmsResourcePath }/img/ic_coop.gif';
		}
		if ($propertyList) {
			if ($propertyList.css('display') == 'none') {
				$propertyList.show();
			} else {
				var $rows = $propertyList.find('tr');
				$rows.each( function(index) {
					$(this).toggle();

				});
			}
		}
	}
	var share = [{
			id: 'sinaShare',
			func: function() {
				var eleTitle = document.getElementsByTagName("title")[0];
				var txt = funGetSelectTxt(),
					title = (eleTitle && eleTitle.innerHTML) ? eleTitle.innerHTML : "未命名页面";
				if (txt) {
					window
						.open('http://v.t.sina.com.cn/share/share.php?title=' + txt + '→来自页面"' + title + '"的文字片段&url=' + encodeURIComponent(window.location.href));
				}
			}
		}, {
			id: "evaluationShare",
			func: function() {
				var fdWikiId = '${param.fdId}';
				var docSubject = funGetSelectTxt();
				if(docSubject){
					var urlPrix = "<c:url value='/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=add&fdWikiId=${param.fdId}&fdFirstId=${param.id}'/>";
					var url = urlPrix + "&fdId=" + fdWikiId;
					var data = Dialog_PopupWindow(Com_Parameter.ContextPath + "resource/jsp/frame.jsp?url=" + encodeURIComponent(url), '500', '300', {
						'docSubject': docSubject
					});
					document.getElementById('share_div').style.display = 'none';
					if (data) {
						var cons = document.createElement('img');
						cons.src = KMS.themePath + "/img/icon_add.png";
						cons.width = '10';
						cons.height = '10';
						cons.setAttribute('contenteditable','false');
						cons.setAttribute('e_id', data);
						var editorDiv = funSetSelectTxt(cons);
						bindEvaluationEvent();
						var fdCatalogId;
						while (editorDiv.parentNode) {
							editorDiv = editorDiv.parentNode;
							if (editorDiv.getAttribute('name')) {
								fdCatalogId = editorDiv.getAttribute('name');
								break;
							}
						}
						var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
						if (fdCatalogId) {
							jQuery
								.post(
								'<c:url value="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=updateContent"/>', {
								docContent: editorDiv.innerHTML.replace(urlFlex,''),
								fdId: fdCatalogId
							}, function(data, textStatus, xhr) {
									//window.location.reload();
								});
						}
					}
				}
			}
		}
	];

	var propertyWindow ;
	function editProperty() {
		propertyWindow = art.dialog.open('kmsWikiMain.do?method=editProperty&type=property&fdId=${param.fdId}', {
			title: '调整属性',
			width: '720px',
			lock: true,
			//background: '#fff', //  
			opacity: 0
		});
	}

	function closePropertyWindow(){
		propertyWindow && propertyWindow.close();
		propertyWindow = null;
	}

	//提示操作成功

	function showSuccessMsg(type) {
		var t = type;
		$("#successTag").show();
		if (t != null && t == 1) setTimeout(function() {
			$("#successTag").hide();
			window.location.reload();
		}, 500);
		else setTimeout(function() {
			$("#successTag").hide();
			Com_OpenWindow('kmsWikiMain.do?method=view&fdId=${param.fdId}', '_self');
		}, 1500);
	}

	//显示标签
	var currentTags="${kmsWikiMainForm.sysTagMainForm.fdTagNames}";

	function showTags(){
		var list= new Array() ;
		list=currentTags.split(" ") ;
		var $tag=$('#tagLists');
		for(i=0;i<list.length;i++) {
	        var l=list[i] ;
	        var more=("<a href='javascript:void(0);' onclick=gotoTags('"+l+"')  ><nobr>"+l+"</nobr></a> ") ;
	        $tag.after(more) ;
			}
		}
	function gotoTags(val){
		var vals=encodeURI(val);
		window.open("<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain&queryType=&queryString="+vals+"' />","_blank");
	}
	
	//添加标签
	function addTags(type) {
		var content = '';
		var value = '';
		var title = '';
		if (type == '2') { // 编辑
			title = "调整标签";
			content = '修改标签，标签间请用“空格”隔开！';
			value = reverseTagStr(currentTags);
		} else if (type == '3') { //添加
			title = "添加标签";
			content = '请输入新标签，标签间请用“空格”隔开！';
			value = " ";
		}
		art.artDialog({
			content: [
				'<div style="margin-bottom:5px;font-size:12px">',
			content,
				'</div>',
				'<div>',
				'<input value="',
			value,
				'" style="width:28em;padding:6px 4px" />',
				'</div>'].join(''),
			initFn: function() {
				input = this.DOM.content.find('input')[0];
				var rtextRange = input.createTextRange();
				rtextRange.moveStart('character', input.value.length);
				rtextRange.collapse(true);
				rtextRange.select();

			},
			height: '50px',
			width: '350px',
			id: 'showTagIds',
			title: title,
			lock: true,
			opacity: 0, //  
			yesFn: function() {
				input = this.DOM.content.find('input')[0];
				updateTags(input.value, type);
			},
			yesVal: '确定',
			noVal: '取消',
			noFn: function() {}
		});
	}
	function reverseTagStr(str) {
		 if(str!=''){
			var arrayStr= str.split(" ") ;
			var returnStr='';
		    for(i=arrayStr.length-1;i>=0;i--){
		    	returnStr=returnStr+arrayStr[i]+" ";
		        }
		  }
		 return returnStr ;
	}
	 //更新标签
	function updateTags(tags,type){
		 //ajax 
		var url="kmsWikiMainXMLService&fdId=${kmsWikiMainForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			 showSuccessMsg(1);
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
		    mask: false,
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
               	changeTemplateUpdate(fdCategoryId,'${param.fdId}') ;
		    }
		};
		// 分类组件
		var navOptions = {
			dataSource : {
				url : jsonUrl,
				modelName:'com.landray.kmss.kms.wiki.model.KmsWikiCategory',
				authType:'02',
				extendFilter:"fdExternalId is null"
			}
		};
		 //分类转移
		function changeTemplateUpdate(templateId,fdId) {
			var url="kmsWikiMainXMLService&type=4&docIds="+fdId+"&templateId="+templateId;
			var data = new KMSSData(); 
			data.SendToBean(url,function defaultFun(rtnData){ 
				var obj = rtnData.GetHashMapArray()[0]; 
		 		var count=obj['count'];
		 		if(count==0){
		 			showSuccessMsg(1);//成功 
		 		}else{
				  //失败
				    alert('操作失败');
		 	 	 }
			});	  
		}

		function showSelectTemplate(){
			artDialog.navSelector('重新选择分类', addoptions, navOptions);
		}

		function checkChange(){
			//showConfirm("将会清空文档属性,确定要继续吗？",function(){
				showSelectTemplate();
			//},true) ;
		}

		function changeRight() {
			var fdid='${param.fdId}';
			var url="<c:url value="/sys/right/rightDocChange.do"/>";
			url+="?method=docRightEdit&modelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&categoryId=${kmsWikiMainForm.fdCategoryId}";
			url+="&fdIds="+fdid;
			Com_OpenWindow(url,'_blank','height=650, width=800, toolbar=0, menubar=0, scrollbars=1, resizable=1, status=1');
			return;
		}

		function unlockWiki(){
			$.ajax({
				url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=updateUnlock&List_Selected=${kmsWikiMainForm.fdId}',
				cache : false,
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
		}			
</script>