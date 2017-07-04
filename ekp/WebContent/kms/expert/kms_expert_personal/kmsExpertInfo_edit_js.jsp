<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${kmsResourcePath }/theme/default/uploadify.css"
	type="text/css" rel="stylesheet" />
<script src="${kmsResourcePath }/js/lib/swfobject.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.uploadify.js"></script>
<script src="${kmsResourcePath }/js/lib/json2.js"></script>
<script>
	function openExpertWindow() {
		Dialog_TreeList(false, 'kmsExpertTypeId', 'kmsExpertTypeName', ';',
				'kmsExpertTypeTreeService&expertTypeId=!{value}',
				'<bean:message key="dialog.tree.title" bundle="kms-expert"/>',
				'kmsExpertTypeListService&expertTypeId=!{value}');
	}

	jQuery.createXMLDocument = function(string) {
		var doc;
		if (window.ActiveXObject) {
			doc = new ActiveXObject("Microsoft.XMLDOM");
			doc.async = "false";
			doc.loadXML(string);
		} else {
			doc = new DOMParser().parseFromString(string, "text/xml");
		}

		return doc;
	}
	jQuery( function($) {

		// 提交个人信息的修改
		submitForm = function() {
			if ($('input[name="kmsExpertTypeId"]').val()) {
				$("#kmsExpertInfoForm").ajaxSubmit( {
					success : function() {
						artDialog.alert("修改个人信息成功！");
					}
				});
			}else{
				artDialog.alert('请选择专家分类！');
			}
			return false;
		};

		/* 上传文件  */
		$("#file_upload")
				.uploadify(
						{
							swf : "${kmsResourcePath }/flash/uploadify.swf",
							uploader : "<c:url value='/sys/attachment/sys_att_main/sysAttMain.do?method=save' />",
							fileObjName : "formFiles[0]",
							checkExisting : false,
							cancelImage : "${kmsResourcePath }/img/uploadify-cancel.png",
							buttonText : "上传形象照片",
							auto : true,
							postData : {
								//method: "save",
								fdId: "${fdAttId}",
								fdModelId : "${kmsExpertInfoForm.fdId}",
								fdModelName : "com.landray.kmss.kms.expert.model.KmsExpertInfo",
								fdKey : "spic",
								fdAttType : "pic"
							},

							onUploadSuccess : function(file, data, response) {
								var fdAttachmentId = null;
								var xmlDom = jQuery.createXMLDocument(data);
								jQuery("data", xmlDom).each( function() {
									if ($(this).attr("fdId")) {
										fdAttachmentId = $(this).attr("fdId");
										return;
									}
								});
								$("#headPic")
										.attr(
												"src",
												"<c:url value='/sys/attachment/sys_att_main"
														+ "/sysAttMain.do?method=download&fdId=' />"
														+ fdAttachmentId
														+ "&_=" + jQuery.now());
							}
						});

	});
</script>