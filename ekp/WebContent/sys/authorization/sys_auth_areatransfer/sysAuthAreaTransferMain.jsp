<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>	
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.authorization.model.SysAuthAreaTransferInfo"%>
<kmss:windowTitle subjectKey="sys-authorization:sysAuthAreaTransfer.business.transfer" moduleKey="sys-authorization:authorization.moduleName" />
<script>
Com_IncludeFile("jquery.js|json2.js|popdialog.js|dialog.js");
</script>
<script type="text/javascript" src="<c:url value="/sys/admin/resource/js/ajaxSyncComponent.js"/>"></script>
<p class="txttitle"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.transfer" /></p>
<html:form action="/sys/authorization/sysAuthAreaTransfer.do">
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.area.type"/>
		</td><td>
            <xform:radio property="transferAreaType" value="false" showStatus="edit" onValueChange="chooesType(this.value);">
				<xform:enumsDataSource enumsType="sys_authorization_transfer_area_type" />
			</xform:radio> 
		</td>
	</tr>
	<tr id="aimArea" style="display: none">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.aim.area"/>
		</td><td>
            <xform:dialog propertyId="fdAreaId" propertyName="fdAreaName" showStatus="edit" style="width: 65%" required="true" >
				Dialog_Tree(false,'fdAreaId','fdAreaName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,null);
			</xform:dialog>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.option"/>
		</td><td>
			<input type="checkbox" name="transferOption" value="true" checked />
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.option.txt"/>
		</td>
	</tr>		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.modules"/>
		</td><td colspan="3" width="85%">
	<table class="tb_normal" width=95% id="table_result">
	<tr>
		<td width="30%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.moduleName" /></td>
		<td width="20%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.result" /></td>
		<td width="30%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.moduleName" /></td>
		<td width="20%" align="center" class="td_normal_title"><bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.result" /></td>
	</tr>

	<c:forEach items="${moduleList}" var="element" varStatus="status" step="2">
		<tr>
			<td style="border:0;" width="25%">
				<label>
					<input type="checkbox" name="fdModulePath" value="${moduleList[status.index]['urlPrefix']}" onclick="selectElement(this);" />
					<c:out value="${moduleList[status.index]['name']}" />
				</label>
			</td>
			<td style="border:0;">
			    <span id="result_${moduleList[status.index]['urlPrefix']}"> </span>
		    </td>
		    
			<td style="border-right:0;border-top:0;border-bottom:0;" width="25%">
			<c:if test="${moduleList[status.index+1] != null}">
				<label>
					<input type="checkbox" name="fdModulePath" value="${moduleList[status.index+1]['urlPrefix']}" onclick="selectElement(this);" />
					<c:out value="${moduleList[status.index+1]['name']}" />
				</label>
			</c:if>		
			</td>
			<td style="border:0">
			<c:if test="${moduleList[status.index+1] != null}">
			    <span id="result_${moduleList[status.index+1]['urlPrefix']}"> </span>
			</c:if>	    
		    </td>	
		                            
		</tr>
	</c:forEach>	
</table>
			&nbsp;<input type="checkbox" name="fdAllModulePaths" onclick="selectAll(this);" /><bean:message key="sysAuthAreaTransfer.selectAll" bundle="sys-authorization" />
		</td>
	</tr>	
</table>
<table width=95%>
	<tr align="left">
		<td>
			<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.remark"/>
		</td>	
	</tr>
</table>
<kmss:auth requestURL="/sys/admin/resource/jsp/jsonp.jsp">
<table width=95%>
	<tr>
		<td align="right">
			<span id="progress1" style="color: red"></span>
		</td>
		<td align="right" width="10%">
			<input id="btnTransfer" class="btnopt" type="button" value="<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.start" />" style="height:20px" 
				onclick="startTransfer()">
		</td>
		<td align="right" width="1%">
			<input id="btnBack" class="btnopt" type="button" value="<bean:message key="button.back"/>" style="height:20px" 
				onclick="window.location='${KMSS_Parameter_ContextPath}/sys/authorization/sysAuthAreaTransfer.do?method=guide&back=true'">
		</td>			
	</tr>
</table>
</kmss:auth>
</center>
</html:form>
<script>
/*
function TR_Onmousein(rowObj){
	rowObj.style.background = '#DFDFDF';
}
function TR_Onmouseout(rowObj){
	rowObj.style.background = '#FFFFFF';
}
*/
function chooesType(value) {
	var _transferAreaType = document.getElementsByName("transferAreaType");
	var aimArea = document.getElementById("aimArea");
	
	if(_transferAreaType[0].checked) {
		aimArea.style.display = 'none';
	} else {
		aimArea.style.display = '';
	}
}
//全选
function selectAll(obj) {
	var _fdModulePath = document.getElementsByName("fdModulePath");
	for(var i = 0; i < _fdModulePath.length; i++){
		if(obj.checked) {
			_fdModulePath[i].checked = true;
		} else {
			_fdModulePath[i].checked = false;
		}
	}
	
	var _fdAllModulePaths = document.getElementsByName("fdAllModulePaths");
	if(obj.checked) {
		_fdAllModulePaths[0].checked = true;
	} else {
		_fdAllModulePaths[0].checked = false;
	}
}
//单个的选择
function selectElement(element){
	var _fdAllModulePaths = document.getElementsByName("fdAllModulePaths");
	if(element && !element.checked){
		_fdAllModulePaths[0].checked = false;
	} else {
		var flag = true;
		var _fdModulePath = document.getElementsByName("fdModulePath");
		for (var j = 0; j < _fdModulePath.length; j++){
			if(!_fdModulePath[j].checked){
				flag = false;
				break;
			}
		}
		if(flag) { //勾选全选
			_fdAllModulePaths[0].checked = true;
		} else {
			_fdAllModulePaths[0].checked = false;
		}
	}
}
Lang = {
	noSelect: '<bean:message bundle="sys-authorization" key ="sysAuthAreaTransfer.noSelect" />',
	comfirmTransfer: '<bean:message bundle="sys-authorization" key ="sysAuthAreaTransfer.business.comfirm" />',
	comfirmStop: '<bean:message bundle="sys-authorization" key ="sysAuthAreaTransfer.stop.transfer.comfirm" />',
	waitting: '<bean:message bundle="sys-authorization" key ="sysAuthAreaTransfer.waitting" />',
	running: '<bean:message bundle="sys-authorization" key ="sysAuthAreaTransfer.running" />',
	start: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.start" />',
	restart: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.restart" />',	
	stop: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.business.stop" />',
	success: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.success" />',
	failure: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.failure" />',
	transferProgress: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.transferProgress" />',
	aimAreaIsNull: '<bean:message bundle="sys-authorization" key="sysAuthAreaTransfer.aim.area.isnull" />'
};

//迁移数据
function transfer() { 
	var component = ajaxSyncComponent(Com_Parameter.ContextPath+"sys/admin/resource/jsp/jsonp.jsp?s_bean=sysAuthAreaTransferService");
	component.addData({});

	component.afterResponse = function(obj) { // 响应后事件
      if(obj.SUCCESS.length > 0 || obj.FAILURE.length > 0 || obj.WAITTING.length > 0 
    		  || obj.RUNNING.length > 0 || obj.STOP.length > 0) {
          
    	  if(obj.IS_SAME_AREA) {
    		  $(":radio[name='transferAreaType']")[1].checked = true;
    		  $("[id=aimArea]").attr("style", "display:block");
    	  } else {
    		  $(":radio[name='transferAreaType']")[0].checked = true;
    		  $("[id=aimArea]").attr("style", "display:none");
    	  }

    	  $(":input[name='fdAreaId']").attr("value", obj.AREA_ID);
          $(":input[name='fdAreaName']").attr("value", obj.AREA_NAME);
          $(":checkbox[name='transferOption']").attr("checked", obj.IS_TRANSFER_NOT_NULL);   

          for(var i = 0; i < obj.ALL.length; i++) { 
  			$(":checkbox[value='" + obj.ALL[i] + "']").attr("checked", true);     
          }
          for(var i = 0; i < obj.SUCCESS.length; i++) { 
  			$("[id='result_" + obj.SUCCESS[i] + "']").css("color","#000DFF").html(Lang.success);      
          }
          for(var i = 0; i < obj.FAILURE.length; i++) { 
          	$("[id='result_" + obj.FAILURE[i] + "']").css("color","red").html(Lang.failure);      
          }     
          for(var i = 0; i < obj.WAITTING.length; i++) { 
          	$("[id='result_" + obj.WAITTING[i] + "']").css("color","#000000").html(Lang.waitting);      
          }  
          for(var i = 0; i < obj.RUNNING.length; i++) { 
          	$("[id='result_" + obj.RUNNING[i] + "']").css("color","#000000").html(Lang.running);      
          }  
          for(var i = 0; i < obj.STOP.length; i++) { 
          	$("[id='result_" + obj.STOP[i] + "']").css("color","#000000").html(Lang.stop);      
          } 

          $(":checkbox[name='fdModulePath']").attr("disabled", true);
          $(":checkbox[name='fdAllModulePaths']").attr("disabled", true);
          $(":radio[name='transferAreaType']").attr("disabled", true);
          $(":checkbox[name='transferOption']").attr("disabled", true);
          $("a").attr("style", "display:none");    

          // 更新进度
          var percent = Math.round((obj.SUCCESS.length + obj.FAILURE.length)*100 / obj.ALL.length);
          $("#progress1").html(Lang.transferProgress+percent+"%");
          
          stopTransfer(obj);
          restartTransfer(obj);
                      	  
      }            
    }

	component.traverse();
}

function stopTransfer(obj) {
      var stop = function () {
	        //comp.stop();  
          if(!confirm(Lang.comfirmStop)) {
	            return;
          }		

          //clearInterval(timer);
          Com_Submit(document.sysAuthAreaTransferForm, 'stopTransfer');
      }; 
        
      $("[id=btnTransfer]").attr("value", Lang.stop);
      $("[id=btnTransfer]").unbind('click'); 
      $("[id=btnTransfer]").attr("onclick", "").click(stop); 
      $("[id=btnBack]").attr("style", "display:none"); 	
}

function restartTransfer(obj) {
	  var len = obj.SUCCESS.length + obj.FAILURE.length + obj.RUNNING.length + obj.STOP.length;
	  
      if(obj.WAITTING.length == 0 && obj.ALL.length == len) {
          var restart = function () {
              Com_Submit(document.sysAuthAreaTransferForm, 'restartTransfer');
          }; 
                      
    	  $("[id=btnTransfer]").attr("value", Lang.restart);
          $("[id=btnTransfer]").unbind('click'); 
    	  $("[id=btnTransfer]").attr("onclick", "").click(restart);
    	  $("[id=btnBack]").attr("style", "display:block");
      }    
}

function startTransfer()
{
	var _transferAreaType = document.getElementsByName("transferAreaType");
	if(_transferAreaType[1].checked) {
		var _fdAreaId = document.getElementsByName("fdAreaId")[0].value;
		var _fdAreaName = document.getElementsByName("fdAreaName")[0].value;

		if(_fdAreaId == null || _fdAreaId.length == 0 || 
				_fdAreaName == null || _fdAreaName.length == 0) {
			alert(Lang.aimAreaIsNull);
			return;	
		}
	} 
	
	if($(":checkbox:checked[name='fdModulePath']").length == 0) {
		alert(Lang.noSelect);
		return;
	}	
		
	if(!confirm(Lang.comfirmTransfer)) {
		return;
	}

	transfer();
	Com_Submit(document.sysAuthAreaTransferForm, 'transfer');
}

window.onload = function () {
	transfer();
	timer=setInterval("transfer()", 6000); // 6秒刷新
}

</script>
<%@ include file="/sys/config/resource/edit_down.jsp"%>