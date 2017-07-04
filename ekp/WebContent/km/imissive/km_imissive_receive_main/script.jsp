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
	var fdSendtoUnitId = document.getElementsByName('fdSendtoUnitId')[0].value;
	if(fdSendtoUnitId.length ==0 || fdSendtoUnitId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSendtoDept"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('sendunit',message);
	}
	var fdDocNum = document.getElementsByName('fdDocNum')[0].value;
	if(fdDocNum.length ==0 || fdDocNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSendtoDept"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('docnum',message);
	}
	var fdReceiveDocNum = document.getElementsByName('fdReceiveDocNum')[0].value;
	if(fdReceiveDocNum.length ==0 || fdReceiveDocNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSendtoDept"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('receivenum',message);
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
	var fdSignerId = document.getElementsByName('fdSignerId')[0].value;
	if(fdSignerId.length ==0 || fdSignerId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdCheckId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signer',message);
	}
	var fdSignTime = document.getElementsByName('fdSignTime')[0].value;
	if(fdSignTime.length ==0 || fdSignTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSignatureId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('signtime',message);
	}
	var fdRecorderId = document.getElementsByName('fdRecorderId')[0].value;
	if(fdRecorderId.length ==0 || fdRecorderId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdCheckId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('recorder',message);
	}
	var fdRecordTime = document.getElementsByName('fdRecordTime')[0].value;
	if(fdRecordTime.length ==0 || fdRecordTime==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdSignatureId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('recordtime',message);
	}
	var fdReceiveUnitId = document.getElementsByName('fdReceiveUnitId')[0].value;
	if(fdReceiveUnitId.length ==0 || fdReceiveUnitId==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDraftDeptId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',message);
	}
	var fdOutSendto = document.getElementsByName('fdOutSendto')[0].value;
	if(fdOutSendto.length ==0 || fdOutSendto==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDraftDeptId"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',message);
	}
	var fdContent = document.getElementsByName('fdContent')[0].value;
	if(fdContent.length ==0 || fdContent==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdContent"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('content',message);
	}
	var fdShareNum = document.getElementsByName('fdShareNum')[0].value;
	if(fdShareNum.length ==0 || fdShareNum==null){
		var message = "<"+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.bookMarks"/>"+"("+"<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdPrintNum"/>"+")>";
		Attachment_ObjectInfo['editonline'].setBookmark('sharenum',message);
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
	var docSubject = document.getElementsByName('docSubject')[0].value;
	var fdSendtoUnitName = document.getElementsByName('fdSendtoUnitName')[0].value;
	var fdDocNum = document.getElementsByName("fdDocNum")[0];
	var fdReceiveDocNum = document.getElementsByName("fdReceiveDocNum")[0];
	var fdDocType = document.getElementsByName("fdDocTypeId")[0];
	var doctype = fdDocType.options[fdDocType.selectedIndex].innerText||fdDocType.options[fdDocType.selectedIndex].textContent;
	var fdEmergencyGrade = document.getElementsByName("fdEmergencyGradeId")[0];
	var emergency = fdEmergencyGrade.options[fdEmergencyGrade.selectedIndex].innerText||fdEmergencyGrade.options[fdEmergencyGrade.selectedIndex].textContent;
	var fdSecretGrade = document.getElementsByName("fdSecretGradeId")[0];
	var secret = fdSecretGrade.options[fdSecretGrade.selectedIndex].innerText||fdSecretGrade.options[fdSecretGrade.selectedIndex].textContent;
	var fdSignerName = document.getElementsByName('fdSignerName')[0].value;
	var fdSignTime = document.getElementsByName('fdSignTime')[0].value;
	var fdRecorderName = document.getElementsByName('fdRecorderName')[0].value;
	var fdRecordTime = document.getElementsByName('fdRecordTime')[0].value;
	var fdReceiveTime = document.getElementsByName('fdReceiveTime')[0].value;
	var fdReceiveUnitName = document.getElementsByName('fdReceiveUnitName')[0].value;
	var fdOutSendto = document.getElementsByName('fdOutSendto')[0].value;
	var fdShareNum = document.getElementsByName('fdShareNum')[0].value;
	var fdContent = document.getElementsByName('fdContent')[0].value;
	if(docSubject!=null && docSubject.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(docSubject!='${kmImissiveReceiveMainForm.docSubject}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('docsubject',docSubject);
		}
	}
	if(fdSendtoUnitName!=null && fdSendtoUnitName.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdSendtoUnitName !='${kmImissiveReceiveMainForm.fdSendtoUnitName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('sendunit', fdSendtoUnitName);
		}
	}
	if(doctype!=null && doctype.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(doctype != '${kmImissiveReceiveMainForm.fdDocTypeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('doctype',doctype);	
		}
	}
	if(secret!=null && secret.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(secret != '${kmImissiveReceiveMainForm.fdSecretGradeName}'){
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
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(emergency != '${kmImissiveReceiveMainForm.fdEmergencyGradeName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('emergency',emergency);
		}
	}
	if(fdEmergencyGrade.value==null || fdEmergencyGrade.value.length ==0){
		Attachment_ObjectInfo['editonline'].setBookmark('emergency','');
	}
	
	if(fdDocNum!=null && fdDocNum.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdDocNum != '${kmImissiveReceiveMainForm.fdDocNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('docnum',fdDocNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('docnum',fdDocNum);
		}
	}
	if(fdReceiveDocNum!=null && fdReceiveDocNum.length !=0){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdReceiveDocNum != '${kmImissiveReceiveMainForm.fdReceiveDocNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('receivenum',fdReceiveDocNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('receivenum',fdReceiveDocNum);
		}
	}

	
	if(fdSignerName!=null && fdSignerName.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(fdCheckerName !='${kmImissiveReceiveMainForm.fdSignerName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('signer', fdSignerName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('signer', fdSignerName);
		}
	}
	if(fdSignerName==null || fdSignerName.length !=0){
		Attachment_ObjectInfo['editonline'].setBookmark('signer', '');
	}
	if(fdSignTime!=null && fdSignTime.length !=0){
		if("${ kmImissiveSendMainForm.method_GET}" == "edit"){
			 if(drafttime != '${kmImissiveReceiveMainForm.fdSignTime}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('signtime',fdSignTime);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('signtime',fdSignTime);
		}
	}
	if(fdShareNum.length !=0 && fdShareNum!=null){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdPrintNum != '${kmImissiveReceiveMainForm.fdShareNum}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('sharenum',fdShareNum);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('sharenum',fdShareNum);
		}
	}
	if(fdShareNum.length ==0 || fdShareNum==null){
		Attachment_ObjectInfo['editonline'].setBookmark('sharenum','');
	}
	if(fdReceiveUnitName.length !=0 && fdReceiveUnitName!=null){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdMissiveMaintoNames != '${kmImissiveReceiveMainForm.fdReceiveUnitName}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',fdReceiveUnitName);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',fdMissiveMaintoNames);
		}
	}
	if(fdOutSendto.length !=0 && fdOutSendto!=null){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdMissiveMaintoNames != '${kmImissiveReceiveMainForm.fdOutSendto}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',fdOutSendto);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('receivetunit',fdOutSendto);
		}
	}
	if(fdContent!=null && fdContent.length !=0 ){
		if("${ kmImissiveReceiveMainForm.method_GET}" == "edit"){
			 if(fdContent != '${kmImissiveReceiveMainForm.fdContent}'){
				 Attachment_ObjectInfo['editonline'].setBookmark('content',fdContent);
			 }
		}else{
			Attachment_ObjectInfo['editonline'].setBookmark('content',fdContent);
		}
	}
	if(fdContent==null || fdContent.length ==0){
		Attachment_ObjectInfo['editonline'].setBookmark('content','');
	}
	return true;
}
</script>