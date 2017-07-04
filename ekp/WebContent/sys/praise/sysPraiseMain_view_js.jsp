<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	var praOpened = "false";//人员列表框是否显示
	window.onload = function() {
		$("body").on("mouseenter","span[praise-data-modelid]", function (praiseObj) { 
				closeListBox(praiseObj);
				if(praOpened == "false"){
					praOpened = "true";
					var _praiseId = $(praiseObj.currentTarget).attr("praise-data-modelid");
					$("#aid_"+_praiseId+" #praisedPerson_list").css("height","0px");
					var hasPraiser = getPraisers(_praiseId,1,false,false);
					if(hasPraiser == true){
						$(praiseObj.currentTarget).parent().find("div[class='lui_praise_layer']").show();
					}
				}
		});

		$("body").on("mouseleave","span[praise-data-modelid]", function (obj) { 
			if(praOpened == "true"){
				praOpened = "false";
			}
			setTimeout(function() {
				if(praOpened == "false"){
					$(obj.currentTarget).parent().find("div[class='lui_praise_layer']").hide();
				}
	    	}, 1000);
		});

		//关闭人员列表框
		$("#praise_close").delegate('.lui_praise_close_s','click',function(evt){
			closeListBox(evt);
		});

		$(document).on("click",function(evt){
			closeListBox(evt);
		});
	}
	
	//点赞
	function sysPraise(praiseId){
		var praiseObj = $("#aid_"+praiseId);
		var fdModelId = praiseObj.attr("praise-data-modelid");
		var fdModelName = praiseObj.attr("praise-data-modelname");
		LUI.$.ajax({
			type : "POST",
			url :  "<c:url value='/sys/praise/sys_praise_main/sysPraiseMain.do?method=executePraise'/>",
			data: {fdModelId: fdModelId,
				   fdModelName: fdModelName},
			dataType : 'text',
			async: false,
			success : function(data) {
					var praiseCount = parseInt($("#aid_"+praiseId+' #praise_count')[0].innerHTML);
					var isPraised = $("#check_"+praiseId).val();
					if("true" == isPraised){
						$("#check_"+praiseId).val("false");
						$("#aid_"+praiseId+' #praise_count')[0].innerHTML = praiseCount - 1;

						$("#aid_"+praiseId+' #praise_icon').removeClass("sys_unpraise").addClass("sys_praise");
						$("span[data-lui-id='"+fdModelId+"']").attr("title","${ lfn:message('sys-praise:sysPraiseMain.praise')}");
					}else{
						$("#check_"+praiseId).val("true");
						$("#aid_"+praiseId+' #praise_count')[0].innerHTML = praiseCount + 1;

						$("#aid_"+praiseId+' #praise_icon').removeClass("sys_praise").addClass("sys_unpraise");
						$("span[data-lui-id='"+fdModelId+"']").attr("title","${ lfn:message('sys-praise:sysPraiseMain.cancel.praise')}");
					}
			},
			error: function() {
				
			}		
		});
	}

	//列出所有点赞人
	function listAllPraiser(praiseId){
		var personListBox = $("#aid_"+praiseId+" #praisedPerson_list");
		praOpened = "";//不为true也不为false
		personListBox.empty();
		personListBox.animate({height:"80px"},"normal",function(){
			$("#aid_"+praiseId+" #praise_page_list").show();
			$("#aid_"+praiseId+" #praise_close").show();
			getPraisers(praiseId,1,true,true);
		});
	}

	//根据当前事件，选择性关闭人员列表框
	function closeListBox(evt){
		if($(evt.target).length>0){
			var targetId = $(evt.target)[0].id;//“更多”按钮
			var closeBtn = $(evt.target)[0].className;//人员列表框关闭按钮
			var clickObj = $(evt.target).parents(".lui_praise_layer").length;
			//当点击的区域为人员列表框外，则隐藏列表框
			if((targetId!="show_more" && clickObj<=0) || closeBtn == "lui_praise_close_s"){
				praOpened = "false";
				$(".lui_praise_layer").hide();
				//$('.person_list').attr({style:"height:35px;"});
				$(".praise_page_list").hide();//翻页
				$(".lui_praise_close_d").hide();//关闭按钮
			}
		}
	}
	
	//翻页列出点赞人
	function getPraisers(praiseId,_pageno,_isShowAll,_isShowPage){
		var _praiseObj = $("#aid_"+praiseId);
		var fdModelId = _praiseObj.attr("praise-data-modelid");
		var fdModelName = _praiseObj.attr("praise-data-modelname");
		var _showPraiserCount = $("input[name='showPraiserCount']").val();
		
		var hasPraiser = true;
		if(_showPraiserCount==""){
			_showPraiserCount = '3';
		}
		LUI.$.ajax({
			type : "POST",
			url :  "<c:url value='/sys/praise/sys_praise_main/sysPraiseMain.do?method=getPraisedPersons'/>",
			data: {fdModelId: fdModelId,
				   fdModelName: fdModelName,
				   pageno:_pageno,
				   isShowAll:_isShowAll,
				   isShowPage:_isShowPage,
				   showPraiserCount:_showPraiserCount},
			dataType : 'json',
			async: false,
			success : function(data) {
					$("#praisedPerson_list").empty();
					//翻页
					if(_isShowPage){
						var nextPage = data['nextPage'];
						var prePage = data['prePage'];
						if(prePage){
							$("#aid_"+praiseId+" #btn_preno").parent().show();
							$("#aid_"+praiseId+" #btn_nextno").parent().show();
							if(nextPage){
								$("#aid_"+praiseId+" #btn_preno").attr("class","praise_icon_l");
								$("#aid_"+praiseId+" #btn_preno").attr("data-praise-mark","1");

								$("#aid_"+praiseId+" #btn_nextno").attr("class","praise_icon_r");
								$("#aid_"+praiseId+" #btn_nextno").attr("data-praise-mark","1");
							}else{
								$("#aid_"+praiseId+" #btn_preno").attr("class","praise_icon_l");
								$("#aid_"+praiseId+" #btn_preno").attr("data-praise-mark","1");

								$("#aid_"+praiseId+" #btn_nextno").attr("class","praise_icon_r_gray");
								$("#aid_"+praiseId+" #btn_nextno").attr("data-praise-mark","0");
							}
						}else{
							if(nextPage){
								$("#aid_"+praiseId+" #btn_preno").parent().show();
								$("#aid_"+praiseId+" #btn_nextno").parent().show();
								
								$("#aid_"+praiseId+" #btn_preno").attr("class","praise_icon_l_gray");
								$("#aid_"+praiseId+" #btn_preno").attr("data-praise-mark","0");

								$("#aid_"+praiseId+" #btn_nextno").attr("class","praise_icon_r");
								$("#aid_"+praiseId+" #btn_nextno").attr("data-praise-mark","1");
							}else{
								$("#aid_"+praiseId+" #praise_page_list").hide();
							}
						}
						
					}
					
					var personList = data['personsList'];
					$("#aid_"+praiseId+" #praisedPerson_list").empty();
					for(var i=0;i<personList.length;i++){
						$("#aid_"+praiseId+" #praisedPerson_list").append("<li><a href='"+Com_Parameter.ContextPath+
								"sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId="+personList[i].personId+
								"' target='_blank'><img title='"+personList[i].personName+
								"' width='30' height='30' src='"+Com_Parameter.ContextPath+
								"sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId="
								+personList[i].personId+"'></a></li>");
					}
					//更多
					if(data['hasMore'])
						$("#aid_"+praiseId+" #praisedPerson_list").append("<li><a><div id='show_more' class='praise_more' onclick='listAllPraiser(\""+praiseId+"\")'>"+
												"</div></a></li>");
					//没人点赞过
					if(personList.length <= 0){
						hasPraiser = false;
					}
			},
			error: function() {
				
			}		
		});
		return hasPraiser;
	}
	//翻页
	var pageno = 1;
	//上一页
	function prePage(objId){
		var data_mark = $("#aid_"+objId+" #btn_preno").attr("data-praise-mark");
		if(data_mark == 1){
			getPraisers(objId,--pageno,true,true);
		}
	}
	//下一页
	function nextPage(objId){
		var data_mark = $("#aid_"+objId+" #btn_nextno").attr("data-praise-mark");
		if(data_mark == 1){
			getPraisers(objId,++pageno,true,true);
		}
	}

	function updatePraiseStatus(praiseModelIds,fdModelName){
		//对已赞过的换用“已赞”图标
		var fdModelIds = praiseModelIds.join(",");
		LUI.$.ajax({
			type : "POST",
			url :  Com_Parameter.ContextPath + "sys/praise/sys_praise_main/sysPraiseMain.do?method=checkPraisedByIds",
			data: {fdModelIds: fdModelIds,
				   fdModelName: fdModelName},
			dataType : 'json',
			async: false,
			success : function(data) {
					for(var i=0;i<data["praiseIds"].length;i++){
						var praisedId = data["praiseIds"][i];
						$("#check_"+praisedId).val("true");
						$("span[data-lui-id='"+praisedId+"'] #praise_icon").attr("class","sys_unpraise");
						$("span[data-lui-id='"+praisedId+"']").attr("title","${lfn:message('sys-evaluation:sysEvaluation.cancel.praise')}");
					}
			},
			error: function() {
				
			}	
		});
	}
</script>