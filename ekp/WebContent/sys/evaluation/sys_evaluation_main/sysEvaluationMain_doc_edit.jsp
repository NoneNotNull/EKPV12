<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<link href="../resource/evaluation/evaluation.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
Com_IncludeFile("jquery.js|jquery.form.js|calendar.js");
</script>
<script type="text/javascript">
function changeBtnStyle(_this,action){
	if("1" == action)
		_this.className = "evButtonOn";
	else
		_this.className = "evButtonDf";
}
var evScoreVal = new Array();
var evScoreTxt = new Array();
$(document).ready(function(){
	//采用jquery.form的方式异步提交表单
	var options={
				url: "${KMSS_Parameter_ContextPath}sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=save",
				type: "post",
				success:  afterSubmit
			};
	$('form[name="sysEvaluationMainForm"]').submit(function(){
		$('input[name="fdEvaluationTime"]').val((new Date()).format(Calendar_Lang.format.dataTime));
		$(this).ajaxSubmit(options);
		return false;
	});

	//星星图标评分
	$('select[name="fdEvaluationScore"] option').each(function(){
		evScoreVal.push($(this).val());
		evScoreTxt.push($(this).text());
	})
  $('.star_rating li').each(function(){
      $(this).click(function(){                     
          var lt=getStars($(this).attr('id'))+1;//通过类名判断星星数
          $('select[name="fdEvaluationScore"]').val(5-lt);
          $('#evScoreTd').text(evScoreTxt[5-lt]);
          $('.star_rating li').slice(0,lt).attr('class','starGood');
          $('.star_rating li').slice(lt,5).attr('class','starBad');
          if(lt>=3)
          	 $('#evScoreTd').attr('class','evScoreGood');
           else
         	  $('#evScoreTd').attr('class','evScoreBad');
          setEvContent(lt);
      });
  });
  $('.star_rating li').mouseover(function(){
      var lt=getStars($(this).attr('id'))+1;
      $('.star_rating li').slice(0,lt).attr('class','starGood');
      $('.star_rating li').slice(lt,5).attr('class','starBad');
      $('#evScoreTd').text(evScoreTxt[5-lt]);
      if(lt>=3)
     	 $('#evScoreTd').attr('class','evScoreGood');
      else
    	  $('#evScoreTd').attr('class','evScoreBad');
  });
  $('.star_rating li').mouseout(function(){
	 var lt = 5-parseInt($('select[name="fdEvaluationScore"]').val());
	 $('.star_rating li').slice(0,lt).attr('class','starGood');
     $('.star_rating li').slice(lt,5).attr('class','starBad');
     $('#evScoreTd').text(evScoreTxt[5-lt]);
     if(lt>=3)
    	 $('#evScoreTd').attr('class','evScoreGood');
     else
   	  $('#evScoreTd').attr('class','evScoreBad');
  });
	 var lt = 5-parseInt($('select[name="fdEvaluationScore"]').val());
	 $('.star_rating li').slice(0,lt).attr('class','starGood');
     $('.star_rating li').slice(lt,5).attr('class','starBad');
     $('#evScoreTd').text(evScoreTxt[5-lt]);
     if(lt>=3)
    	 $('#evScoreTd').attr('class','evScoreGood');
     else
   	  $('#evScoreTd').attr('class','evScoreBad');
     setEvContent(lt);

});
function submitForm(thisObj){
	thisObj.disabled=true;
	setTimeout("document.getElementById('btn_evalBtn').disabled=false;", 5000);
	$('form[name="sysEvaluationMainForm"]').submit();
}
function afterSubmit(){
	if(!window.frameElement)
		return;
	//往评论列表中插入最新评论的数据
	var varScore=$('select[name="fdEvaluationScore"]').val();
	var liHTML = "<li>";
		liHTML += "<div>";
		liHTML += Com_HtmlEscape($('textarea[name="fdEvaluationContent"]').val());
		liHTML += "</div>";
		liHTML += "<span>";
		liHTML += $('input[name="fdEvaluatorName"]').val();
		liHTML += "&nbsp;&nbsp;|&nbsp;&nbsp;";
		liHTML += $('input[name="fdEvaluationTime"]').val();
		liHTML += '</span>';
		liHTML += '<span class="evScoreList" title="'+$('select[name="fdEvaluationScore"]').find('option:selected').text()+'">';
		liHTML += '<ul>';
		for(var i=0;i<5;i++){
			liHTML += '<li class="'+(i<(5-parseInt(varScore, 10))?'selected':'')+'">';
			liHTML += '</li>';
		}
		liHTML += '</ul>';
		liHTML += "</span>";
		//liHTML += "</p>";
		liHTML += "</li>";
	var ulObj = $(window.parent.document).find('#evaluationListIfram').contents().find(".docList");
	if(ulObj.find("li").length==0)
		ulObj.text("");
	ulObj.prepend(liHTML)
	//清空文本内容，并获取焦点
	$('textarea[name="fdEvaluationContent"]').val("");
	$('textarea[name="fdEvaluationContent"]').focus();
	//更新label数字
	var iframeObj=parent.document.getElementById("evaluationListIfram");
	var parentObj=$(iframeObj).parents("tr[LKS_LabelIndex]");
	var numinfo = 0;
	if(parentObj.length>0){
		var tableId=parentObj.parents('table[LKS_LabelClass="info_view"]').attr("id");
		var indexInt=parentObj.attr("LKS_LabelIndex");
		var inpObj=$(parent.document).find("#"+tableId+"_Label_Btn_"+indexInt);
		var scoreInfo=inpObj.val();
		if(scoreInfo.indexOf("(")>0){
			var prefix=scoreInfo.substring(0,scoreInfo.indexOf("("));
			numinfo = scoreInfo.substring(scoreInfo.indexOf("(")+1,scoreInfo.indexOf(")"));
			inpObj.val(prefix+"("+(parseInt(numinfo)+1)+")");
		}else
			inpObj.val(scoreInfo+"(1)");
	}
	//调整iframe高度
	iframeObj.style.height=getNuminfo(iframeObj.style.height) + 70;
	parent.Com_FireLKSEvent('refreshEvaluationNum',parseInt(numinfo)+1);
}
function getNuminfo(heighrVar){
	var rtnVar=heighrVar.match(/\d/g);
	if(rtnVar!=null && rtnVar.length>0)
		return parseInt(rtnVar.join(""),10);
	else
		return 0;
}
//通过类名返回评分值
function getStars(stars){
    var re=2;
    switch(stars){
        case 'one_star':re=0;break;
        case 'two_stars':re=1;break;
        case 'three_stars':re=2;break;
        case 'four_stars':re=3;break;
        case 'five_stars':re=4;break;
    }
    return re;
}
function setEvContent(lt){
	var evContentObj = $('textarea[name="fdEvaluationContent"]');
	if(getEvVal(1)==evContentObj.val() || getEvVal(2)==evContentObj.val() || getEvVal(3)==evContentObj.val() || getEvVal(4)==evContentObj.val() || getEvVal(5)==evContentObj.val() || ""==evContentObj.val()){
		evContentObj.val(getEvVal(lt));
		evContentObj.css({'color':'#808080'});
	}
}
function getEvVal(lt){
	var evVal = "";
	switch(lt){
		case 1:evVal = '<bean:message key="sysEvaluation.oneStar.showText" bundle="sys-evaluation" />';break;
	    case 2:evVal = '<bean:message key="sysEvaluation.twoStar.showText" bundle="sys-evaluation" />';break;
	    case 3:evVal = '<bean:message key="sysEvaluation.threeStar.showText" bundle="sys-evaluation" />';break;
	    case 4:evVal = '<bean:message key="sysEvaluation.fourStar.showText" bundle="sys-evaluation" />';break;
	    case 5:evVal = '<bean:message key="sysEvaluation.oneStar.fiveText" bundle="sys-evaluation" />';break;
	}
	return evVal;
}
function imposeMaxLength(Object, MaxLen)
{
	if(Object.value.length>MaxLen){
		Object.value = Object.value.substring(0,MaxLen);
		return false;
	}else{
		return true;
	}
}

function onValueChg_eval(thisObj){
   	if(getEvVal(1)==$(thisObj).val() || getEvVal(2)==$(thisObj).val() || getEvVal(3)==$(thisObj).val() || getEvVal(4)==$(thisObj).val() || getEvVal(5)==$(thisObj).val()|| ""==$(thisObj).val()){
	   		$(thisObj).css({'color':''});
			$(thisObj).val('');
	   }
	var evalStr=thisObj.value.split("");
	var promptVar=document.getElementById("div_prompt_eval");
	var submitVar=document.getElementById("btn_evalBtn");
	var l = 0;
	for (var i = 0; i < evalStr.length; i++) {				
		if (evalStr[i].charCodeAt(0) < 299) {
			l++;
		} else {
			l += 2;
		}
	}
	if(l<280){
		promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert1" bundle="sys-evaluation"/><font style="font-family: Constantia, Georgia; font-size: 24px;">'+Math.abs(parseInt((280-l) / 2))+'</font><bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
		promptVar.style.color="";
		submitVar.disabled=false;
	}else{
		promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert2" bundle="sys-evaluation"/><font style="font-family: Constantia, Georgia; font-size: 24px;">'+Math.abs(parseInt((l-280) / 2))+'</font><bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
		promptVar.style.color="red";
		submitVar.disabled=true;
	}	
}
</script>
<html:form action="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do">
<center>
	<div class="evEditMain">
		<html:hidden property="fdId" />
		<html:hidden property="fdEvaluatorName"/>
		<html:hidden property="fdEvaluationTime"/>
		<html:hidden property="method_GET" />
		<html:hidden property="fdKey" />
		<input type="hidden" name="fdModelId" value="${param.fdModelId}"/>
		<input type="hidden" name="fdModelName" value="${param.fdModelName}"/>
		<sunbor:enums property="fdEvaluationScore" enumsType="sysEvaluation_Score" elementType="select" elementClass="hidden"/>
		<table style="height: 18px;margin: 0px;">
			<tr>
				<td><h2><bean:message key="sysEvaluation.title" bundle="sys-evaluation" /></h2></td>
				<td>
					<ul class="star_rating">
						<li id="one_star"></li>
						<li id="two_stars"></li>
						<li id="three_stars"></li>
						<li id="four_stars"></li>
						<li id="five_stars"></li>
					</ul>
				</td>
				<td id="evScoreTd" class="evScoreGood"></td>
				<td><div id="div_prompt_eval" style="float:right;margin-left:230px;"></div></td>
			</tr>
		</table>
		<div class="clear"></div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" height="80"><html:textarea property="fdEvaluationContent" style=" border: 1px solid #DFDFDF; margin:10px 0 6px; padding:10px; width:100%; height:80px;"
				 onfocus="onValueChg_eval(this);" onkeyup="onValueChg_eval(this);"/>
				</td>
				<td width="90px" align="center" valign="top" height="80">
					<input id="btn_evalBtn" class="evButtonDf" type=button onmouseover="changeBtnStyle(this,'1')" onmouseout="changeBtnStyle(this,'0')" value="<bean:message key="button.submit"/>" onclick="submitForm(this);">
				</td>
			</tr>

					
		</table>
		
		<input name="isNotify" type="checkbox" value="yes" checked="checked"><bean:message key="sysEvaluationMain.isNotify" bundle="sys-evaluation" />
		<c:if test="${param.notifyOtherName!='' && param.notifyOtherName!= null}">
			<input name="notifyOther" type="checkbox" value="${param.notifyOtherName}" checked="checked"><bean:message key="${param.key}" bundle="${param.bundel}" />
		</c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />：<kmss:editNotifyType property="fdNotifyType"/>
	</div>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
