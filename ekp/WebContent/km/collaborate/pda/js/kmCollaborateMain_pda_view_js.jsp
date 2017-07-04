<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						var showWard = '${showForward}';
						if (showWard == "true") {
							$("#readd").removeClass();
							$("#readd")
									.addClass(
											"ui-btn ui-shadow ui-btn-corner-all ui-btn-inline ui-btn-up-b");
						}
						// 回帖仅作者可见
						var fdIsOnlyView = "${kmCollaborateMainForm.fdIsOnlyView}";
						if (fdIsOnlyView == "true") {
							$("#replyAll").hide();
						}

						//初识回复框隐藏
						$("#replyText").hide();
						$("#replyTextAll").hide();

						//关注与取消关注标识
						var isfollow = "${isfollow}";
						if (isfollow == '1') {
							$("#attention").hide();
						} else if (isfollow == '0') {
							$("#cancleAttention").hide();
						}

						//通知方式去除JQurey Mobile自带样式
						$("input[type='checkbox']").attr("data-role", "none");

					});
	//打开回复框
	function openReplayText(index) {
		$("#repMsg").hide();
		$("#notifyType").hide();
		//隐藏回复所有人框
		$('#replyTextAll').hide();
		$("#hidAll").val(0);
		var value = $("#hid").val();
		if (value == 0) {
			$("#replyText").show();
			$("#hid").val(1);
		} else {
			$("#replyText").hide();
			$("#hid").val(0);
		}
		if (index == 1) {
			var top = $("#replyText").offset().top;
			window.scroll(0, top);
		}
	}
	//打开回复所有人框
	function openReplayTextAll(index) {
		$("#repMsgAll").hide();
		$("#replyAllNotifyType").hide();
		//隐藏回复个人框
		$("#replyText").hide();
		$("#hid").val(0);
		var value = $("#hidAll").val();
		if (value == 0) {
			$("#replyTextAll").show();
			$("#hidAll").val(1);
		} else {
			$("#replyTextAll").hide();
			$("#hidAll").val(0);
		}
		if (index == 1) {
			var top = $("#replyTextAll").offset.Top;
			window.scroll(0, top);
		}
	}
	//回复内容提交
	function submitF(i,fdParentId){
		var fdPdaType = device.getClientType();
		
		var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=";
		var fdMainId='${kmCollaborateMainForm.fdId}';
		url=url+'saveReply&fdIsOnlyView=${kmCollaborateMainForm.fdIsOnlyView}&docCreatorId=${kmCollaborateMainForm.docCreatorId}';//method
		//创建动态表单，使用post提交回复内容
		var submitForm = document.createElement("FORM");
		var contentInput = document.createElement("textarea");
		contentInput.name = "fdContentMain";
		submitForm.name = "kmCollaborateMainReplyForm";
		submitForm.appendChild(contentInput);
		submitForm.method = "POST";
		window.frames[0].document.body.appendChild(submitForm);
		
		$("#repMsg").hide();
		$("#repMsgAll").hide();
		$("#replyAllNotifyType").hide();
		$("#notifyType").hide();
		var html="";
		submitForm.style.display = "none";
		//回复;
		if(i==1){
			var txtObj = document.getElementById("fdContentMain");
		    html=changeBr(txtObj);
			var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
			txtObj=$.trim(txtObj.value);
			if( null != txtObj && txtObj == ''){
				$("#repMsg").show();
				return false;		
			}
			if(null == fdNotifyType || fdNotifyType==""){
				$("#notifyType").show();
				$("#notifyType input[type='checkbox']").focus();
				return false;
			}else{
				$("#notifyType").hide();
			}
			url=url+"&pda=true&fdMainId="+fdMainId+'&fdType=1';//param
			url=url+"&fdCommunicationMainId="+fdMainId+"&fdNotifyType="+fdNotifyType+"&fdPdaType="+fdPdaType;
			contentInput.value = html;
			submitForm.action = url;
		}
		//回复所有人;
		if(i==2){
			var txtObj = document.getElementById("fdContentMainAll");
	        html=changeBr(txtObj);
			var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
			txtObj=$.trim(txtObj.value);
			if( null != txtObj && txtObj == ''){
				$("#repMsgAll").show();
				return false;
			}
			if(null == fdNotifyType || fdNotifyType==""){
				$("#replyAllNotifyType").show();
				$("#notifyType input[type='checkbox']").focus();
				return false;
			}else{
				$("#replyAllNotifyType").hide();
			}
			url=url+"&pda=true&fdMainId="+fdMainId+"&fdType=2";//param
			url=url+"&fdCommunicationMainId="+fdMainId+"&fdNotifyType="+fdNotifyType+"&fdPdaType="+fdPdaType;
			contentInput.value = html;
			submitForm.action = url;
		}
		submitForm.submit();
		if(i==1){
			openReplayText();	
		}else{
			openReplayTextAll();				
		}
		window.replyOfReply="replyOfReply";
		
		//重置提交表单
		var defaultNotity = "${kmCollaborateConfig.defaultNotifyType}";
		$("input[type='checkbox']").each(function(){
			if(defaultNotity.indexOf($(this).attr("value")) != -1){
				$(this).prop({checked:true});
			}else
			{
				$(this).prop({checked:false});
			}
		});
		document.getElementsByName("fdNotifyType")[0].value = defaultNotity;
		
		$("#fdContentMain").val($("#defaultReply").val());
		$("#fdContentMainAll").val($("#defaultReply").val());
		
	 };
	//用来保存手机端显示testarea用户输入带有的换行格式
	function changeBr(txtObj) {
		var textArray = txtObj.value.split("\n"); //对文本进行分行处理
		var html = "";
		for ( var i = 0; i < textArray.length; i++) {
			html += "<p>" + textArray[i] + "</p>";//加上html换行符
		}
		return html;
	}
	//转发
	function reAdd() {
		var url = '<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add"/>' + '&showForward=true' + '&pda=true' + '&showid=${kmCollaborateMainForm.fdId}';
		window.open(url, "_self");
	}
	//结束
	function endIng() {
		var url = '<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude"/>' + '&fdId=${kmCollaborateMainForm.fdId}';
		$
				.ajax( {
					type : "GET",
					url : url,
					success : function(msg) {
						$('#loadMsg')
								.html(
										"<font color='red'><bean:message bundle='km-collaborate' key='kmCollaborateMain.pda.endingsuccess'/>!</font>")
								.show(300).delay(2000).fadeOut('slow');
						$('#ending')
								.attr("class",
										"ui-disabled ui-btn ui-btn-up-b ui-shadow ui-btn-corner-all ui-btn-inline");
						$('#reply')
								.attr("class",
										"ui-disabled ui-btn ui-btn-up-b ui-shadow ui-btn-corner-all ui-btn-inline");
						location.reload(true);
					}
				});
	};

	//attention
	function follow(flag) {
		var url = '<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=isRead"/>' + '&docid=${kmCollaborateMainForm.fdId}' + '&flag=' + flag;
		$
				.ajax( {
					type : "GET",
					url : url,
					success : function(msg) {
						if ('cancleAttention' == flag) {
							$("#cancleAttention").hide();
							$("#attention").show();
							$('#loadMsg')
									.html(
											"<font color='red'><bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.success'/>!</font>")
									.show(300).delay(2000).fadeOut('slow');
						} else {
							$("#attention").hide();
							$("#cancleAttention").show();
							$('#loadMsg')
									.html(
											"<font color='red'><bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.success'/>!</font>")
									.show(300).delay(2000).fadeOut('slow');
						}
					}
				});
	}

	//查看信息伸缩事件
	function expandDiv(id) {
		var divObj = document.getElementById("label_" + id);
		var statusObj = document.getElementById("status_" + id);
		if (divObj != null) {
			var isExpand = divObj.getAttribute("isExpand");
			if (isExpand == null || isExpand == '1') {
				divObj.setAttribute("isExpand", "0");
				divObj.style.display = "none";
				statusObj.className = "ui-icon ui-icon-shadow ui-icon-plus";
			} else {
				divObj.setAttribute("isExpand", "1");
				divObj.style.display = "";
				statusObj.className = "ui-icon ui-icon-shadow ui-icon-minus";
			}
		}
	}
</script>