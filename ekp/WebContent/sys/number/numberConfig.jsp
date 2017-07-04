<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.number.util.NumberPlugin"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@ include file="/resource/jsp/common.jsp"%>


<%@page import="com.landray.kmss.util.StringUtil"%><script type="text/javascript">  
	Com_IncludeFile("jquery.js");
	 
	function init_config_moduleList()
	{
		var listValue=document.getElementsByName("value(sys.number.list)")[0].value; //存储的模块列表设置 ****：true;***:false;
		var names=document.getElementById("sys.number.names").value;//模块列表名称
		if(listValue!=null && listValue!='')
		{
			var list=listValue.split(";");
			if(list!=null &&list.length>0)
			{
				for(var i=0;i<list.length;i++)
				{
					if(list[i]=="")
						continue;
					var namevalue=list[i].split(":");
					var name=namevalue[0];
					var value=namevalue[1];
					if(value=='true')
					{
						document.getElementsByName(name)[0].checked="checked";
					}
					else
					{
						document.getElementsByName(name)[0].checked="";
					}
				}
			}
			
		}
	}

	function config_number_chgTbodyDisplay(tbid, display){
		var tbObj = document.getElementById(tbid);
		tbObj.style.display = display?"":"none";
		var fields = tbObj.getElementsByTagName("INPUT");
		for(var i=0; i<fields.length; i++){
			fields[i].disabled = !display;
		}
	}

	function add_config_moduleList()
	{
		var names=document.getElementById("sys.number.names").value;//模块列表名称
		if(names!=null && names!="")
		{
			var namelist=names.split(";");
			var valuelist="";
			if(namelist!=null && namelist.length>0)
			{
				for(var j=0;j<namelist.length;j++)
				{
					var name=namelist[j];
					if(name!="")
					{
						var obj=document.getElementById(name);
						var value=obj.checked;
						if(true==value)//只有当多选框被选中时才保存该值
							valuelist+=name+":"+value+";";
					}
				}
			}
			document.getElementsByName("value(sys.number.list)")[0].value=valuelist;
		}
		return true;
	}
	config_addOnloadFuncList(init_config_moduleList);// onload 触发
	config_addCheckFuncList(add_config_moduleList); //  保存时触发
</script>

<table class="tb_normal" width=100%>
	<tbody id="sys.number.list">
	<xform:text property="value(sys.number.list)" showStatus="noshow"></xform:text>
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message key="sysNumber.config.name" bundle="sys-number" />
		</td>
		<td>
			<%
				Map<String,Map<String,String>> map=NumberPlugin.getExtendMap();
				StringBuilder strBuilder=new StringBuilder();
				if(map!=null && !map.isEmpty())
				{
					Iterator<String> nameIter=map.keySet().iterator();
					int i=0;
					while(nameIter.hasNext())
					{
						String modelName=nameIter.next();
						Map<String,String> modelMap= map.get(modelName);
						if(modelMap!=null && !modelMap.isEmpty())
						{
							 String moduleName=modelMap.get(NumberPlugin.ITEM_PARAM_MODULE_NAME);
							 String isReform=modelMap.get(NumberPlugin.ITEM_PARAM_ISREFORM);
							 if(StringUtil.isNotNull(isReform) && isReform.equals("true"))
							 {
								 i++;
								 out.print("<input type='checkbox' id='sys.number."+modelName+"' name='sys.number."+modelName+"' /> <label for='sys.number."+modelName+"'>"+moduleName+"</label>&nbsp;&nbsp;&nbsp;&nbsp;");
								 if(i%4==0)
								 {
									 out.print("<br/>");
								 }
								 strBuilder.append("sys.number."+modelName).append(";");
							 }
							 
						}
						
					}
				}
				out.print("<input type='hidden' id='sys.number.names' value='"+strBuilder.toString()+"' />");
			%>
			<br/>
			<span class="message">
				<bean:message key="sysNumber.config.message" bundle="sys-number" />
			</span>
		</td>
	</tr>
	
	</tbody>
	
</table>
