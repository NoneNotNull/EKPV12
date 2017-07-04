<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
function checkBookMarks(){
	var docSubject = document.getElementsByName('docSubject')[0].value;
	if(docSubject.length ==0 || docSubject==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.docSubject"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject',message);
	}
	var fdDocTypeId = document.getElementsByName('fdDocTypeId')[0].value;
	if(fdDocTypeId.length ==0 || fdDocTypeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDocType"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('doctype',message);
	}
	var fdDraftTime = document.getElementsByName('fdDraftTime')[0].value;
	if(fdDraftTime.length ==0 || fdDraftTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDraftTime"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',message);
	}
	if(fdDraftTime.length!==0 && fdDraftTime!=null){
		var drafttime = transferDate(fdDraftTime);
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
	}
	var fdSendtoUnitId = document.getElementsByName('fdSendtoUnitId')[0].value;
	if(fdSendtoUnitId.length ==0 || fdSendtoUnitId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSendtoDept"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('sendunit',message);
	}
	var fdCheckerId = document.getElementsByName('fdCheckerId')[0].value;
	if(fdCheckerId.length ==0 || fdCheckerId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdCheckId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('checker',message);
	}
	var fdSignatureId = document.getElementsByName('fdSignatureId')[0].value;
	if(fdSignatureId.length ==0 || fdSignatureId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSignatureId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signature',message);
	}
	var fdDraftUnitId = document.getElementsByName('fdDraftUnitId')[0].value;
	if(fdDraftUnitId.length ==0 || fdDraftUnitId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDraftDeptId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('draftunit',message);
	}
	var fdDrafterId = document.getElementsByName('fdDrafterId')[0].value;
	if(fdDrafterId.length ==0 || fdDrafterId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDraftId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('drafter',message);
	}
	var fdContent = document.getElementsByName('fdContent')[0].value;
	if(fdContent.length ==0 || fdContent==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdContent"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('content',message);
	}
	var fdSecretGradeId = document.getElementsByName('fdSecretGradeId')[0].value;
	if(fdSecretGradeId.length ==0 || fdSecretGradeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSecretGrade"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade',message);
	}
	var fdEmergencyGradeId = document.getElementsByName('fdEmergencyGradeId')[0].value;
	if(fdEmergencyGradeId.length ==0 || fdEmergencyGradeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdEmergencyGrade"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('emergency',message);
	}
	var fdDocNum = document.getElementsByName('fdDocNum')[0].value;
	if(fdDocNum.length ==0 || fdDocNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDocNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',message);
	}
	var docPublishTime = document.getElementsByName('docPublishTime')[0].value;
	if(docPublishTime.length ==0 || docPublishTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.docPublishTime"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signdate',message);
		var messagecn = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.docPublishTime.chinese"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',messagecn);
	}
	var fdPrintNum = document.getElementsByName('fdPrintNum')[0].value;
	if(fdPrintNum.length ==0 || fdPrintNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdPrintNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('printnum',message);
	}
	var fdPrintPageNum = document.getElementsByName('fdPrintPageNum')[0].value;
	if(fdPrintPageNum.length ==0 || fdPrintPageNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdPrintPageNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',message);
	}
	var fdMaintoIds = document.getElementsByName('fdMaintoIds')[0].value;
	if(fdMaintoIds.length ==0 || fdMaintoIds==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveMainMainto.fdUnitId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('maintounit',message);
	}
	var fdCopytoIds = document.getElementsByName('fdCopytoIds')[0].value;
	if(fdCopytoIds.length ==0 || fdCopytoIds==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveMainCopyto.fdUnitId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('copytounit',message);
	}
	var fdReporttoIds = document.getElementsByName('fdReporttoIds')[0].value;
	if(fdReporttoIds.length ==0 || fdReporttoIds==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveReportto.fdUnitId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('reporttounit',message);
	}
}
function switchLabelEvent(tableName, index){
	if(index == 2){
		addBookMarks();
	}
}
//作用：还原特殊符号
function returnStr(str){
	// 回车、双引号、单引号
	var regEnter=new RegExp("<br>","g"), regRegQm=new RegExp("&quot","g"),RegSqm=new RegExp("&acute","g");
	return str.replace(regEnter,"\r\n").replace(regRegQm,'"').replace(RegSqm,"'"); 
}

function addBookMarks(){
	var drafttime = transferDate(document.getElementsByName('fdDraftTime')[0].value);
	var docPublishTimeCn = transferDate(document.getElementsByName('docPublishTime')[0].value);
	var docPublishTime = transferDateToChinese(document.getElementsByName('docPublishTime')[0].value);
	var docSubject = document.getElementsByName('docSubject')[0].value;
	var fdSendtoUnitName = document.getElementsByName('fdSendtoUnitName')[0].value;
	var fdCheckerName = document.getElementsByName('fdCheckerName')[0].value;
	var fdSignatureName = document.getElementsByName('fdSignatureName')[0].value;
	var fdDraftUnitName = document.getElementsByName('fdDraftUnitName')[0].value;
	var fdDrafterName = document.getElementsByName('fdDrafterName')[0].value;
	var fdContent = document.getElementsByName('fdContent')[0].value;
	var fdDocType = document.getElementsByName("fdDocTypeId")[0];
	var doctype = fdDocType.options[fdDocType.selectedIndex].innerText||fdDocType.options[fdDocType.selectedIndex].textContent;
	var fdSecretGrade = document.getElementsByName("fdSecretGradeId")[0];
	var secret = fdSecretGrade.options[fdSecretGrade.selectedIndex].innerText||fdSecretGrade.options[fdSecretGrade.selectedIndex].textContent;
	var fdEmergencyGrade = document.getElementsByName("fdEmergencyGradeId")[0];
	var emergency = fdEmergencyGrade.options[fdEmergencyGrade.selectedIndex].innerText||fdEmergencyGrade.options[fdEmergencyGrade.selectedIndex].textContent;
	var fdPrintNum = document.getElementsByName('fdPrintNum')[0].value;
	var fdPrintPageNum = document.getElementsByName('fdPrintPageNum')[0].value;
	var fdMissiveMaintoNames = document.getElementsByName('fdMaintoNames')[0].value;
	var fdMissiveCopytoNames = document.getElementsByName('fdCopytoNames')[0].value;
	var fdMissiveReporttoNames = document.getElementsByName('fdReporttoNames')[0].value;
	if(docSubject!=null && docSubject.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(docSubject!='${kmImissiveSendMainForm.docSubject}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
		}
	}
	if(fdSendtoUnitName!=null && fdSendtoUnitName.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdSendtoUnitName !='${kmImissiveSendMainForm.fdSendtoUnitName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
		}
	}
	if(fdCheckerName!=null && fdCheckerName.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdCheckerName !='${kmImissiveSendMainForm.fdCheckerName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('checker', fdCheckerName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('checker', fdCheckerName);
		}
	}
	if(fdCheckerName==null || fdCheckerName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('checker', '');
	}
	if(fdSignatureName!=null && fdSignatureName.length !=0 ){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdSignatureName !='${kmImissiveSendMainForm.fdSignatureName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('signature', fdSignatureName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('signature', fdSignatureName);
		}
	}
	if(fdDraftUnitName!=null && fdDraftUnitName.length !=0  ){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdDraftUnitName !='${kmImissiveSendMainForm.fdDraftUnitName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftUnitName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftUnitName);
		}
	}
	if(fdDrafterName!=null && fdDrafterName.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdDrafterName !='${kmImissiveSendMainForm.fdDrafterName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('drafter', fdDrafterName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('drafter', fdDrafterName);
		}
	}
	if(drafttime!=null && drafttime.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(drafttime != '${kmImissiveSendMainForm.fdDraftTime}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
		}
	}
	if(fdContent!=null && fdContent.length !=0 ){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdContent != '${kmImissiveSendMainForm.fdContent}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('content',fdContent);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('content',fdContent);
		}
	}
	if(fdContent==null || fdContent.length ==0){
		Attachment_ObjectInfo['editonline'].setBookmark('content','');
	}
	if(doctype!=null && doctype.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(doctype != '${kmImissiveSendMainForm.fdDocTypeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
		}
	}
	if(secret!=null && secret.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(secret != '${kmImissiveSendMainForm.fdSecretGradeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('secretgrade',secret);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('secretgrade',secret);
		}
	}
	if(fdSecretGrade.value==null || fdSecretGrade.value.length ==0){
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade','');
	}
	if(emergency!=null && emergency.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(emergency != '${kmImissiveSendMainForm.fdEmergencyGradeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
		}
	}
	if(fdEmergencyGrade.value==null || fdEmergencyGrade.value.length ==0){
		Attachment_ObjectInfo['editonline'].setBookmark('emergency','');
	}
	if(docPublishTime!=null && docPublishTime.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(docPublishTime != '${kmImissiveSendMainForm.docPublishTime}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',docPublishTimeCn);
				 Attachment_ObjectInfo['editonline'].setBookmark('signdate',docPublishTime);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',docPublishTimeCn);
			Attachment_ObjectInfo['editonline'].setBookmark('signdate',docPublishTime);
		}
	}
	if(fdPrintNum.length !=0 && fdPrintNum!=null){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdPrintNum != '${kmImissiveSendMainForm.fdPrintNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('printnum',fdPrintNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('printnum',fdPrintNum);
		}
	}
	if(fdPrintNum.length ==0 || fdPrintNum==null){
		Attachment_ObjectInfo['editonline'].setBookmark('printnum','');
	}
	if(fdPrintPageNum.length !=0 && fdPrintPageNum!=null){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdPrintPageNum != '${kmImissiveSendMainForm.fdPrintPageNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',fdPrintPageNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',fdPrintPageNum);
		}
	}
	if(fdPrintPageNum.length ==0 || fdPrintPageNum==null){
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum','');
	}
	if(fdMissiveMaintoNames.length !=0 && fdMissiveMaintoNames!=null){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdMissiveMaintoNames != '${kmImissiveSendMainForm.fdMaintoNames}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('maintounit',fdMissiveMaintoNames);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('maintounit',fdMissiveMaintoNames);
		}
	}
	if(fdMissiveMaintoNames.length ==0 || fdMissiveMaintoNames==null){
		Attachment_ObjectInfo['editonline'].setBookmark('maintounit','');
	}
	if(fdMissiveCopytoNames.length !=0 && fdMissiveCopytoNames!=null){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdMissiveCopytoNames != '${kmImissiveSendMainForm.fdCopytoNames}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('copytounit',fdMissiveCopytoNames);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('copytounit',fdMissiveCopytoNames);
		}
	}
	if(fdMissiveCopytoNames.length ==0 || fdMissiveCopytoNames==null){
		Attachment_ObjectInfo['editonline'].setBookmark('copytounit','');
	}
	if(fdMissiveReporttoNames.length !=0 && fdMissiveReporttoNames!=null){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdMissiveReporttoNames != '${kmImissiveSendMainForm.fdReporttoNames}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('reporttounit',fdMissiveReporttoNames);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('reporttounit',fdMissiveReporttoNames);
		}
	}
	if(fdMissiveReporttoNames.length !=0 || fdMissiveReporttoNames==null){
		Attachment_ObjectInfo['editonline'].setBookmark('reporttounit','');
	}
	return true;
}
</script>