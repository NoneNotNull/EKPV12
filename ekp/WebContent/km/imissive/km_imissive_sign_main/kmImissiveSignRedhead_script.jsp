<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">  
function addRedHeadBookMarks(){
	//文种
	var doctype ='${kmImissiveSignMainForm.fdDocTypeName}'; 
	if(doctype!=null && doctype.length !=0){ 
		Attachment_ObjectInfo['editonline'].setBookmark('doctype', doctype);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('doctype', '');
	}
	//密级
	var secretgrade ='${kmImissiveSignMainForm.fdSecretGradeName}'; 
	if(secretgrade!=null && secretgrade.length !=0){ 
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade', secretgrade);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade', '');
	}
	//缓急
	var emergency = '${kmImissiveSignMainForm.fdEmergencyGradeName}';
	if(emergency!=null && emergency.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('emergency','');
	}
	//标题
	var docSubject ='${kmImissiveSignMainForm.docSubject}';
	if(docSubject!=null && docSubject.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject','');
	}
	// 签报字号
	var fdDocNum ='${kmImissiveSignMainForm.fdDocNum}';
	if(fdDocNum!=null && fdDocNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',fdDocNum);
	}else{
		if(document.getElementsByName("fdDocNum")[0])
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
	}
	// 核稿人
	var fdCheckerName ='${kmImissiveSignMainForm.fdCheckerName}';
	if(fdCheckerName!=null && fdCheckerName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('checker',fdCheckerName);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('checker','');
	}
	// 起草人
	var fdDrafterName ='${kmImissiveSignMainForm.fdDrafterName}';
	if(fdDrafterName!=null && fdDrafterName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('drafter',fdDrafterName);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('drafter','');
	}
	// 起草时间
	var fdDraftTime ='${kmImissiveSignMainForm.fdDraftTime}';
	if(fdDraftTime!=null && fdDraftTime.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',fdDraftTime);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime','');
	}
	//拟稿部门
	var fdDraftDeptName ='${kmImissiveSignMainForm.fdDraftDeptName}';
	if(fdDraftDeptName!=null && fdDraftDeptName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftDeptName);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('draftunit', '');
	}
	//打印份数
	var fdPrintNum='${kmImissiveSignMainForm.fdPrintNum}';
	if(fdPrintNum!=null || fdPrintNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('printnum', fdPrintNum);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('printnum', '');
	}
	//打印页数
	var fdPrintPageNum='${kmImissiveSignMainForm.fdPrintPageNum}';
	if(fdPrintPageNum!=null || fdPrintPageNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum', fdPrintPageNum);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum', '');
	}
	return true;
}
</script>
