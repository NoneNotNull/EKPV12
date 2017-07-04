<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.ui.taglib.fn.LuiFunctions"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ page language="java" pageEncoding="UTF-8"%> 
<%
String xcode = request.getParameter("code");
JSONObject var = JSONObject.fromObject(request.getParameter("var"));
pageContext.setAttribute("luivar",var);
pageContext.setAttribute("luivarid","var_"+IDGenerator.generateID());
pageContext.setAttribute("luivarparam",StringUtil.isNotNull(var.getString("body")) ? JSONObject.fromObject(var.get("body")) : new JSONObject());
 
JSONObject jsonbody = (JSONObject)pageContext.getAttribute("luivarparam");
String model = jsonbody.getString("model");
String dialogJsp = "/sys/simplecategory/varkind/selectsimplecategory.jsp?model="+model;
if(StringUtil.isNotNull(xcode) && xcode.indexOf(SysUiConstant.SEPARATOR)>0){
	String url = xcode.substring(0,xcode.indexOf(SysUiConstant.SEPARATOR));
	url = SysUiConstant.getServerUrl(url);
	dialogJsp = url + dialogJsp;
}
String dialogTitle = (jsonbody.get("title") == null ? LuiFunctions.msg(var.get("name").toString()) : LuiFunctions.msg(jsonbody.getString("title")));
String dialogJs = "VariableSetting.openConfigPage('"+pageContext.getAttribute("luivarid")+"_name','"+pageContext.getAttribute("luivarid")+"_id','"+dialogJsp+"','"+dialogTitle+"')";
pageContext.setAttribute("dialogJs",dialogJs);
%>
<script>
	//Com_IncludeFile("dialog.js");
	//Dialog_SimpleCategory('${luivarcategorymodel}','${ luivarid }_id','${ luivarid }_name',false,null,'01',null,true);
	${param['jsname']}.VarSet.push({
		"name":"${ luivar['key'] }",
		"getter":function(){
			var val = {};
			val.${ luivar['key'] } = $("#${ luivarid }_id").val();
			val.${ luivar['key'] }_name = $("#${ luivarid }_name").val();
			return val;
		},
		"setter":function(val){
			$("#${ luivarid }_id").val(val.${ luivar['key'] });
			$("#${ luivarid }_name").val(val.${ luivar['key'] }_name);
		},
		"validation":function(){
			var val = this['getter'].call();
			var requ = ${ luivar['require'] ? "true" : "false" };
			if(requ){
				if(val ==null || val.${ luivar['key'] } == null || $.trim(val.${ luivar['key'] }) == ""){
					return "${ luivar['name'] }不能为空";
				}
			}
		}
	});
</script>
<tr>
	<td>${ lfn:msg(luivar['name']) }</td>
	<td>
		<input id="${ luivarid }_id" name="${ luivarid }_id" type="hidden">
		<input class="inputsgl" readonly="readonly" id="${ luivarid }_name" name="${ luivarid }_name" type="text">${ luivar['require'] ? "<span style='color:red;'>*<span>" : "" }
		<a href="javascript:void(0)" class="com_btn_link" onclick="${dialogJs}">${ lfn:message('sys-ui:ui.vars.select') }</a>
		<%
			if(var.get("require")!=null && var.getBoolean("require")){
				
			}else{
				out.append("<a href='javascript:void(0)' class='com_btn_link' onclick=\"document.getElementById('"+pageContext.getAttribute("luivarid")+"_id').value='';document.getElementById('"+pageContext.getAttribute("luivarid")+"_name').value='';\">"+LuiFunctions.message("sys-ui:ui.vars.clear")+"</a>");
			}
		%>
		<span class="com_help">${ lfn:msg(luivarparam['help']) }</span>
	</td>
</tr>