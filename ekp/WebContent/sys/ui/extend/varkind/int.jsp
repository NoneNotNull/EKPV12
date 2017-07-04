<%@page import="java.util.HashMap"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.ui.taglib.fn.LuiFunctions"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
JSONObject var = JSONObject.fromObject(request.getParameter("var"));
pageContext.setAttribute("luivar",var);
pageContext.setAttribute("luivarid","var_"+IDGenerator.generateID());
pageContext.setAttribute("luivarparam",StringUtil.isNotNull(var.getString("body")) ? JSONObject.fromObject(var.get("body")) : new JSONObject());
%>
<script>
${param['jsname']}.VarSet.push({
	"name":"${ luivar['key'] }",
	"getter":function(){
		return $("#${ luivarid }").val();
	},
	"setter":function(val){
		$("#${ luivarid }").val(val);
	},
	"validation":function(){
		var val = this['getter'].call();
		var requ = ${ luivar['require'] ? "true" : "false" };
		if(requ){
			if($.trim(val)==""){
				return "${ luivar['name'] }不能为空";
			}
		}
	}
});
</script>
<tr>
	<td>${ lfn:msg(luivar['name']) }</td>
	<td><input class="inputsgl" id="${ luivarid }" style="width:36px;" type="text" value="${luivar['default']}" onkeyup='this.value=this.value.replace(/\D/gi,"")'/>${ luivar['require'] ? "<span style='color:red;'>*<span>" : "" }<span class="com_help">${ lfn:msg(luivarparam['help']) }</span></td>
</tr>