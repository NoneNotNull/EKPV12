<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/introduce/style/intr.css" />
<template:include file="/kms/common/pda/template/core.jsp">
	<template:replace name="title">
		<li class="lui-docSubject">
			<h2 class="textEllipsis">推荐</h2>
		</li>
	</template:replace>
	<template:replace name="content">
		<section data-lui-role="rowTable" id="introduce_list" class="lui-content lui-intr-no-bottom">
			<script type="text/config">
				{
					source : {
						url : '${LUI_ContextPath}/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=viewAll&forward=listUi&rowsize=10&fdModelId=${param.intr_modelId}&fdModelName=${param.intr_modelName}',
						type : 'ajaxJson'
					},
					render : {
						templateId : '#introduce_tmpl'
					},
					scroll : false
				}
			</script>
		</section>	
		<kmss:auth requestURL="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add&fdModelName=${param.intr_modelName}&fdModelId=${param.intr_modelId}" 
				   requestMethod="GET">
			<script>
				Pda.Element('introduce_panel').on("ready" ,function(){
					$("#introduce_list").removeClass("lui-intr-no-bottom");
					$("#introduce_list").addClass("lui-intr-bottom");
					$("#introduce_list").css({"height" : "auto"});
				});
			</script>
			<section class="lui-introduce-footer">
				<ul class="lui-introduce-editinfo" id="intro_edit">
					<li class="clearfloat" >
						<span class="lui-intr-tip">
							推荐级别：
						</span>
						<ul  class="lui-intr-star">
							<li id="intrStars_2" class="lui-star-icon-on" onclick="_intr_selectStar(this);"></li>
							<li id="intrStars_1" class="lui-star-icon-on" onclick="_intr_selectStar(this);"></li>
							<li id="intrStars_0" class="lui-star-icon-on" onclick="_intr_selectStar(this);"></li>
						</ul>
						<span style="float:right;margin-right:10px;">
							<span class="lui-intr-tip">
								推荐给：
							</span>
							<span class="lui-intr-to-box">
							<c:if test="${param.toEssence == 'true'}">
								<span class="lui-intr-to lui-intr-to-left" 
									  id="toEssence_btn" 
									  style="border-right:1px solid #DADADA;padding-right: 4px">精华库
								</span></c:if><c:if test="${'false' != param.toPerson }"><span 
									  class="lui-intr-to lui-intro-to-selected lui-intr-to-right" 
									  id="toPerson_btn" >个人</span></c:if>
							</span>
						</span>
					</li>
					<li class="clearfloat" id="intro_goals">
						<div class="lui-intr-goal">
							<span class="lui-intr-tip">
									推荐对象：
							</span>
							<span class="lui-intr-goal-span goals_textEllipsis">
								<script type="text/javascript" src="<c:url value="/resource/js/common.js"/>"></script>
								<script type="text/javascript" src="<c:url value="/third/pda/resource/script/address.js"/>"></script>
								<script>
									function addressFix() {
										var divObj = document.getElementById("_pda_address_dialog_div");
										if(divObj) {
											$(divObj).css({
												'top': '0',
												'position': 'absolute',
												'z-index': '9999',
												'width':'100%'}
											);
										}
									}
								</script>
								<span style="display: inline-block;"
										class="selectIcon"
										onclick="Pda_Address('fdIntroduceGoalIds', 'fdIntroduceGoalNames', true, ';', ORG_TYPE_ALL);addressFix();"></span>
								<input type="hidden"
									   name="fdIntroduceGoalNames"/>
								<input type="hidden" name="fdIntroduceGoalIds"/>
								
							</span>
						</div>
					</li>
					<li class="lui-introduce-submit clearfloat" >
						<div class="lui-introduce-input-div">
							<input type="hidden" name="fdIntroduceToEssence" value="0">
							<input type="hidden" name="fdIntroduceToPerson" value="1"/>
							<input type="hidden" name="fdIntroduceTime"/>
							<input type="hidden" name="fdKey" value="${param.fdKey}"/>
							<input type="hidden" name="fdIntroduceGrade" value="0">
							<input type="hidden" name="fdModelId" value="${param.intr_modelId}"/>
							<input type="hidden" name="fdModelName" value="${param.intr_modelName}"/>
							<input type="hidden" name="fdCateModelName" value="${param.fdCateModelName}"/>
							<input type="hidden" name="docSubject" value="${param['docSubject']}"/>
							<input type="hidden" name="docCreatorName" value="${param['docCreatorName']}"/>
							<input type="text" placeholder="推荐评语~" name="fdIntroduceReason" 
									onfocus="__intr_validate()" onblur="__intr_validate()" onkeyup="__intr_validate()"/>
							<input name="fdIsNotify" type="hidden" value="1">
							<span style="display:none;"><kmss:editNotifyType property="fdNotifyType" value="todo"/></span>
						</div>
						<span class="lui-intro-submit-btn" 
							  onclick="__intro_submit()" 
							  style="display:none;">提交</span>
					</li>
				</ul>
			</section>
			<div class="lui-intro-dialog-tip" id="intro_dialog">
				
			</div>
		</kmss:auth>
	</template:replace>
	<template:replace name="footer">
		<script id="introduce_tmpl" type="text/template">
		if(data.length <= 0) {
		{$
			<div class="lui-intr-no-list">未找到相应的推荐记录！</div>
		$}
	
		} else {
		{$
			<ul class="lui-intr-list">	
		$}
		for(var i = 0; i < data.length ; i++) {
		{$ 
			<li class="lui-intr-list-li">
				<div class="lui-intr-reason">
					<p>{% data[i]['fdIntroduceReason'] %}</p>
				</div>
				<div class="clearfloat lui-intr-info">
					<span class="lui-intr-intrer">{%data[i]['fdIntroducer.fdName']%}</span>
					<span class="lui-intr-summary-time">&nbsp;|&nbsp;{%data[i]['fdIntroduceTime']%}</span>
					<span><ul class="lui-intr-star">
			$}
						for(var m = 0 ; m < 3; m++){
							var flag = 2- parseInt(data[i]['fdIntroduceGrade']);
							var className = 'lui-star-icon-view';
							if(m <= flag){
								className = 'lui-star-icon-on-view';
							}
					    	{$<li class='{%className%}'></li>$}
						}
		{$         </ul></span>						
				</div>
				<div class="lui-intrto-summary-detail">
					<span>{%data[i]['introduceType']%}</span>
					<span>{%data[i]['introduceGoalNames'].replace(/;/gi,' , ')%}</span>
				</div>
			</li>
		$}
		}
		{$
			</ul>
		$}
		}
	</script>
	<script>
		function _intr_selectStar(thisObj) {
			var objId=thisObj.getAttribute("id");
			if(objId.indexOf("_")>-1){
				var indexVar = parseInt(objId.substr(objId.indexOf("_")+1), 10);
				var scoreVal = document.getElementsByName("fdIntroduceGrade")[0];
				scoreVal.value = indexVar;
				thisObj.setAttribute("class", "lui-star-icon-on");
				for( var i= 2; i>= 0; i--) {
					if(i > indexVar)
						document.getElementById("intrStars_"+i).setAttribute("class", "lui-star-icon-on");
					if(i < indexVar)
						document.getElementById("intrStars_"+i).setAttribute("class", "lui-star-icon");
				}
			}
		}
		
		
		Pda.Element('introduce_panel').on("ready" ,function(){
			$(".lui-intr-to").on('click',
					function(){
						var $self = $(this);
						if($self.hasClass("lui-intro-to-selected")) {
							if(this.id == "toEssence_btn")
								resetToEssence(false);
							if(this.id == "toPerson_btn") {
								resetToperson(false);
							}
						}
						else {
							if(this.id == "toEssence_btn")
								resetToEssence(true);
							if(this.id == "toPerson_btn") {
								resetToperson(true);
							}
						}
					}
			);
		});
		function resetToperson(selected) {
			if(selected) {
				$('#toPerson_btn').addClass("lui-intro-to-selected");
				$('[name=fdIntroduceToPerson]').val(1);
				$('#intro_goals').show();
			} else {
				$('#toPerson_btn').removeClass("lui-intro-to-selected");
				$('[name=fdIntroduceToPerson]').val(0);
				$('#intro_goals').hide();
			}
			$('[name=fdIntroduceGoalNames]').val('');
			$('[name=fdIntroduceGoalIds]').val('');
			$('#_fdIntroduceGoalIds_label').html('');
		}
		function resetToEssence(selected) {
			if(selected) {
				$('#toEssence_btn').addClass("lui-intro-to-selected");
				$('[name=fdIntroduceToEssence]').val(1);
			} else {
				$('#toEssence_btn').removeClass("lui-intro-to-selected");
				$('[name=fdIntroduceToEssence]').val(0);
			}
		}
		function __intr_validate(){
			var flag= false,
			     val = $('input[name="fdIntroduceReason"]').val(),
			     leng = val.length,
			     l = 0;
			for (var i = 0; i < leng; i++) {				
				if (val[i].charCodeAt(0) < 255) 
					l++;
				 else 
					l += 2;
			}
			if(l<=280 && l>0)
				flag = true;
			if(flag)
				$('.lui-intro-submit-btn').show();
			else
				$('.lui-intro-submit-btn').hide();
			return flag;
		}
	
		function _get_intro_data(id) {
			var dataObj = {};
			$("#"+ id).find("input").each(function(){
				var domObj = $(this),
				    eName = domObj.attr("name");
				if(eName!=null && eName!="" ){
					dataObj[eName] = domObj.val();
				}
			});
			return dataObj;
		}
		function __intro_submit() {
			if(!__intr_validate()) 
				return;
			if($('[name=fdIntroduceToEssence]').val() == "1"  && !__intro_checkEssence()) 
				return;
			if(($('[name=fdIntroduceToPerson]').val() == "0" 
					&& $('[name=fdIntroduceToEssence]').val() == "0") ||
				($('[name=fdIntroduceToPerson]').val() == "1"
					&& !$('[name=fdIntroduceGoalIds]').val())) {
				return;
			}
			var _loading = Pda.loading();
			_loading.show();
			var data = _get_intro_data('intro_edit');
			$.post('${LUI_ContextPath }/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=save',data,function(){
				Pda.Element('introduce_list').reDraw();
				__intro_edit_reset();
				_loading.hide();
			});
		}
	
		function __intro_edit_reset() {
			_intr_selectStar($('#intrStars_0')[0]);
			$('[name=fdIntroduceReason]').val('');
			resetToperson(true);
			resetToEssence(false);
		}

		//检验当前人是否已经推荐本文档到精华库
		function __intro_checkEssence () {
			var _url = "${LUI_ContextPath }/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=introcheck";
			$.ajax({
				url:_url,
				type: 'get',
				dataType: 'json',
				data: _get_intro_data('intro_edit'),
				async:false,
				success: function(data, textStatus, xhr) {
					return true;
				},
				error: function(data, textStatus, xhr) {
					_dialog_tip("您已推荐过此文档到本模块精华库");
					return false;
				}
			});
		}

		function _dialog_tip(text) {
			$("#intro_dialog").text(text);
			$("#intro_dialog").css({"opacity":"1"}).show();
			$("#intro_dialog").animate({"opacity" : "0"}, 3000 ,
					function(){
				      $("#intro_dialog").hide();
			   		});
		}
	</script>
	</template:replace>
</template:include>
	
