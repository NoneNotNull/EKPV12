<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ sysTaskAnalyzeForm.method_GET == 'add' }">
				<c:out value="新建分析 - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${sysTaskAnalyzeForm.docSubject} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<%--edit页面按钮--%>
				<c:when test="${ sysTaskAnalyzeForm.method_GET == 'edit' }">
					<ui:button text="${lfn:message('button.update')}" 
						onclick="Com_Submit(document.sysTaskAnalyzeForm, 'update');">
					</ui:button>
				</c:when>
				<%--add页面的按钮--%>
				<c:when test="${sysTaskAnalyzeForm.method_GET=='add' || sysTaskAnalyzeForm.method_GET=='quoteAdd'}">
					<ui:button text="${lfn:message('button.update')}" 
						onclick="Com_Submit(document.sysTaskAnalyzeForm, 'save');">
					</ui:button>
				</c:when>
			</c:choose>
			<%--关闭--%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskAnalyze') }" >
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	
	<%--任务分析表单--%>
	<template:replace name="content"> 
		<script type="text/javascript">
			Com_IncludeFile("dialog.js");
			seajs.use(['lui/jquery','lui/dialog'], function($,dialog) {
				//重置
				window.resetForm=function(){
					document.sysTaskAnalyzeForm.reset();
					document.getElementsByName("fdBoundIds")[0].value = "";
				};
				//预览
				window.setIframSrc=function(){
					var analyzeObjType_radio = document.getElementsByName("fdAnalyzeObjType");
					var analyzeObjType;
					for(var i=0;i<analyzeObjType_radio.length;i++){   
					 	if(analyzeObjType_radio[i].checked) 
							analyzeObjType= analyzeObjType_radio[i].value;  
					}
					var analyzeStartDate = document.getElementsByName("fdStartDate")[0].value;
					var analyzeEndDate = document.getElementsByName("fdEndDate")[0].value;
					var fdBoundIds = document.getElementsByName("fdBoundIds")[0].value;
					var analyzeType_radio = document.getElementsByName("fdAnalyzeType");
					var dateQueryTypeList = document.getElementsByName("dateQueryTypeList");
					var isincludechild_radio =document.getElementsByName("fdIsincludechild");
					var isincludechildtask_radio=document.getElementsByName("fdIsincludechildTask");
			        var isincludechild;
			        var isincludechildtask;
					var analyzeType;
					var dateQueryType = "";
					for(i=0;i<analyzeType_radio.length;i++){   
						if(analyzeType_radio[i].checked)  analyzeType= analyzeType_radio[i].value;  
					}
					for(i = 0 ; i < dateQueryTypeList.length; i++ ){
						if(dateQueryTypeList[i].checked){
							dateQueryType = dateQueryType+dateQueryTypeList[i].value;
						}
					}
					if(analyzeStartDate != undefined || analyzeEndDate != undefined) {
						if(dateQueryType == ""){
							dialog.alert("<bean:message bundle='sys-task' key='sysTaskAnalyze.dateQueryType.message'/>");
							return ;
						}
					}
					//判断是否包含子部门
				    for(var i=0;i<isincludechild_radio.length;i++){   
						if(isincludechild_radio[i].checked)  
							isincludechild= isincludechild_radio[i].value ; 
					}
					//判断是否包含子任务
					 for(var i=0;i<isincludechildtask_radio.length;i++){   
					 	if(isincludechildtask_radio[i].checked) 
						 	 isincludechildtask= isincludechildtask_radio[i].value;  
					}
					document.getElementById("iframe_id").style.display="";
					document.getElementById("iframe_id").src="${LUI_ContextPath}/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=listPriviewResult"
					+"&objType="+analyzeObjType
					+"&fdStartDate="+analyzeStartDate
					+"&fdEndDate="+analyzeEndDate
					+"&boundIds="+fdBoundIds
					+"&analyzeType="+analyzeType
					+"&type="+analyzeType
					+"&isincludechild="+isincludechild
					+"&isincludechildtask="+isincludechildtask
					+"&dateQueryType="+dateQueryType;
				};
			});
		</script>
		<html:form action="/sys/task/sys_task_analyze/sysTaskAnalyze.do">
			<html:hidden property="fdId"/>
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" style="padding-top: 10px;">
				<table class="tb_normal" width=100%>	
					<tr>
						<%--报表名称--%>
						<td class="td_normal_title" width=15% >
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.docSubject"/>
						</td>
						<td  colspan=3>
							<xform:text property="docSubject" style="width:97%;" ></xform:text>
						</td>
					</tr>
					<tr>
						<%--对象类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.type"/>
						</td>
						<td width=35%>
							<sunbor:enums enumsType="sysTaskAnalyze_analyzeObj_type"  elementType = "radio" property="fdAnalyzeObjType"  />
						</td>
						<%--报表类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyze.type"/>
						</td>
						<td width=35%>
							<sunbor:enums enumsType="sysTaskFreedback_analyze_type"  elementType = "radio" property="fdAnalyzeType" />
						</td>
					</tr>	
					<tr>
						<%--对象范围--%>
						<td class="td_normal_title" width="15%" >
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.bound"/>
						</td>
						<td colspan="3">
							<html:hidden property="fdBoundIds"/>
							<xform:address style="width:97%;"  subject="${lfn:message('sys-task:sysTaskAnalyze.analyzeObj.bound') }" propertyId="fdBoundIds" propertyName="fdBoundNames" isLoadDataDict="false" required="true" mulSelect="true"></xform:address>
						</td>
					</tr>
					<tr>
						<%--是否包括所有子部门（包含个人） --%>
	    			 	<td class="td_normal_title" width="15%" >
	    			 		<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechild"/>
	    			 	</td>
						<td width="35%">
	     					<sunbor:enums enumsType="sysTaskAnalyze_fdIsincludechild"  elementType = "radio" property="fdIsincludechild"  />	     
	   				  	</td>
	   				  	<%-- 任务类型（是否包括子任务）--%>
	   				  	<td class="td_normal_title" width="15%">
	   				  		<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechildTask"/>
	   				  	</td>
	         			<td width="35%">
	     					<sunbor:enums enumsType="sysTaskAnalyze_fdIsincludechildTask"  elementType = "radio" property="fdIsincludechildTask"  />	     
	        			</td>
					</tr>
					<tr>
						<%-- 查询时期类型--%>
						<td colspan=4 class="td_normal_title" >
							<sunbor:multiSelectCheckbox formName="sysTaskAnalyzeForm"  enumsType="sysTaskAnalyze_fdDateQueryType" property="dateQueryTypeList"></sunbor:multiSelectCheckbox>
						</td>
					</tr>
					<tr>
						<%--开始日期--%>
	       				<td class="td_normal_title" width="15%">
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.startDate"/>
		    			</td>
		    			<td width=35%>
		    				<xform:datetime property="fdStartDate" dateTimeType="date" style="width:95%"></xform:datetime>
		    			</td>
		    			<%--结束日期--%>
		   				<td class="td_normal_title" width="15%">
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.endDate"/>
		   				</td>
		   				<td width=35%>
		   					<xform:datetime property="fdEndDate" dateTimeType="date" style="width:95%"></xform:datetime>
		    			</td>
	   				</tr>
				</table>
				<div style="margin: 10px auto;text-align: center;">
					<%--重置--%>
					<ui:button text="${lfn:message('sys-task:button.reset') }" order="2" onclick="resetForm();">
					</ui:button>
					<%--预览--%>
					<ui:button text="${lfn:message('sys-task:button.priview') }" order="3" onclick="setIframSrc();">
					</ui:button>
				</div>
				<iframe style="display:none" id = "iframe_id" width="100%" height="100%" style="width:100%;height:100%" frameborder="0" ></iframe>
			</div>
		</html:form>
		<script type="text/javascript">
			Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");
		</script>
		<script type="text/javascript">
			$KMSSValidation();//加载校验框架
		</script>
	</template:replace>
	
</template:include>