var self = this;
if (this.fdViewType == "pic_single") {
	var xdiv = $("<div id='att_xdiv_" + this.fdKey
			+ "' style='height:100%'></div>");
	if (this.editMode == 'view') {
		// 查看视图
		if (this.fileList.length > 0) {
			for (var i = 0; i < this.fileList.length; i++) {
				xdiv.append(createViewFileDiv(this.fileList[i]));
			}
		}
	} else {
		// 编辑视图
		for (var i = 0; i < this.fileList.length; i++) {
			xdiv.append(createEditFileDiv(this.fileList[i]));
		}
	}
	done(xdiv);
}

/** 查看视图 开始 * */
function createViewFileDiv(file) {
	var xdiv = $("<div id='" + file.fdId
			+ "' style='height:100%;position:relative'></div>");
	var imgExtend = "";
	if (self.fdImgHtmlProperty != null && self.fdImgHtmlProperty != "")
		imgExtend = self.fdImgHtmlProperty;
	var idiv = $("<div class='lui_upload_list_img_div'></div>");

	// 图片规格重构
	var __href = self.getUrl("download", file.fdId);
	var $___img = $("<img src=\"" + __href + "\"  border=0 >");
	// 点击放大图片

	idiv.append($___img);
	xdiv.append(idiv);

	if (self.fdShowMsg != false) {
		var ____sizeDiv = $("<div class='lui_upload_list_size_div'/>");
		xdiv.append(____sizeDiv);
		idiv.append("<div class='lui_upload_list_img_div_name'>"
				+ file.fileName + "</div>");
	} else
		idiv.css('bottom', 0);
	$___img.load(function(evt) {
				var ___w2h = resizeImg(evt.target, $('#att_xdiv_' + self.fdKey
								+ ''));
				self.emit('imgLoaded', {
							target : this
						});
				if (self.fdShowMsg == false)
					return;
				____sizeDiv.html(___w2h.width + "*" + ___w2h.height);
			})

	return xdiv;
}
/** 查看视图 结束 * */

/** 编辑视图 开始 * */
function createEditFileDiv(file) {
	var xdiv = $("<div id='" + file.fdId
			+ "' style='height:100%;position:relative'></div>");
	var idiv = $("<div class='lui_upload_list_img_div'></div>");
	var $___img = $("<img src=\"" + self.getUrl("download", file.fdId)
			+ "\"  border=0 >");
	idiv.append($___img);
	xdiv.append(idiv);
	var ____sizeDiv = $("<div class='lui_upload_list_size_div'/>");
	xdiv.append(____sizeDiv);
	$___img.load(function(evt) {
				var ___w2h = resizeImg(evt.target, $('#att_xdiv_' + self.fdKey
								+ ''));
				____sizeDiv.html(___w2h.width + "*" + ___w2h.height);
			})
	idiv.append("<div class='lui_upload_list_img_div_name'>" + file.fileName
			+ "</div>");
	idiv.append($("<div class='upload_list_img_div_del'></div>").click(
			function() {
				self.___delImg(file, xdiv);
			}));
	return xdiv;
}

function uploadCreateFileDiv(file) {
	var xdiv = $("<div id='" + file.fdId
			+ "' style='height:100%;position:relative'></div>");
	var idiv = $("<div class='lui_upload_list_img_div'></div>");
	xdiv.append(idiv);
	return xdiv;
}

function __resizeImg(__img, width, height) {
	var obj = __img
	var iwidth = parseInt(width);
	var iheight = parseInt(height);
	var __width = obj.width, __height = obj.height;
	if (__width > 0 && __height > 0) {
		if (__width / __height >= iwidth / iheight) {
			if (__width > iwidth) {
				obj.width = iwidth;
				obj.height = (__height * iwidth) / __width;
				$(obj).css(
						'margin-top',
						[(iheight - (__height * iwidth) / __width) / 2, 'px']
								.join(''));
			} else {
				obj.width = __width;
				obj.height = __height;
				$(obj).css('margin-top',
						[(iheight - __height) / 2, 'px'].join(''));
			}
		} else {
			if (__height > iheight) {
				obj.height = iheight;
				obj.width = (__width * iheight) / __height;
				obj.style.cssText = ['margin-left: ',
						(iwidth - (__width * iheight) / __height) / 2, 'px']
						.join('');
			} else {
				obj.width = __width;
				obj.height = __height;
				obj.style.cssText = ['margin-top: ', (iheight - __height) / 2,
						'px;margin-left: ', (iwidth - __width) / 2, 'px']
						.join('');
			}
		}
	}
	return {
		width : __width,
		height : __height
	};
}

function resizeImg(__img, $outerObj) {
	var iheight = $outerObj.height()
			- $outerObj.find('.lui_upload_list_size_div').height(), iwidth = $outerObj
			.width();// 去除分辨率高度
	return __resizeImg(__img, iwidth, iheight);
}

// 删除图片
self.___delImg = function(file, xdiv) {
	if (typeof(seajs) != 'undefined') {
		seajs.use('lui/dialog', function(___dialog) {
					___dialog.confirm(
							Attachment_MessageInfo["button.confimdelte"],
							function(___val) {
								if (___val) {
									file.fileStatus = -1;
									$("#" + file.fdId).remove();
									// 移除分辨率
									xdiv.find('.lui_upload_list_size_div')
											.remove();
									self.emit('editDelete', {
												"file" : file
											});
								}
							});
				})
	} else {
		if (confirm("" + Attachment_MessageInfo["button.confimdelte"] + "")) {
			file.fileStatus = -1;
			$("#" + file.fdId).remove();
			self.emit('editDelete', {
						"file" : file
					});
		}
	}
}

if (this.editMode == 'view') {
	// 查看时不需要绑定上传时间
} else {
	this.on("uploadCreate", function(data) {
				var file = data.file;
				$('#att_xdiv_' + self.fdKey + '')
						.append(uploadCreateFileDiv(file));
			});
	this.on("uploadStart", function(data) {
		var file = data.file;
		var idiv = $("#" + file.fdId).find(".lui_upload_list_img_div");
		idiv
				.append("<div class='upload_list_img_div_progress'><div class='upload_list_img_div_progress_val' style='width:0px;'></div></div>");
		$("#" + file.fdId).find(".upload_list_img_div_del").off().hide();
	});

	this.on("uploadProgress", function(data) {
				var file = data.file;
				var bytesLoaded = data.bytesLoaded;
				var bytesTotal = data.bytesTotal;
				var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
				$("#" + file.fdId).find(".upload_list_img_div_progress_val")
						.css("width", percent + "%");
			});

	this.on("uploadSuccess", function(data) {
				var file = data.file;
				var serverData = data.serverData;
				if (file.id != file.fdId)
					$("#" + file.id).attr("id", file.fdId);

				var idiv = $("#" + file.fdId).find(".lui_upload_list_img_div")
						.empty();

				// 获取图片高度宽度，用于呈现
				var $___img = $("<img src=\""
						+ self.getUrl("download", file.fdId) + "\"  border=0 >");
				idiv.append($___img);
				var ____sizeDiv = $("<div class='lui_upload_list_size_div'/>");
				xdiv.append(____sizeDiv);
				$___img.bind('load', function(evt) {
							var ___w2h = resizeImg(evt.target, $('#att_xdiv_'
											+ self.fdKey + ''));
							____sizeDiv
									.html(___w2h.width + "*" + ___w2h.height);
						});

				idiv.append("<div class='lui_upload_list_img_div_name'>"
						+ file.fileName + "</div>");
				idiv.append($("<div class='upload_list_img_div_del'></div>")
						.click(function() {
									self.___delImg(file, xdiv);
								}));
			});
	this.on("uploadFaied", function(data) {
				var file = data.file;
				var serverData = data.serverData;
				$("#" + file.fdId).find(".lui_upload_list_img_div").empty()
						.append(Attachment_MessageInfo["msg.uploadFail"]);
			});
	this.on("uploadError", function(data) {
				var file = data.file;
				var errorCode = data.errorCode;
				var message = data.message;
				$("#" + file.fdId).find(".lui_upload_list_img_div").empty()
						.append(Attachment_MessageInfo["msg.uploadFail"]);
			});
}