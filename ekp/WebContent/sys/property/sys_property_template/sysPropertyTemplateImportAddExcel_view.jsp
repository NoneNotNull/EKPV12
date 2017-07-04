<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.*"%>
<script language="javascript">
 Com_IncludeFile("docutil.js|calendar.js|dialog.js|optbar.js");
 var objs = window.dialogArguments ;
</script>

 <html:form   action="/sys/property/sys_property_template/sysPropertyTemplate.do?method=importExcel" 
    	  enctype="multipart/form-data"   >
	      <table align="center" border="0" width="95%">
	     	<tr>
	      		<td colspan="2" align="center"> 
	      			<font size="3" color="red">${message}</font>
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2" align="center" id="importTitle"> 
	      			<b>属性模板导入</b>
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2">
	      			&nbsp;
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2" align="center"> 
	      			 <html:file property="file"  style="width:80%"/>
	      		</td>
	      	</tr>
	      	<tr align="center" height="50px">
	      		<td colspan="2" align="center">
	      		     <input type="hidden" name="modelName" id="modelName"  >
		      		 <input type="button" value="确定"  onclick="submitExcel()"> &nbsp;&nbsp;
		      		 <input type="button" value="取消"  onclick="javascript:window.close()">
	      		</td>
	      	</tr> 
	      </table>
 <html:hidden property="method_GET" />
</html:form>

<script language="javascript">
function myFormCheck(){
    var importFile = document.getElementsByName("file");
		if(importFile[0].value==null || importFile[0].value.length==0){
			alert('请选择文件');
        return false;
     }else{
        str=importFile[0].value;
        strs=str.toLowerCase();
        lens=strs.length;
        extname=strs.substring(lens-4);
        extname1=strs.substring(lens-5);
       if(extname==".xls"||extname1==".xlsx"){
        	return true;
        }else{
        	alert("请选择excel文件！");
            return false;
        }
     }
     return true ;
}

function submitExcel(){
   if(myFormCheck()){
     document.getElementById("modelName").value=objs;
     Com_Submit(document.sysPropertyTemplateForm, 'importExcel');
     window.close() ;
    } 
 }
</script>
 
<%@ include file="/resource/jsp/edit_down.jsp"%>