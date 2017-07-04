<%@ page language="java" contentType="text/html; charset=GBK"
     pageEncoding="GBK"%>
<%String path=request.getContextPath(); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>导入Excel</title>
</head>
<p>&nbsp;</p>
<body>
    <form name="sysPropertyValImportAddExcel" action="/kms/multimedia/kms_multimedia_main/kmsMultimediaMainImportUpdateExcel.do?method=addExcel" 
    	  enctype="multipart/form-data" method=post onsubmit="return myFormCheck(this)">
	      <table align="center" border="0" width="95%">
	     	<tr>
	      		<td colspan="2" align="center"> 
	      			<font size="3" color="red">${message}</font>
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2" align="center" id="importTitle"> 
	      			<b>sql类型的属性模板导入</b>
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2">
	      			&nbsp;
	      		</td>
	      	</tr>
	      	<tr>
	      		<td colspan="2" align="center"> 
	      			<input type="file" name="importFile" size="40" />
	      		</td>
	      	</tr>
	      	<tr align="center" height="50px">
	      		<td colspan="2" align="center">
		      		 <input type="submit" value="导入" > &nbsp;&nbsp;
		      		 <input type="button" value="取消"  onclick="javascript:window.close();">
	      		</td>
	      	</tr> 
	      </table>
    </form>
</body>
<script language="javascript">
function myFormCheck(theform){
	var fdParentId = "${param.fdParentId}";
	
 document.getElementsByName("sysPropertyValImportAddExcel")[0].action="<%=path %>/kms/multimedia/kms_multimedia_main/kmsMultimediaMainImportUpdateExcel.do?method=addExcel";
   if(theform.importFile.value==""){
        alert("请点击浏览按钮，选择您要导入的文件!");
        theform.importFile.focus;
       return false;
     }else{
        str= theform.importFile.value;
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
     return;
}
</script>
</html>