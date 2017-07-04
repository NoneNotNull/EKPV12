<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/evaluation/style/eval.css" />
<template:include file="/kms/common/pda/template/core.jsp">
<template:replace name="title">
	<h2 class="textEllipsis">点评</h2>
</template:replace>
<template:replace name="content">
	<section data-lui-role="rowTable" id="evaluation_list" class="lui-content lui-evaluation-list-no-bottom">
		<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=list&rowsize=10&forward=listUi&fdModelId=${param.eval_modelId}&fdModelName=${param.eval_modelName}&rowsize=8',
				type : 'ajaxJson'
			},
			render : {
				templateId : '#evaluation_tmpl'
			},
			scroll : false
		}
		</script>
	</section>
	<kmss:auth requestURL="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${param.eval_modelName}&fdModelId=${param.eval_modelId}&key=${param.key}" 
			   requestMethod="GET">
		<script>
			Pda.Element('evaluation_panel').on("ready",function() {
				$("#evaluation_list").removeClass("lui-evaluation-list-no-bottom");
				$("#evaluation_list").addClass("lui-evaluation-list-bottom");
				$("#evaluation_list").css({"height" : "auto"});
			});
		</script>
		<section class="lui-evaluation-footer">
			<ul>
				<li class="clearfloat" >
					<span class="lui-evaluation-tip">
						我来评分
					</span>
					<ul id="ul_star" class="lui-eval-summary-star">
						<li id="stars_1" class="lui-star-icon-on" onclick="selectStar(this);"></li>
						<li id="stars_2" class="lui-star-icon-on" onclick="selectStar(this);"></li>
						<li id="stars_3" class="lui-star-icon-on" onclick="selectStar(this);"></li>
						<li id="stars_4" class="lui-star-icon-on" onclick="selectStar(this);"></li>
						<li id="stars_5" class="lui-star-icon" onclick="selectStar(this);"></li>
					</ul>
		
				</li>
				<li class="lui-evaluation-submit clearfloat" id="eval_area">
					<div class="lui-evaluation-input-div">
						<input type="hidden" name="fdEvaluationTime"/>
						<input type="hidden" name="fdKey" value="${param.key}"/>
						<input type="hidden" name="fdModelId" value="${param.eval_modelId}"/>
						<input type="hidden" name="fdModelName" value="${param.eval_modelName}"/>
						<html:hidden property="fdEvaluationScore" value="1"/>
						<input type="text" placeholder="我也来评两句~" name="fdEvaluationContent" 
							onfocus="__eval_validate()" onblur="__eval_validate()" onkeyup="__eval_validate()"/>
					</div>
					<span class="lui-evaluation-submit-btn" onclick="__eval_submit()" style="display: none">评论</span>
				</li>
			</ul>
		</section>
	</kmss:auth>
</template:replace>
<template:replace name="footer">
<script id="evaluation_tmpl" type="text/template">
if(data.length <= 0) {
	{$
		<div class="lui-eval-no-list">未找到相应的点评记录！</div>
	$}
	
} else {
{$
	<ul class="lui-eval-table">
$}
for(var i=0;i<data.length;i++){
{$
		<li class="lui-eval-li">
			<div class="lui-eval-image">
				<img src="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&size=90&fdId={% data[i]['fdEvaluator.fdId'] %}" width="45px" height="45px"/>
			</div>
			<div class="lui-eval-article">
				<div class="clearfloat">
					<h3>{% data[i]['fdEvaluator.fdName'] %}</h3>
						<ul class="lui-eval-summary-star-view"> $}
							for(var m=0;m<5;m++){
								var flag = 4 - parseInt(data[i]['fdEvaluationScore']);
								var className = 'lui-star-icon-view';
								if(m <= flag){
									className = 'lui-star-icon-on-view';
								}
								{$<li class="{%className%}"></li>$}
							}
						{$</ul>
					<span>{% Pda.Util.formatDate(Pda.Util.parseDate(data[i]['fdEvaluationTime'],'yyyy-MM-dd hh:mm'),'MM-dd hh:mm') %}</span>
				</div>
				<p>{% data[i]['fdEvaluationContent'] %}</p>
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

	function selectStar(thisObj){
		var objId=thisObj.getAttribute("id");
		if(objId.indexOf("_")>-1){
			var indexVar=parseInt(objId.substr(objId.indexOf("_")+1), 10);
			var scoreVal=document.getElementsByName("fdEvaluationScore")[0];
			var contentVar=document.getElementsByName("fdEvaluationContent")[0];
			scoreVal.value=5-indexVar;
			thisObj.setAttribute("class", "lui-star-icon-on");
			for( var i= 1; i<= 5; i++) {
				if(i<indexVar)
					document.getElementById("stars_"+i).setAttribute("class", "lui-star-icon-on");
				if(i>indexVar)
					document.getElementById("stars_"+i).setAttribute("class", "lui-star-icon");
			}
		}
	}

	function _eval_getUploadData(areaId){
		var dataObj = {};
		$("#"+ areaId).find("input").each(function(){
			var domObj = $(this);
			var eName = domObj.attr("name");
			if(eName!=null && eName!="" ){
				dataObj[eName] = domObj.val();
			}
		});
		return dataObj;
	};

	function __eval_validate(){
		var flag= false;
		var val = $('input[name="fdEvaluationContent"]').val();
		var leng = val.length;
		var l =0;
		for (var i = 0; i < leng; i++) {				
			if (val[i].charCodeAt(0) < 299) 
				l++;
			 else 
				l += 2;
		}
		if(l<=280 && l>0)
			flag = true;
		if(flag)
			$('.lui-evaluation-submit-btn').show();
		else
			$('.lui-evaluation-submit-btn').hide();
		return flag;
	}

	function __eval_submit(){
		if(!__eval_validate()) return ; 
		var __l = Pda.loading();
		__l.show();
		var data = _eval_getUploadData('eval_area');
		$.post('${LUI_ContextPath }/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=save',data,function(){
				Pda.Element('evaluation_list').reDraw();
				$('input[name="fdEvaluationContent"]').val('');
				__l.hide();
			});
	}
</script>

</template:replace>
</template:include>