<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.ui.taglib.fn.LuiFunctions"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
JSONObject var = JSONObject.fromObject(request.getParameter("var"));
pageContext.setAttribute("luivar", var);
pageContext.setAttribute("luivarid","var_"+IDGenerator.generateID());
pageContext.setAttribute("luivarparam",StringUtil.isNotNull(var.getString("body")) ? JSONObject.fromObject(var.get("body")) : new JSONObject());
%>
<script>
${param['jsname']}.VarSet.push({
	"name":"${ luivar['key'] }",
	"getter":function(){
		var showType = "${ luivarparam['showType'] }";
		if(showType==""||showType=="select"){
			return $("#${ luivarid }").val();		
		}else if(showType=="radio"){
			return $("input[name='${ luivarid }']:checked").val();
		}else if(showType=="checkbox"){
			var tempVal = [];
			$("input[name='${ luivarid }']:checked").each(function(){
				tempVal.push($(this).val());
			});
			return tempVal.join(";");
		}
	},
	"setter":function(val){
		var showType = "${ luivarparam['showType'] }";
		if(showType==""||showType=="select"){
			$("#${ luivarid }").val(val);		
		}else if(showType=="radio"){
			$("input[name='${ luivarid }']").each(function(){
				if($(this).val() == val){
					$(this).attr("checked","checked");
				}
			});
		}else if(showType=="checkbox"){
			//debugger;
			$("input[name='${ luivarid }']").each(function(){
				this.checked = false; 
			});
			$("input[name='${ luivarid }']").each(function(){
				//debugger;
				var vals = $.trim(val).split(";");
				for(var i=0;i<vals.length;i++){
					if(vals[i] == $.trim($(this).val())){
						//$(this).attr("checked","checked");
						this.checked = true; 
					}
				}
			});
		}
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
	<td><%=getInput(var,pageContext.getAttribute("luivarid").toString())%>${ luivar['require'] ? "<span style='color:red;'>*<span>" : "" }<span class="com_help">${ lfn:msg(luivarparam['help']) }</span></td>
</tr>
<%!public String getInput(JSONObject var,String luivarid) throws Exception {
		StringBuilder sb = new StringBuilder();
		JSONObject body = JSONObject.fromObject(var.get("body"));
		JSONArray array = body.getJSONArray("values");
		String showFlag = body.getString("showType");
		String def = var.containsKey("default") ? var.getString("default") : "";
		if ("select".equals(showFlag) || "".equals(showFlag)) {
			sb.append("<select id=\""+luivarid+"\">");
			for (int i = 0; i < array.size(); i++) {
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(array.getJSONObject(i).getString("value"))){
						temp = " selected='true' ";
					}
				}
				sb.append("<option "+temp+" value="
						+ array.getJSONObject(i).getString("value") + ">"
						+ LuiFunctions.msg(array.getJSONObject(i).getString("text")) + "</option>");
				
			}
			sb.append("</select>");
		}
		else if ("radio".equals(showFlag)) {
			for (int i = 0; i < array.size(); i++) {
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(array.getJSONObject(i).getString("value"))){
						temp = " checked='true' ";
					}
				}
				sb.append("<label><input "+temp+" type=\"radio\" name=\""+luivarid+"\" value=" + array.getJSONObject(i).getString("value") + ">&nbsp;" + LuiFunctions.msg(array.getJSONObject(i).getString("text")) + "</label>&nbsp;&nbsp;");	
			}
		}
		else if ("checkbox".equals(showFlag)) {
			for (int i = 0; i < array.size(); i++) {
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(array.getJSONObject(i).getString("value"))){
						temp = " checked='true' ";
					}
				}
				sb.append("<label><input "+temp+" type=\"checkbox\" name=\""+luivarid+"\" value=" + array.getJSONObject(i).getString("value") + ">&nbsp;" + LuiFunctions.msg(array.getJSONObject(i).getString("text")) + "</label>&nbsp;&nbsp;");
			}
		}
		return sb.toString();
	}%>