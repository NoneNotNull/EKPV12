<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
function checkBookMarks(){
	var docSubject = document.getElementsByName('docSubject')[0].value;
	if(docSubject.length ==0 || docSubject==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.docSubject"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('docsubject',message);
	}
	var fdDocTypeName = document.getElementsByName('fdDocTypeName')[0].value;
	if(fdDocTypeName.length ==0 || fdDocTypeName==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDocType"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('doctype',message);
	}
	var fdDraftTime = document.getElementsByName('fdDraftTime')[0].value;
	if(fdDraftTime.length ==0 || fdDraftTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDraftTime"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',message);
	}
	if(fdDraftTime.length!==0 && fdDraftTime!=null){
		var drafttime = transferDate(fdDraftTime);
		Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
	}
	var fdSendtoUnitName = document.getElementsByName('fdSendtoUnitName')[0].value;
	if(fdSendtoUnitName.length ==0 || fdSendtoUnitName==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdSigntoDept"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('sendunit',message);
	}
	var fdCheckerName = document.getElementsByName('fdCheckerName')[0].value;
	if(fdCheckerName.length ==0 || fdCheckerName==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdCheckId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('checker',message);
	}
	var fdDraftDeptName = document.getElementsByName('fdDraftDeptName')[0].value;
	if(fdDraftDeptName.length ==0 || fdDraftDeptName==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDraftDeptId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('draftdept',message);
	}
	var fdDrafterName = document.getElementsByName('fdDrafterName')[0].value;
	if(fdDrafterName.length ==0 || fdDrafterName==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDraftId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('drafter',message);
	}
	var fdContent = document.getElementsByName('fdContent')[0].value;
	if(fdContent.length ==0 || fdContent==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdContent"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('content',message);
	}
	var fdDocTypeId = document.getElementsByName('fdDocTypeId')[0].value;
	if(fdDocTypeId.length ==0 || fdDocTypeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDocType"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('doctype',message);
	}
	var fdSecretGradeId = document.getElementsByName('fdSecretGradeId')[0].value;
	if(fdSecretGradeId.length ==0 || fdSecretGradeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdSecretGrade"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('secretgrade',message);
	}
	var fdEmergencyGradeId = document.getElementsByName('fdEmergencyGradeId')[0].value;
	if(fdEmergencyGradeId.length ==0 || fdEmergencyGradeId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdEmergencyGrade"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('emergency',message);
	}
	var fdDocNum = document.getElementsByName('fdDocNum')[0].value;
	if(fdDocNum.length ==0 || fdDocNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDocNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',message);
	}
	var docPublishTime = document.getElementsByName('docPublishTime')[0].value;
	if(docPublishTime.length ==0 || docPublishTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.docPublishTime"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signdate',message);
		var messagecn = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.docPublishTime.chinese"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',messagecn);
	}
	var fdPrintNum = document.getElementsByName('fdPrintNum')[0].value;
	if(fdPrintNum.length ==0 || fdPrintNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdPrintNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('printnum',message);
	}
	var fdPrintPageNum = document.getElementsByName('fdPrintPageNum')[0].value;
	if(fdPrintPageNum.length ==0 || fdPrintPageNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSignMain.fdPrintPageNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',message);
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
	var fdDraftDeptName = document.getElementsByName('fdDraftDeptName')[0].value;
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
	if(docSubject!=null && docSubject.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(docSubject!='${kmImissiveSignMainForm.docSubject}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
		}
	}
	if(fdSendtoUnitName!=null && fdSendtoUnitName.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdSendtoUnitName !='${kmImissiveSignMainForm.fdSendtoUnitName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
		}
	}
	if(fdCheckerName!=null && fdCheckerName.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdCheckerName !='${kmImissiveSignMainForm.fdCheckerName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('checker', fdCheckerName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('checker', fdCheckerName);
		}
	}
	if(fdCheckerName==null || fdCheckerName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('checker', '');
	}
	if(fdDraftDeptName!=null && fdDraftDeptName.length !=0  ){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdDraftDeptName !='${kmImissiveSignMainForm.fdDraftDeptName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftDeptName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('draftunit', fdDraftDeptName);
		}
	}
	if(fdDrafterName!=null && fdDrafterName.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdDrafterName !='${kmImissiveSignMainForm.fdDrafterName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('drafter', fdDrafterName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('drafter', fdDrafterName);
		}
	}
	if(drafttime!=null && drafttime.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(drafttime != '${kmImissiveSignMainForm.fdDraftTime}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('drafttime',drafttime);
		}
	}
	if(fdContent!=null && fdContent.length !=0 ){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdContent != '${kmImissiveSignMainForm.fdContent}'){
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
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(doctype != '${kmImissiveSignMainForm.fdDocTypeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
		}
	}
	if(secret!=null && secret.length !=0){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(secret != '${kmImissiveSignMainForm.fdSecretGradeName}'){
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
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(emergency != '${kmImissiveSignMainForm.fdEmergencyGradeName}'){
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
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(docPublishTime != '${kmImissiveSignMainForm.docPublishTime}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',docPublishTimeCn);
				 Attachment_ObjectInfo['editonline'].setBookmark('signdate',docPublishTime);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('signdatecn',docPublishTimeCn);
			Attachment_ObjectInfo['editonline'].setBookmark('signdate',docPublishTime);
		}
	}
	if(fdPrintNum.length !=0 && fdPrintNum!=null){
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdPrintNum != '${kmImissiveSignMainForm.fdPrintNum}'){
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
		if("${ kmImissiveSignMainForm.method_GET}" == "edit"){
			 if(fdPrintPageNum != '${kmImissiveSignMainForm.fdPrintPageNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',fdPrintPageNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('printpagenum',fdPrintPageNum);
		}
	}
	if(fdPrintPageNum.length ==0 || fdPrintPageNum==null){
		Attachment_ObjectInfo['editonline'].setBookmark('printpagenum','');
	}
	return true;
}
</script>