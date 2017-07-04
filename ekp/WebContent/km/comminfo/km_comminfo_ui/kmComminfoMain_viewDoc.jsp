<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.view" width="630px" sidebar="no">
    <template:replace name="head">
	    <link href="${LUI_ContextPath}/km/comminfo/resource/css/com_datum.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript">
		  //自适应高度
	    	window.dyniFrameSize = function() {
	    		try {
	    			// 调整高度
	    			var contentId = "exp_preview";
	    			var arguObj = document.getElementById(contentId);
	    			if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
		    			    window.frameElement.style.height = (arguObj.offsetHeight) +88+ "px";
		    				window.parent.document.getElementById("com_datum_contentC").style.height = (arguObj.offsetHeight) +88+ "px";
		    				window.parent.document.getElementById("com_datum_contentLeft").style.height = (arguObj.offsetHeight) +88+ "px";
	    			}
	    		} catch(e) {
	    		}
	    	 };
			seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
		    	LUI.ready( function() {
			    	//取得滑动方向
		    		var direc = "${param.direc}";
		    		showContent(direc);
		    		//获取父类的变量total,currIndex值
		    		var currIndex = window.parent.document.getElementById("currIndex").value;
		    		var total = window.parent.document.getElementById("total").value;
		    		var currDocId = "${param.fdId}";
		    		//动态修改父页面的title
		    		parent.document.title = "${kmComminfoMainForm.docSubject}" + " - ${lfn:message('km-comminfo:module.km.comminfo')}";

		    		//优化富文本框链接
			        $("#_____rtf_____content").find("a").each(function () {
					    $(this).attr("target","_blank");   
				    });

		    		CKResize.____ckresize____(true);
		    		dyniFrameSize();
		    		window.parent.setHeight();
		    		if(currIndex != ""){
		    			window.parent.changeCurrArea(currDocId);
		    		}
			     });
		    	 //滑动控制显示
		    	 window.showContent = function(direc){
						if (direc == "left") {
						    $("#exp_preview").css({ "display": "block", "right": "auto", "left": "-628px" ,"top":"48px"}).animate({ "left": "0px" }, 500);
								} 
					    if (direc == "right") {
					        $("#exp_preview").css({ "display": "block", "right": "-668px", "left": "auto","top":"48px" }).animate({ "right": "50px" }, 500);
								}
						};
				 //删除
	    		window.deleteConfirm = function(){
			    	dialog.confirm("${lfn:message('km-comminfo:kmComminfoMain.deleteComminfo')}",function(value){
						if(value==true){
							Com_OpenWindow('${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=delete&categoryId=${categoryId}&fdId=${param.fdId}','_self');
  					    }
	  					    return false;
        	        });
			    };
			});
		</script>
	</template:replace>
	<template:replace name="content">
		<script>
			Com_IncludeFile('ckresize.js', 'ckeditor/');
		</script>
        <style>
        	.lui_form_body  {background-color:#fff!important;}
        </style>
        <div id="commContent" style="min-height:690px;width:716px; padding-top:1px;">
          <div class="com_datum_contentBtn">
		       <p>
					<!-- 编辑-->
					<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
						<a href="#" class="icon_edit" onclick="javascript:window.parent.open('kmComminfoMain.do?method=edit&fdId=${param.fdId}','_self');">
						<bean:message key="button.edit"/></a>
					</kmss:auth>
					<!-- 删除-->	
					<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=delete&categoryId=${categoryId}" requestMethod="GET">
						<a href="#" class="icon_del" onclick="if(!deleteConfirm())return;Com_OpenWindow('kmComminfoMain.do?method=delete&categoryId=${categoryId}&fdId=${param.fdId}','_self');">
						<bean:message key="button.delete"/></a>
					</kmss:auth>
				</p>
			</div>
            <div class="exp_preview" id="exp_preview" style="left:-3px; top:48px; display: ${param.direc!=null?'none':''}">
                <div>
                    <h2 id="docSubject">
                    	${kmComminfoMainForm.docSubject}
                    </h2>
                   	<div id="_____rtf_____content">
                        ${kmComminfoMainForm.docContent}
                   	</div>
                    <div id='_____rtf__temp_____content' style="width:100%"></div>
                    <script type="text/javascript">
	                 	var property = 'content';
						CKResize.addPropertyName(property);
			       	</script>
                 </div>
			    <!-- 附件-->
		           	<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formBeanName" value="kmComminfoMainForm" />
						    <c:param name="fdKey" value="attachment" />
						    <c:param name="fdAttType" value="byte" />
							<c:param name="fdModelId" value="${kmComminfoMainForm.fdId }" />
							<c:param name="fdModelName" value="com.landray.kmss.km.comminfo.model.KmComminfoMain" />
					</c:import>
				<!-- showAfterCustom是附件绘画完毕后执行方法-->
					<script type="text/javascript">
					   	  	attachmentObject_attachment_${kmComminfoMainForm.fdId}.showAfterCustom=function(){
					   	  	    dyniFrameSize();
					   	  		window.parent.setHeight();
						     };
					</script>
             </div>
        </div>            
	</template:replace>
</template:include>
