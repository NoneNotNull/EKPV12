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

	/*根据类型提交*/
	function commitMethod(commitType, saveDraft) {
		var formObj = document.kmsMultidocKnowledgeForm;
		var docStatus = document.getElementsByName("docStatus")[0];
		var validator = $KMSSValidation(document.forms['kmsMultidocKnowledgeForm']);
		if (saveDraft == "true") {
			docStatus.value = "10";
			//暂存时不验证属性必填项
			validator.removeElements($('#validate_ele2')[0],'required');
		} else {
			docStatus.value = "20";
		}
		if ('save' == commitType) {
			Com_Submit(formObj, commitType, 'fdId');
		} else {
			Com_Submit(formObj, commitType);
		}
	}

	

	/*修改辅类别*/
	
	function modifySecondCate(canClose) {
		seajs.use(['lui/dialog','lui/jquery'], function(dialog, $) {
			dialog.simpleCategory(
					'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
					'docSecondCategoriesIds','docSecondCategoriesNames',
					true,
					null, null, canClose, {'fdTemplateType':'1,3'},false);	
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
		}
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

</script>
