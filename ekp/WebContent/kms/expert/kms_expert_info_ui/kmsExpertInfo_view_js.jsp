<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	//推荐专家
	function introExpert(_id,_name,_type){
		var tips = _type=='intro'?
					"${lfn:message('kms-expert:kmsExpert.intro.isSure')} <span class='com_author'>" +  _name +"</span> ${lfn:message('kms-expert:kmsExpert.intro.setIntro')}":
						"${lfn:message('kms-expert:kmsExpert.inro.cancel')} <span class='com_author'>" +  _name +"</span> ？";
		seajs.use(['lui/dialog'],function(dialog){
			dialog.confirm(tips,function(value){
				if(value) {
					var loading = dialog.loading();
					LUI.$.ajax({
						url : '<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />',
						data: {
							method : 'introExpert',
							List_Selected : _id,
							type:_type
						},
						cache: false,
						async: false, 
						success: function(data){
							if(data == true){
								loading.hide();
								dialog.success("${lfn:message('return.optSuccess')}");
								//替换按钮
								changeButton(_type);
							} else{
								loading.hide();
								dialog.failure("${lfn:message('return.optFailure')}");
							}
						},
						error: function(){
							loading.hide();
							dialog.success();
						}
				  });
	
				}
	
			});
	
		});
	}
	
	function changeButton(type) {
		if("intro" == type) {
			LUI.$("#intro").hide();
			LUI.$("#cancel").show();
		}else if("cancel"== type) {
			LUI.$("#cancel").hide();
			LUI.$("#intro").show();
		}
	}
	//向专家提问
	function askToExpert(fdId) {
		window
				.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
	}
	//计算个人积分比的样式class
	function calculatePcClass(score, up, down) {
		// 积分取值区间
		var region = up - down, p = region / 10;
		var found = 0, curRegion = down;
		for ( var i = 0; i < 11; i++) {
			if (score <= curRegion) {
				found = i;
				break;
			}
			curRegion += p;
		}

		return "lui_score_percent" + found;
	}

	function resolveUrl(url, urlParam) {
		if (url.indexOf('?') > 0) {
			url += "&" + urlParam;
		} else {
			url += "?" + urlParam;
		}
		return url;
	}

	
	seajs.use(['lui/jquery'],function($){
		$(document).ready(function(){
			$('.lui_expert_nav_links').bind('mouseout mouseover',function(){
				$(this).toggleClass('lui_expert_km_selected_icon');
			});
		});
	});

	
	function myKmDetails(personalUrl, obj) {
		LUI.$('#___content').attr('src',
				resolveUrl('${LUI_ContextPath}' + personalUrl, 'fdOrgId=${fdOrgId}'));
		selectKnowledge(obj);
	}

	function selectKnowledge(obj) {
		seajs.use(['lui/jquery'], function($) {
			var _$obj = null;
			if(typeof(obj) == "string") 
				_$obj = $('[data-personal-model="'+ obj +'"]');
			else _$obj = $(obj);
			$('.lui_expert_km_nav .lui_expert_myKmdetail').each( function() {
				$(this).removeClass('lui_expert_km_selected');
			});
			_$obj.parent().parent().addClass('lui_expert_km_selected');
		});
	}

</script>