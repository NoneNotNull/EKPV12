<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
Doc_ShowMaxIcon = false;
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
function Doc_ResizeParentHeight(idName){
	try{
		parent.document.getElementById(idName).style.height=document.body.scrollHeight+7;
	}catch(e){
	}
}
</script>