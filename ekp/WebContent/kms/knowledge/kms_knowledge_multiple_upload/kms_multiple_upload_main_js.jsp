<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<script type="text/javascript">

    function batchUpdate()
    {
        var checkCollect=$("input[type='checkbox']:checked");
        if(checkCollect.length==0)
        {
        	seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
        	    	dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.slectAttachments.execute')}");
        	});
          return false;
        }
        var attIds="";
        var delFormIds="";
        var formId="";
        var editId="";
        var batchId="";
        var batchIdObj=null;
        var attId="";
        checkCollect.each(function(){ 
        	attId=$(this).val();
        	if(attId.length>3)
        	{
        		attIds+=attId+";"; 
            	editId=$('#'+attId+'_doc').val();
            	batchIdObj=$('#'+attId+'_batch').val();
            	//如果该列是已经被批量编辑过
            	if(batchIdObj.length>3)
            	{
            		delFormIds+=batchIdObj.split(";")[1]+";";
            	}
            	//如果该列被编辑过，则将他们记录，需要从缓存移除
            	if(editId.length>3)
            	{
            		delFormIds+=editId+';';
            	}	  
        	}       	     
    	}); 
    	var url='${LUI_ContextPath}/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadEditDoc.do?method=edit&fdModelName=${kmsMultipleUploadMainForm.modelClassName}&cateId=${kmsMultipleUploadMainForm.fdCategoryId}&categoryIndicateName=${kmsMultipleUploadMainForm.categoryIndicateName}&isBatchOperate=true&batchAttIds='+attIds+'&delFormIds='+delFormIds;
    	window.open("<c:url value='"+url+"'/>");
    }

	function addDoc() {	
		var unUploadAttCount = attachmentObject_attachment.swfupload.getStats().files_queued;//剩余附件上传数
		if(unUploadAttCount==0){
			if(checkAttSize()){
				getFileArrays();	
				docSubmitBefore();
				submitFormByAjax();
			}
		}else{//附件还在上传中
			seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
		    	dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.onloadWaiting')}");
			});
		}
	}

	function submitFormByAjax()
	{
    	seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
            		var loading = dialog.loading("${lfn:message('kms-knowledge:kmsKnowledge.uploadWaiting')}");
            		$.ajax({
    					type : "POST",
    					url :  "<c:url value='/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadMain.do?method=saveDoc'/>",
    					data : $('form[name=kmsMultipleUploadMainForm]').serialize(),
    					dataType : 'json',
    					success : function(result) {
    						 loading.hide();	
        				     if(result.uploadStatus!='success')
        				     {
        				    	 dialog.alert(result.errorMessage);
        				     }
        				    parent.location.reload();
    					}				
    				});
        	     });		
	}
	//检查待上传附件数量
	function checkAttSize(){
		var fileNameArray = document.getElementsByName("inputFileName");  
		if(fileNameArray.length<1)
		{
			seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
    	    	dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.chooseAttachments')}");
    	    });
       		return false;
		}
		if(fileNameArray.length>10)
		{
			seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
		    	dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.uploadAtt.description')}");
			});
			return false;
		}
		return true;
	}
	
	function getFileArrays(){
		//提交的时候还要获取附件的动态ID
		var fileIdObjs = document.getElementsByName("attIdAndAttNameJson");
		var attPartJsonArray=document.getElementsByName("attIdNameJson");
		var jsonArray='[';
		for (var j = 0; j < attPartJsonArray.length; j++) {
		       var temp=attPartJsonArray[j].value.split(";");
		       jsonArray+="{attId:'"+temp[0]+"',attName:'"+temp[1] +"'}";
			 if (j!= attPartJsonArray.length - 1) {
				 jsonArray += ',';
			}
		}
		jsonArray+=']';
		fileIdObjs[0].value = jsonArray;	
	}

	function getAttFileInfo(rtnFunc,_dialog){
		var unUploadAttCount = attachmentObject_attachment.swfupload.getStats().files_queued;//剩余附件上传数
		if(unUploadAttCount==0){
			if(checkAttSize()){
				getFileArrays();
				docSubmitBefore();
				var inputVals = $('form[name=kmsMultipleUploadMainForm]'); 
				rtnFunc(inputVals,_dialog);
			}
		}else{//附件还在上传中
			seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
		    	dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.onloadWaiting')}");
			});
		}
	}

	
    function setBathOperateValue()
    {
        //获取所有属于批量操作的附件id和对应的属性form的fd_Id的关系
    	var fileIdObjs = document.getElementsByName("bachOperate");
        var jsonArray='[';
		for (var j = 0; j < fileIdObjs.length; j++) {
		  if(fileIdObjs[j].value.length>0)
		  {
		       var temp=fileIdObjs[j].value.split(";");
		       jsonArray+="{attId:'"+temp[0]+"',formId:'"+temp[1] +"'}";
			   if (j!= fileIdObjs.length - 1) {
				 jsonArray += ',';
			   }
		   }
		}
		jsonArray+=']';
		//除去[]是否有实际的值存在，不存在则不需要赋值
		if(jsonArray.length>20)
		{
			document.getElementsByName("batchIdJson")[0].value=jsonArray;  
		}
    }

	
	//跳转到文档编辑页面
	function redirectEditPage(obj)
	{
		var fdId="";
		var isBatchColumn='false';
		var attIdAndName=obj.id.split(";");
		//如果被编辑过说明缓存中已经存在数据，需要将数据取出，然后呈现
		var formIdObj=document.getElementById(attIdAndName[0]+'_doc');
		//批量修改过的formId
		var batchFormIdObj=document.getElementById(attIdAndName[0]+'_batch');
		//如果该列属于批量操作列,用批量操作的form代替自身的文档form信息
        if(batchFormIdObj.value.length>3)
        {
        	fdId=batchFormIdObj.value.split(";")[1];
        	isBatchColumn='true';
        }
        else{
        	fdId=formIdObj.value;
        }
		var attEncodeName=encodeURIComponent(encodeURIComponent(attIdAndName[1]));
		var url='${LUI_ContextPath}/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadEditDoc.do?method=edit&fdModelName=${kmsMultipleUploadMainForm.modelClassName}&cateId=${kmsMultipleUploadMainForm.fdCategoryId}&categoryIndicateName=${kmsMultipleUploadMainForm.categoryIndicateName}&attId='+attIdAndName[0]+'&isBatchColumn='+isBatchColumn+'&fdId='+fdId+'&attName='+attEncodeName;
		window.open("<c:url value='"+url+"'/>");
	}
	//提交前刷新附件ID信息
	function docSubmitBefore()
	{
		updateIds();
		updateAttInfo(window.attachmentObject_${kmsMultipleUploadMainForm.fdKey});
		setBathOperateValue();
	}
	
    //更新添加删除的主键ids,如果被删除，则不生成文档
    function updateIds()
    { 
    	initArray();
        //实际单个编辑的列
    	var mainDocIdObj = document.getElementsByName("mainDocId");
    	var mainDocIdsArray=buildArray(mainDocIdObj);
    	//所有单个编辑并保存到缓存的formId
    	var fdDocAddIdsValue=document.getElementsByName("fdDocAddIds")[0].value;
    	var fdDocAddIdsArray=fdDocAddIdsValue.split(";");
    	var docId="";
    	var delIds="";
    	for(var i=0;i<fdDocAddIdsArray.length;i++)
    	{
          if(mainDocIdsArray.indexOf(fdDocAddIdsArray[i])<0)
          {
        	  delIds+=fdDocAddIdsArray[i];
          }
          if(i<fdDocAddIdsArray.length-1)
          {
        	  delIds+=";";  
          }
      	}
         var reallyAddIds='';
    	 for(var j=0;j<mainDocIdsArray.length;j++)
         { 
     		 reallyAddIds+=mainDocIdsArray[j]+";";    
         }
    	document.getElementsByName("fdDocAddIds")[0].value=reallyAddIds;
        document.getElementsByName("fdDelIds")[0].value=delIds;
      }

    function buildArray(htmlCollectObj)
    {
          var array=[];
    	  for(var i=0;i<htmlCollectObj.length;i++)
          { 
            	docId=htmlCollectObj[i].value;
            	if(docId!='')
            	  array.push(docId);         	
          }
          return array;
    }

    //覆盖上传更新附件的ID的方法
    function updateAttInfo(self) {
		var attIds = document.getElementsByName("attachmentForms." + self.fdKey + ".attachmentIds");
		var attIdsJson = document.getElementsByName("fdAttIdsJson");
		if (attIds && attIds.length > 0) {
			var tempIds = "";
			var tempDelIds = "";
			var tempAttIds="[";
			for ( var i = 0; i < self.fileList.length; i++) {
				var doc = self.fileList[i];
				if (doc.fileStatus == -1) {
					if(doc.fdId.indexOf("SWFUpload") >=0){
					}else{
						tempDelIds += ";" + doc.fdId;
					}
				} else if(doc.fileStatus == 1) {
					if((self.fdAttType!="pic" || self.uploadAfterSelect==false )){
						var tempDocId=doc.fdId;
						doc.fdId = self.createAttMainInfo(doc);
						tempAttIds+="{attId:'"+tempDocId+"',docAttId:'"+doc.fdId +"'}";
						if(i<self.fileList.length-1){
							tempAttIds+=',';
						}
						else if(i==self.fileList.length-1)
						{
							tempAttIds+="]";
						}
					}
					tempIds += ";" + doc.fdId;
					if(doc.fdId=='' || doc.fdId==null){
						alert(doc.fileName + Attachment_MessageInfo["msg.uploadFail"]);
						return false;
					}
				}
			}
			if (tempIds.length > 0) {
				if(self.onFinishPostCustom){
					self.onFinishPostCustom(self.fileList);
				} 
				tempIds = tempIds.substring(1, tempIds.length);
			}
			if (tempDelIds.length > 0) {
				tempDelIds = tempDelIds.substring(1, tempDelIds.length);
			}
			if(attIdsJson!=null&&attIdsJson[0]!=undefined)
			{
				attIdsJson[0].value=tempAttIds;
			}
         	attIds[0].value = tempIds;
			document.getElementsByName("attachmentForms." + self.fdKey + ".deletedAttachmentIds")[0].value = tempDelIds;
			return true;
		}
	}

	window.onload=function()
	{
		var obj=window.attachmentObject_${kmsMultipleUploadMainForm.fdKey}; 
		//替换编辑界面
	    obj.renderurl= Com_Parameter.ContextPath + "kms/knowledge/kms_knowledge_multiple_upload/kms_multiple_upload_edit_display.js"; 
	    
	}
    setTimeout(function(){$(".uploadinfotext").html($(".uploadinfotext").html()+"<span style='font-size:12px'>(${lfn:message('kms-knowledge:kmsKnowledge.uploadAtt.description')})</span>");},600);

	function initArray(){
		if (!Array.prototype.indexOf)
		{
		  Array.prototype.indexOf = function(elt /*, from*/)
		  {
		    var len = this.length >>> 0;
		    var from = Number(arguments[1]) || 0;
		    from = (from < 0)
		         ? Math.ceil(from)
		         : Math.floor(from);
		    if (from < 0)
		      from += len;
		    for (; from < len; from++)
		    {
		      if (from in this &&
		          this[from] === elt)
		        return from;
		    }
		    return -1;
		  };
		}
	};
</script>
