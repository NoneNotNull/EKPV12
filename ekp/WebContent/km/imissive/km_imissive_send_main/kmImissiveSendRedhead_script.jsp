<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">  
function addRedHeadBookMarks(){
	//文种
	var doctype ='${kmImissiveSendMainForm.fdDocTypeName}'; 
	if(doctype!=null && doctype.length !=0){ 
		Attachment_ObjectInfo['editonline'].setBookmark('doctype', doctype);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('doctype', '');
	}
	//密级
	var secretgrade ='${kmImissiveSendMainForm.fdSecretGradeName}'; 
	if(secretgrade!=null && secretgrade.length !=0){ 
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade', secretgrade);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade', '');
	}
	//缓急
	
	var emergency = '${kmImissiveSendMainForm.fdEmergencyGradeName}';
	if(emergency!=null && emergency.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('emergency','');
	}
	//标题
	var docSubject ='${kmImissiveSendMainForm.docSubject}';
	if(docSubject!=null && docSubject.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject','');
	}
	// 发文文号
	var fdDocNum ='${kmImissiveSendMainForm.fdDocNum}';
	if(fdDocNum!=null && fdDocNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',fdDocNum);
	}else{
		if(document.getElementsByName("fdDocNum")[0])
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
	}
	// 核稿人
	var fdCheckerName ='${kmImissiveSendMainForm.fdCheckerName}';
	if(fdCheckerName!=null && fdCheckerName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('checker',fdCheckerName);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('checker','');
	}
	// 签发人
	var fdSignatureName ='${kmImissiveSendMainForm.fdSignatureName}';
	if(fdSignatureName!=null && fdSignatureName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('signature',fdSignatureName);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('signature','');
	}
	// 起草人
	var fdDrafterName ='${kmImissiveSendMainForm.fdDrafterName}';
	if(fdDrafterName!=null && fdDrafterName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('drafter',fdDrafterName);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('drafter','');
	}
	// 起草时间
	var fdDraftTime ='${kmImissiveSendMainForm.fdDraftTime}';
	if(fdDraftTime!=null && fdDraftTime.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',fdDraftTime);
	}else{
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime','');
	}
	//发文单位
	var fdSendtoUnitName ='${kmImissiveSendMainForm.fdSendtoUnitName}';
	if(fdSendtoUnitName!=null && fdSendtoUnitName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('sendunit', '');
	}
	//拟稿部门
	var fdDraftUnitName ='${kmImissiveSendMainForm.fdDraftUnitName}';
	if(fdDraftUnitName!=null && fdDraftUnitName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftUnitName);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('draftunit', '');
	}
	
	//主送
	var fdMaintoNames ='${kmImissiveSendMainForm.fdMaintoNames}';
	if(fdMaintoNames!=null && fdMaintoNames.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('maintounit', fdMaintoNames);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('maintounit', '');
	}
	//抄送
	var	fdCopytoNames ='${kmImissiveSendMainForm.fdCopytoNames}'; 
	if(fdCopytoNames!=null || fdCopytoNames.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('copytounit', fdCopytoNames);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('copytounit', '');
	}
	//抄报
	var fdReporttoNames = '${kmImissiveSendMainForm.fdReporttoNames}';
	if(fdReporttoNames!=null && fdReporttoNames.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('reporttounit', fdReporttoNames);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('reporttounit', '');
	}
	//签发日期（大写）
	var docPublishTimeUpper='${kmImissiveSendMainForm.docPublishTimeUpper}';
	if(docPublishTimeUpper!=null || docPublishTimeUpper.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('signdatecn', docPublishTimeUpper);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('signdatecn', '');
	}
	//签发日期（数字）
	var docPublishTimeNum='${kmImissiveSendMainForm.docPublishTimeNum}';
	if(docPublishTimeNum!=null || docPublishTimeNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('signdate', docPublishTimeNum);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('signdate', '');
	}
	//打印份数
	var fdPrintNum='${kmImissiveSendMainForm.fdPrintNum}';
	if(fdPrintNum!=null || fdPrintNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('printnum', fdPrintNum);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('printnum', '');
	}
	//打印页数
	var fdPrintPageNum='${kmImissiveSendMainForm.fdPrintPageNum}';
	if(fdPrintPageNum!=null || fdPrintPageNum.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum', fdPrintPageNum);
	} else{
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum', '');
	}
	return true;
}
</script>
