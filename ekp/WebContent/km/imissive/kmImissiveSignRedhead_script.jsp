<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
//选择发文红头模板
function LoadHeadWordList(fdModelName){
	var url =Dialog_SimpleCategoryForNewFile("com.landray.kmss.km.imissive.model.KmImissiveSignRedHeadTemplate","createUrl?&fdTemplateId=!{id}&fdTemplateName=!{name}",false,true,"02",null,true,"<bean:message bundle='km-imissive' key='kmImissiveRedheadset.select'/>");
    var selAttId = Com_GetUrlParameter(url,"fdTemplateId");
    if(Attachment_ObjectInfo['editonline']){
    	var JGWebOffice =Attachment_ObjectInfo['editonline'].ocxObj; 
    }
	try { 
		if(selAttId!=null){
			JG_UseTemplate(JGWebOffice,selAttId,fdModelName); //确定套红
		}else {//取消 
			return
		}
	}catch(err){
		JGWebOffice.WebOpen(false);//恢复主文档的正文 
	}
}
 //调用数据库中的发文红头模板。
function JG_UseTemplate(JGWebOffice,selAttId,fdModelName){
 	 JGWebOffice.WebSetMsgByName("_fdTemplateModelId",selAttId);
	 JGWebOffice.WebSetMsgByName("_fdTemplateModelName","com.landray.kmss.km.imissive.model.KmImissiveSignRedHeadTemplate");
	 JGWebOffice.WebSetMsgByName("_fdTemplateKey","editonline");
	if (JGWebOffice.WebLoadTemplate()){   //交互OfficeServer的OPTION="LOADTEMPLATE"
		window.setTimeout(function(){
			JG_insertFile(JGWebOffice,fdModelName);
		},700); //暂停下否则加载报错
   }else {
	   alert("<bean:message bundle='km-imissive' key='kmImissiveRedheadset.open.error'/>");//打开模板失败
  	 return false;
    }
} 
//②把正文文档插入到模板的书签位置。
function JG_insertFile(JGWebOffice,fdModelName){
	 JGWebOffice.WebShow(false);
	 JGWebOffice.WebSetMsgByName("_fdId",'${param.fdId}');  
	 JGWebOffice.WebSetMsgByName("_fdModelName",fdModelName);  
	 JGWebOffice.WebSetMsgByName("_fdKey","editonline");
	 redheadFlag = "true";
	 JGWebOffice.WebInsertFile();   //填充公文正文 交互OfficeServer的OPTION="INSERTFILE" 
     window.setTimeout(addRedHeadBookMarks,500); //暂停下否则加载报错,替换书签内容
}  
</script>
