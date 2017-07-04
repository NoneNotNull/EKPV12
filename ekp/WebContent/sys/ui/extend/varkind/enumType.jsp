<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.sunbor.web.tag.enums.ValueLabel"%>
<%@page import="com.landray.kmss.util.EnumerationTypeUtil"%>
<%@page import="com.sunbor.web.tag.enums.Type"%>
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
		JSONObject param = JSONObject.fromObject(var.get("body"));
		String enumType = param.getString("type");
		String showFlag = param.getString("showType");
		Type type = EnumerationTypeUtil.newInstance().getColumnEnums()
				.findType(enumType);

		String def = var.containsKey("default") ? var.getString("default") : "";
		if ("select".equals(showFlag) || "".equals(showFlag)) { 
			sb.append("<select id=\""+luivarid+"\">");
			for (int i = 0; i < type.getValueLabels().size(); i++) {
				ValueLabel valueLabel = (ValueLabel) type.getValueLabels().get(i);
				String _bundle = valueLabel.getBundle();
				if (StringUtil.isNull(_bundle)) {
					_bundle = type.getBundle();
				}
				String value = valueLabel.getValue();
				String label = ResourceUtil.getString(valueLabel.getLabelKey(),_bundle);
				//
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(value)){
						temp = " selected='true' ";
					}
				}
				sb.append("<option "+temp+" value=\"" + value + "\">" + LuiFunctions.msg(label) + "</option>");
			}
			sb.append("</select>");
		} 
		else if ("radio".equals(showFlag)) {
			for (int i = 0; i < type.getValueLabels().size(); i++) {
				ValueLabel valueLabel = (ValueLabel) type.getValueLabels().get(i);
				String _bundle = valueLabel.getBundle();
				if (StringUtil.isNull(_bundle)) {
					_bundle = type.getBundle();
				}
				String value = valueLabel.getValue();
				String label = ResourceUtil.getString(valueLabel.getLabelKey(),_bundle);
				//
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(value)){
						temp = " checked='true' ";
					}
				}
				sb.append("<label><input "+temp+" type=\"radio\" name=\""+luivarid+"\" value=" + value + ">&nbsp;" + LuiFunctions.msg(label) + "</label>&nbsp;&nbsp;");
				 
			}
		}
		else if ("checkbox".equals(showFlag)) {
			for (int i = 0; i < type.getValueLabels().size(); i++) {
				ValueLabel valueLabel = (ValueLabel) type.getValueLabels().get(i);
				String _bundle = valueLabel.getBundle();
				if (StringUtil.isNull(_bundle)) {
					_bundle = type.getBundle();
				}
				String value = valueLabel.getValue();
				String label = ResourceUtil.getString(valueLabel.getLabelKey(),_bundle);
				//
				String temp = "";
				if(def!=null && def.length()>0){
					if(def.equals(value)){
						temp = " checked='true' ";
					}
				}
				sb.append("<label><input "+temp+" type=\"checkbox\" name=\""+luivarid+"\" value=" + value + ">&nbsp;" + LuiFunctions.msg(label) + "</label>&nbsp;&nbsp;");
				
			}
		}
		return sb.toString();
	}%>