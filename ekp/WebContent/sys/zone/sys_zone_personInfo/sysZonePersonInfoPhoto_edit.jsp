<%@ page language="java" pageEncoding="UTF-8" import="com.landray.kmss.sys.zone.forms.SysZonePersonInfoForm"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super/> - ${lfn:message('sys-zone:sysZonePersonInfo') }
	</template:replace>
<template:replace name="content"> 
<html:form action="/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do" styleId="sysZonePersonInfoForm">
  <ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
	 <ui:content title="${lfn:message('sys-zone:sysZonePersonImg.upload')}">
 		<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
          <c:param name="fdKey" value="personPic"/>
          <c:param name="fdAttType" value="pic"/>
          <c:param name="fdMulti" value="false" />
          <c:param name="enabledFileType" value="*.gif;*.jpg;*.jpeg;*.png" />	
        </c:import> 
        <p style="color: red;">
        	&nbsp;${lfn:message('sys-zone:sysZonePersonImg.format')}
        </p>
        <br>
		<div>
        	<div style="padding-bottom: 5px;min-width:240px;display:inline-block;" >
        		<img id="crop_person_img" src="${LUI_ContextPath}/sys/zone/resource/images/upload_photo_240_240.jpg" width="240" height="240">
        	</div>
        	<div style="display:inline-block;width:100px;vertical-align:top;margin-left:30px;margin-top:40px;">
	        	<div style="width: 120px;height: 120px;overflow: hidden;">
	        		<c:choose>
	        			<c:when test="${not empty bigMain }">
	        				<img id="big_person_img" width="120" height="120" src="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=${bigMain.fdId}">
	        			</c:when>
	        			<c:otherwise>
	        				<img id="big_person_img" width="120" height="120" src="${LUI_ContextPath}/sys/zone/resource/images/upload_photo_120_120.jpg">
	        			</c:otherwise>
	        		</c:choose>
	        	</div>
	        	<p>${lfn:message('sys-zone:sysZonePersonImg.bigImg')}</p>
	        </div>
	        <div style="display:inline-block;width:60px;vertical-align:top;margin-left:50px;margin-top:40px;">
	        	<div style="width: 60px;height: 60px;overflow: hidden;">
	        		<c:choose>
	        			<c:when test="${not empty middleMain }">
	        				<img id="middle_person_img" width="60" height="60" src="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=${middleMain.fdId}" >
	        			</c:when>
	        			<c:otherwise>
	        				<img id="middle_person_img" width="60" height="60" src="${LUI_ContextPath}/sys/zone/resource/images/upload_photo_60_60.jpg" >
	        			</c:otherwise>
	        		</c:choose>
	        	</div>
	        	<p>${lfn:message('sys-zone:sysZonePersonImg.midImg')}</p>
	        	<div style="width: 30px;height: 30px;overflow: hidden;margin-top:10px;">
	        		<c:choose>
	        			<c:when test="${not empty smallMain}">
	        				<img id="small_person_img" width="30" height="30" src="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=${smallMain.fdId}">
	        			</c:when>
	        			<c:otherwise>
	        				<img id="small_person_img" width="30" height="30" src="${LUI_ContextPath}/sys/zone/resource/images/upload_photo_30_30.jpg">
	        			</c:otherwise>
	        		</c:choose>
	        	</div>
	        	<p>${lfn:message('sys-zone:sysZonePersonImg.smallImg')}</p>
        	</div>
        	<div>
        		<script>
        			seajs.use(['theme!zone']);
        		</script>
        		<a  href="javascript:;" style="margin-right:10px;display:none;" 
        			class="lui_zone_cut_btn com_bgcolor_n com_bordercolor_d com_fontcolor_n"  onclick="sureCropImg();"
        			title="${lfn:message('button.save')}">${lfn:message('button.save')}</a>
        		<a  href="javascript:;" style="display:none;" class="lui_zone_cut_btn com_bgcolor_n com_bordercolor_d com_fontcolor_n lui_zone_cut_cancel"  
        			onclick="cancelCropImg();"
        			title="${lfn:message('button.cancel')}">${lfn:message('button.cancel')}</a>
        	</div>
        	<div class="validation-advice" id="person_pic_error"
				_reminder="true" style="display: none;">
				<table class="validation-table">
					<tbody>
						<tr>
							<td><div class="lui_icon_s lui_icon_s_icon_validator"></div></td>
							<td class="validation-advice-msg"><span
								class="validation-advice-title">头像</span> 不能为空且必须裁剪</td>
						</tr>
					</tbody>
				</table>
			</div>
        </div>
        <input type="hidden" name="bigPicFdId" id="bigPicFdId" value="${bigMain.fdId }">
        <input type="hidden" name="middlePicFdId" id="middlePicFdId" value="${middleMain.fdId }">
        <input type="hidden" name="smallPicFdId" id="smallPicFdId" value="${smallMain.fdId }">
	</ui:content>
 </ui:panel>
</html:form> 
<div style="display: none;">
	<label>起点x坐标 <input type="text" size="4" id="startX" name="startX" /></label>
    <label>起点y坐标 <input type="text" size="4" id="startY" name="startY" /></label>
    <label>终点x坐标 <input type="text" size="4" id="finishX" name="finishX" /></label>
    <label>终点y坐标 <input type="text" size="4" id="finishY" name="finishY" /></label>
    <label>选择的宽 <input type="text" size="4" id="cropWidth" name="cropWidth" /></label>
    <label>选择的高 <input type="text" size="4" id="cropHeight" name="cropHeight" /></label>
</div>
<link rel="stylesheet" href="${ LUI_ContextPath }/sys/zone/resource/Jcrop/css/jquery.Jcrop.min.css" type="text/css" />
<script src="${ LUI_ContextPath }/sys/zone/resource/Jcrop/js/jquery.Jcrop.js"></script>
<script>
var jcrop_api = null;
var attId = null;
var jcropZone_filePath = null;
//var photoClick = 0;
attachmentObject_personPic.on("uploadSuccess", function() {
	seajs.use( [ 'sys/ui/js/dialog'], function(dialog) {
		jcropZone_filePath = null; // 置为空
		$(".lui_zone_cut_btn").hide();
		var fileList =  attachmentObject_personPic.fileList;
		attId = fileList[fileList.length - 1].fdId;
		fileList.length = 0;
		if($(".jcrop-holder").size() > 0) {
			$(".jcrop-holder").remove();
			jcrop_api.destroy();
		}
		//去除附件机制生成的img
		$("#att_xdiv_personPic").empty();
		var load = dialog.loading("${lfn:message('sys-zone:sysZonePersonImg.uploading')}");
			//压缩图片
			$.ajax({
				 type:"post",
				 url:"${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=zoomImg",
				 data:"attId=" + attId + "&ruleWidth=240&ruleHeight=240",
				 dataType:"json",
				 success:function(data) {
					 jcropZone_filePath = data['zoomPath'];
					 load.hide();
					 $(".lui_zone_cut_btn").show();
					//回显图片
					 $("#crop_person_img, #big_person_img, #middle_person_img, #small_person_img")
					 .attr("src","${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=" + data['attId']);
					 $("#crop_person_img").css({
						 width:data['width'],
						 height:data['height']
					 });
					//显示裁剪框
					$("#crop_person_img").Jcrop({
						allowSelect: false,
						bgFade: true,
						bgOpacity: 0.5,
						aspectRatio:1,
						onChange:   showCoords
					},function(){
						 var bounds = this.getBounds();
					     boundx = bounds[0];
					     boundy = bounds[1];
						 jcrop_api = this;
						 jcrop_api.animateTo([0, 0, 120, 120]);
				    });
					
				 },
				 error:function() {
					 load.hide();
				 }
			});
	});
 });

 /**
  * 显示裁剪框
  */
 function showCoords(c){
     $('#startX').val(c.x);
     $('#startY').val(c.y);
     $('#finishX').val(c.x2);
     $('#finishY').val(c.y2);
     $('#cropWidth').val(c.w);
     $('#cropHeight').val(c.h);
     //更新预览
     updatePreview(c);
 };
 /**
  * 更新预览
  */
 function updatePreview(c){
   if (parseInt(c.w) > 0){
     $("#big_person_img").css({
       width: Math.round( (120 / c.w) * boundx) + 'px',
       height: Math.round((120 / c.w) * boundy) + 'px',
       marginLeft: '-' + Math.round((120 / c.w) * c.x) + 'px',
       marginTop: '-' + Math.round((120 / c.w) * c.y) + 'px'
     });
     
     $("#middle_person_img").css({
	       width: Math.round((60 / c.w) * boundx) + 'px',
	       height: Math.round((60 / c.w) * boundy) + 'px',
	       marginLeft: '-' + Math.round((60 / c.w) * c.x) + 'px',
	       marginTop: '-' + Math.round((60 / c.w) * c.y) + 'px'
	     });
     
     $("#small_person_img").css({
	       width: Math.round((30 / c.w) * boundx) + 'px',
	       height: Math.round((30 / c.w) * boundy) + 'px',
	       marginLeft: '-' + Math.round((30 / c.w) * c.x) + 'px',
	       marginTop: '-' + Math.round((30 / c.w) * c.y) + 'px'
	     });
   }
 };
/**
 * 裁剪图片
 */
function sureCropImg() {
	seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
		var load = dialog.loading("${lfn:message('sys-zone:sysZonePersonImg.croping')}");
		$.ajax({
			type:"post",
			url:"${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=cropImg",
			data: "startX=" + $('#startX').val() + "&startY=" 
				+ $('#startY').val() +  "&width="
				+  $('#cropWidth').val() + "&height=" + $('#cropHeight').val() + "&attId=" + attId + "&zoomPath=" + jcropZone_filePath,
			dataType:"json",	
			success: function(data) {
				 $("#crop_person_img").attr("src", "${LUI_ContextPath}/sys/zone/resource/images/upload_photo_240_240.jpg").css("visibility", "visible").show();
				 $("#crop_person_img").css({
					 width:"240",
					 height:"240"
				 });
				 $("#big_person_img").attr("src", "${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=" + data['bigPicAttId'])
				 .attr("style", "");
				 $("#middle_person_img").attr("src", "${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=" + data['middlePicAttId'])
				 .attr("style", "");
				 $("#small_person_img").attr("src", "${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=" + data['smallPicAttId'])
				 .attr("style","");
				 $(".jcrop-holder").remove();
				 jcrop_api.destroy();
				 $("#smallPicFdId").val(data['smallPicAttId']);
				 $("#bigPicFdId").val(data['bigPicAttId']);
				 $("#middlePicFdId").val(data['middlePicAttId']);
				 $("#person_pic_error").hide();
				 $(".lui_zone_cut_btn").hide();
	
				 /*更新左边的头像*/
					imgUrl = '${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${KMSS_Parameter_CurrentUserId}&size=b';
					imgUrl = imgUrl + "&_temp=" + new Date().getTime();
					$('#sys_person_userpic')
						.css('backgroundImage', "url('"+imgUrl+"')");
				 load.hide();
			},
			error: function() {
				load.hide();
			}
		});
	});
}
//取消裁剪
function cancelCropImg() {
	$.ajax({
		type:"post",
		url:"${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=cancelImg",
		data: "attId=" + attId + "&zoomPath=" + jcropZone_filePath,
		dataType:"json",	
		success: function(data) {
			 var src = "${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${KMSS_Parameter_CurrentUserId}&size=";
			 $("#crop_person_img").attr("src", "${LUI_ContextPath}/sys/zone/resource/images/upload_photo_240_240.jpg").css("visibility", "visible").show();
			 $("#crop_person_img").css({
				 width:"240",
				 height:"240"
			 });
			 var tmp = "&_temp=" + new Date().getTime();
			 $("#big_person_img").attr("src", src + "b" + tmp).attr("style", "");
			 $("#middle_person_img").attr("src", src + "m" + tmp).attr("style", "");
			 $("#small_person_img").attr("src", src + "s" + tmp).attr("style","");
			 $(".jcrop-holder").remove();
			 jcrop_api.destroy();
			 $("#person_pic_error").hide();
			 $(".lui_zone_cut_btn").hide();
		},
		error: function() {
			
		}
	});
}
/**
 * 清除裁剪框
 */
function clearCoords(){
    $('#coords input').val('');
 };
</script>
</template:replace>
</template:include>