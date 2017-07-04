<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 个人基本信息 -->
<script type="text/template" id="portlet_common_per_tmpl">
{$
<ul class = "l_m">
<li><a href="#" class="img_f" title=""><img src="{%data.fdImgUrl%}" onload="javascript:drawImage(this,this.parentNode)"/></a></li>
<li>
	<span style="padding:10px 10px 0 0;display:block;float:left;" kk="kk_span"></span>  
	<span class={%data.fdIsExpert ? '"icon_expert"' : '"icon_person"'%} >{%data.fdPersonName%}</span>
</li>
<li>
$}
	if(data.fdIsExpert){
{$
		<div class="btn_d" style="float:left" ><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%data.fdExpertId%}')"><span>向他提问</span></a></div>
$}
	}
{$
	<div class="clear"></div>
</li>
<li>{%data.fdPersonPost%}</li>
<li><span class="btn_k m_r10" style="display:inline"><a href="#" title="" style="display:inline"><span>{%data.fdTotalGrade%}</span></a></span><span class="a_e">{%data.fdLevel%}</span></li>
<li>经验：<span class="a_c">{%data.fdTotalScore%}</span>/{%data.fdScoreRegionUp%}<br />
<span id="kmsScorePercent" 
	class="{%calculatePcClass(data.fdTotalScore, data.fdScoreRegionUp, data.fdScoreRegionDown)%}" title="{%data.fdTotalScore + '/' + data.fdScoreRegionUp%}"></span>
</li>
</ul>
$}
</script>

<div id="kk_div" style="display: none;position: absolute;">
	<c:import url="/sys/ims/sysIms_manage.jsp" charEncoding="UTF-8">  
		<c:param name="imName" value="KK" />  
		<c:param name="imParams" value="{orgs:'${loginName }',menuCfg:{gravity:'n'},showMenu:false, htmlElem:' border=0 '}" />  
	</c:import>
</div>