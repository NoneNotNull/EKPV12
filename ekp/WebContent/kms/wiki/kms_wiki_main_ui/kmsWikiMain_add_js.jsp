<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript"
	src="${LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/js/editorCategory.js">
</script>
<script>
	Com_IncludeFile("ckfilter.js|ckeditor.js", "ckeditor/");
</script>
<script type="text/javascript">
    var _dialog;
	seajs.use(['lui/dialog'], function(dialog) {
		_dialog = dialog;
	});
	//公共方法---获取对象
	function GetEl(elementName){
		return document.getElementsByName(elementName)[0];
	} 
	//公共方法---获取对象
	function GetID(id){
		return document.getElementById(id) ;
	}
	//更新模板
	function reflashTemplate() {
		var fdMainId = "${kmsWikiMainForm.fdId}";
		//先删除所有页面中的目录及其内容（目录可能会改变）
		var _catelogTree = LUI.$('#catelogTree');
		_catelogTree.empty();
		//重新添加目录
		for(var i=0; i<catelogJson.length; i++) {
			var _id = catelogJson[i].fdId;
			var editparagraph = "${lfn:message('kms-wiki:kmsWiki.editParagraph')}";
			_catelogTree.append('<div id="catelogChild_' + _id + '"></div>');
			_catelogTree.append('<div class="lui_wiki_clear"></div>');
			LUI.$('#catelogChild_' + _id).append(
				'<div class="lui_wiki_catelog clearfloat"  id="catelog_'+ _id +'"></div>',
				'<div class="lui_wiki_content" id="editable_'+ _id +'"></div>'	
			);
			LUI.$('#catelog_' + _id)
				.append('<div class="lui_wiki_title_c">' + catelogJson[i].fdName + '</div>');
			LUI.$('#catelog_' + _id)
				.append('<div class="lui_wiki_editparagraph com_subject" onclick="openEdit(this);return false;"><span  id="' + _id +'">'+editparagraph +'</span></div>');
			LUI.$('#editable_' + _id)
				.append('<div id="replace_' + _id +'" class="lui_wiki_content_catelog"></div>');
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "fdId", catelogJson[i].fdId));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "fdName", catelogJson[i].fdName));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "fdOrder", catelogJson[i].fdOrder));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "fdMainId", fdMainId));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "docContent", catelogJson[i].docContent));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "fdParentId", catelogJson[i].fdParentId));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "authEditorIds", catelogJson[i].authEditorIds));
			LUI.$('#editable_' + _id)
				.append(createHidElement(i, "authEditorNames", catelogJson[i].authEditorNames));
			GetID('replace_'+_id).innerHTML = catelogJson[i].docContent;

		}
		//重新修改右侧目录
		
		var right_catelog = GetID("catelogUl");
		var html = "";
		for(var i=0;i<catelogJson.length;i++){
			html = html + ['<li class="right_selectLi">','<a class="lui_catelog_dot" href="javascript:void(0)">'
							,catelogJson[i].fdName,'</a>','<div id="viewable_',catelogJson[i].fdId,'"></div>' ].join('');
		}
		right_catelog.innerHTML = html;
		//刷新二三级目录
		LUI.$('.lui_wiki_content_catelog').each(function() {
			var _thisId = LUI.$(this).attr('id').split('_');
			var thisId = _thisId[1];
			//去掉原有目录
			 LUI.$('#viewable_' + thisId).find('li').remove();
			 LUI.$(this).find('h3,h4').each(
				function() {
					if(LUI.$(this).is('h3')) {
						LUI.$('#viewable_' + thisId).append('<li class="lui_wiki_catelog_t" >' + $(this).text()  +'</li>');
					}
					else {
						LUI.$('#viewable_' + thisId).append('<li class="lui_wiki_catelog_s" >' + $(this).text()  +'</li>');
					}
				}
			);
			
		});
		dbWhite(LUI.$);

	}
	// 选择模板刷新页面
	function callBackTemplateAction(rtnVal){
		if(!rtnVal || !rtnVal.GetHashMapArray())
			return;
		if(rtnVal.GetHashMapArray().length == 0) {
			catelogJson = [];
			reflashTemplate();
			LUI.$('#wiki_description').text("");
		}
		else if(rtnVal.GetHashMapArray().length > 0) {
			var hash = rtnVal.GetHashMapArray();
			var fdTemplateId = hash[0]['id']; 
			LUI.$.ajax({ 
				url:['<c:url value="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do"/>?method=loadTemplate','fdTemplateId=' + fdTemplateId].join('&'),
				cache : false,
				dataType : "json",
				async:false,
				success : function(data) {
					catelogJson = data.catelogJson;
					var description = data.description;
					//刷新编辑规范
					LUI.$('#wiki_description').text(description);
					reflashTemplate();
				},
				error : function(error) {
				
				}
			});
			//var fdCategoryId = "${param.fdCategoryId}";
			//var url = ['<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add','fdCategoryId='+fdCategoryId,'fdTemplateId='+fdTemplateId].join('&');
			//setTimeout("location='"+url+"'",10);
		};
	}
	/**
	*修改分类
	*/
	function changeDocCate(modelName, unClose, isModify) {
		if (modelName == null || modelName == '')
			return;
		seajs.use(['sys/ui/js/dialog'], function(dialog) {
			var changeConfirm = true;
			if(isModify) {
				//修改分类，弹出确认框
				dialog.confirm("${lfn:message('kms-wiki:kmsWiki.confirmCategory')}", 
						function(flag) {
							if(flag)
								dialogForNewFile();
						}
			    );
			} else dialogForNewFile();

		    function dialogForNewFile () {
				var create_url = '/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=!{id}';
				dialog.simpleCategoryForNewFile(
					modelName,
					create_url,
					false,
					function(rtn) {
						// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!unClose && !rtn)
							window.close();
					},
					null,
					LUI.$('input[name=docCategoryId]').val(),
					"_self",
					true, {
						'fdTemplateType': '2,3'
					}
				);

			}
		});
	}
	/**
	*修改辅分类
	*/
	function changeDocCate_h(modelName,canClose) {
		if(modelName==null || modelName=='')
			return; 
		var cfg = {
				modelName:modelName ,
				authType:'02',
				idField:'docSecondCategoriesIds',
				nameField:'docSecondCategoriesNames',
				canClose:canClose,
				mulSelect: true,
				notNull : false ,
				___urlParam: {'fdTemplateType':'2,3'}
		}
		seajs.use(['sys/ui/js/dialog'], 
				function(dialog){
					dialog.simpleCategory(cfg);
				}
		);
	}

	/**
	*修改作者类型
	*/
	function changeAuthorType(value) {
		LUI.$('#innerAuthor').hide();
		LUI.$('#outerAuthor').hide();
		if (value == 1) {
			LUI.$('#outerAuthor input').attr('validate', '').val('');
			LUI.$('#innerAuthor input').attr('validate', 'required');
			LUI.$('#innerAuthor').show();
			LUI.$('#_textStrong').remove(); 
		}
		if (value == 2) {
			LUI.$('#innerAuthor input').attr('validate', '').val('');
			LUI.$('#outerAuthor input').attr('validate', 'required');
			LUI.$('#outerAuthor').show();
			LUI.$('#outerAuthor input').after('<span class="txtstrong" id="_textStrong">*</span>');
			changeAuthodInfo(null);
		}
	}


	var editor;
	/**
	*删除编辑框
	*/
	function destroyDiv(){
		if (editor){
			editor.destroy();
		}
	}
	/**
	*双击编辑区域
	*/
	seajs.use(['lui/jquery'],function($) {
		$(function() {
			dbWhite($);
		});
	});

	function dbWhite(_$) {
		_$(".lui_wiki_content").bind("dblclick", function(event){
			   var p = LUI.$(this).prev().find('.lui_wiki_editparagraph')[0];
			   openEdit(p);
		 }
	   );
	}
	/**
	*编辑此段时切换编辑框
	*/
	function openEdit(parent) {
		LUI.$(".lui_wiki_btn_confirm").remove();
		LUI.$(".lui_wiki_editparagraph").show();
		var top = -1;
		var thisObj = parent.getElementsByTagName("span")[0];
		var thisId = thisObj.id;
		var replaceObj = document.getElementById("replace_" + thisId);
		if(replaceObj) {
			destroyDiv();
			editor = CKEDITOR.replace(replaceObj, {"toolbar":"Wiki","toolbarStartupExpanded":false,"toolbarCanCollapse":true});
			editor.on('refreshCategory',function(){
				CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
			});
			top = LUI.$(parent).parent().offset().top - 45;
		}
		//隐藏掉“编辑此段”
		LUI.$(parent).hide();
		LUI.$(parent).parent().append("<span class='lui_wiki_btn_confirm' onclick='editConfirm(this)'><bean:message bundle='kms-wiki' key='kmsWiki.confirm.true'/></span>");
		if(top > 0) {
			//滚动到此段显示
			LUI.$('html,body').animate({
				scrollTop:top
			}, 500);
		}
	}
	//编辑完成，确认
	function editConfirm(object) {
		LUI.$(object).remove();
		destroyDiv();
		LUI.$(".lui_wiki_editparagraph").show();
	}
	//编辑目录
	var catelogJson = [];
	<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="vstatus">
	<c:set var="order" value="${vstatus.index}" scope="request" /> 
		catelogJson["<c:out value='${order}' />"] = {
			fdId:"<c:out value='${kmsWikiCatelogForm.fdId}' />",
			fdName:"<c:out value='${kmsWikiCatelogForm.fdName}' />",
			fdOrder:"<c:out value='${kmsWikiCatelogForm.fdOrder}' />",
			docContent:"",
			fdParentId:"<c:out value='${kmsWikiCatelogForm.fdParentId}' />",
			authEditorIds:"<c:out value='${kmsWikiCatelogForm.authEditorIds}' />",
			authEditorNames:"<c:out value='${kmsWikiCatelogForm.authEditorNames}' />"
		};
	</c:forEach>

	//弹出编辑目录框
	function catelogIframe(){
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=openCatelogDialog&fdId=${kmsWikiMainForm.fdId}', 
							" ",
							 null, 
							 {	
				 				scroll:true,
								width:800,
								height:450,
								buttons:[
									{
										name : "${lfn:message('button.ok')}",
										value : true,
										focus : true,
										fn : function(value,_dialog) {
											//获取弹出窗口的window对象
											var winObj = LUI.$('#dialog_iframe').find('iframe')[0].contentWindow; 
											//获取弹出窗口的document对象里面的table
											var tableObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementById('TABLE_DocList');
											kmsWikiCatelog_doOk(tableObj);
											_dialog.hide();
										}
									}, {
										name : "${lfn:message('button.cancel')}",
										styleClass:"lui_toolbar_btn_gray",
										value : false,
										fn : function(value, _dialog) {
											_dialog.hide();
										}
									} 

								]
							}
			);

		});
	}
		//编辑目录后确定
		function kmsWikiCatelog_doOk(tableObj) {
			var _catelogJson = [];
			//拼装json
			var index = tableObj.rows.length - 1;
			for ( var i = 0; i < index; i++) {
				var _fdId = LUI.$(tableObj).find("input[name='fdCatelogList[" + i + "].fdId']").val();
				var _fdName = LUI.$(tableObj).find("input[name='fdCatelogList[" + i + "].fdName']").val();
				var _docContent = LUI.$(tableObj).find("input[name='fdCatelogList[" + i + "].docContent']").val();
				var _fdParentId = LUI.$(tableObj).find("input[name='fdCatelogList[" + i + "].fdParentId']").val();
				var _authEditorIds = LUI.$(tableObj).find("input[name='fdCatelogList[" + i + "].authEditorIds']").val();
				var _authEditorNames = LUI.$(tableObj).find("textarea[name='fdCatelogList[" + i + "].authEditorNames']").val();
				_catelogJson[i] = {
					fdId : _fdId,
					fdName : _fdName,
					fdOrder : i + 1,
					docContent : _docContent,
					fdParentId : _fdParentId,
					authEditorIds : _authEditorIds,
					authEditorNames : _authEditorNames
				};
			}
			catelogJson = _catelogJson;
			reflashTemplate();
			
		}
	
	function editCatelog(){
		//隐藏编辑框(隐藏后才会将编辑的内容放入特指的元素中)
		destroyDiv();
		if(catelogJson.length > 0){
			for(var i=0; i<catelogJson.length; i++){
				var _fdId = catelogJson[i].fdId;
				var contentObj = GetID("replace_"+_fdId);
				catelogJson[i].docContent = contentObj.innerHTML;//将编辑框的内容放入json中
			}
		}
		
	//	var url="<c:url value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=openCatelogDialog' />&fdId=${kmsWikiMainForm.fdId}";  
	//	var style = "dialogWidth:700px; dialogHeight:600px; status:0;scroll:1; help:0; resizable:1";
	//	var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url="+encodeURIComponent(url),catelogJson,style);    
	/*	if(!rtnVal) {
			if(!window.ReturnValue){
				return;
			}else{
				rtnVal= window.ReturnValue;
			}
			
		};*/ 
		
		//将修改后的目录和内容重新赋值
		var ___catelogJson = catelogIframe();
		
	}

	//创建隐藏的元素
	function createHidElement(iVal, nameVal, valueVal) {
	    var ele = LUI.$('<input></input>');
	    ele.attr('type', 'hidden');
	    ele.attr('name', 'fdCatelogList[' + iVal + '].' + nameVal);
	    ele.attr('value', valueVal);
		return ele;
	}
	//当前新建词条锁表的id
	var curLockId = "";
	
	//检查词条是否存在
	function checkIsExist() {
		var flag = false;
		var docSubject = LUI.$('input[name="docSubject"]').val();
		//词条名为空不验证词条是否存在
		if(docSubject == "" || docSubject == null) 
			return "s_isnull";
		var url = "<c:url  value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=checkAddSubject'/>";
		var data = {
				"fdId" : "${kmsWikiMainForm.fdId}",
				"docSubject" : encodeURIComponent(docSubject),
				"lockId":curLockId
		};
		LUI.$.ajax({ 
			url:url,
			data: data,
			cache : false,
			dataType : "json",
			async:false,
			success : function(data) {
				var rtnVal = data[0];
				//当前新建词条的锁表的id
				if(data[0].lockId != null && data[0].lockId!="") 
					curLockId = data[0].lockId;
				flag = addCallBack(rtnVal);
			},
			error : function(error) {
				flag = false;
			}
		});

		return flag;
	}
	//新建回调函数
	var addCallBack = function(data){
		if(data['fdIsExist'] == true){
			var fdId = data['existId'];
			var id = data['firstId'];
	 		//已存在已发布的词条
	 		_dialog.confirm("${lfn:message('kms-wiki:kmsWiki.TitleRepeat')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsWikiMain.do?method=view&fdId='+ fdId + '&id=' + id,'_blank');
				}},
				null,
		        [{
					name : "打开",
					value : true,
					focus : true,
					fn : function(value, dialog) {
						dialog.hide(value);
					}
				}, {
					name : "关闭",
					value : false,
					fn : function(value, dialog) {
						dialog.hide(value);
					}
				}]
			);
	 		//_dialog.alert("${lfn:message('kms-wiki:kmsWiki.isExist')}");
	 		return false;
	 	}
		 //存在审核中的词条
		else if(data["fdIsInFlow"] == true){
				_dialog.alert("${lfn:message('kms-wiki:kmsWiki.inFlow')}");
				return false;
		}
		//存在新建中的词条
		else if(data["fdIsInAdd"] == true){
			_dialog.alert("${lfn:message('kms-wiki:kmsWiki.inAdd')}");
			return false;
		}
		
		return true;
	}

	
	function submitDocContent() {
		//去掉编辑框
		destroyDiv();
		//将编辑器的内容都放入docContent的隐藏域里
		if(catelogJson.length>0){
			for(var i=0;i<catelogJson.length;i++){
				var _fdId = catelogJson[i].fdId;
				var contentObj = GetID("replace_"+_fdId);
				if(contentObj != null && typeof(contentObj) != "undefined"){
					//编辑段落时，不能编辑的段落内容全部隐藏。json中也为空，
					var contentStr = CKFilter.fireReplaceFilters(contentObj.innerHTML);
					catelogJson[i].docContent = contentStr;
					//alert(catelogJson[i].fdOrder);
					// 替代掉url前缀，解决移动kms图片头像不显示的问题
					var  urlFlex = "http:\/\/" + location.hostname + ":" + location.port;
					GetEl("fdCatelogList["+i+"].docContent").value 
						= base64Encode(contentStr.replace(urlFlex,''));//将编辑框的内容放入隐藏域中
				}
			}
		}
		return true;
	}

	//提交时修改文档状态
	function editStatus(status) {
		GetEl("docStatus").value = status;
	}

	

	var setIntervalFlag = null;
	// 新建的时候每55分钟延长锁定事件
	function extendAddLock() {
		if(curLockId != null && curLockId!="") { 
		setIntervalFlag = setInterval(function(){
			 $.ajax({
					url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=extendLockAdd" />',
					data : {
						"fdId" : curLockId
					},
					cache : false,
					dataType : "json"
					});
			 }, 60*1000*55);
		}
	}



	var ___validator;
	//验证不过后的跳转
	var _afterFormValidate = function (result, form, first) {
		if(!result)	{
			var t = LUI.$(first).parents('[data-lui-content-index]');
			LUI('__step').fireJump(t.attr('data-lui-content-index'));
		}		
	}
	function submitMethod(status) {
		if(!___validator) {
			___validator = $KMSSValidation(document.forms['kmsWikiMainForm'],
					{afterFormValidate:_afterFormValidate});
		}
		else {
			 ___validator.form = document.forms['kmsWikiMainForm'];
			 ___validator.options.afterFormValidate = _afterFormValidate;
		}
		//暂存时不验证属性必填项
		if(status=="10"){
			 ___validator.removeElements($('#validate_ele2')[0],'required');
		}
		var isNotExist = checkIsExist();
		if(isNotExist == "s_isnull") {
			//标题为空直接提交 
			Com_Submit(document.forms['kmsWikiMainForm'], 'save');
		}
		else if(isNotExist) {
			editStatus(status);
			submitDocContent();
			Com_Submit(document.forms['kmsWikiMainForm'], 'save');
		}
	}
	
	//右边信息是否显示
	var showFlag = false;
	//右边信息显示切换
	function rightInfoShow() {
		LUI.$('#r_info').removeClass("lui_wiki_hideDiv");
		LUI.$('#r_info').addClass("lui_wiki_showDiv");
		return true;
	}
	//添加右边信息/
	function addInfo() {
		//让右侧信息显示
		if(!showFlag) {
			showFlag = rightInfoShow();
		}
		seajs.use(['lui/topic','lui/view/render','lui/data/source','lui/base'],function(topic, render,source,base) {
			//去掉现有的基本信息
			topic.group("baseInfo_right").publish('removeContent',
					{"data":{'target':{"id":'baseInfo_right_id'}}});
			var authType =  LUI.$('input:radio[name="authorType"]:checked').val();
			var authorId = "";
			var authorName = "";
			if(authType=='1') {
				//内部作者
				authorId = document.getElementsByName('docAuthorId')[0].value;
				authorName = document.getElementsByName('docAuthorName')[0].value;
			} else if(authType == '2') {
				authorName = document.getElementsByName("outerAuthor")[0].value;
			} 
			var docCreatorId = "${kmsWikiMainForm.docCreatorId}";
			var docCreatorName  = "${kmsWikiMainForm.docCreatorName}";
			var docCreateTime = "${kmsWikiMainForm.docCreateTime}";
			var fdCateHost = document.getElementsByName("docCategoryName")[0].value;
			var fdCateHelp = document.getElementsByName("docSecondCategoriesNames")[0].value;
			//构造预览source
			var sourceObj = new source.Static(
				{ datas:{
						_authType:authType,
						_authorId:authorId,
						_docCreatorId:docCreatorId,
						_authorName: authorName,
						_creatorName: docCreatorName,
						_creatTime: docCreateTime,
						_fdCateHost: fdCateHost,
						_fdCateHelp: fdCateHelp
				  }
				}
			);
			sourceObj.startup();
			//构造预览render
			var renderObj = new render.Template({
				"src":'/kms/wiki/kms_wiki_main_ui/kms_wiki_baseInfo_tmpl.jsp'
				});
			
			renderObj.startup();
			//构造dataview
			var dataView = new base.DataView();
			dataView.addChild(renderObj);
			dataView.addChild(sourceObj);
			renderObj.setParent(dataView);
			dataView.startup();
			dataView.draw();
			//发布事件，新增content展示
			topic.group("baseInfo_right").publish('addContent',{"data":{
						"id":"baseInfo_right_id",
						"title":"${lfn:message('kms-wiki:kmsWiki.rightInfo.baseInfo')}",
						"child":[dataView]
					}});
		});
	}
	//添加标题
	function addDocTitle() {
		var title = document.getElementsByName("docSubject")[0].value;
		LUI.$('#title_span').html(title);
	}

	
	//点击上一步下一步的验证
	function pre_nextValidate(obj,_evt,validateIsExist) {
		//去掉前面的验证
		if(!___validator){
			___validator = $KMSSValidation(obj);
		} 
		___validator.form = obj;

		//只验证第一个
		if(!Com_Parameter.event["submit"][0]()) {
				_evt.cancel = true;
				return false;
		}
		//验证词条是否存在
		if(validateIsExist) {
			if(!checkIsExist()) {
				//若存在词条，则停止在第一步
				_evt.cancel = true;
				return false;
			}
		} 
		return true;

	}

	function filesUploaded(evt){
		//附件上传完毕
		var isFilesLoaded = attachmentObject_attachment.isUploaded();
		if(!isFilesLoaded) {
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert("${lfn:message('kms-wiki:kmsWiki.upload.files.tip')}");
			});
			evt.cancel = true;
			return false;
		}
	}
	seajs.use( [ 'lui/topic' ], function(topic) {
		topic.subscribe('JUMP.STEP', function(evt) {
			//验证基本信息
			if(evt.last==0 ) {
				if(pre_nextValidate(document.getElementById('validate_ele0'),evt,true)) {
						//添加标题
						addDocTitle();
						//添加右边信息
						addInfo();
						//延长锁定时间
						if(setIntervalFlag == null)
							extendAddLock();
				}
			}
			//去掉编辑框
			else if(evt.last==1) {
				if(filesUploaded(evt))
					editConfirm(LUI.$('.lui_wiki_btn_confirm')[0]);
			}
			//验证属性
			else if(evt.last==2 && evt.cur==3) {
				pre_nextValidate(document.getElementById('validate_ele2'),evt);
			}
		});

		topic.subscribe('PRE.STEP', function(evt) {
			//验证内容
			/*
			if(evt.index==0) {
				pre_nextValidate(document.getElementById('validate_ele1'),evt);
					
			}
			//验证属性
			if(evt.index==1) {
				pre_nextValidate(document.getElementById('validate_ele2'),evt);
			}*/
		});
	});

	/**
	*将部门和岗位修改为作者的部门和岗位
	*/
	function changeAuthodInfo(value) {
		if(value) {//内部作者
			var authorId = value[0];
			LUI.$.ajax({
				url : "<c:out value='${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=loadAuthodInfo'/>",
				type : 'post',
				dataType :'json',
				data: {fdId: authorId},
				success : function(data) {
					if (data) {
							LUI.$('input[name=docDeptId]').val(data.depId);
							LUI.$('input[name=docDeptName]').val(data.depName);
							LUI.$('input[name=docPostsIds]').val(data.postsIds);
							LUI.$('input[name=docPostsNames]').val(data.postsNames);
					} 
				},
				error : function(error) {
				}
			});
		} else {//外部作者
			LUI.$('input[name=docDeptId]').val('${kmsWikiMainForm.docDeptId}');
			LUI.$('input[name=docDeptName]').val('${kmsWikiMainForm.docDeptName}');
			LUI.$('input[name=docPostsIds]').val('${kmsWikiMainForm.docPostsIds}');
			LUI.$('input[name=docPostsNames]').val('${kmsWikiMainForm.docPostsNames}');
		}
		
	}
	//无分类情况下进入新建页面，自动弹框选择类别
	<c:if test="${kmsWikiMainForm.method_GET=='add'}">
		if('${param.fdCategoryId}'==''){
			window.changeDocCate('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',false);
		}
	</c:if>
</script>
