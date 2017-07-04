var self = this;
function createFlashDiv(){
	var xdiv = $("<div style='position:relative' class='swfuploadbutton'><div style='position:absolute;width:100%;height:100%;'><div class='swfuploadtext'>"+Attachment_MessageInfo["button.upload"]+"</div></div><div style='position:absolute;width:100%;height:100%;'><div data-lui-mark='uploadbutton' style='width:100%;height:100%;'></div></div></div>");
	return xdiv;
}

function createBigFileDiv(){
	var xdiv = $("<div class='biguploadbutton'><div class='biguploadtext'>"+Attachment_MessageInfo["button.bigAttBtn"]+"</div></div>");
	xdiv.click(function(){
		var xurl = Com_Parameter.ContextPath + "sys/attachment/swf/kFileClient.jsp?jsname=" + self.jsname;
		var win = new _popup_({
			"width" : 450,
			"height" : 300,
			"title" : Attachment_MessageInfo["button.bigAttBtn"],
			"url" : xurl,
			"showMini" : true,
			"onClose": self.onBigAttFrameClose
		});
		self.bigAttFrameObj = win;
	});
	return xdiv;
}
var xtable = $("<table class='tb_noborder' width='100%' border=0 cellspacing=0 cellpadding=0></table>");
if (this.editMode == "edit" || this.editMode == "add"){ 
	var xtr1 = $("<tr></tr>");
	var xtd = $("<td style='padding-top:0'></td>");
	xtd.append(createFlashDiv());
	if(self.fdSupportLarge && self.fdAttType != 'pic'){
		xtd.append(createBigFileDiv());
	}
	xtd.append("<div class='uploadinfotext'>"+Attachment_MessageInfo["button.textinfo"]+"</div>");
	if(self.required){
		xtd.append('<span class="txtstrong">*</span>');
	}
	xtable.append(xtr1.append(xtd));
}
var xtr2 = $("<tr><td data-lui-mark='attachmentlist'></td></tr>");
xtable.append(xtr2);

done(xtable);

/**
$(document).ready(function(){
	setTimeout(function(){
		//设置宽高
		self.swfupload.setButtonDimensions(100,25);
		//设置文字
		self.swfupload.setButtonText("<span class='uploadOpt'>"+Attachment_MessageInfo["button.create"]+"</span>");
		//设置文字
		self.swfupload.setButtonTextStyle(".uploadOpt{color:#ff0000;}");
		//
		self.swfupload.setButtonTextPadding(5,5);
		//设置背景图
		self.swfupload.setButtonImageURL("/ekp/sys/attachment/view/img/bg1.jpg");
	},500);
});
**/