<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="java.util.List"%>
<script language="JavaScript">
	Com_IncludeFile("doclist.js|dialog.js");
	function openExpertWindow(){
		  Dialog_TreeList(false, 'kmsExpertTypeId', 'kmsExpertTypeName', ';', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-expert"/>', 'kmsExpertTypeListService&expertTypeId=!{value}');
	}
	//重新获取人员信息
 	function getPersonInfo(rtnVal){
	    if(rtnVal==null)
	      return;
	    var fdPerId = rtnVal.GetHashMapArray()[0].id;
	    var flag = true ;
	    $.ajax({
			url : '<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />',
			data: {
				method : 'checkFdPerId',
				fdPerId : fdPerId
			},
			cache: false,
			async: false, 
			success: function(data){
				if(data=='true'){
					flag = false ;
					alert("专家已经存在！请重新选择！");
					document.getElementsByName("fdPersonId")[0].value="";
					document.getElementsByName("fdName")[0].value="";
				} 
			},
			error: function(){}
		});
		if(flag){
	    	var url = location.href;
	   		url = Com_SetUrlParameter(url,"method","add");
	   		// 兼容chrome浏览器--解决无法在当前窗口打开新页面的问题
	   		url = Com_SetUrlParameter(url,"fdPersonId",fdPerId);
			setTimeout('location="' + url + '";',100);
		}
  	}
	function typeChange(type){
		var SPAN_InnerID = document.getElementById("SPAN_InnerID");
		var SPAN_OuterID = document.getElementById("SPAN_OuterID");
		var fdPersonId = document.getElementsByName("fdPersonId")[0];
		var fdName = document.getElementsByName("fdName")[0];
		var fdOutName = document.getElementsByName("fdOutName")[0];
		var fdDeptName = document.getElementsByName("fdDeptName")[0];
		var fdPostNames = document.getElementsByName("fdPostNames")[0];
		var fdRtxNo = document.getElementsByName("fdRtxNo")[0];
		var fdQqNumber = document.getElementsByName("fdQqNumber")[0];
		var fdMsnNumber = document.getElementsByName("fdMsnNumber")[0];
		var fdWorkPhone = document.getElementsByName("fdWorkPhone")[0];
		var fdEmail = document.getElementsByName("fdEmail")[0];
		var fdMobileNo = document.getElementsByName("fdMobileNo")[0];
		var InnerRtxNO = document.getElementById("InnerRtxNO");
		if(type=='true'){
			SPAN_InnerID.style.display="";
			SPAN_OuterID.style.display="none";
			fdWorkPhone.readOnly=true;
			fdWorkPhone.style.borderBottomStyle = "none";
			fdWorkPhone.style.color="black";
			fdEmail.readOnly=true;
			fdEmail.style.borderBottomStyle = "none";
			fdEmail.style.color="black";
			fdMobileNo.readOnly=true;
			fdMobileNo.style.borderBottomStyle = "none";
			fdMobileNo.style.color="black";
			fdRtxNo.readOnly=true;
			fdRtxNo.style.borderBottomStyle = "none";
			fdRtxNo.style.color="black";
			InnerRtxNO.style.display="";
		}else{
			SPAN_InnerID.style.display="none";
			SPAN_OuterID.style.display="";
			fdWorkPhone.readOnly=false;
			fdWorkPhone.style.borderBottomStyle = "";
			fdWorkPhone.style.color="#0066FF";
			fdEmail.readOnly=false;
			fdEmail.style.borderBottomStyle = "";
			fdEmail.style.color="#0066FF";
			fdMobileNo.readOnly=false;
			fdMobileNo.style.borderBottomStyle = "";
			fdMobileNo.style.color="#0066FF";
			fdRtxNo.readOnly=true;
			fdRtxNo.style.borderBottomStyle = "none";
			InnerRtxNO.style.display="none";
		}
		if(${kmsExpertInfoForm.method_GET!='edit'} && Com_GetUrlParameter(location.href,"fdPersonId")==null){
			fdPersonId.value="";
			fdName.value="";
			fdOutName.value="";
			fdDeptName.value="";
			fdPostNames.value="";
			fdRtxNo.value="";
			fdQqNumber.value="";
			fdMsnNumber.value="";
			fdWorkPhone.value="";
			fdMobileNo.value="";
			fdEmail.value="";
		}
	}
	function checkName(type){ 
		var fdName = document.getElementsByName("fdName")[0];
		var fdOutName = document.getElementsByName("fdOutName")[0];
		var kmsExpertTypeId = document.getElementsByName("kmsExpertTypeId")[0];
		var fdEmail = document.getElementsByName("fdEmail")[0];
		var fdMsnNumber = document.getElementsByName("fdMsnNumber")[0];
		var SPAN_InnerID = document.getElementById("SPAN_InnerID");
		var checkmail = /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;
		if((type=="update"||type=="save"||type=="saveadd")&&SPAN_InnerID.style.display==""){
			 
			if(fdName.value==""){
				alert("<bean:message bundle="kms-expert" key="error.kmsExpertInfo.fdName.isNull" />");
				
				return false;
			}
		}else if(SPAN_InnerID.style.display=="none"){
			if(fdOutName.value==""){
				alert("<bean:message bundle="kms-expert" key="error.kmsExpertInfo.fdName.isNull" />");
				return false;
			}
		}
		 
		if(fdEmail.value!=""){ 
			if (!(checkmail.test(fdEmail.value))){ 
				alert("<bean:message bundle="kms-expert" key="kmsExpert.error.msg.email" />"); 
				return false;
			}
		}
		if(fdMsnNumber.value!=""){ 
			if (!(checkmail.test(fdMsnNumber.value))){ 
				alert("<bean:message bundle="kms-expert" key="kmsExpert.error.msg.msn" />"); 
				return false;
			}
		}
		if(kmsExpertTypeId.value==""){
			alert("<bean:message bundle="kms-expert" key="kmsExpert.error.msg.expert" />"); 
			return false;
		}
		Com_Submit(document.kmsExpertInfoForm,type);
	}
	window.onload = function(){
		//debugger;
		/*typeChange();	*/
		if(${kmsExpertInfoForm.method_GET=='edit'}){
			LKSTree = new TreeView("LKSTree", "<bean:write name="kmsExpertInfoForm" property="fdDeptName" />", document.getElementById("treeDiv"));
			var n1 = LKSTree.treeRoot;
			n1.nodeType = ORG_TYPE_DEPT;
			n1.AppendBeanData("kmsExperDepartView&fdId=${kmsExpertInfoForm.fdPersonId}",null,null,false,null);
			LKSTree.Show();
		}
		
  	}

	function SetDivSize() {
		var div = document.getElementById("_dept_div");
		var td = document.getElementById("_person_td");
		div.style.width = td.offsetWidth - 2 + 'px';
		div.style.height = td.offsetHeight + 'px';
	}
	function SetDivWidth() {
		var div = document.getElementById("_dept_div");
		var td = document.getElementById("_person_td");
		div.style.width = td.offsetWidth - 2 + 'px';
	}
	Com_AddEventListener(window, 'load', SetDivSize);
	Com_AddEventListener(window, 'resize', SetDivWidth);
</script>
<html:form action="/kms/expert/kms_expert_info/kmsExpertInfo.do">
	<div id="optBarDiv">
		<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
			<input type=button value="<bean:message key="button.update" />" onclick="checkName('update');">
		</c:if>
		<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
			<input type=button value="<bean:message key="button.save" />" onclick="checkName('save');">
			<input type=button value="<bean:message key="button.saveadd"/>" onclick="checkName('saveadd');">
		</c:if>
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle">
		<bean:message bundle="kms-expert" key="kmsExpert.expertInfo.title" />
	</p>
	<center>
	<table class="tb_normal" width=95%>
		<html:hidden property="fdId" />
      	<tr>
		    <td class="td_normal_title" colspan="4">
		        <bean:message bundle="kms-expert" key="kmsExpert.expertInfo.summaryinfo" />
		    </td>     
		</tr>
		<tr>
			<td width=50% valign="middle" align="center" colspan="2" id="_person_td">
	        	<table class="tb_noborder" width="100%">
	        		<tr>
	        			<td align="left" valign="top" width="200" height="160">
						  	<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="spic"/>
							<c:param name="fdAttType" value="pic"/>
							<c:param name="fdShowMsg" value="true"/>
							<c:param name="fdMulti" value="false"/>
							<c:param name="fdImgHtmlProperty" value="width=150 height=150"/>
							<c:param name="fdModelId" value="${param.fdId }"/>
							<c:param name="fdModelName" value="com.landray.kmss.kms.expert.model.KmsExpertInfo"/>
							</c:import> 
        				</td>
	        			<td valign="top">
	        			<html:hidden property="fdCreateTime" />
	        		        <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.name" /></b>
					        <span id="SPAN_InnerID"> 
					            <html:hidden property="fdPersonId" value="${kmsExpertInfoForm.fdPersonId}" /> 
					            <c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
						            <html:text property="fdName" readonly="true"  styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdName}"/>
						            <span class="txtstrong">*</span>
						            <a href="#" onclick="Dialog_Address(false, 'fdPersonId','fdName', ',', ORG_TYPE_PERSON, getPersonInfo);">
						            <bean:message key="dialog.selectOrg" /></a><br> 
						            <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></b>
						            <html:text property="fdDeptName" readonly="true" value="${kmsExpertInfoForm.fdDeptName}" style="width:85%;"/><br>
						            <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></b>
						            <html:text property="fdPostNames" readonly="true" value="${kmsExpertInfoForm.fdPostNames}" style="width:85%;"/>
						         </c:if>
					             <c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
						            <html:text property="fdName" readonly="true" /><br>            
						            <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></b>
						            ${kmsExpertInfoForm.fdDeptName}<br>
						            <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></b>
						            <% 
								  		List postList = (List)request.getAttribute("posts");
									    if(postList.size()!=0){
								  	%>     	 	
									<c:forEach items="${posts}" var="post"  varStatus="status">
							        	<c:out value="${post}" /><br>
							        	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>        	
							        </c:forEach>
							        <%
									    }
									%>
								</c:if>
								<br>
						        <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.sex" /></b>
							        <c:if test="${kmsExpertInfoForm.fdSex!=null&&kmsExpertInfoForm.fdSex!='' }">
							        	<sunbor:enumsShow value="${kmsExpertInfoForm.fdSex }" enumsType="kmsExpert_personInfo_sex" />
							        </c:if>
								<BR>
								<br><br>
					        </span> 
					        <span id="SPAN_OuterID">
						         <html:text property="fdOutName" style="width:45%;" /><span class="txtstrong">*</span><br>
						         <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.department" /></b>
						         <html:text property="fdDeptName" readonly="true" /><br>
						         <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.post" /></b>
						         <html:text property="fdPostNames" readonly="true" /><br>
						         <b><bean:message bundle="kms-expert" key="kmsExpert.expertInfo.person.sex" /></b>
							         <xform:select property="fdSex" value="${(kmsExpertInfoForm.fdSex==null||kmsExpertInfoForm.fdSex=='')?'1':(kmsExpertInfoForm.fdSex)}">
				        				<xform:enumsDataSource enumsType="kmsExpert_personInfo_sex"></xform:enumsDataSource>		        			
				        			</xform:select>
						         <br><br>
					        </span>
	        			</td>
	        		</tr> 
	        		<tr>
		         		<td colspan="2">
		         			<hr>
		        		</td>
        			</tr>
					<tr>
		         		<td colspan="2">
		         			<table class="tb_noborder" width="100%">
		         				<tr>
		         					<td width="50%">
					         			<b><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdMobile" /></b>
										<c:if test="${kmsExpertInfoForm.method_GET!='edit'}"> 
											<html:text property="fdMobileNo" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdMobileNo }"/><br>
										</c:if>
										<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
										  		<html:text property="fdMobileNo" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdMobileNo}"/><br>
										</c:if>  
								    </td>
							        <td width="50%">
					    		       	<b><bean:message bundle="kms-expert" key="kmsExpert.comtele" /></b>
										<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
										   	<html:text property="fdWorkPhone" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdWorkPhone}"/><br>
										</c:if>
										<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
											    <html:text property="fdWorkPhone" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdWorkPhone}"/><br>
										
										</c:if>
								    </td>
								<tr>
									<td>
								       	<b><bean:message bundle="kms-expert" key="kmsExpert.qq" /></b>
		        						<html:text property="fdQqNumber"   styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdQqNumber}"/><br>
								    </td>
								    <td>
								    	<span id="InnerRtxNO">
								        	<b><bean:message bundle="kms-expert" key="kmsExpert.rtx" /></b>
								        </span>
										<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
										    <html:text property="fdRtxNo" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdRtxNo}"/>
										</c:if>
										<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
											    <html:text property="fdRtxNo" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdRtxNo}"/>
											
										</c:if>  
								    </td>
								</tr>
								<tr>
									<td>
								      	<b><bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdEmail" /></b>
										<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
										    <html:text property="fdEmail" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdEmail}"/><br>
										</c:if>
										<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
											   	<html:text property="fdEmail" styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdEmail}"/><br>
								      	</c:if>
									</td>
									<td> 
								        <b><bean:message bundle="kms-expert" key="kmsExpert.msn" /></b>
		       							<html:text property="fdMsnNumber"   styleClass="inputsgl" style="width:45%;" value="${kmsExpertInfoForm.fdMsnNumber}"/><br>
									</td>
						     	</tr>
						     </table>
		        		</td>
		        	</tr>
	        	</table>
			</td>  
		    <td width=50% valign="top" colspan="2">
		        <table class="tb_noborder" width="100%">
					<tr>
						<td>
							<div id="_dept_div" style="overflow: auto;width: 100%;height: 200px;"><div id="treeDiv"></div></div>
						</td>
					</tr>
				</table>
     		</td>
    	</tr>
		    <tr>
		      <td class="td_normal_title" colspan="4">
		        <bean:message bundle="kms-expert" key="kmsExpert.expertInfo.title" />
		      </td>     
		    </tr>
			<tr>
		        <td width=15% class="td_normal_title">
		          <bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />
		        </td>
		        <td width=35% colspan="3">
		          <html:hidden property="kmsExpertTypeId" />
		          <html:text property="kmsExpertTypeName" readonly="true" style="width:85%;" styleClass="inputsgl" />
		          <span class="txtstrong">*</span> <a href="#" id="selectAreaNames" onclick="openExpertWindow();"><bean:message key="dialog.selectOther" /></a>
		        </td>
			</tr>
			<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
				<c:import url="/kms/expert/kms_expert_area/kmsExpertArea_add.jsp"
					charEncoding="UTF-8">
					<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
					<c:param name="treeBean" value="${kmsExpertArea.treeBean}" />
					<c:param name="index" value="${vstatus.index}" />
					<c:param name="fdModelName" value="${ kmsExpertArea.uuid}" />
				</c:import>
			</c:forEach>
		    <tr>
		    	<td width=15% class="td_normal_title">
		    		<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdOrder" />
		    	</td>
		    	<td colspan="3">
		    		<html:text property="fdOrder" style="width:95%" />
		    	</td>
		    </tr>
		    <tr>
				<td width=15% class="td_normal_title">
					<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdBackground" />
				</td>
				<td colspan=3>
					<html:textarea property="fdBackground" style="width:95%" />
				</td>
			</tr>
		</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
