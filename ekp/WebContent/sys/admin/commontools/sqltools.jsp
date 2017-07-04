<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.component.dbop.ds.DataSet"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<%@page import="com.landray.kmss.util.StringUtil"%>

<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.util.ArrayList"%>

<%@page import="java.util.List"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="com.landray.kmss.util.UserUtil"%><html>
<head>
	<style>
	
<!--
	body, td, input{
	font-size: 12px;
	color: #333333;
}
body{
	margin: 0px;
}
	body div table{
		margin-left:10px;
		margin-bottom:20px;
		border: 1px dashed #C1DAD7;
		background-color: #FAFCFD	
	}
	.divColspan{
		height:50px;
		overflow:auto;
		overflow-x:hidden;
	}
	.colNameClass{
		font: bold 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
		color: #4f6b72;
		background-color: #CAE8EA;
	}
	.colTypeClass{
		
		background-color: #E6E6FA;
	}
	
-->

th.nobg {
border-top: 0;
border-left: 0;
border-right: 1px solid #C1DAD7;
background: none;
}

td {
border-right: 1px solid #C1DAD7;
border-bottom: 1px solid #C1DAD7;
font-size:11px;
padding: 6px 6px 6px 6px;
}

</style>
<script type="text/javascript">
function divMouseOver(objDiv){
	objDiv.style.height="400px";	
}

function divMouseOut(objDiv){
	objDiv.style.height="50px";
}

function divDbclick(objDiv){
	
	window.clipboardData.setData("Text",objDiv.innerText);	
	alert("数据已拷贝到剪切板！");
	
}
function checkAll()
{
	var tables=document.getElementsByName("tables");
	var checkAll=document.getElementById("checkedAll");
	for(var i=0;i<tables.length;i++){
		tables[i].checked=checkAll.checked;
	}
}
window.onload=function()
{
	if(${param.mytype==null||param.mytype=="flow"}){
		document.getElementById("flowDiv").style.display="";
		document.getElementById("sqlDiv").style.display="none";
		document.getElementsByName("type")[0].checked=true;
	}
	else{
		document.getElementById("flowDiv").style.display="none";
		document.getElementById("sqlDiv").style.display="";
		document.getElementsByName("type")[1].checked=true;
	}

}
function changeType(){
	var types=document.getElementsByName("type");
	document.getElementById("contentDiv").innerHTML="";
	if(types[0].checked){
		document.getElementById("flowDiv").style.display="";
		document.getElementById("sqlDiv").style.display="none";
		//document.getElementById("mytype_"+types[0].value).value=types[0].value;
	}
	else{
		document.getElementById("flowDiv").style.display="none";
		document.getElementById("sqlDiv").style.display="";
		//document.getElementById("mytype_"+types[1].value).value=types[1].value;
	}
}

</script>
</head>
<body>
<%
String[][] sqls=new String[][]{
		{"流程表","lbpm_process","select * from lbpm_process where lbpm_process.fd_id=?"},
		{"节点表","lbpm_node","select * from lbpm_node where fd_process_id =?"},
		{"历史节点表","lbpm_history_node","select * from lbpm_history_node where fd_process_id=?"},
		{"工作项表","lbpm_workitem","select * from lbpm_workitem where fd_process_id=?"},
		{"历史工作项表","lbpm_history_workitem","select * from lbpm_history_workitem where fd_process_id=?"},
		{"工作项暂存表","lbpm_workitem_data","select b.* from lbpm_workitem a,lbpm_workitem_data b where b.fd_workitem_id=a.fd_id and a.fd_process_id=?"},
		{"审批记录","lbpm_audit_note","select * from lbpm_audit_note where fd_process_id=?"},
		{"错误队列","lbpm_error_queue","select * from lbpm_error_queue where fd_process_id=?"},
		{"流程参数","lbpm_process_parameter","select * from lbpm_process_parameter where fd_process_id=?"},
		{"定时任务队列","lbpm_quartz","select * from lbpm_quartz where fd_process_id=?"},
		{"处理人日志","lbpm_expecter_log","select * from lbpm_expecter_log where fd_process_id=?"},
		{"处理人历史日志","lbpm_history_expecter_log","select * from lbpm_history_expecter_log where fd_process_id=?"},
		{"工作代理","lbpm_byproxyedit","select * from lbpm_byproxyedit where fd_process_id=?"},
		{"流程授权","lbpm_byaccredit","select b.* from lbpm_workitem a,lbpm_byaccredit b where b.fd_workitem_id=a.fd_id and a.fd_process_id=?"},
		{"执行路径","lbpm_execution","select * from lbpm_execution where fd_process_id=?"},
		};

		String[] checkedTable=request.getParameterValues("tables");
		
		List<String> listCheckedTables=null;
		if(checkedTable==null||checkedTable.length==0){
			listCheckedTables=new ArrayList<String>();
		}
		else{
			listCheckedTables=java.util.Arrays.asList(checkedTable);
		}
%>
<div align="left" style="border: 1px dashed #C1DAD7;
		background-color: #FAFCFD;margin-left: 10px;margin-bottom: 0px;margin-top: 5px;">
<input type="radio" name="type" value="flow" checked="checked" onclick="changeType();">流程</input>
<input type="radio" name="type" value="sql" onclick="changeType();">SQL</input>
</div>
<div id="flowDiv">
	<form action="sqltools.jsp" method="post">
		<input type="hidden" name="mytype" id="mytype_flow" value="flow"/>
		<table>
		<tr>
			<td>主文档/流程ID：<input type="text" name="fdId" value="${param.fdId}" style="width:300px"/>
			
			<input type="checkbox"" name="isLoadBlob" title="双击大字段区域，可拷贝数据到剪切板" ${param.isLoadBlob=="on"?"checked":""}>是否加载大字段</input>
			
			<input type="checkbox"" name="checkedAll" onclick="checkAll();" ${param.checkedAll=="on"?"checked":""}>全选</input>
			
			<input type="checkbox"" name="filterNullTable" onclick="filterNullTalbe(this);" title="前端过滤">过滤空表</input>
			<br/>
				<%
					
					for(int y=0;y<sqls.length;y++){
						String isChecked="";
						if(listCheckedTables.contains(sqls[y][1])){
							isChecked="checked";
						}
						%>
						<input type="checkbox" name="tables" value='<%=sqls[y][1]%>'  <%=isChecked%> ><%=sqls[y][0]%>(<%=sqls[y][1]%>)</input>
						<%
					}
				%>
			
		<br/>
				<div align="center"><button type="submit">提交</button></div>
			</td>
		</tr>
		
		</table>
	</form>
</div>

<div id="sqlDiv">
	<form action="sqltools.jsp" method="post">
		<input type="hidden" name="mytype" id="mytype_sql" value="sql"/>
		<table>
		<tr>
			<td colspan="4">仅支持查询SQL，多条sql语句用英文分号分割。对数据量大的表，必须手动限制查询行数<br/>
			SQL：<textarea rows="6" cols="100" name="sql">${param.sql}</textarea>
			<br/>
			<input name="maxRow" value="${param.maxRow==null?100:param.maxRow}" style="width:50px">最大显示行</input>
			
			<input type="checkbox"" name="isLoadBlob" title="双击大字段区域，可拷贝数据到剪切板" ${param.isLoadBlob=="on"?"checked":""}>是否加载大字段</input>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type="submit">提交</button></td>
		</tr>
		
		</table>
	</form>
</div>



<div id="contentDiv">
<%
//非超管不能操作
if(!UserUtil.getKMSSUser().isAdmin()){
	return ;
}
String mytype= request.getParameter("mytype");
if(StringUtil.isNull(mytype)){
	return;
}
if("sql".equals(mytype)){
	String sqlsStr = request.getParameter("sql");
	if(StringUtil.isNull(sqlsStr)){
		return;
	}
	String[] sqlAry = sqlsStr.split(";");
	
	//sqls=new String[sqlAry.length][3];
	List<String[]> sqlList=new ArrayList<String[]>();
	for(int x=0;x<sqlAry.length;x++)
	{
		//非查询语句不处理
		if(sqlAry[x].toLowerCase().indexOf("select")==-1){
			continue;
		}
		String tableName="";
		 String regex="\\bfrom\\s*\\S*";
	        Pattern p=Pattern.compile(regex);
	        Matcher m=p.matcher(sqlAry[x]);
	        if(m.find()){
	            tableName=m.group().replace("from","");
	        }
	        
		String[] tempAry = new String[3];
		
		
		tempAry[0]="表";
		tempAry[1]=tableName;
		tempAry[2]=sqlAry[x];
		
		sqlList.add(tempAry);
	}
	String[][] tempArys = new String[sqlList.size()][3];
	sqls=sqlList.toArray(tempArys);
}
for(int z=0;z<sqls.length;z++)
{
	if(!listCheckedTables.contains(sqls[z][1])&&"flow".equals(mytype)){
		continue;
	}

	DataSet ds = new DataSet(); 
	Connection con = ds.getConnection();
	PreparedStatement ps=null;
	ResultSet rs=null;
try{
	String fdId=request.getParameter("fdId");

	if(StringUtil.isNull(fdId) &&"flow".equals(mytype)){
		
		return ;
	}
	%>
<div>
	<table cellspacing="0px" id="table_info_<%=z%>">
	<thead>
		<%=sqls[z][0]%>(<%=sqls[z][1]%>)
	</thead>
	<%
	ps=con.prepareStatement(sqls[z][2]);
	if(!"sql".equals(mytype)){
		ps.setString(1,fdId);
	}
	rs= ps.executeQuery();
	
	
	
	
	ResultSetMetaData rm=rs.getMetaData();
	
	int colCount=0;
	if(rm!=null){
		colCount=rm.getColumnCount();
		out.print("<tr class='colNameClass'>");
		for(int i=1;i<=colCount;i++){
			String colName= rm.getColumnName(i);
			out.print("<td>"+colName+"</td>");
		}
		out.print("</tr>");
		out.print("<tr class='colTypeClass'>");
		for(int i=1;i<=colCount;i++){
				out.print("<td>"+rm.getColumnTypeName(i)+"("+rm.getColumnDisplaySize(i)+")</td>");
			}
			
		out.print("</tr>");
	}
	int totalCount=0;
	while(rs.next()){
		totalCount++;
		if("sql".equals(mytype)){
			int maxRow = Integer.parseInt(request.getParameter("maxRow"));
			if(maxRow==totalCount-1){
				break;
			}
		}
		out.print("<tr>");
		//out.print("<td>"+rs.getString(1)+"</td>");
		for(int i=1;i<=colCount;i++){
			out.print("<td>&nbsp;");
			if("datetime".equals(rm.getColumnTypeName(i).toLowerCase())){
				if(rs.getDate(i)!=null){
					String outStr = DateUtil.convertDateToString(new java.util.Date(rs.getDate(i).getTime()),"yyyy-MM-dd HH:mm:ss");
					out.print(outStr);
				}
			}
			//Blob  文本大字段类型 MySql
			else if(rm.getColumnType(i)==-1 || "blob".equals(rm.getColumnTypeName(i).toLowerCase())){
				
				java.sql.Blob blob = rs.getBlob(i);
				if(blob !=null && "on".equals(request.getParameter("isLoadBlob"))){
					BufferedReader br = new BufferedReader(new InputStreamReader(blob.getBinaryStream()));
					String line=br.readLine();
					
					out.print("<div class='divColspan' onmouseover='divMouseOver(this);' onMouseOut='divMouseOut(this);' onDblclick='divDbclick(this)' >");
					while(line !=null){
						out.println(StringUtil.XMLEscape(line));
						line=br.readLine();
					}
					out.print("</div>");
					
				}else if(blob !=null){
					out.print("未加载");
				}
				
			}
			//Oracl is  clob  and  sql server is  text
			else if("clob".equals(rm.getColumnTypeName(i).toLowerCase()) ||"text".equals(rm.getColumnTypeName(i).toLowerCase())){
				java.sql.Clob clob = rs.getClob(i);
				if(clob !=null && "on".equals(request.getParameter("isLoadBlob"))){
					
					BufferedReader br = new BufferedReader(clob.getCharacterStream());
					String line=br.readLine();
					
					out.print("<div class='divColspan' onmouseover='divMouseOver(this);' onMouseOut='divMouseOut(this);' onDblclick='divDbclick(this)' >");
					while(line !=null){
						out.println(StringUtil.XMLEscape(line));
						line=br.readLine();
					}
					out.print("</div>");
					
				}else if(clob !=null){
					out.print("未加载");
				}
			}
			
			else{
				out.print(rs.getString(i));
			}
			out.print("</td>");
		}
		out.print("</tr>");
	}
	
	%>
	</table>	
</div>	
	
	<%
	
}catch(Exception e){
	e.printStackTrace();
	out.println(e);
}
finally{
	if(rs !=null){
		rs.close();
	}
	if(ps !=null){
		ps.close();
	}
	if(con!=null){
		con.close();
	}
}
}
%>   
</div>
</body>
</html>
<script type="text/javascript">
//过滤空表
function filterNullTalbe(obj){
	
	for(var i=0;i< <%=sqls.length%>;i++){
		var tab=document.getElementById("table_info_"+i);
		if(!tab){
			continue;
		}
		if(obj.checked && tab.rows.length==2){
			tab.style.display="none";
		}
		else {
			tab.style.display="";
		}
			
	}
}
</script>
  