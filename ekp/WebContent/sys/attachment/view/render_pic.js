var self = this;
if(this.fdViewType=="pic") { 
	var xdiv = $("<div id='att_xdiv_"+this.fdKey+"' style='margin-top: 10px;'></div>");
	if(this.editMode=='view'){
		//查看视图
		if(this.fileList.length > 0){
			for (var i=0;i<this.fileList.length;i++){
				xdiv.append(createViewFileDiv(this.fileList[i]));
			}
		}
	}else{
		//编辑视图
		for (var i=0;i<this.fileList.length;i++){
			xdiv.append(createEditFileDiv(this.fileList[i]));
		}
	}
	done(xdiv);
}
/** 查看视图 开始 **/ 
function createViewFileDiv(file){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var fileIcon = window.GetIconNameByFileName(file.fileName);
	var xdiv = $("<div id='"+file.fdId+"' class='upload_list_div'></div>");
	var imgExtend = "";
	if(self.fdImgHtmlProperty!=null && self.fdImgHtmlProperty!="")	
		imgExtend = self.fdImgHtmlProperty; 	 
 	var idiv = $("<div class='upload_list_img_div'></div>");
 	idiv.append("<img  width='200' height='150' onclick=\"location.href='"+self.getUrl("download",file.fdId)+"'\" src=\""+self.getUrl("download",file.fdId)+"\" "+imgExtend+" border=0>");

 	idiv.append("<div class='upload_list_img_div_name'>"+file.fileName+"</div>");
 	
 	xdiv.append(idiv);
	var sdiv = $("<div class='upload_list_size_div'>"+Attachment_MessageInfo["button.filesize"]+":"+self.formatSize(file.fileSize)+"</div>");
 	xdiv.append(sdiv);
	return xdiv;
} 
/** 查看视图 结束 **/



/** 编辑视图 开始 **/
function createEditFileDiv(file){
	var fileExt = file.fileName.substring(file.fileName.lastIndexOf("."));
	var fileIcon = window.GetIconNameByFileName(file.fileName);
	var xdiv = $("<div id='"+file.fdId+"' class='upload_list_div'></div>");
	var imgExtend = "";
	if(self.fdImgHtmlProperty!=null && self.fdImgHtmlProperty!="")	
		imgExtend = self.fdImgHtmlProperty; 	 
 	var idiv = $("<div class='upload_list_img_div'></div>");
 	if(file.fileStatus==0){
 		idiv.append("<div style='width:200px;height:150px;'></div>");
 	}else{
 		idiv.append("<img  width='200' height='150' onclick=\"location.href='"+self.getUrl("download",file.fdId)+"'\" src=\""+self.getUrl("download",file.fdId)+"\" "+imgExtend+" border=0>");
 	} 	
 	idiv.append("<div class='upload_list_img_div_name'>"+file.fileName+"</div>");
 	idiv.append($("<div class='upload_list_img_div_del'></div>").click(function(){
			if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
			}
		}));
 	xdiv.append(idiv);
	//var sdiv = $("<div class='upload_list_size_div'>"+Attachment_MessageInfo["button.filesize"]+":"+self.formatSize(file.fileSize)+ "&nbsp;&nbsp;" +Attachment_MessageInfo["button.downtimes"].replace("{0}",file.downloadSum)+"</div>");
 	// 编辑状态下不显示下载次数
 	var sdiv = $("<div class='upload_list_size_div'>"+Attachment_MessageInfo["button.filesize"]+":"+self.formatSize(file.fileSize)+"</div>");
 	xdiv.append(sdiv);
	return xdiv;
} 
if(this.editMode=='view'){
	//查看时不需要绑定上传时间
}else{
	//this.off();
	this.on("uploadCreate",function(data){
		var file = data.file;
		$('#att_xdiv_'+self.fdKey+'').append(createEditFileDiv(file));
	});
	this.on("uploadStart", function(data){ 
		var file = data.file;
		var idiv = $("#"+file.fdId).find(".upload_list_img_div");
		idiv.append("<div class='upload_list_img_div_progress'><div class='upload_list_img_div_progress_val' style='width:0px;'></div></div>");
 		$("#"+file.fdId).find(".upload_list_img_div_del").off().hide();
	});
	this.on("uploadProgress", function(data){
		var file = data.file;
		var bytesLoaded = data.bytesLoaded;
		var bytesTotal = data.bytesTotal;
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
		$("#"+file.fdId).find(".upload_list_img_div_progress_val").css("width",percent+"%");
	});
	this.on("uploadSuccess", function(data){
		var file = data.file;
		var serverData = data.serverData; 
		if(file.id != file.fdId){
			$("#"+file.id).attr("id",file.fdId);
		}		
		var imgExtend = "";
		if(self.fdImgHtmlProperty!=null && self.fdImgHtmlProperty!="")	
			imgExtend = self.fdImgHtmlProperty;
		var idiv = $("#"+file.fdId).find(".upload_list_img_div").empty();
		idiv.append($("<div class='upload_list_img_div_del'></div>").click(function(){
			if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
				self.emit('editDelete',{"file":file});
			}
		}));
		// 编辑状态下禁止下载
		//idiv.append("<img width='200' height='150' onclick=\"location.href='"+self.getUrl("download",file.fdId)+"'\" src=\""+self.getUrl("download",file.fdId)+"\" "+imgExtend+" border=0>");
		idiv.append("<img width='200' height='150' src=\""+self.getUrl("download",file.fdId)+"\" "+imgExtend+" border=0>");
		idiv.append("<div class='upload_list_img_div_name'>"+file.fileName+"</div>");
 		idiv.append($("<div class='upload_list_img_div_del'></div>").click(function(){
			if(confirm(""+Attachment_MessageInfo["button.confimdelte"]+"")){
				file.fileStatus = -1;
				$("#"+file.fdId).remove();
				self.emit('editDelete',{"file":file});
			}
		}));
	});
	this.on("uploadFaied", function(data){
		var file = data.file;
		var serverData = data.serverData;	
		$("#"+file.fdId).find(".upload_list_img_div").empty().append(Attachment_MessageInfo["msg.uploadFail"]);
	});
	this.on("uploadError", function(data){
		var file = data.file;
		var errorCode = data.errorCode;
		var message = data.message;	
		$("#"+file.fdId).find(".upload_list_img_div").empty().append(Attachment_MessageInfo["msg.uploadFail"]);
	});
}