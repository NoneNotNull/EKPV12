<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="auto">
<template:replace name="toolbar">
	<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
		<c:if test="${kmImissiveTemplateCfgForm.method_GET=='edit'}">
		    <ui:button text="提交" order="2" onclick="submitMethod('update');">
		    </ui:button>
		</c:if>
		<c:if test="${kmImissiveTemplateCfgForm.method_GET=='add'||kmImissiveTemplateCfgForm.method_GET=='clone'}">
	  	    <ui:button text="保存" order="1" onclick="submitMethod('save');">
		    </ui:button>
		    <ui:button text="保存并新建" order="2" onclick="submitMethod('saveadd');">
		    </ui:button>
		</c:if>
		 <ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		 </ui:button>
	</ui:toolbar>
</template:replace>
<template:replace name="content">
<script language="JavaScript">
function submitMethod(method){
	var formObj = document.kmImissiveTemplateCfgForm;
	var fdCfgType,fdOneId,fdTwoId;
	var fdType = document.getElementsByName("fdType");
	for(var i=0;i<fdType.length;i++){
		if(fdType[i].checked){
			fdCfgType=fdType[i].value;
			if(fdType[i].value=='SR'){
				fdOneId = document.getElementsByName("fdSendTempOneId")[0].value;
				fdTwoId = document.getElementsByName("fdReceiveTempTwoId")[0].value;
			}
			if(fdType[i].value=='RS'){
				fdOneId = document.getElementsByName("fdReceiveTempOneId")[0].value;
				fdTwoId = document.getElementsByName("fdSendTempTwoId")[0].value;
			}
			if(fdType[i].value=='RR'){
				fdOneId = document.getElementsByName("fdReceiveTempOneId")[0].value;
				fdTwoId = document.getElementsByName("fdReceiveTempTwoId")[0].value;
			}
	    }
	}
	 var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do?method=checkUnique"; 
	 if(fdOneId!=""&&fdTwoId!=""){
		 $.ajax({     
		     type:"post",     
		     url:url,     
		     data:{fdOneId:fdOneId,fdTwoId:fdTwoId,fdCfgType:fdCfgType},    
		     async:false,    //用同步方式 
		     success:function(data){
		 	    var results =  eval("("+data+")");
			    if(results['repeat'] =='true'){
			    	alert("该交换配置已存在");
			    	return;
				}else{
					var formObj = document.kmImissiveTemplateCfgForm;
			    	Com_Submit(formObj, method);
				}
			}    
	    });	
	}else{
		alert("请填写目标和来源");
	}
}

function selcetSendOne(){
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		dialog.category('com.landray.kmss.km.imissive.model.KmImissiveSendTemplate','fdSendTempOneId','fdSendTempOneName',false,null,"选择发文模板");
    });
}
function selcetSendTwo(){
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		dialog.category('com.landray.kmss.km.imissive.model.KmImissiveSendTemplate','fdSendTempTwoId','fdSendTempTwoName',false,null,"选择发文模板");
    });
}
function selcetReceiveOne(){
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		dialog.category('com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate','fdReceiveTempOneId','fdReceiveTempOneName',false,null,"选择收文模板");
    });
}
function selcetReceiveTwo(){
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		dialog.category('com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate','fdReceiveTempTwoId','fdReceiveTempTwoName',false,null,"选择收文模板");
    });
}
function changeType(value){
	//移除校验
	 document.getElementById("s1").setAttribute("validate", "");
	 document.getElementById("s2").setAttribute("validate", "");
	 document.getElementById("r1").setAttribute("validate", "");
	 document.getElementById("r2").setAttribute("validate", "");
	 $("#s1").parent().parent().unbind("click"); //移除click
	 $("#s2").parent().parent().unbind("click"); //移除click
	 $("#r1").parent().parent().unbind("click"); //移除click
	 $("#r2").parent().parent().unbind("click"); //移除click
	 $("#send1").hide();
	 $("#receive1").hide();
	 $("#send2").hide();
	 $("#receive2").hide();
	 //切换转换类型时，清空值
	document.getElementsByName("fdSendTempOneId")[0].value = "";
	document.getElementsByName("fdSendTempOneName")[0].value="";
	document.getElementsByName("fdSendTempTwoId")[0].value = "";
	document.getElementsByName("fdSendTempTwoName")[0].value="";
	document.getElementsByName("fdReceiveTempOneId")[0].value = "";
	document.getElementsByName("fdReceiveTempOneName")[0].value="";
	document.getElementsByName("fdReceiveTempTwoId")[0].value = "";
	document.getElementsByName("fdReceiveTempTwoName")[0].value="";
	if(value == "SR"){
		$("#send1").show();
		$("#receive2").show();
		document.getElementById("s1").setAttribute("validate", "required");
		document.getElementById("r2").setAttribute("validate", "required");
	  $("#s1").parent().parent().click(function(){
			selcetSendOne();
      });
	  $("#r2").parent().parent().click(function(){
		  selcetReceiveTwo();
      });
	}
	if(value == "RS"){
		$("#send2").show();
		$("#receive1").show();
		document.getElementById("r1").setAttribute("validate", "required");
		document.getElementById("s2").setAttribute("validate", "required");
	  $("#r1").parent().parent().click(function(){
		 selcetReceiveOne();
      });
	  $("#s2").parent().parent().click(function(){
		  selcetSendTwo();
      });
	}
	if(value == "RR"){
		$("#receive2").show();
		$("#receive1").show();
		document.getElementById("r1").setAttribute("validate", "required");
		document.getElementById("r2").setAttribute("validate", "required");
	  $("#r1").parent().parent().click(function(){
			 selcetReceiveOne();
	   });
	  $("#r2").parent().parent().click(function(){
			 selcetReceiveTwo();
	  });
	}
	if(value == "SS"){
		$("#send1").show();
		$("#send2").show();
		document.getElementById("s1").setAttribute("validate", "required");
		document.getElementById("s2").setAttribute("validate", "required");
      $("#s1").parent().parent().click(function(){
			  selcetSendOne();
	   });
      $("#s2").parent().parent().click(function(){
			  selcetSendTwo();
	  });
	}
}
//编辑的时候初始化
function intType(value){
	 document.getElementById("s1").setAttribute("validate", "");
	 document.getElementById("s2").setAttribute("validate", "");
	 document.getElementById("r1").setAttribute("validate", "");
	 document.getElementById("r2").setAttribute("validate", "");
	 $("#s1").parent().parent().unbind("click"); //移除click
	 $("#s2").parent().parent().unbind("click"); //移除click
	 $("#r1").parent().parent().unbind("click"); //移除click
	 $("#r2").parent().parent().unbind("click"); //移除click
	 $("#send1").hide();
	 $("#receive1").hide();
	 $("#send2").hide();
	 $("#receive2").hide();
	if(value == "SR"){
		document.getElementsByName("fdSendTempTwoId")[0].value = "";
		document.getElementsByName("fdSendTempTwoName")[0].value="";
		document.getElementsByName("fdReceiveTempOneId")[0].value = "";
		document.getElementsByName("fdReceiveTempOneName")[0].value="";
		$("#send1").show();
		$("#receive2").show();
		document.getElementById("s1").setAttribute("validate", "required");
		document.getElementById("r2").setAttribute("validate", "required");
	  $("#s1").parent().parent().click(function(){
			selcetSendOne();
    });
	  $("#r2").parent().parent().click(function(){
		  selcetReceiveTwo();
    });
	}
	if(value == "RS"){
		document.getElementsByName("fdSendTempOneId")[0].value = "";
		document.getElementsByName("fdSendTempOneName")[0].value="";
		document.getElementsByName("fdReceiveTempTwoId")[0].value = "";
		document.getElementsByName("fdReceiveTempTwoName")[0].value="";
		$("#send2").show();
		$("#receive1").show();
		document.getElementById("r1").setAttribute("validate", "required");
		document.getElementById("s2").setAttribute("validate", "required");
	    $("#r1").parent().parent().click(function(){
		 selcetReceiveOne();
        });
	    $("#s2").parent().parent().click(function(){
		  selcetSendTwo();
        });
	}
	if(value == "RR"){
		document.getElementsByName("fdSendTempOneId")[0].value = "";
		document.getElementsByName("fdSendTempOneName")[0].value="";
		document.getElementsByName("fdSendTempTwoId")[0].value = "";
		document.getElementsByName("fdSendTempTwoName")[0].value="";
		$("#receive2").show();
		$("#receive1").show();
		document.getElementById("r1").setAttribute("validate", "required");
		document.getElementById("r2").setAttribute("validate", "required");
	    $("#r1").parent().parent().click(function(){
			 selcetReceiveOne();
	    });
	    $("#r2").parent().parent().click(function(){
			 selcetReceiveTwo();
	    });
	}
	if(value == "SS"){
		document.getElementsByName("fdReceiveTempOneId")[0].value = "";
		document.getElementsByName("fdReceiveTempOneName")[0].value="";
		document.getElementsByName("fdReceiveTempTwoId")[0].value = "";
		document.getElementsByName("fdReceiveTempTwoName")[0].value="";
		$("#send1").show();
		$("#send2").show();
		document.getElementById("s1").setAttribute("validate", "required");
		document.getElementById("s2").setAttribute("validate", "required");
	    $("#s1").parent().parent().click(function(){
			  selcetSendOne();
	    });
	    $("#s2").parent().parent().click(function(){
			  selcetSendTwo();
	   });
	}
}
$(document).ready(function(){
	if("${kmImissiveTemplateCfgForm.method_GET}"=='add'){
	  changeType("SR");
	}
	if("${kmImissiveTemplateCfgForm.method_GET}"=='edit'||"${kmImissiveTemplateCfgForm.method_GET}"=='clone'){
		intType("${kmImissiveTemplateCfgForm.fdType}");
	}
});
</script>
<html:form action="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do">
<p class="txttitle">公文交换</p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdName"/>
		</td><td width=85% colspan=3>
			<xform:text property="fdName" style="width:85%" required="true" showStatus="edit"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdTableHead"/>
		</td><td width=85% colspan=3>
			<xform:text property="fdTableHead" style="width:85%" showStatus="edit"/>
			<br>
			    <bean:message bundle="km-imissive" key="kmImissive.config.message"/>
				<FONT color="red"><bean:message bundle="km-imissive" key="kmImissive.config.message1"/></FONT>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdType"/>
		</td><td width=85% colspan=3>
			<xform:radio property="fdType" onValueChange="changeType(this.value);" value="${kmImissiveTemplateCfgForm.fdType}" showStatus="edit">
			   <xform:enumsDataSource enumsType="kmImissiveTemplateCfg_type"></xform:enumsDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.from"/>
		</td><td width=35%>
		   <div id="send1" style="display:none">
				<xform:dialog htmlElementProperties="id='s1'" required="true" idValue="${kmImissiveTemplateCfgForm.fdSendTempOneId}" nameValue="${kmImissiveTemplateCfgForm.fdSendTempOneName}" propertyId="fdSendTempOneId" propertyName="fdSendTempOneName" style="width:95%"  className="inputsgl" subject="${ lfn:message('km-imissive:kmImissiveTemplateCfg.from')}" showStatus="edit">
			    </xform:dialog>
		   </div>
		    <div id="receive1" style="display:none">
			   <xform:dialog htmlElementProperties="id='r1'" required="true" idValue="${kmImissiveTemplateCfgForm.fdReceiveTempOneId}" nameValue="${kmImissiveTemplateCfgForm.fdReceiveTempOneName}" propertyId="fdReceiveTempOneId" propertyName="fdReceiveTempOneName" style="width:95%"  className="inputsgl" subject="${ lfn:message('km-imissive:kmImissiveTemplateCfg.from')}" showStatus="edit">
			   </xform:dialog>
		   </div>
		</td>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.to"/>
		</td><td width=35%>
		    <div id="send2" style="display:none">
		    <xform:dialog htmlElementProperties="id='s2'" required="true" idValue="${kmImissiveTemplateCfgForm.fdSendTempTwoId}" nameValue="${kmImissiveTemplateCfgForm.fdSendTempTwoName}"  propertyId="fdSendTempTwoId" propertyName="fdSendTempTwoName" style="width:95%"  className="inputsgl"  subject="${ lfn:message('km-imissive:kmImissiveTemplateCfg.to')}" showStatus="edit"> 
		    </xform:dialog>
		    </div>
		     <div id="receive2" style="display:none">
		    <xform:dialog htmlElementProperties="id='r2'" required="true" idValue="${kmImissiveTemplateCfgForm.fdReceiveTempTwoId}" nameValue="${kmImissiveTemplateCfgForm.fdReceiveTempTwoName}"  propertyId="fdReceiveTempTwoId" propertyName="fdReceiveTempTwoName" style="width:95%"  className="inputsgl" subject="${ lfn:message('km-imissive:kmImissiveTemplateCfg.to')}" showStatus="edit">
		    </xform:dialog>
		     </div>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<script language="JavaScript">
	$KMSSValidation(document.forms['kmImissiveTemplateCfgForm']);
</script>
</html:form>
</template:replace>
</template:include>