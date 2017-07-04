<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<script type="text/javascript">
	function addDoc(isBatchOperate) {
		if(!$KMSSValidation(document.forms['kmsMultipleUploadEditDocForm']).validate()){
			return;
		}
		var attIndex = '${param.attIndex}';//知识专辑对单个附件的编辑
		//如果不是批量
		if (isBatchOperate == undefined || isBatchOperate.length < 1) {
			if(attIndex!=''){
				var fdDocIdsObj = window.opener.document
				.getElementById('${kmsMultipleUploadEditDocForm.attId}_doc['+attIndex+']');
			}else{
				var fdDocIdsObj = window.opener.document
					.getElementById('${kmsMultipleUploadEditDocForm.attId}_doc');
			}
			var fdDocId='${kmsMultipleUploadEditDocForm.fdNewId}';
			if(fdDocId=='')
			{
				fdDocId='${kmsMultipleUploadEditDocForm.fdId}';
				fdDocIdsObj.value = '${kmsMultipleUploadEditDocForm.fdId}';		
			}
			else{
				fdDocIdsObj.value = fdDocId;
			}
			if(attIndex!=''){
				var fdDocAddIdsObj = window.opener.document
							.getElementsByName('fdMultipleUploadList['+attIndex+'].fdDocAddIds')[0];
			}else{
				var fdDocAddIdsObj = window.opener.document
							.getElementsByName('fdDocAddIds')[0];
			}
			
			var fdDocAddIdsObjValue = fdDocAddIdsObj.value;
			//将单独编辑的formId,写到父页面中的form的对应字段上，记录所有点击保存的formId, 主要是计算当在确认提交所有的文档的时候，时候有执行过删除，如果有，则需要从缓存中移除
			if (fdDocAddIdsObjValue == "" || fdDocAddIdsObjValue == null) {
				fdDocAddIdsObjValue = fdDocId;
				fdDocAddIdsObj.value = fdDocAddIdsObjValue;
			} else if (fdDocAddIdsObjValue
					.indexOf(fdDocId) < 0) {
				if(fdDocAddIdsObjValue.substring(fdDocAddIdsObjValue.length-1)==";"){
					fdDocAddIdsObjValue += fdDocId;
				}else{
					fdDocAddIdsObjValue += ";" + fdDocId;
				}
				
				fdDocAddIdsObj.value = fdDocAddIdsObjValue;
			}
			//批量标示字段
			if(attIndex!=''){
				var batchCurrentValue=window.opener.document
						.getElementById('${kmsMultipleUploadEditDocForm.attId}_batch['+attIndex+']');
			}else{
				var batchCurrentValue=window.opener.document
						.getElementById('${kmsMultipleUploadEditDocForm.attId}_batch');
			}
			var parentDelFormIdValue=window.document.getElementsByName('delFormIds')[0].value;
			//删除对应的批量列标示
			if(batchCurrentValue.value.length>3)
			{
				var batchValues=batchCurrentValue.value.split(";");
				window.document.getElementsByName('delFormIds')[0].value=parentDelFormIdValue+";"+batchValues[1];
				//将批量列重置为''
				batchCurrentValue.value='';
			}
			if(attIndex == ''){
				setEditColumnStyle('${kmsMultipleUploadEditDocForm.attId}');
			}
		} else {
			var batchReferenceCount = document
					.getElementsByName('batchReferenceCount')[0];
			var referenceCount = parseInt(batchReferenceCount.value);
			var attids = '${kmsMultipleUploadEditDocForm.batchAttIds}';
			var attidArray = attids.split(';');
			for ( var i = 0; i < attidArray.length; i++) {
				if (attidArray[i].length != 0) {
					//将信息做为一个form保存，并将这个fd_id与附件的自身的id关联，方便查找
					var attIdAndFormId = attidArray[i] + ';${kmsMultipleUploadEditDocForm.fdId}';
					//标示附件是批量操作
					window.opener.document
							.getElementById(attidArray[i] + '_batch').value = attIdAndFormId;
					referenceCount++;
					//删除单个编辑的值
					window.opener.document.getElementById(attidArray[i] +'_doc').value='';
					setEditColumnStyle(attidArray[i]);
				}
			}
			batchReferenceCount.value = referenceCount;
		}
		//封面附件id
		setCoverPicIds();
		document.kmsMultipleUploadEditDocForm.submit();
  	}
  	
	//设置封面附件attachmentIds和deletedAttachmentIds
	function setCoverPicIds(){
		var tempIds = "";
		var tempDelIds = "";
		for ( var i = 0; i < attachmentObject_spic.fileList.length; i++) {
			var doc = attachmentObject_spic.fileList[i];
			if (doc.fileStatus == -1) {
				if(doc.fdId.indexOf("SWFUpload") >=0){
				}else{
					tempDelIds += ";" + doc.fdId;
				}
			} else if(doc.fileStatus == 1) {
				tempIds += ";" + doc.fdId;
			}
		}
		if (tempIds.length > 0) {
			tempIds = tempIds.substring(1, tempIds.length);
		}
		if (tempDelIds.length > 0) {
			tempDelIds = tempDelIds.substring(1, tempDelIds.length);
		}
		
		$("input[name='spicAttIds']").val(tempIds);
		$("input[name='spicDeleteAttIds']").val(tempDelIds);
	}
    //修改编辑过的背景色
  	function setEditColumnStyle(attId){
  		window.opener.document.getElementById(attId).style.background = "#fbed90";
  	}

</script>
