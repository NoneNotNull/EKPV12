<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
</script>
<style>

.div_priview{
	float:left;
	border:2px solid transparent;
	margin:1px;
	cursor: pointer;
}
.div_priview_choose{
	float:left;
	border:2px solid blue;
	margin:1px;
	cursor: pointer;
}
.div_priview_choose:HOVER{
	float:left;
	border:2px solid #3099da;
	margin:1px;
	cursor: pointer;
}
.div_priview:HOVER{
	float:left;
	border:2px solid #3099da;
	margin:1px;
	cursor: pointer;
}
</style>
</head>
<body>
<div id="preivew_style">

</div>
</body>
</html>
<script>
	var params=window.opener.Com_Parameter.Dialog.data;
	var data=params?params.data:"";
	var chooseStyle=params?params.chooseStyle:"";
	chooseStyle=chooseStyle?chooseStyle:'tb_normal';
	var callback=window.opener.Com_Parameter.Dialog.AfterShow;
</script>
<script>

function ok(obj){
	rtn = {};
	rtn["pathProfix"]=$(obj).attr("pathProfix");
	rtn["tbClassName"]=$(obj).attr("tbClassName");
	//rtn[key]=elems[j].value;
	callback(rtn);
	window.close();
}
function createPrview(param,idx,isChoose){
	var classId=isChoose?'div_priview_choose':'div_priview';
	
	var html=[];
	html.push("<div class='"+classId+"' onclick='ok(this);' pathProfix='"+param.pathProfix+"' tbClassName='"+param.tbClassName+"' title='"+param.name+"(样式"+idx+")'>");
	html.push("<img src='"+Com_Parameter.ContextPath+param.pathProfix+"/preview.png' alt='"+param.name+"'  width='160' height='90px'/>");
	html.push("</div>");
	return html.join("");
}

$(function(){
	if(data){
		var html=""
		for(var i=0;i<data.length;i++){
			if(chooseStyle==data[i].tbClassName){
				html+=createPrview(data[i],i+1,true);
			}
			else{
				html+=createPrview(data[i],i+1);
			}
		}
		$("#preivew_style").html(html);
	}
	
});
</script>
