<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	/**
	 * 初始化默认属性
	 */
	function initDefineProperty() {
		var url = this.location.href;
		var defineProperty = '${param.defineProperty}';
		if (defineProperty == "true") {
			var num = url.indexOf("defineProperty=true");
			var len = "defineProperty=true".length;
			//解析字符串默认属性
			anatomyKeyValue(url.substring(num + len + 1));
		}
	}

	/**
	 * 解析字符串设置属性
	 */
	function anatomyKeyValue(str) {

		var propertys = str.split("&");
		var len = propertys.length;
		var prefix = "extendDataFormInfo.value(";
		var suffix = ")";
		var keyValue, key, value, elem;
		for ( var i = 0; i < len; i++) {
			keyValue = propertys[i].split("=");
			key = prefix + keyValue[0] + suffix;
			value = keyValue[1];
			elem = document.getElementsByName(key);
			if (!elem || elem.length <= 0)
				continue;
			//文本框
			if (elem[0].type == "text") {
				elem[0].value = value;

			} else if (elem[0].type == "hidden") {
				var _elem = document.getElementsByName("_" + key);
				//文本选择（地址、组织架构）
				if (!_elem) {
					elem[0].value = value;
				}
				//复选框
				elem = _elem;
				var elen = elem.length;
				for ( var j = 0; j < elen; j++) {
					if (value.indexOf(elem[j].value) >= 0) {
						if (elem[j].type == "checkbox") {
							$(elem[j]).trigger("click");
						}
					}
				}

				//下拉框
			} else if (elem[0].type == "select-one") {
				elem = elem[0].children;
				var elen = elem.length;
				for ( var j = 0; j < elen; j++) {
					if (elem[j].value == value) {
						elem[j].selected = true;
						break;
					}
				}

				//单选
			} else if (elem[0].type == "radio") {
				var elen = elem.length;
				for ( var j = 0; j < elen; j++) {
					if (elem[j].value == value) {
						elem[j].checked = true;
						break;
					}
				}
			}
		}
	}

	//点击新版本
	function showNewEdtion(obj) {
		var url = obj.rev;
		var version = Dialog_PopupWindow(url, 497, 310);
		if (version != null) {
			var href = assemblyHref();
			href = href + "&version=" + version;
			window.location.href = href;
		}
	}

	function assemblyHref() {
		var href = window.location.href;
		var reg = /method=\w*/;
		href = href.replace(reg, "method=newEdition");
		var reg1 = /fdId/;
		href = href.replace(reg1, "originId");
		return href;
	}


	/*修改分类*/
	
	function modifyCate(unClose, isModify) {
		seajs.use(['lui/dialog', 'lui/util/env'],function(dialog, env) {
			if(isModify) {
				//修改分类，弹出确认框
				dialog.confirm("${lfn:message('kms-multidoc:kmsMultidoc.confirmCategory')}", 
						function(flag) {
							if(flag)
								dialogForNewFile();
						}
			    );
			} else dialogForNewFile();

				
			function dialogForNewFile() {
				dialog
				   .simpleCategoryForNewFile(
					"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
					"/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdWorkId=${param.fdWorkId}&fdPhaseId=${param.fdPhaseId}",
					false, function(rtn) {
						// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!unClose && !rtn)
							window.close();
					}, null, LUI.$('input[name=docCategoryId]').val(), "_self",
					true, {
						'fdTemplateType': '1,3'
					});
			}

	    });
	}
	/*修改辅类别*/
	function modifySecondCate(canClose) {
		seajs.use(['lui/dialog', 'lui/jquery'], function(dialog, $) {
			dialog.simpleCategory({
				modelName: 'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
				authType: 2,
				idField: 'docSecondCategoriesIds',
				nameField: 'docSecondCategoriesNames',
				mulSelect: true,
				canClose: true,
				notNull : false ,
				___urlParam: {
					'fdTemplateType': '1,3'
				}
			});
		});
	}

	/*切换作者类型*/
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
			changeAuthodInfo(null);
		}
	}

	seajs.use( [ 'lui/topic' ], function(topic) {
		topic.subscribe('JUMP.STEP', function(evt) {
			//验证基本信息
			if(evt.last==0 ) {
				if(pre_nextValidate(document.getElementById('validate_ele0'),evt)) {
					//添加标题
					addDocTitle();
					//添加右边信息
					addInfo();
				}
			}
			//验证完善知识属性
			if(evt.last==2 && evt.cur==3){
				pre_nextValidate(document.getElementById('validate_ele2'),evt);
			}
		});

	});

	//添加标题
	function addDocTitle() {
		var title = document.getElementsByName("docSubject")[0].value;
		LUI.$('#title_span').html(title);
	}

	//右边信息是否显示

	//添加右边信息/
	function addInfo() {
		//让右侧信息显示
		showFlag = rightInfoShow();
		addRightInfo();
	}
	
	//右边信息显示切换
	function rightInfoShow() {
		LUI.$('#r_info').removeClass("lui_multidoc_hideLi");
		LUI.$('#r_info').addClass("lui_multidoc_showLi");

		LUI.$('#r_info1').removeClass("lui_multidoc_hideLi");
		LUI.$('#r_info1').addClass("lui_multidoc_showLi");

		var secondCategoryValue = document.getElementsByName("docSecondCategoriesNames")[0].value;
		if(secondCategoryValue != ""){
			LUI.$('#r_info2').removeClass("lui_multidoc_hideLi");
			LUI.$('#r_info2').addClass("lui_multidoc_showLi");
		}
	}
	
	//添加右边信息
	function addRightInfo(){
		var author = document.getElementsByName("docAuthorName")[0].value;
		LUI.$('#author_span').html(author);

		var docTemplate = document.getElementsByName("docTemp")[0].innerHTML; 
		LUI.$('#docTemplate_span').html(docTemplate);

		var secondaryCategories = document.getElementsByName("docSecondCategoriesNames")[0].value;
		LUI.$('#secondaryCategories_span').html(secondaryCategories);
		
	}
	
	var ___validator;
	//点击上一步下一步的验证
	function pre_nextValidate(obj,_evt) {
		//去掉前面的验证
		if(!___validator){
			___validator = $KMSSValidation(obj);
		}
		___validator.form = obj;
		//附件上传完毕
		var isFilesLoaded = attachmentObject_attachment.isUploaded();
		if(!isFilesLoaded) {
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert("${lfn:message('kms-multidoc:kmsMultidoc.upload.files.tip')}");
			});
			_evt.cancel = true;
			return false;
		}
		//只验证第一个
		if(!Com_Parameter.event["submit"][0]()) {
				_evt.cancel = true;
				return false;
		}
		return true;
	}

	//验证不过后的跳转
	var _afterFormValidate = function (result, form, first) {
		if(!result)	{
			var t = LUI.$(first).parents('[data-lui-content-index]');
			LUI('__step').fireJump(t.attr('data-lui-content-index'));
		}		
	}

	/*根据类型提交*/
	function commitMethod(commitType, saveDraft) {
		if(!___validator) {
			___validator = $KMSSValidation(document.forms['kmsMultidocKnowledgeForm'],
					{afterFormValidate:_afterFormValidate});
		}
		else {
			 ___validator.form = document.forms['kmsMultidocKnowledgeForm'];
			 ___validator.options.afterFormValidate = _afterFormValidate;
		}
		
		var formObj = document.kmsMultidocKnowledgeForm;
		var docStatus = document.getElementsByName("docStatus")[0];
		if (saveDraft == "true") {
			docStatus.value = "10";
			 //暂存调用,在暂存时,移除自定义表单部分的必填校验。
			___validator.removeElements($('#validate_ele2')[0],'required');
		} else {
			docStatus.value = "20";
		}
		if ('save' == commitType) {
			Com_Submit(formObj, commitType, 'fdId');
		} else {
			Com_Submit(formObj, commitType);
		}
	}
	//新建页面以第一个附件名为文档名
	attachmentObject_attachment.on("uploadSuccess",getFileName);
	attachmentObject_attachment.on("editDelete",getFileName);
	function getFileName(){
		var length = attachmentObject_attachment.fileList.length;
		for(var i = 0;i<length;i++){
			var fileName = attachmentObject_attachment.fileList[i].fileName;
			var fileBaseName = fileName.substring(0,fileName.lastIndexOf('.'));
			var _contain = contains(attachmentObject_attachment.fileList,LUI.$('.inputAdd')[0].value);
			if(LUI.$('.inputAdd')[0].value!=""&&!_contain){
				break;
			}else if(attachmentObject_attachment.fileList[i].fileStatus>-1){
				LUI.$('.inputAdd')[0].value=fileBaseName;
				break;
			}
		}
	}

	function contains(fileList,elem){
		for(var i = 0;i<fileList.length;i++){
			var fileName = fileList[i].fileName;
			var fileBaseName = fileName.substring(0,fileName.lastIndexOf('.'));
			if(fileBaseName == elem){
				return true;
			}
		}
		return false;
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
			LUI.$('input[name=docDeptId]').val('${kmsMultidocKnowledgeForm.docDeptId}');
			LUI.$('input[name=docDeptName]').val('${kmsMultidocKnowledgeForm.docDeptName}');
			LUI.$('input[name=docPostsIds]').val('${kmsMultidocKnowledgeForm.docPostsIds}');
			LUI.$('input[name=docPostsNames]').val('${kmsMultidocKnowledgeForm.docPostsNames}');
		}
		
	}
	
	//无分类情况下进入新建页面，自动弹框选择类别
	<c:if test="${kmsMultidocKnowledgeForm.method_GET=='add'}">
		if('${param.fdTemplateId}'==''){
			window.modifyCate(false);
		}
	</c:if>


</script>
