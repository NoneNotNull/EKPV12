var self = this;
function createFlashDiv() {
	var xdiv = $("<div style='position:relative' class='lui_upload_list_swfuploadbutton'><div style='position:absolute;width:100%;height:100%;'><div class='swfuploadtext'>"
			+ Attachment_MessageInfo["button.upload"] + (self.required==true?'&nbsp;<span class="txtstrong">*</span>':'')
			+ "</div></div><div style='position:absolute;width:100%;height:100%;'><div data-lui-mark='uploadbutton' style='width:100%;height:100%'></div></div></div>");
	return xdiv;
}

function createBigFileDiv() {
	var xdiv = $("<div class='lui_upload_list_swfuploadbutton'><div class='biguploadtext'>"
			+ Attachment_MessageInfo["button.bigAttBtn"] + "</div></div>");
	xdiv.click(function() {
				var xurl = Com_Parameter.ContextPath
						+ "sys/attachment/swf/kFileClient.jsp?jsname="
						+ self.jsname;
				var win = new _popup_({
							"width" : 450,
							"height" : 300,
							"title" : Attachment_MessageInfo["button.bigAttBtn"],
							"url" : xurl,
							"showMini" : true,
							"onClose" : self.onBigAttFrameClose
						});
				self.bigAttFrameObj = win;
			});
	return xdiv;
}
var ___width = self.fdPicContentWidth ? self.fdPicContentWidth.indexOf('%') > 0
		? self.fdPicContentWidth
		: parseInt(self.fdPicContentWidth) : 150, ___height = self.fdPicContentHeight
		? self.fdPicContentHeight.indexOf('%') > 0
				? self.fdPicContentHeight
				: parseInt(self.fdPicContentHeight)
		: 200;
$("#" + self.renderId).css({
			width : ___width,
			height : ___height
		});
var xcontainer = $("<div class='lui_upload_img_container' />");
var ximg = $("<div data-lui-mark='attachmentlist' class='lui_upload_img_content'/>");
var xbutton = $("<div class='lui_upload_img_button'/>");
xcontainer.append(ximg);
if (this.editMode == "edit" || this.editMode == "add") {
	xbutton.append(createFlashDiv());
	if (self.fdSupportLarge && self.fdAttType != 'pic') {
		xbutton.append(createBigFileDiv());
	}
	xcontainer.append(xbutton);
} else {
	// 高度覆盖掉按钮
	ximg.css('bottom', 0);
}

done(xcontainer);
