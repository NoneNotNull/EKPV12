<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${kmsResourcePath }/theme/default/uploadify.css"
	type="text/css" rel="stylesheet" />
<script src="${kmsResourcePath }/js/lib/jquery.form.js"></script>
<script src="${kmsResourcePath }/js/lib/swfobject.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.uploadify.js"></script>
<script src="${kmsResourcePath }/js/lib/json2.js"></script>
<script>
	var submitForm = null;

	jQuery( function($) {
		// 提交个人信息的修改
		submitForm = function() {
			$("#kmsPersonInfoForm").ajaxSubmit( {
				success : function() {
					artDialog.alert("修改个人信息成功！");
				},
				error : function() {
					artDialog.alert("修改个人信息失败！");
				}
			});
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
								fdId : "${fdAttId}",
								fdModelId : "${kmsPersonInfoForm.fdId}",
								fdModelName : "com.landray.kmss.kms.common.model.KmsPersonInfo",
								fdKey : "spic",
								fdAttType : "pic"
							//width: 144,
							//height: 135
							},

							onUploadSuccess : function(file, data, response) {
								var fdAttachmentId = null;
								var xmlDom = jQuery.createXMLDocument(data);
								jQuery("data", xmlDom).each( function() {
									var aa = "";
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
</script>