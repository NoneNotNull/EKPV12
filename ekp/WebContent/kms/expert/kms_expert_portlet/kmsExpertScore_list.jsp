<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/lib/jquery.js"></script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/lib/json2.js"></script>
<script type="text/javascript">
	Com_IncludeFile("kms_tmpl.js", null, "js");
</script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/kms_portlet.js"></script>
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
 <script>
 function aa(i){
	$("#"+i).show();
	var height=parseInt($("#"+i).height());
	var parent=$("#"+i).parent();
	var h=parent.height();
	var divtopheight=$("#"+i).offset().top;
	var num= parseInt( $("#"+i).css('margin-top') );
	if(height+divtopheight>300 ){
		var num2=-num-h-height-20;
		$("#"+i).css("margin-top",num2);
		
		}
	 }
 function bb(i){
	
		$("#"+i).hide();
		 }
 
 
 </script>
<script id="portlet_expertlist_tmpl" type="text/template">
{$	<div style="height:300px;padding:5px;ext-align:center">
<div style="height:300px;width:240px;margin:0px auto; ">
		<ul class="l_c" style="float:left;margin:0 auto;height:300px">
$}

for(i=0;i<data.itemList.length;i++){

	if(i>=0&&i<3){
	{$	
		<li style="float:left;height:100px;"><a style="cursor: hand;height:100px;background-image:none;padding:0px;" href="{%data.itemList[i].fdUrl%}" target="_blank"><img src="{%data.itemList[i].fdImgUrl%}"  height=100px width=120px onmouseover='aa("{%data.itemList[i].fdId%}")' onmouseout='bb("{%data.itemList[i].fdId%}")'/></a>
			<div id="{%data.itemList[i].fdId%}" class="showcontent" style="width:120px;display:none;position:absolute ;z-index:2;background:paleturquoise;padding:5px;margin-top:-100px;margin-left:80px;">姓名:{%data.itemList[i].fdName%}</br>部门：{%data.itemList[i].fdDeptName%}</br>专长领域：{%data.itemList[i].expertType%}</br>积分：{%data.itemList[i].fdScore%}分</div></li>
	$}
	}
if(i==3){
		{$
			</ul><ul class="l_c" style="float:left;height:300px">
		$}
}

if(i>=3&&i<9){
	{$	
		<li style="float:left;height:50px;"><a style="cursor: hand;height:50px;background-image:none;padding:0px;" href="{%data.itemList[i].fdUrl%}" target="_blank"><img src="{%data.itemList[i].fdImgUrl%}" height=50px width=60px onmouseover='aa("{%data.itemList[i].fdId%}")' onmouseout='bb("{%data.itemList[i].fdId%}")'/></a>
			<div id="{%data.itemList[i].fdId%}" class="showcontent1" style="width:120px;display:none;position:absolute ;z-index:2;background:paleturquoise;padding:5px;margin-top:-50px;margin-left:-110px;">姓名:{%data.itemList[i].fdName%}</br>部门：{%data.itemList[i].fdDeptName%}</br>专长领域：{%data.itemList[i].expertType%}</br>积分：{%data.itemList[i].fdScore%}分</div></li>
	$}
}
if(i==9){
		{$
			</ul><ul class="l_c" style="float:left;height:300px">
		$}
	}
if(i>=9){
{$	
		<li style="float:left;height:50px;"><a style="cursor: hand;height:50px;background-image:none;padding:0px;" href="{%data.itemList[i].fdUrl%}" target="_blank"><img src="{%data.itemList[i].fdImgUrl%}" height=50px width=60px onmouseover='aa("{%data.itemList[i].fdId%}")' onmouseout='bb("{%data.itemList[i].fdId%}")'/></a>
			<div id="{%data.itemList[i].fdId%}" class="showcontent1" style="width:120px;display:none;position:absolute ;z-index:2;background:paleturquoise;padding:5px;margin-top:-50px;margin-left:-110px;">姓名:{%data.itemList[i].fdName%}</br>部门：{%data.itemList[i].fdDeptName%}</br>专长领域：{%data.itemList[i].expertType%}</br>积分：{%data.itemList[i].fdScore%}分</div></li>
	$}

}
	

}

{$
		</ul>
</div>
</div>
$}
</script>
<kms:portlet title="专家排行榜" id="kmsExperScoreList" dataType="Bean" dataBean="kmsHomeExpertService" beanParm="{s_method:\"findKmsExperScoreList\",rowsize:15,orderby:\"fdPhase\"}" template="portlet_expertlist_tmpl"></kms:portlet>
