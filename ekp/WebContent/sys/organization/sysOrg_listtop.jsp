<input type=radio name="f_orgtype" value='org' onclick="changeOrgTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgElement.org" />
<input type=radio name="f_orgtype" value='dept' onclick="changeOrgTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgElement.dept" />
<input type=radio name="f_orgtype" value='post' onclick="changeOrgTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgElement.post" />
<input type=radio name="f_orgtype" value='person' onclick="changeOrgTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgElement.person" />
<input type="text" name="fdName" class="inputSgl" onkeydown="if(event.keyCode==13) {simpleSearch();return false;}">
<input type="button" class="btnopt" value="<bean:message key="button.list"/>" onclick="simpleSearch();">
<input type="button" class="btnopt" value="<bean:message key="button.reset"/>" onclick="doReset();">
<bean:message bundle="sys-organization" key="sysOrgElement.search" />
<script>
Com_Parameter.IsAutoTransferPara = true;
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
function changeOrgTypeList(orgName){
	Com_Parameter.IsAutoTransferPara = false;
	var url = Com_Parameter.ContextPath+"sys/organization/sys_org_"+orgName+"/sysOrg"+orgName.substring(0,1).toUpperCase()+orgName.substring(1)+".do?method=list";
	url = Com_SetUrlParameter(url, "available", Com_GetUrlParameter(location.href, "available"));
	url = Com_SetUrlParameter(url, "all", Com_GetUrlParameter(location.href, "all"));
	url = Com_SetUrlParameter(url, "parent", Com_GetUrlParameter(location.href, "parent"));
	url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
	Com_OpenWindow(url, "_self");
}

function resetRadio(){
	var url = location.href.toString();
	var orgName = url.substring(0, url.indexOf(".do"));
	orgName = orgName.substring(0, orgName.lastIndexOf("/"));
	orgName = orgName.substring(orgName.lastIndexOf("_")+1);
	var fields = document.getElementsByName("f_orgtype");
	for(var i=0; i<fields.length; i++)
		if(fields[i].value==orgName){
			fields[i].checked = true;
			break;
		}
	var fdName = Com_GetUrlParameter(location.href, "fdName");
	if(fdName != "" && fdName != null){
		document.getElementsByName("fdName")[0].value = fdName;
	}
}

function List_ConfirmInvalid(checkName){
	return List_CheckSelect(checkName) && confirm('<bean:message bundle="sys-organization" key="organization.invalidatedAll.comfirm" />');
}

resetRadio();

//搜索方法
function simpleSearch(){
	//debugger;
	var url = location.href;
	var fdName = document.getElementsByName("fdName")[0].value;
	url = Com_SetUrlParameter(url, "fdName", fdName);
	window.location.href = url;
}

//重置方法
function doReset(){
	var url = location.href;
	url = Com_SetUrlParameter(url, "hidetoplist", Com_GetUrlParameter(location.href, "hidetoplist"));
	url = Com_SetUrlParameter(url, "available", Com_GetUrlParameter(location.href, "available"));
	url = Com_SetUrlParameter(url, "all", Com_GetUrlParameter(location.href, "all"));
	url = Com_SetUrlParameter(url, "parent", Com_GetUrlParameter(location.href, "parent"));
	url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
	url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
	url = Com_SetUrlParameter(url, "fdName", "");
	window.location.href = url;
}

</script>