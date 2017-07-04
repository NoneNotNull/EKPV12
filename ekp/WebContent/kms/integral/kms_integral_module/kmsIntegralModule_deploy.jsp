<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">

	function checkAndSubmit(){
		return document.kmsIntegralModuleForm.submit();
	}
	
	function changeCheck(name,check){
		var obj=document.getElementsByName(name)[0];
		if(check){
			obj.value=true;
		}else{
			obj.value=false;
		}
	}
	
	function refresh(){
		document.kmsIntegralModuleForm.action="<c:url value='/kms/integral/kms_integral_server/kmsIntegralServer.do?method=getNewList'/>";
		document.kmsIntegralModuleForm.submit();
	}

	function openChildCate(cateId,moduleId){
		var tempIndexId = cateId ;
		if(cateId == null){
			tempIndexId = moduleId ;
		}
		var flag = document.getElementsByName("flag"+tempIndexId)[0].value ;  
		var f = document.getElementById("1"+tempIndexId) ;    
		var childs = f.children;  
		if("yes" == flag && childs.length == 1){
			$.ajax({
				   type: "POST",
				   url: "<c:url value='/kms/integral/kms_integral_server/kmsIntegralServer.do?method=selectChildCate'/>"+"&fdCategoryId="+cateId+"&fdModuleId="+moduleId,
				   dataType: "json",
				   success: function(msg){
					   if(msg){
						   var data = msg.json ;
						   for(var i in data){  
							   data[i].fdName = decodeURI(data[i].fdName);
							   var node=document.getElementById("2"+tempIndexId);  
							   var insertedNode=document.createElement("div"); 	
								   var html = "<div id='1"+data[i].fdId+"'><div id='2"+data[i].fdId+"'>" ;
								    var len = data[i].fdHierarchyId.length ;
								   	do{
								   	 html += " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" ;
								   	 len = len - 33 ;
								   	}while(len>5);
								   	html += "<span style='margin-right:20px;line-height:30px;'>"+data[i].fdName ;
									html += "</span><bean:message  bundle='kms-integral' key='kms.integral.fdCateModulus'/> ：<input type='text' name='"+data[i].fdId+"' value='"+data[i].fdCateModulus+"' style='width:30px;' class='inputsgl'>" ;
									html += "<br><input type='hidden' name='flag"+data[i].fdId+"' value='yes'>	</div></div>" ; 
								  insertedNode.innerHTML = html ;  
								  node.parentNode.insertBefore(insertedNode,node.nextSibling);  
						   }  
					   }
				   } 
			});
			document.getElementsByName("flag"+tempIndexId)[0].value ="no";
		}else if("yes" == flag && childs.length > 1){
			for(var i = childs.length - 1; i >= 1; i--) {   
				childs[i].style.display = "";
			}
			document.getElementsByName("flag"+tempIndexId)[0].value ="no";
		}else{
			for(var i = childs.length - 1; i >= 1; i--) {   
				childs[i].style.display = "none";
			}
			document.getElementsByName("flag"+tempIndexId)[0].value ="yes";
		}
	}
</script>
<style>
.inputsgl{height: 20px;border: 0px;border-bottom: 1px solid #b4b4b4;}     
</style>
<form name="kmsIntegralModuleForm" action="<c:url value='/kms/integral/kms_integral_module/kmsIntegralModule.do?method=deploy'/>" method="post">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.update"/>" onclick="checkAndSubmit()">
	<input type="button" value="<bean:message bundle="kms-integral" key="kms.integral.module.refresh"/>" onclick="refresh()">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="kms-integral" key="kms.integral.module.title"/></p>


<center>
	<table class="tb_normal" width=95%>
		<input type="hidden" name="type" value="1">
		<c:forEach items="${kmsIntegralServerList}" var="server">
			<tr>
				<td class="td_normal_title" style="background-color: rgb(231, 244, 252)">
					<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdName"/> 
				</td>
				<td class="td_normal_title" style="background-color: rgb(231, 244, 252)">
					${server.fdName}
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" style="width:15%">
					<bean:message  bundle="kms-integral" key="kms.integral.module.moduleList"/>
				</td>
				<td>	
					<c:forEach items="${server.kmsIntegralModuleList}" var="module">
					        <div id="1${module.fdId}"> 
					        <div id="2${module.fdId}">
							<span style="margin-right:20px;line-height:30px;">
							<input type="hidden" id="${module.modelName}" name="${module.kmsIntegralServer.fdId}${module.modelName}" value="${module.fdStartOrStop}"/>
							<input type="checkbox" name="${module.kmsIntegralServer.fdId}${module.modelName}"  <c:if test="${module.fdStartOrStop eq true}">checked</c:if> onclick="changeCheck(this.name,this.checked)"/>
							${module.fdName}</span><bean:message  bundle='kms-integral' key='kms.integral.fdCateModulus'/>：<input type="text" name="${module.fdId}fdModuleModulus" value="${module.fdModuleModulus}" style="width:50px;" class="inputsgl">
							<c:if test="${module.fdHaveCategory==true}"><a href="javascript:void(0);" onclick="openChildCate(null,'${module.fdId}');" style="cursor:pointer;color:green;">	<bean:message  bundle="kms-integral" key="kms.integral.cate.set"/></a></c:if>
							<br>
							<input type="hidden" name="flag${module.fdId}" value="yes">
							</div>
							</div>	
					</c:forEach>
				</td>
			</tr>				
		</c:forEach>
		<tr>
			<td class="td_normal_title" style="width:15%">
				<bean:message  bundle="kms-integral" key="kms.integral.module.description"/>
			</td>
			<td>	
				<span class="txtstrong">*</span><bean:message  bundle="kms-integral" key="kms.integral.module.description1"/><br>
				<span class="txtstrong">*</span><bean:message  bundle="kms-integral" key="kms.integral.module.description2"/><br>
				<span class="txtstrong">*</span><bean:message  bundle="kms-integral" key="kms.integral.module.description3"/><br>
				<span class="txtstrong">*</span><bean:message  bundle="kms-integral" key="kms.integral.module.description4"/><br>
				<span class="txtstrong">*</span><bean:message  bundle="kms-integral" key="kms.integral.module.description5"/>
			</td>
		</tr>			
	</table>
</center>
</form>

<%@ include file="/resource/jsp/edit_down.jsp"%>
