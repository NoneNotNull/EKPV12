<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 
</head>
<body>
 
<table  align='center' width="100%" border=0 >
<tr><td align='center'>
<img src='<%=request.getContextPath()%>/sys/attachment/sys_att_main/sysAttMain.do?method=download&amp;fdId=<%=request.getParameter("fdId")%>'  align='center' border='0'  >   
 </td>
 </tr>
 <tr>
 <td  align='center'>
 <input type="button" onclick="javascript:window.close();" value="关闭"></input>
 </td></tr>
 </table>
</body>
</html>