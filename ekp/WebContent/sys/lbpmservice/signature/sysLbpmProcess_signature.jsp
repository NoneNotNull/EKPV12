<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<kmss:ifModuleExist path="/km/signature/">
<tr id="showSignature">
	<td class="td_normal_title" width="15%">
		<c:out value="电子签名展示" />
	</td>
	<td id="signaturePic" colspan="3" width="85%">
		<ul id="signaturePicUL" class="clearfloat lui_sns_signatureList">
		</ul>
	</td>
</tr>
</kmss:ifModuleExist>
<style>
ul, li { list-style: none; }
.btn_canncel_img{
	display:inline-block;
	width:20px;
	height:20px;
    background:url(${KMSS_Parameter_ContextPath}sys/lbpmservice/signature/images/closeDiv.png) no-repeat 50%;
    background-size: 20px; 
    display:block;
    cursor:pointer;
}

.clearfloat { zoom: 1; }
.clearfloat:after { display: block; clear: both; visibility: hidden; line-height: 0px; content: 'clear'; }

.lui_sns_signatureList{ }
.lui_sns_signatureList li{ float:left; padding-top:3px; margin-right:15px; margin-bottom:8px; position:relative;}
.lui_sns_signatureList li img{ width:100px; height:75px;}
.lui_sns_signatureList .btn_canncel_img{ position:absolute; right:-8px; top:-5px;}
</style>
<script>
$(document).ready(function () {
	var func = "/km/signature/km_signature_main/kmSignatureMain_showSig.jsp";
	var html = '<kmss:ifModuleExist path="/km/signature/">';
	html += '&nbsp;&nbsp;';
	html += '<a href="javascript:;" class="com_btn_link" id="signature" onclick="signature();">';
	html += '<c:out value="电子签名" />';
	html += '</a>';
	html += '</kmss:ifModuleExist>';
	$("#optionButtons").append(html);
});

	var fileIds = [];
	
	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
		//新建
		window.signature = function() {
			var url = "/km/signature/km_signature_main/kmSignatureMain_showSig.jsp";
			dialog.iframe(url,"电子签名",function(rtn){
				if(rtn!=null){
					var file = {
						fdAttId:rtn.attId
		            };
		            var flag = true;
					if(fileIds.length>0){
			            for(var i = 0;i < fileIds.length;i++){
							if(fileIds[i].fdAttId == rtn.attId){
								flag = false;
							}
			            }
					}
		            if(flag){
						fileIds.push(file);
						var imageUl = $("#signaturePicUL");
						var html = '<li id="'+rtn.attId+'"><img width="100" height="75" src="${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId='+rtn.attId+'"/>';
						html += '<span id="'+rtn.attId+'" class="btn_canncel_img" onclick="deletex(this);"></span></li>';
						if(imageUl.length > 0){
							if(imageUl[0].innerHTML==""){
								imageUl.html(html);
							}else{
								imageUl.append(html);
							}
						}else{
							var rowhtml = '<kmss:ifModuleExist path="/km/signature/">';
							rowhtml += '<tr id="showSignature"><td class="td_normal_title" width="15%">签章图片</td>';
							rowhtml += '<td colspan="3" width="85%" id="signaturePic"><ul id="signaturePicUL" class="clearfloat lui_sns_signatureList">'+html+'</ul></td></tr>';
							rowhtml += '</kmss:ifModuleExist>';
							$("#descriptionRow").after(rowhtml);
						}
		            }else{
						alert("签章重复，请重新上传！");
		            }
				}
			},{width:800,height:270});
		};
	});

	//删除附件
	function deletex(obj){
		debugger;
		var tmpfileIds = [];
        for(var i= 0;i<fileIds.length;i++){
	        if(fileIds[i].fdAttId != obj.id){
	        	tmpfileIds.push(fileIds[i]);
		    }
        }
        fileIds = tmpfileIds;
        if(confirm("是否确认删除签章图片？")){
	        $("li[id='"+obj.id+"']").remove();
		}
	}

	//监听流程提交事件，绑定签章信息
	Com_Parameter.event["submit"].push(function(){     //流程提交生成附件信息
		var flag = false;
		if(fileIds.length>0){
			var fdAttIds = "";
			for(var i= 0;i<fileIds.length;i++){
				if(i != fileIds.length-1){
					fdAttIds += fileIds[i].fdAttId + ";";
				}else{
					fdAttIds += fileIds[i].fdAttId;
				}
			}
			var fdKey = "${param.auditNoteFdId}" + "_qz";
			var fdModelId = "${param.modelId}";
			var fdModelName = "${param.modelName}";
			var checkUrl = "${KMSS_Parameter_ContextPath}km/signature/km_signature_main/kmSignatureMain.do?method=submitSignature";
			$.ajax({
			     type:"post",
			     url:checkUrl,
			     data:{"fdAttIds":fdAttIds,"fdKey":fdKey,"fdModelId":fdModelId,"fdModelName":fdModelName},
			     async:false,
			     success:function(data){
			    	 flag = data.flag;
				}
		    });
		}else{
			flag = true;
		}
		return flag;
	});
	</script>
