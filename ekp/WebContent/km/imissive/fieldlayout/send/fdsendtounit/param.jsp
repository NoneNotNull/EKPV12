<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/" + Com_Parameter.Style + "/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
	Com_IncludeFile('dialog.js');
</script>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
</head>
<body>
	<form>
	<table class="tb_normal"  width=95%>
	  <%@ include file="/km/imissive/fieldlayout/common/param_top.jsp"%>
	  <c:import url="/km/imissive/fieldlayout/common/param_required.jsp" charEncoding="UTF-8">
		   <c:param name="defaultChecked" value="true" />
	  </c:import>
      <c:import url="/km/imissive/fieldlayout/common/param_width.jsp" charEncoding="UTF-8">
		   <c:param name="defaultWidth" value="45%" />
	  </c:import>
	  <tr>
	        <%-- 可选发文单位--%>
			<td class="td_normal_title" width=40%><bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdUnitId"/></td>
			<td>
			    <xform:dialog propertyId="fdMissiveUnitListIds"
			                  propertyName="fdMissiveUnitListNames"
			                  textarea="true"
					          style="width:95%" 
					          showStatus="edit"
					          htmlElementProperties="storage=true"
					          subject="${ lfn:message('km-imissive:kmImissiveUnit.fdCategoryId') }">  
						      Dialog_TreeList(true, 'fdMissiveUnitListIds', 'fdMissiveUnitListNames', ';',
						                            'kmImissiveUnitCategoryTreeService', 
						                            '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
						                            'kmImissiveUnitListService&parentId=!{value}',selectUnit)
				</xform:dialog>
		    </td>
	  </tr>
	  <tr>  <%-- 默认发文单位--%>
			<td class="td_normal_title" width=40%><bean:message  bundle="km-imissive" key="kmImissiveSendTemplate.fdSendtoDept"/></td>
		<td>
		    <input type="hidden" name="fdMissiveUnitName" storage='true'/>
		    <select name="fdMissiveUnitId" storage='true' onchange="selectChange(this);">
			  <%
			    String message = ResourceUtil.getString("page.firstOption");
				out.print("<option value=''>"
						+ message + "</option>");
			  %>
		     </select></td>
	  </tr>
	   <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
	</table>
	</form>
</body>
</html>
<script>
//可选发文单位change事件
function selectUnit(rtnval){
	if(rtnval==null){
		return;
	}else{
		var field = document.getElementsByName("fdMissiveUnitId")[0];
		rtnval.AddHashMap({id:"",name:"<bean:message key="page.firstOption"/>"});
		var mapArray = rtnval.GetHashMapArray();
		if(mapArray.length>1){
			rtnval.SwitchIndex(0,mapArray.length-1);
		}
		rtnval.PutToSelect(field, "id", "name", field.selectedIndex==-1?"":field.options[field.selectedIndex].value);
	}
}
//赋默认name的值
function selectChange(obj){
   var text = $(obj).find("option:selected").text();
   $("input[name='fdMissiveUnitName']").val(text);
}

function initSelect(params){
	if(params){
		var ids = params['fdMissiveUnitListIds'];
		if(ids==""||ids==null){
			return;
		}
		var names = params['fdMissiveUnitListNames'];
		var idsArr = ids.split(";");
		var namesArr = names.split(";");
		
		var selectObj = $("select[name='fdMissiveUnitId']");  
	    var defaultId = params['fdMissiveUnitId'];
		for(var j=0;j<idsArr.length;j++){
			if(defaultId==idsArr[j]){
				selectObj.append("<option value='"+idsArr[j]+"' selected='selected'>"+namesArr[j]+"</option>");  
			}else{
				selectObj.append("<option value='"+idsArr[j]+"'>"+namesArr[j]+"</option>");  
			}
		}
	}
}

//加载的时初始化
$(function(){
	initSelect(params);
	load_ini();
});
</script>