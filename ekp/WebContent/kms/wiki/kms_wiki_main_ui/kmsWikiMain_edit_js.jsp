<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	Com_IncludeFile("ckfilter.js|ckeditor.js", "ckeditor/");
</script>
<script type="text/javascript"
	src="${LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/js/editorCategory.js">
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
	// 选择模板刷新页面
	function callBackTemplateAction(rtnVal){
		if(rtnVal){
			var hash = rtnVal.GetHashMapArray();
			var fdTemplateId = hash[0]['id']; 
			var fdCategoryId = "${param.fdCategoryId}";
			var url = ['<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do"/>?method=add','fdCategoryId='+fdCategoryId,'fdTemplateId='+fdTemplateId].join('&');
			setTimeout("location='"+url+"'",10);
		}
	};
	
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
				___urlParam: {'fdTemplateType':'2,3'},
				notNull: false
		}
		seajs.use(['sys/ui/js/dialog'], 
				function(dialog){
					dialog.simpleCategory(cfg);
				});
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
			   var p = _$(this).prev().find('.lui_wiki_editparagraph')[0];
			   openEdit(p);
		 });
	};
	

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
		}
		if (value == 2) {
			LUI.$('#innerAuthor input').attr('validate', '').val('');
			LUI.$('#outerAuthor input').attr('validate', 'required');
			LUI.$('#outerAuthor').show();
		}
	}
	//记录删除的段落点评ids
	var evaWikis = new Array();
	//当前编辑断的段落点评ids
	var evaWiki_after = new Array();
	var evaWiki_before = new Array();
	//编辑之前
	function beforeEvaWiki(_pid) {
		//找出本段下面的所有段落点评img
		var eid;
		LUI.$('#replace_' + _pid).find('img[e_id]').each(
			function() {
				eid = LUI.$(this).attr('e_id');
				evaWiki_before.push(eid);
			}
		);
	}
	//编辑之后
	function afterEvaWiki(_pid) {
		//找出本段删除的段落
		var _eid
		LUI.$('#replace_' + _pid).find('img[e_id]').each(
				function() {
					_eid = LUI.$(this).attr('e_id');
					evaWiki_after.push(_eid);
				}
		);
		//添加到删除的数组中去
		var _delete = getDeleteEva(evaWiki_before,evaWiki_after);
		if(_delete!=null &&  _delete.length > 0)
			evaWikis = evaWikis.concat(_delete);
		evaWiki_after.length=0;
		evaWiki_before.length=0;		
	}

	//数组相减 第一个数组减去第二个数组
	function getDeleteEva(beforr_Arr,after_bArr){   
	    if(beforr_Arr.length==0) {
		    	return null;
		}
	    var diff=new Array();
	    var str=after_bArr.join("&quot;&quot;");
		for(var i=0; i<beforr_Arr.length; i++) {
	        if(str.indexOf(beforr_Arr[i])==-1){
	            	diff.push(beforr_Arr[i]);
	        }
		 }
    	return diff;
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
	*编辑此段时切换编辑框
	*/
	function openEdit(parent) {
		var thisObj = parent.getElementsByTagName("span")[0];
		var thisId = thisObj.id;
		var replaceObj = document.getElementById("replace_" + thisId);
		var catelogId = '${param.catelogId}';
		if(catelogId != null && catelogId.length>0) {
			//var name=LUI.$('#catelog_' + thisId + ' .lui_wiki_title').text();
			//showEditDiv(thisId,name);
			//return;
			LUI('preview').setVisible(true);
			LUI.$('.lui_wiki_edit_p').hide();
			LUI.$('#catelogChild_'+thisId).show();
		}
		LUI.$(".lui_wiki_btn_confirm").remove();
		LUI.$(".lui_wiki_editparagraph").show();
		var top = -1;
		if(replaceObj) {
			destroyDiv();
			editor = CKEDITOR.replace(replaceObj, {"toolbar":"Wiki","toolbarStartupExpanded":false,"toolbarCanCollapse":true});
			editor.on('refreshCategory',function(){
				CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
			});
			top = LUI.$(parent).parent().offset().top - 45;	
			//添加本段的段落点评
			beforeEvaWiki(thisId);	
		}
		//隐藏掉“编辑此段”
		LUI.$(parent).hide();
		LUI.$(parent).parent().append("<span class='lui_wiki_btn_confirm' onclick='editConfirm(this,\""+ thisId +"\")'><bean:message bundle='kms-wiki' key='kmsWiki.confirm.true'/></span>");
		if(top > 0) {
			//滚动到此段显示
			LUI.$('html,body').animate({
				scrollTop:top
			}, 500);
		}
	}
	//编辑完成，确认
	function editConfirm(object,thisId) {
		LUI.$(object).remove();
		destroyDiv();
		LUI.$(".lui_wiki_editparagraph").show();
		afterEvaWiki(thisId);
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
		//修改页面上的目录
		var fdMainId = "${kmsWikiMainForm.fdId}";
		//先删除所有页面中的目录及其内容（目录可能会改变）
		var _catelogTree = LUI.$('#catelogTree');
		_catelogTree.empty();
		//重新添加目录
		for(var i=0; i<catelogJson.length; i++) {
			var _id = catelogJson[i].fdId;
			var editparagraph = "${lfn:message('kms-wiki:kmsWiki.editParagraph')}";
			_catelogTree.append('<div class="lui_wiki_clear"></div>');
			_catelogTree.append('<div id="catelogChild_' + _id + '"></div>');
			LUI.$('#catelogChild_' + _id).append(
				'<div class="lui_wiki_catelog clearfloat"  id="catelog_'+ _id +'"></div>',
				'<div class="lui_wiki_content" id="editable_'+ _id +'"></div>'	
			);
			LUI.$('#catelog_' + _id)
				.append('<div class="lui_wiki_title">' + catelogJson[i].fdName + '</div>');
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
		catelogIframe();
	}

	//创建隐藏的元素
	function createHidElement(iVal, nameVal, valueVal) {
	    var ele = LUI.$('<input></input>');
	    ele.attr('type', 'hidden');
	    ele.attr('name', 'fdCatelogList[' + iVal + '].' + nameVal);
	    ele.attr('value', valueVal);
		return ele;
	}


	//检查词条是否存在
	function checkIsExist() {
		var flag = false;
		var docSubject = LUI.$('input[name="docSubject"]').val();
		var url = "<c:url  value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=checkAddSubject'/>";
		var data = {
				"fdId" : "${kmsWikiMainForm.fdId}",
				"docSubject" : encodeURIComponent(docSubject)
		};
		LUI.$.ajax({ 
			url:url,
			data: data,
			cache : false,
			dataType : "json",
			async:false,
			success : function(data) {
				var rtnVal = data[0]; 
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
	 		//已存在已发布的词条
	 		_dialog.alert("${lfn:message('kms-wiki:kmsWiki.isExist')}");
	 		return false;
	 	}else{
		 	//存在审核中的词条
			if(data["fdIsInFlow"] == true){
				_dialog.alert("${lfn:message('kms-wiki:kmsWiki.inFlow')}");
				return false;
			}
		}
		return true;
	}

	
	function submitDocContent() {
		var isOk = true;
		//去掉编辑框
		destroyDiv();
		var editId = LUI.$(".lui_wiki_btn_confirm").prev().find('span').attr("id");
		if(editId)
			afterEvaWiki(editId);
		LUI.$(".lui_wiki_btn_confirm").remove();
		LUI.$(".lui_wiki_editparagraph").show();
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
		//异步更新段落点评
		if(evaWikis.length > 0) {
			var values = "";
			for (var i = 0; i < evaWikis.length; i++) {
					values += evaWikis[i] + ",";
			}
			LUI.$('[name=wikiEvaIds]').val(values);		
		}
		return isOk;
	}

	//提交时修改文档状态
	function editStatus(status) {
		GetEl("docStatus").value = status;
	}

	//加载页面时，如果是完善段落的，默认显示此段为编辑状态
	function loadCatelogEditor(){
		var edit_catelogId = "${param.catelogId}";
		if(edit_catelogId != "" && edit_catelogId != null){
			if(catelogJson.length>0){
				for(var i=0;i<catelogJson.length;i++){
					if(catelogJson[i].fdParentId == edit_catelogId){
						//编辑的目录id
						var id = catelogJson[i].fdId;
						var catelogName = catelogJson[i].fdName;
						//showEditDiv(id,catelogName);
						var edit_catelog = GetID("replace_"+id);
						var _top = LUI.$('#catelogChild_' + id).offset().top - 45;
						if(edit_catelog != null){
							LUI.$('#catelog_' + id).find('.lui_wiki_editparagraph').hide();
							LUI.$('#catelog_' + id).append("<span class='lui_wiki_btn_confirm' onclick='editConfirm(this,\"" + id +"\")'><bean:message bundle='kms-wiki' key='kmsWiki.confirm.true'/></span>");
							LUI.$('#catelogChild_'+id).show();
							editor = CKEDITOR.replace(edit_catelog,{"toolbar":"Wiki","toolbarStartupExpanded":false,"toolbarCanCollapse":true});//默认此段为编辑状态
							editor.on('refreshCategory',function(){
								CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
							});
							LUI.$('html,body').animate({ scrollTop : _top }, 500);
							break;
						}
						break;
					}
				}
			}
		}
	}

	//编辑此段时弹出层
	function showEditDiv(divId,_catelogName) {
		var _content = LUI.$("#replace_" + divId).html();
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
		window.dialogDiv = dialog.build( {
				id : 'editDiv',
				config : {
					height: 1000,
					width:  800,
					lock : true,
					cache : false,
					title : "",
					content : {
						type : "html",
						html : ['<div class="lui_wiki_editThis">',
								'<div class="lui_wiki_catelog">',
								'<div class="lui_wiki_title com_subject">',
								_catelogName,
								'</div>',
								'<span class="lui_wiki_btn_confirm" onclick="editThisCancel()">${lfn:message("button.cancel")}</span>',
								'<span class="lui_wiki_btn_confirm" onclick="editThis(','\''+ divId + '\'',')">${lfn:message("button.ok")}</span>',
								'</div>','<br>',
								'<div id="_editContent" style="height:350px;overflow: hidden;">',_content,
								'</div>',
								'</div>'
							   ].join(" "),
					    iconType : ""
					    /*buttons : [ {
							name : "${lfn:message('button.ok')}",
							value : true,
							focus : true,
							fn : function(value,_dialog) {
									var a = editor.document.getBody().getHtml();
									console.log(LUI.$("#" + divId));
									LUI.$("#" + divId).html(a);
									_dialog.hide();
								}
								
							}
						, {
							name : "${lfn:message('button.cancel')}",
							value : false,
							fn : function(value, dialog) {
								dialog.hide();
							}
						} ]*/
					}
				},

				callback : function(value, dialog) {

				},
				actor : {
					type : "default"
				},
				trigger : {
					type : "default"
				}

			}).show();


	});
		window.dialogDiv.on("layoutDone",function(){
				var edit_catelog_content = GetID("_editContent");
				editor = CKEDITOR.replace(edit_catelog_content,{"toolbar":"Wiki","toolbarStartupExpanded":false,"toolbarCanCollapse":true,"height":350});//默认此段为编辑状态
				editor.on('refreshCategory',function(){
					CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
				});
				//记录段落点评id
				beforeEvaWiki(divId);
			}
		)
	}
	
	
	//编辑段落确定（弹出层）
	function editThis(_divId) {
		destroyDiv();
		var editor_c = LUI.$("#_editContent").html();
		//console.log(LUI.$("#" + _divId));
		LUI.$("#replace_" + _divId).html(editor_c);
		//确定后滑到刚刚编辑的段落
		var _top = LUI.$("#catelog_" + _divId).offset().top - 45;
		LUI.$('html,body').animate({
			scrollTop:_top
		}, 500);
		window.dialogDiv.hide();
		//段落点评id
		afterEvaWiki(_divId);
	}
	//编辑段落取消（弹出层）
	function editThisCancel() {
		window.dialogDiv.hide();
	}
	window.onload= function () {
		setTimeout("loadCatelogEditor()", 200);
	}


	//预览词条
	function preview(){
		editConfirm(LUI.$('.lui_wiki_btn_confirm')[0],LUI.$('.lui_wiki_btn_confirm').attr('id'));
		LUI.$('.lui_wiki_edit_p').show();
		if(GetID('cardPic')) {
			drawImage(GetID('cardPic'),GetID('cardPic').parentNode);
		}
		LUI('preview').setVisible(false);
	}

	function drawImage(obj, outerObj) {
		
		var image = new Image(), iheight, iwidth;
		if (outerObj.currentStyle) {
			iheight = outerObj.currentStyle['height'];
			iwidth = outerObj.currentStyle['width'];
		} else {
			var style = document.defaultView.getComputedStyle(outerObj, null);
			iheight = style['height'];
			iwidth = style['width'];
		}
	
		iheight = parseInt(iheight);
		iwidth = parseInt(iwidth);
		image.src = obj.src;
		// 兼容chrome浏览器
		image.height = image.height == 0 ? obj.height : image.height;
		image.width = image.width == 0 ? obj.width : image.width;
		if (image.width > 0 && image.height > 0) {
			if (image.width / image.height >= iwidth / iheight) {
				if (image.width > iwidth) {
					obj.width = iwidth;
					obj.height = (image.height * iwidth) / image.width;
					// display is none ~~ obj.height = 0;
					obj.style.cssText = ['margin-top: ',
							(iheight - (image.height * iwidth) / image.width) / 2,
							'px'].join('');
				} else {
					obj.width = image.width;
					obj.height = image.height;
					obj.style.cssText = ['margin-top: ',
							(iheight - image.height) / 2, 'px;margin-left: ',
							(iwidth - image.width) / 2, 'px'].join('');
				}
			} else {
				if (image.height > iheight) {
					obj.height = iheight;
					obj.width = (image.width * iheight) / image.height;
					obj.style.cssText = ['margin-left: ',
							(iwidth - (image.width * iheight) / image.height) / 2,
							'px'].join('');
				} else {
					obj.width = image.width;
					obj.height = image.height;
					obj.style.cssText = ['margin-top: ',
							(iheight - image.height) / 2, 'px;margin-left: ',
							(iwidth - image.width) / 2, 'px'].join('');
				}
			}
		}
		obj.style.visibility = 'visible';
	}

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

	function submitMethod(status) {
		var docSubject = LUI.$('input[name="docSubject"]').val();
		if(docSubject.trim()==""){
			_dialog.alert("${lfn:message('kms-wiki:kmsWikiMain.docSubject.isNull')}");
	 		return false;
		}
		//暂存时不验证属性必填项
		if(status=="10"){
			var valdate = $KMSSValidation(document.forms['kmsWikiMainForm']);
			valdate.removeElements($('#validate_ele2')[0],'required');
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

	/**
	 * 暂存调用,在暂存时,移除自定义表单部分的必填校验。
	 */
	function saveDraft(status){
		var valdate = $KMSSValidation(document.forms['kmsWikiMainForm']);
		valdate.removeElements($('#validate_ele2')[0],'required');
		Com_Submit(document.kmsWikiMainForm,status);
	}
</script>
