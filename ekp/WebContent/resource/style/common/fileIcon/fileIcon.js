/*****************************************
功能：根据附件文件名后缀返回信息
参数：fileType 附件类型
******************************************/
function GetIconName(fileType) {
	switch(fileType){
		case "application/msword":return "word.png";
		case "application/vnd.ms-excel":return "excel.png";
		case "application/vnd.ms-powerpoint":return "ppt.png";
		case "application/pdf":return "pdf.png";
		case "text/plain":return "text.png";
		case "application/x-jpg":return "image.png";
		case "application/x-ico":return "image.png";
		case "application/x-bmp":return "image.png";
		case "image/gif":return "image.png";
		case "image/png":return "image.png";
		default:return "documents.png";
	}
}

function GetIconNameByFileName(fileName) {
	if(fileName==null || fileName=="")
		return "documents.png";
	var fileExt = fileName.substring(fileName.lastIndexOf("."));
	if(fileExt!="")
		fileExt=fileExt.toLowerCase();
	switch(fileExt){
		case ".doc":
		case ".docx":
			  return "word.png";
		case ".xls":
		case ".xlsx":
			return "excel.png";
		case ".ppt":
		case ".pptx":
			return "ppt.png";
		case ".pdf":return "pdf.png";
		case ".txt":return "text.png";
		case ".jpg":return "image.png";
		case ".ico":return "image.png";
		case ".bmp":return "image.png";
		case ".gif":return "image.png";
		case ".png":return "image.png";
		default:return "documents.png";
	}
}