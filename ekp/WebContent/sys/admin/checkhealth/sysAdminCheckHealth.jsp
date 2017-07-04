<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="java.util.List,java.util.Iterator,java.sql.Connection,java.sql.DatabaseMetaData
,java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException,java.sql.Statement,java.util.ArrayList
,java.util.Calendar,java.util.Date,com.landray.kmss.common.dao.IBaseDao,java.lang.management.ManagementFactory
,java.lang.management.ClassLoadingMXBean,java.lang.management.MemoryMXBean,java.lang.management.ThreadMXBean
,com.landray.kmss.util.SpringBeanUtil,java.sql.ResultSetMetaData,java.lang.reflect.Field,java.lang.management.RuntimeMXBean
,java.text.SimpleDateFormat,java.util.Formatter" %>
<%
  String rootPath = request.getContextPath();
  getDBConn();
  queryAll();
  loadAppLogDate(request);
  loadLoginLogDate(request);
%>
<script type="text/javascript">Com_IncludeFile("chart.js|data.js|list.js");</script>
<script>
function generateChart(param,divId){
	var chart;
	var cahartType = CHART_TYPE_LINE;
	var data = new KMSSData();
	var type;
	var logTable;
	if(divId == "applog"){
		applogLineChart = new Chart(
				"applogLineChart",
				cahartType,
				document.getElementById("applog")
		);
		chart = applogLineChart;
		type="app";
		logTable="applogTable";
	}else if(divId == "loginlog"){
		loginLineChart = new Chart(
				"loginLineChart",
				cahartType,
				document.getElementById("loginlog")
		);
		chart = loginLineChart;
		type="login"
		logTable="loginlogTable";
	}
	data.AddBeanData('sysAdminLogInfoService&type='+type+'&dateParam='+param.value);
	var obj = data.GetHashMapArray()[0]; 
	var labels=obj['labels'];
	var values=obj['values'];
	var table=obj['table'];
	var applogTable = document.getElementById(logTable);
	var html="<table class='tb_normal' width='100%'>"+table+"</table>";
	applogTable.innerHTML = html;
	chart.title = param.options[param.selectedIndex].text;
	chart.ySuffix = "次";
	chart.SetLabelByString(labels);
	chart.SetValueByString(values,";", null, null, cahartType);
	chart.Show();	
}
function appLogOpen(param){
	generateChart(param,"applog");
}
function loginLogOpen(param){
	generateChart(param,"loginlog");
}
window.onload = function(){
	var applogDate = document.getElementsByName("applogDate")[0];
	var loginlogDate = document.getElementsByName("loginlogDate")[0];
 	generateChart(applogDate,"applog");
 	generateChart(loginlogDate,"loginlog");
 };

function expandMethod(imgSrc,divSrc) {
	var imgSrcObj = document.getElementById(imgSrc);
	var divSrcObj = document.getElementById(divSrc);
	if(divSrcObj.style.display!=null && divSrcObj.style.display!="") {
		divSrcObj.style.display = "";
		imgSrcObj.src = Com_Parameter.ContextPath+"resource/style/default/icons/collapse.gif";
	}else{
		divSrcObj.style.display = "none";
		imgSrcObj.src = Com_Parameter.ContextPath+"resource/style/default/icons/expand.gif";		
	}
}
List_TBInfo = new Array(
		{TBID:"List_ViewTable1"},{TBID:"List_ViewTable2"},{TBID:"List_ViewTable3"},{TBID:"List_ViewTable4"},
		{TBID:"List_ViewTable5"},{TBID:"List_ViewTable6"},{TBID:"List_ViewTable7"}
	);
</script>
<html>
<head>
<title>系统健康检查</title>
</head>
<body>
<p class="txttitle">系统健康检查</p>
<center>
<table id="Label_Tabel" width=95%>
	<tr LKS_LabelName='基本信息'>
		<td>
			<table class="tb_normal" width="100%">
				<tr>
	            	<td width="13%" class="td_normal_title">WEB服务器</td>
	            	<td width="20%" ><%=application.getServerInfo() %></td>
	            	<td width="13%" class="td_normal_title">启动时间</td>
	            	<td width="20%" ><%=startTime %></td>   
	            	<td width="13%" class="td_normal_title">运行时间</td>
	            	<td width="20%"><%=upTime %></td>           
				</tr> 			
				<tr>
	            	<td width="13%" class="td_normal_title">操作系统名称</td>
	            	<td width="20%" ><%=osName %></td>
	            	<td width="13%" class="td_normal_title">操作系统架构</td>
	            	<td width="20%" ><%=osArch %></td>   
	            	<td width="13%" class="td_normal_title">可用的CPU数目</td>
	            	<td width="20%"><%=processorCount %></td>           
				</tr>   
		    	<tr>
              		<td width="13%" class="td_normal_title">数据库名</td>
              		<td width="20%"><%=databaseName %></td>
					<td width="13%" class="td_normal_title">数据库的版本号</td>
					<td width="20%"><%=databaseVersion %></td>
					<td width="13%" class="td_normal_title">驱动程序的版本号</td>
					<td width="20%"><%=databaseDriverVersion %></td>              
            	</tr>   			      		      	            
            	<tr> 
					<td width="13%" class="td_normal_title">JVM 厂商</td>
					<td width="20%" ><%=vmVendor %></td>
					<td width="13%" class="td_normal_title">JAVA 版本号</td>
					<td width="20%"><%=javaVersion %></td>  
					<td width="13%" class="td_normal_title">JVM 版本号</td>
					<td width="20%"><%=vmVersion %></td>                         
           		</tr> 
				<tr>
					<td width="13%" class="td_normal_title">JVM 可使用内存</td>
					<td width="20%"><%=totalMemory %></td>
					<td width="13%" class="td_normal_title">JVM 剩余内存</td>
					<td width="20%"><%=freeMemory %></td>
					<td width="13%" class="td_normal_title">JVM 最大可使用内存</td>
					<td width="20%"><%=maxMemory %></td>              
            	</tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName="JAVA虚拟机">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
	              	<td width="25%" class="td_normal_title">当前加载到 JVM 中的类的数量</td>
	              	<td width="75%"><%=loadedClassCount %></td>
	            </tr>
	            <tr>
	              	<td width="25%" class="td_normal_title">堆内存的当前使用量</td>
	              	<td width="75%"><%=heapMemUsage %></td>
	            </tr>
	            <tr>
	              	<td width="25%" class="td_normal_title">非堆内存的当前使用量</td>
	              	<td width="75%"><%=nonHeapMemUsage %></td>           
	            </tr> 
	            <tr>              
	              	<td width="25%" class="td_normal_title">自 JVM 开始执行到目前已经加载的类的总数</td>
	              	<td width="75%"><%=totalLoadedClassCount %></td>           
	            </tr> 
	            <tr>
	              	<td width="25%" class="td_normal_title">自 JVM 开始执行到目前已经卸载的类的总数</td>
	              	<td width="75%" ><%=unloadedClassCount %></td>       
	            </tr>              
	            <tr>
	              	<td width="25%" class="td_normal_title">终止被挂起的对象的近似数目</td>
	              	<td width="75%" ><%=pendingObjCount %></td>               
	            </tr>  
	            <tr>
	              	<td width="25%" class="td_normal_title">类加载系统的 verbose 输出</td>
	              	<td width="75%" colspan="3"><%=classVerbose %></td>         
	            </tr>  
	            <tr>
	              	<td width="25%" class="td_normal_title">内存系统的 verbose 输出</td>
	              	<td width="75%" colspan="3"><%=memVerbose %></td>           
	            </tr>			
			</table>
		</td>
	</tr>	
	<tr LKS_LabelName="线程">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
		            <td width="25%" class="td_normal_title">活动线程的当前数目</td>
		            <td width="75%"><%=threadCount %></td>            
		        </tr>  
				<tr>
	              	<td width="25%" class="td_normal_title">创建和启动的线程总数目</td>
	              	<td width="75%"><%=totalStartedThreadCount %></td>         
	            </tr>  
				<tr>
	              	<td width="25%" class="td_normal_title">活动守护线程的当前数目</td>
	              	<td width="75%"><%=daemonThreadCount %></td>              
	            </tr>                          
				<tr>
	              	<td width="25%" class="td_normal_title">峰值活动的线程数目</td>
	              	<td width="75%"><%=peakThreadCount %></td>          
	            </tr>  
				<tr>
	              	<td width="25%" class="td_normal_title">当前线程的总 CPU 时间</td>
	              	<td width="75%"><%=curThreadCupTime %> 毫秒</td>        
	            </tr>  
				<tr>
	              	<td width="25%" class="td_normal_title">当前线程在用户模式中执行的 CPU 时间</td>
	              	<td width="75%"><%=curThreadUserTime %> 毫秒</td>              
	            </tr>                          
				<tr>
	              	<td width="25%" class="td_normal_title">处于监视器死锁状态的线程数目</td>
	              	<td width="75%"><%=monitorDeadlockedThreadCount %></td>            
	            </tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName='组织架构'>
		<td>
			<table class="tb_normal" width="100%">
				<tr align=center>
					<td width="40pt" class="td_normal_title">
						序号
					</td>
					<td class="td_normal_title">
						类型
					</td>
					<td class="td_normal_title">
						有效性
					</td>
					<td class="td_normal_title">
						数量
					</td>			
				</tr>
				<% 
				   for(int i = 0; i < orgList.size(); i++)
				   {
					   String[] arr = (String[])orgList.get(i);
				%>
				<tr align=center>
					<td><%=i+1%></td>
					<td><%=arr[0]%></td>
					<td><%=arr[1]%></td>
					<td><%=arr[2]%></td>
				</tr>
				<% } %>			
			</table>
			<div align="right">合计：<%=orgAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>
		</td>
	</tr>	
	<tr LKS_LabelName='流程'>
		<td>
			<table class="tb_normal" width="100%">	
				<tr>
					<td width="15%" class="td_normal_title">每日处理流程平均数</td>
					<td width="85%"><%=wfAvgDay%></td>				
				</tr>	
				<tr>
					<td width="15%" class="td_normal_title">每日处理流程最大数</td>
					<td width="85%"><%=wfMaxDay%></td>				
				</tr>	
				<tr>
					<td width="15%" class="td_normal_title">时间字段为空的流程数</td>
					<td width="85%"><%=wfNoTime%></td>				
				</tr>								
				<tr>
					<td width="15%" class="td_normal_title">流程模板</td>
					<td width="85%">
					    <img id="viewSrc1" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc1','viewDiv1')" style="cursor:pointer"><br>
						<div id="viewDiv1" style="display:none">				
							<table id="List_ViewTable1" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											功能模块类名
										</td>
										<td>
											数量
										</td>
									</sunbor:columnHead>	
								</tr>
								<% 
								   for(int i = 0; i < wfTemplateList.size(); i++)
								   {
									   String[] arr = (String[])wfTemplateList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
								</tr>
								<% } %>
							</table>
							<div align="right">合计：<%=wfTemplateAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>
						</div>			
					</td>																							
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">流程（模块）</td>
					<td width="85%">
					    <img id="viewSrc2" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc2','viewDiv2')" style="cursor:pointer"><br>
						<div id="viewDiv2" style="display:none">					
							<table id="List_ViewTable2" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											功能模块类名
										</td>
										<td>
											数量
										</td>
									</sunbor:columnHead>			
								</tr>
								<% 
								   for(int i = 0; i < wfProcessByModelList.size(); i++)
								   {
									   String[] arr = (String[])wfProcessByModelList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
								</tr>
								<% } %>
							</table>
							<div align="right">合计：<%=wfAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>					
						</div>		
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">流程（状态）</td>
					<td width="85%">
						<img id="viewSrc3" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc3','viewDiv3')" style="cursor:pointer"><br>
						<div id="viewDiv3" style="display:none">	
							<table id="List_ViewTable3" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											流程状态
										</td>
										<td>
											数量
										</td>
									</sunbor:columnHead>		
								</tr>
								<% 
								   for(int i = 0; i < wfProcessByStatusList.size(); i++)
								   {
									   String[] arr = (String[])wfProcessByStatusList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
								</tr>
								<% } %>
							</table>	
							<div align="right">合计：<%=wfAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>
						</div>							
					</td>
				</tr>		
				<tr>
					<td width="15%" class="td_normal_title">最近一个月的流程</td>
					<td width="85%">
					    <img id="viewSrc4" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc4','viewDiv4')" style="cursor:pointer"><br>
						<div id="viewDiv4" style="display:none">					
							<table id="List_ViewTable4" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											功能模块类名
										</td>
										<td>
											数量
										</td>
									</sunbor:columnHead>		
								</tr>
								<% 
								   for(int i = 0; i < wfProcessByMonthList.size(); i++)
								   {
									   String[] arr = (String[])wfProcessByMonthList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
								</tr>
								<% } %>
							</table>	
							<div align="right">合计：<%=wfMonthAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>			
						</div>		
					</td>
				</tr>						
				<tr>
					<td width="15%" class="td_normal_title">待处理流程数</td>
					<td width="85%"><%=wfEvent%></td>			
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">已办流程工作项数</td>
					<td width="85%"><%=wfHistoryWorkitem%></td>			
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">待办流程工作项数</td>
					<td width="85%"><%=wfWorkitem%></td>				
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">工作项表外键</td>
					<td width="85%"><%=fkOfWorkitem%></td>				
				</tr>				
				<tr>
					<td width="15%" class="td_normal_title">工作项表索引</td>
					<td width="85%"><%=indexOfWorkitem%></td>				
				</tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName='待办事宜'>
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td width="15%" class="td_normal_title">每日新建待办平均数</td>
					<td width="85%"><%=todoAvgDay%></td>				
				</tr>	
				<tr>
					<td width="15%" class="td_normal_title">每日新建待办最大数</td>
					<td width="85%"><%=todoMaxDay%></td>				
				</tr>			
				<tr>
					<td width="15%" class="td_normal_title">待办事项</td>
					<td width="85%">
					    <img id="viewSrc5" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc5','viewDiv5')" style="cursor:pointer"><br>
						<div id="viewDiv5" style="display:none">					
							<table id="List_ViewTable5" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											类型
										</td>
										<td>
											数量
										</td>	
										<td>
											最早创建时间
										</td>
									</sunbor:columnHead>					
								</tr>
								<% 
								   for(int i = 0; i < todoList.size(); i++)
								   {
									   String[] arr = (String[])todoList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
									<td><%=arr[2]%></td>				
								</tr>
								<% } %>
							</table>
							<div align="right">合计：<%=todoAmount %>&nbsp;&nbsp;&nbsp;&nbsp;</div>		
						</div>								
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">已办事项数</td>
					<td width="85%"><%=todoDone%></td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">待办处理人数</td>
					<td width="85%"><%=todoTarget%></td>
				</tr>												
			</table>
		</td>
	</tr>
	<tr LKS_LabelName='应用日志'>
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td width="15%" class="td_normal_title">每日新建日志平均数</td>
					<td width="85%"><%=logAvgDay%></td>				
				</tr>	
				<tr>
					<td width="15%" class="td_normal_title">每日新建日志最大数</td>
					<td width="85%"><%=logMaxDay%></td>				
				</tr>			
				<tr>
					<td width="15%" class="td_normal_title">最近7天的日志条数</td>
					<td width="85%"><%=logApp%></td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">最早创建时间</td>
					<td width="85%"><%=logAppFirstTime%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName='附件'>
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td width="15%" class="td_normal_title">附件</td>
					<td width="85%">
					    <img id="viewSrc6" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc6','viewDiv6')" style="cursor:pointer"><br>
						<div id="viewDiv6" style="display:none">					
							<table id="List_ViewTable6" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											功能模块类名
										</td>
										<td>
											数量
										</td>				
										<td>
											大小
										</td>
									</sunbor:columnHead>			
								</tr>
								<% 
								   for(int i = 0; i < attMainList.size(); i++)
								   {
									   String[] arr = (String[])attMainList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
									<td><%=arr[2]%></td>				
								</tr>
								<% } %>
								<tr>
									<td colspan="2">
										合计
									</td>
									<td>
									    <%=attMainAmount%>
									</td>				
									<td>
										<%=attMainTotalSize%>
									</td>			
								</tr>		
							</table>
						</div>					
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">RTF附件</td>
					<td width="85%">
						<img id="viewSrc7" src="<%=rootPath%>/resource/style/default/icons/expand.gif" border="0" onclick="expandMethod('viewSrc7','viewDiv7')" style="cursor:pointer"><br>
						<div id="viewDiv7" style="display:none">
							<table id="List_ViewTable7" class="tb_noborder" width="100%">
								<tr>
									<sunbor:columnHead htmlTag="td">
										<td width="40pt">
											序号
										</td>
										<td>
											功能模块类名
										</td>
										<td>
											数量
										</td>				
										<td>
											大小
										</td>
									</sunbor:columnHead>			
								</tr>
								<% 
								   for(int i = 0; i < attRtfList.size(); i++)
								   {
									   String[] arr = (String[])attRtfList.get(i);
								%>
								<tr>
									<td><%=i+1%></td>
									<td><%=arr[0]%></td>
									<td><%=arr[1]%></td>
									<td><%=arr[2]%></td>				
								</tr>
								<% } %>
								<tr>
									<td colspan="2">
										合计
									</td>
									<td>
									    <%=attRtfAmount%>
									</td>				
									<td>
										<%=attRtfTotalSize%>
									</td>			
								</tr>
							</table>
						</div>		
					</td>
				</tr>												
			</table>
		</td>
	</tr>
	<tr LKS_LabelName='并发量'>
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td class="td_normal_title" colspan="10"><b>操作并发量</b>
						<select name="applogDate" onchange="appLogOpen(this);">
						  <%=appLogDate%>
						</select>
					</td>
				</tr>
				<tr>
					<td id="applogTable">
					</td>
				</tr>
				<tr>
					<td style="height:480px;width: 100%" >
						<div id="applog" align="center"></div>
					</td>
				</tr>
			</table>
			<br>
			<table class="tb_normal" width="100%">
				<tr>
					<td class="td_normal_title" colspan="10"><b>登录并发量</b>
						<select name="loginlogDate" onchange="loginLogOpen(this);">
						  <%=loginLogDate%>
						</select>
					</td>
				</tr>
				<tr>
					<td id="loginlogTable">
					</td>
				</tr>
				<tr>
					<td style="height:480px;width: 100%" >
						<div id="loginlog" align="center"></div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</center>
</body>
</html>
<%!
private Connection conn = null;
private Statement st = null;
private PreparedStatement ps = null;
private ResultSet rs = null;
private int kb = 1024;

//组织架构SQL
private static final String SQL_ORG_ELEMENT = "select fd_org_type, fd_is_available, count(fd_id) cnt from sys_org_element group by fd_org_type, fd_is_available";
//流程SQL
private static final String SQL_WF_TEMPLATE = "select fd_model_name, count(fd_id) cnt from sys_wf_template group by fd_model_name";
private static final String SQL_WF_PROCESS_BY_MODELNAME = "select fd_model_name, count(fd_id) cnt from sys_wf_process group by fd_model_name";
private static final String SQL_WF_PROCESS_BY_STATUS = "select fd_status, count(fd_id) cnt from sys_wf_process group by fd_status";
private static final String SQL_WF_PROCESS_BY_MONTH = "select fd_model_name, count(fd_id) cnt from sys_wf_process where fd_id >=? group by fd_model_name";
private static final String SQL_WF_EVENT = "select count(fd_id) cnt from sys_wf_event";
private static final String SQL_WF_HISTORY_WORKITEM = "select count(fd_id) cnt from sys_wf_history_workitem";
private static final String SQL_WF_WORKITEM = "select count(fd_id) cnt from sys_wf_workitem";
private static final String SQL_WF_AVG_DAY_MySQL = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by date_format(fd_last_handle_time,'%Y-%m-%d')) t";
private static final String SQL_WF_MAX_DAY_MySQL = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by date_format(fd_last_handle_time,'%Y-%m-%d')) t";
private static final String SQL_WF_AVG_DAY_Oracle = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by to_char(fd_last_handle_time,'yyyy-mm-dd')) t";
private static final String SQL_WF_MAX_DAY_Oracle = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by to_char(fd_last_handle_time,'yyyy-mm-dd')) t";
private static final String SQL_WF_AVG_DAY_Microsoft_SQL_Server = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by convert(varchar(10),fd_last_handle_time,110)) t";
private static final String SQL_WF_MAX_DAY_Microsoft_SQL_Server = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is not null group by convert(varchar(10),fd_last_handle_time,110)) t";
private static final String SQL_WF_NO_TIME = "select count(fd_id) cnt from sys_wf_process where fd_last_handle_time is null";
//待办SQL
private static final String SQL_TODO = "select fd_type, count(fd_id) cnt, min(fd_create_time) first_time from sys_notify_todo group by fd_type";
private static final String SQL_TODO_DONE = "select count(fd_id) cnt from sys_notify_todo_done_info";
private static final String SQL_TODO_TARGET = "select count(fd_todoid) cnt from sys_notify_todotarget";
private static final String SQL_TODO_AVG_DAY_MySQL = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_notify_todo group by date_format(fd_create_time,'%Y-%m-%d')) t";
private static final String SQL_TODO_MAX_DAY_MySQL = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_notify_todo group by date_format(fd_create_time,'%Y-%m-%d')) t";
private static final String SQL_TODO_AVG_DAY_Oracle = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_notify_todo group by to_char(fd_create_time,'yyyy-mm-dd')) t";
private static final String SQL_TODO_MAX_DAY_Oracle = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_notify_todo group by to_char(fd_create_time,'yyyy-mm-dd')) t";
private static final String SQL_TODO_AVG_DAY_Microsoft_SQL_Server = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_notify_todo group by convert(varchar(10),fd_create_time,110)) t";
private static final String SQL_TODO_MAX_DAY_Microsoft_SQL_Server = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_notify_todo group by convert(varchar(10),fd_create_time,110)) t";
//日志SQL
private static final String SQL_LOG_APP = "select count(fd_id) cnt from sys_log_app where fd_id >=?";
private static final String SQL_LOG_FIRST_TIME = "select min(fd_created) first_time from sys_log_app";
private static final String SQL_LOG_AVG_DAY_MySQL = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_log_app group by date_format(fd_created,'%Y-%m-%d')) t";
private static final String SQL_LOG_MAX_DAY_MySQL = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_log_app group by date_format(fd_created,'%Y-%m-%d')) t";
private static final String SQL_LOG_AVG_DAY_Oracle = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_log_app group by to_char(fd_created,'yyyy-mm-dd')) t";
private static final String SQL_LOG_MAX_DAY_Oracle = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_log_app group by to_char(fd_created,'yyyy-mm-dd')) t";
private static final String SQL_LOG_AVG_DAY_Microsoft_SQL_Server = "select round(avg(cnt),0) avg_cnt from (select count(fd_id) cnt from sys_log_app group by convert(varchar(10),fd_created,110)) t";
private static final String SQL_LOG_MAX_DAY_Microsoft_SQL_Server = "select max(cnt) max_cnt from (select count(fd_id) cnt from sys_log_app group by convert(varchar(10),fd_created,110)) t";
//附件SQL
private static final String SQL_ATT_MAIN = "select fd_model_name, count(fd_id) cnt, sum(fd_size) total_size from sys_att_main group by fd_model_name";
private static final String SQL_ATT_RTF_DATA = "select fd_model_name, count(fd_id) cnt, sum(fd_size) total_size from sys_att_rtf_data group by fd_model_name";

private List orgList = new ArrayList();
private List wfTemplateList = new ArrayList();
private List wfProcessByModelList = new ArrayList();
private List wfProcessByStatusList = new ArrayList();
private List wfProcessByMonthList = new ArrayList();
private List todoList = new ArrayList();
private List attMainList = new ArrayList();
private List attRtfList = new ArrayList();

private int wfAvgDay = 0;
private int wfMaxDay = 0;
private int wfNoTime = 0;
private int todoAvgDay = 0;
private int todoMaxDay = 0;
private int logAvgDay = 0;
private int logMaxDay = 0;
private int orgAmount = 0;
private int wfTemplateAmount = 0;
private int wfAmount = 0;
private int wfMonthAmount = 0;
private int todoAmount = 0;
private int wfEvent = 0;
private int wfHistoryWorkitem = 0;
private int wfWorkitem = 0;
private int todoDone = 0;
private int todoTarget = 0;
private int logApp = 0;
private String attMainTotalSize = "";
private String attRtfTotalSize = "";
private int attMainAmount = 0;
private int attRtfAmount = 0;
private String fkOfWorkitem = "";
private String indexOfWorkitem = "";
private String logAppFirstTime = "";

private String databaseName = "";   //数据库名
private String databaseVersion = "";  // 数据库的版本号
private String databaseDriverVersion = "";  // 驱动程序的版本号

private String totalMemory = ""; // 可使用内存
private String freeMemory = ""; // 剩余内存
private String maxMemory = ""; // 最大可使用内存
private String upTime = "";//正常运行时间
private String startTime = "";//启动时间
private String totalPhysicalMemory = ""; // 总的物理内存
private String freePhysicalMemory = ""; // 剩余的物理内存
private String usedPhysicalMemory = ""; // 已使用的物理内存
private String osName = "";   //操作系统名称
private String osArch = "";   //操作系统构架 
private String vmVendor = "";  //Java 虚拟机实现供应商
private String javaVersion = "";  //运行时环境版本 
private String vmVersion = "";  //Java 虚拟机版本
private int processorCount = 0;  //可用的CPU数目
private int loadedClassCount = 0;  //当前加载到 Java 虚拟机中的类的数量
private long totalLoadedClassCount = 0L;  //自 Java 虚拟机开始执行到目前已经加载的类的总数
private long unloadedClassCount = 0L;  //自 Java 虚拟机开始执行到目前已经卸载的类的总数
private String classVerbose = "";  //类加载系统的 verbose 输出
private String heapMemUsage = "";  //堆内存的当前使用量
private String nonHeapMemUsage = "";  //非堆内存的当前使用量
private int pendingObjCount = 0;  //终止被挂起的对象的近似数目
private String memVerbose = "";  //内存系统的 verbose 输出
private long curThreadCupTime = 0L;  //当前线程的总 CPU 时间
private long curThreadUserTime = 0L;  //当前线程在用户模式中执行的 CPU 时间
private int threadCount = 0;  //活动线程的当前数目
private long totalStartedThreadCount = 0L;  //创建和启动的线程总数目
private int daemonThreadCount = 0;  //活动守护线程的当前数目
private int peakThreadCount = 0;  //峰值活动的线程数目
private int monitorDeadlockedThreadCount = 0;  //处于监视器死锁状态的线程数目
private String loginLogDate = "";// 登录日志时间选择选项
private String appLogDate = "";//操作日志时间选择选项


/**
 * 获取DB连接
 */
private Connection getDBConn() {
	IBaseDao dao = (IBaseDao) SpringBeanUtil.getBean("KmssBaseDao");
	conn = dao.getHibernateSession().connection();

	return conn;
}

/**
 * 数据查询主方法
 */
private void queryAll() {
	if (conn == null) return;

	try {
		st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

		getSystemInfo();  //查询系统信息
		getDbInfo();  //查询数据库信息
		queryOrg();  //查询组织架构信息
		queryWf();  //查询流程信息
		queryWfByTime();  //根据时间查询流程
		queryTodo();  //查询待办
		queryLogApp();   //查询应用日志
		queryLogAppByTime();  //根据时间查询应用日志
		queryAtt();  //查询附件

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
			}
		}
		if (st != null) {
			try {
				st.close();
			} catch (SQLException e) {
			}
		}
		if (ps != null) {
			try {
				ps.close();
			} catch (SQLException e) {
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			}
		}
	}
}

/**
 * 获取系统信息
 */
private void getSystemInfo() {
    this.osName = System.getProperty("os.name");
    this.osArch = System.getProperty("os.arch");
    this.vmVendor = System.getProperty("java.vm.vendor");
    this.vmVersion = System.getProperty("java.vm.version");
    this.javaVersion = System.getProperty("java.version");
    this.processorCount = Runtime.getRuntime().availableProcessors();
	this.totalMemory = Runtime.getRuntime().totalMemory() / kb + " K";
	this.freeMemory = Runtime.getRuntime().freeMemory() / kb + " K";
	this.maxMemory = Runtime.getRuntime().maxMemory() / kb + " K";
	
//	com.sun.management.OperatingSystemMXBean osmxb = (com.sun.management.OperatingSystemMXBean) sun.management.ManagementFactory.getOperatingSystemMXBean();
//    this.totalPhysicalMemory = osmxb.getTotalPhysicalMemorySize() / kb + " K";
//   this.freePhysicalMemory = osmxb.getFreePhysicalMemorySize() / kb + " K";
//    this.usedPhysicalMemory = (osmxb.getTotalPhysicalMemorySize() - osmxb.getFreePhysicalMemorySize()) / kb + " K";	

    ClassLoadingMXBean clxmb = ManagementFactory.getClassLoadingMXBean();
    this.loadedClassCount = clxmb.getLoadedClassCount();
    this.totalLoadedClassCount = clxmb.getTotalLoadedClassCount();
    this.unloadedClassCount = clxmb.getUnloadedClassCount();
    if(clxmb.isVerbose()) {
    	this.classVerbose = "已启用";
    } else {
    	this.classVerbose = "未启用";
    }
    RuntimeMXBean rtxmb = ManagementFactory.getRuntimeMXBean();
    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    this.upTime = formatTimeSpan(rtxmb.getUptime());
    this.startTime = sf.format(rtxmb.getStartTime());
    
    MemoryMXBean mmxbean = ManagementFactory.getMemoryMXBean();
    this.heapMemUsage = mmxbean.getHeapMemoryUsage().toString();
    this.nonHeapMemUsage = mmxbean.getNonHeapMemoryUsage().toString();
    this.pendingObjCount = mmxbean.getObjectPendingFinalizationCount();
    if(mmxbean.isVerbose()) {
    	this.memVerbose = "已启用";
    } else {
    	this.memVerbose = "未启用";
    }   
    
    ThreadMXBean tmxbean = ManagementFactory.getThreadMXBean();
    if (tmxbean.isCurrentThreadCpuTimeSupported() && tmxbean.isThreadCpuTimeEnabled()) {
    	this.curThreadCupTime = tmxbean.getCurrentThreadCpuTime() / 1000000;
    	this.curThreadUserTime = tmxbean.getCurrentThreadUserTime() / 1000000;
    }
    this.daemonThreadCount = tmxbean.getDaemonThreadCount();
    this.peakThreadCount = tmxbean.getPeakThreadCount();
    this.threadCount = tmxbean.getThreadCount();
    this.totalStartedThreadCount = tmxbean.getTotalStartedThreadCount();
    long[] mdtArr = tmxbean.findMonitorDeadlockedThreads();
    this.monitorDeadlockedThreadCount = (mdtArr == null ? 0 : mdtArr.length);
    
}

/**
 * 获取数据库及表结构的信息
 */
private void getDbInfo() throws SQLException {
	if (conn == null) return;

	DatabaseMetaData dbMetaData = conn.getMetaData();

	this.databaseName = dbMetaData.getDatabaseProductName();
	this.databaseVersion = dbMetaData.getDatabaseProductVersion();
	this.databaseDriverVersion = dbMetaData.getDriverVersion();
	
	StringBuffer indexBuff = new StringBuffer();
	rs = dbMetaData.getIndexInfo(conn.getCatalog(), null, "sys_wf_workitem",
			false, false);
	while (rs.next()) {
		ResultSetMetaData rsmd = rs.getMetaData();

		for (int i = 1; i <= rsmd.getColumnCount(); i++) {
			String columnName = rsmd.getColumnName(i);
			
			if("COLUMN_NAME".equalsIgnoreCase(columnName))
			{
				indexBuff.append(" [");
				indexBuff.append(rs.getObject(i));
				indexBuff.append("] ");
			}
		}
	}
	this.indexOfWorkitem = indexBuff.toString();

	StringBuffer fkBuff = new StringBuffer();
	rs = dbMetaData.getImportedKeys(conn.getCatalog(), null, "sys_wf_workitem");
	while (rs.next()) {
		ResultSetMetaData rsmd = rs.getMetaData();

		for (int i = 1; i <= rsmd.getColumnCount(); i++) {
			String columnName = rsmd.getColumnName(i);
			
			if("FKCOLUMN_NAME".equalsIgnoreCase(columnName))
			{
				fkBuff.append(" [");
				fkBuff.append(rs.getObject(i));
				fkBuff.append("] ");
			}
		}
	}
	this.fkOfWorkitem = fkBuff.toString();	
	
}

/**
 * 获取组织架构的信息
 */
private void queryOrg() throws SQLException {
	if (st == null) return;

	int orgAmount = 0;
	List orgList = new ArrayList();
	rs = st.executeQuery(SQL_ORG_ELEMENT);
	while (rs.next()) {
		int type = rs.getInt("fd_org_type");
		String typeName = "", avail = "";

		switch (type) {
		case 0x1:
			typeName = "机构";
			break;
		case 0x2:
			typeName = "部门";
			break;
		case 0x4:
			typeName = "岗位";
			break;
		case 0x8:
			typeName = "个人";
			break;
		case 0x10:
			typeName = "群组";
			break;
		case 0x20:
			typeName = "角色";
		}

		boolean isAvailable = rs.getBoolean("fd_is_available");

		if (isAvailable) {
			avail = "有效";
		} else {
			avail = "无效";
		}
		
		orgAmount += rs.getInt("cnt");

		String[] arr = { typeName, avail, rs.getString("cnt") };
		orgList.add(arr);
	}
	
	this.orgList = orgList;
	this.orgAmount = orgAmount;
}

/**
 * 获取流程的信息
 */
private void queryWf() throws Exception {
	if (st == null) return;

	rs = st.executeQuery(getFieldValue("SQL_WF_AVG_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.wfAvgDay = rs.getInt("avg_cnt");
	}
    
	rs = st.executeQuery(getFieldValue("SQL_WF_MAX_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.wfMaxDay = rs.getInt("max_cnt");
	}    
	
	rs = st.executeQuery(SQL_WF_NO_TIME);
	if (rs.next()) {
		this.wfNoTime = rs.getInt("cnt");
	}   	

	int wfTemplateAmount = 0;
	List wfTemplateList = new ArrayList();
	rs = st.executeQuery(SQL_WF_TEMPLATE);
	while (rs.next()) {
		wfTemplateAmount += rs.getInt("cnt");
		String[] arr = { rs.getString("fd_model_name"), rs.getString("cnt") };
		wfTemplateList.add(arr);
	}
	this.wfTemplateList = wfTemplateList;
	this.wfTemplateAmount = wfTemplateAmount;
	
	int wfAmount = 0;
	List wfProcessByModelList = new ArrayList();
	rs = st.executeQuery(SQL_WF_PROCESS_BY_MODELNAME);
	while (rs.next()) {
		wfAmount += rs.getInt("cnt");
		String[] arr = { rs.getString("fd_model_name"), rs.getString("cnt") };
		wfProcessByModelList.add(arr);
	}
	this.wfProcessByModelList = wfProcessByModelList;
	this.wfAmount = wfAmount;

	List wfProcessByStatusList = new ArrayList();
	rs = st.executeQuery(SQL_WF_PROCESS_BY_STATUS);
	while (rs.next()) {
		String[] arr = { rs.getString("fd_status"), rs.getString("cnt") };
		wfProcessByStatusList.add(arr);
	}	
	this.wfProcessByStatusList = wfProcessByStatusList;	

	rs = st.executeQuery(SQL_WF_EVENT);
	if (rs.next()) {
		this.wfEvent = rs.getInt("cnt");
	}

	rs = st.executeQuery(SQL_WF_HISTORY_WORKITEM);
	if (rs.next()) {
		this.wfHistoryWorkitem = rs.getInt("cnt");
	}

	rs = st.executeQuery(SQL_WF_WORKITEM);
	if (rs.next()) {
		this.wfWorkitem = rs.getInt("cnt");
	}
}

/**
 * 在时间域查询流程的信息
 */
private void queryWfByTime() throws SQLException {
	if (conn == null) return;

	int wfMonthAmount = 0;
	List wfProcessByMonthList = new ArrayList();

	ps = conn.prepareStatement(SQL_WF_PROCESS_BY_MONTH);
	ps.setString(1, getStartIndex(Calendar.MONTH, -1));
	rs = ps.executeQuery();
	while (rs.next()) {
		wfMonthAmount += rs.getInt("cnt");
		String[] arr = { rs.getString("fd_model_name"), rs.getString("cnt") };
		wfProcessByMonthList.add(arr);
	}
	this.wfProcessByMonthList = wfProcessByMonthList;
    this.wfMonthAmount = wfMonthAmount;
}

/**
 * 获取待办事项的信息
 */
private void queryTodo() throws Exception {
	if (st == null) return;
	
	rs = st.executeQuery(getFieldValue("SQL_TODO_AVG_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.todoAvgDay = rs.getInt("avg_cnt");
	}   
	
	rs = st.executeQuery(getFieldValue("SQL_TODO_MAX_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.todoMaxDay = rs.getInt("max_cnt");
	}  
	
	int todoAmount = 0;
	List todoList = new ArrayList();
	rs = st.executeQuery(SQL_TODO);
	while (rs.next()) {
		int type = rs.getInt("fd_type");
		String typeName = "";

		if (type == 1) {
			typeName = "待办";
		} else if (type == 2) {
			typeName = "待阅";
		}
		
		todoAmount += rs.getInt("cnt");
		String[] arr = { typeName, rs.getString("cnt"), rs.getString("first_time") };
		todoList.add(arr);
	}
	this.todoList = todoList;
	this.todoAmount = todoAmount;
	
	rs = st.executeQuery(SQL_TODO_DONE);
	if (rs.next()) {
		this.todoDone = rs.getInt("cnt");
	}

	rs = st.executeQuery(SQL_TODO_TARGET);
	if (rs.next()) {
		this.todoTarget = rs.getInt("cnt");
	}

}

/**
 * 获取应用日志的信息
 */
private void queryLogApp() throws Exception {
	if (st == null) return;
	
	rs = st.executeQuery(getFieldValue("SQL_LOG_AVG_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.logAvgDay = rs.getInt("avg_cnt");
	}   
	
	rs = st.executeQuery(getFieldValue("SQL_LOG_MAX_DAY_" + this.databaseName.replace(' ', '_')));
	if (rs.next()) {
		this.logMaxDay = rs.getInt("max_cnt");
	}  

}

/**
 * 按时间域获取应用日志的信息
 */
private void queryLogAppByTime() throws SQLException {
	if (conn == null) return;

	//java.sql.Date startDate = new java.sql.Date(getDate(Calendar.DAY_OF_YEAR, -8));
	ps = conn.prepareStatement(SQL_LOG_APP);
	ps.setString(1, getStartIndex(Calendar.DAY_OF_YEAR, -8));
	rs = ps.executeQuery();
	if (rs.next()) {
		this.logApp = rs.getInt("cnt");
	}
	
	
	ps = conn.prepareStatement(SQL_LOG_FIRST_TIME);
	rs = ps.executeQuery();
	if (rs.next()) {
		this.logAppFirstTime = rs.getString("first_time");
	}	

}

/**
 * 统计附件的信息
 */
private void queryAtt() throws SQLException {
	if (st == null) return;

	long attMainTotalSize = 0L;
	int attMainAmount = 0;
	List attMainList = new ArrayList();
	rs = st.executeQuery(SQL_ATT_MAIN);
	while (rs.next()) {
		long m = rs.getLong("total_size");
		String size = String.valueOf(m / kb) + " K";
		attMainTotalSize += m;
		attMainAmount += rs.getInt("cnt");
		String modelName = rs.getString("fd_model_name");
		if(modelName == null) modelName = "";

		String[] arr = { modelName, rs.getString("cnt"), size };
		attMainList.add(arr);
	}
	this.attMainList = attMainList;
	this.attMainTotalSize = String.valueOf(attMainTotalSize / kb) + " K";
	this.attMainAmount = attMainAmount;
	
	long attRtfTotalSize = 0L;
	int attRtfAmount = 0;
	List attRtfList = new ArrayList();
	rs = st.executeQuery(SQL_ATT_RTF_DATA);
	while (rs.next()) {
		long m = rs.getLong("total_size");
		String size = String.valueOf(m / kb) + " K";
		attRtfTotalSize += m;
		attRtfAmount += rs.getInt("cnt");
		String modelName = rs.getString("fd_model_name");
		if(modelName == null) modelName = "";
		
		String[] arr = { modelName, rs.getString("cnt"), size };
		attRtfList.add(arr);
	}
	this.attRtfList = attRtfList;
	this.attRtfTotalSize = String.valueOf(attRtfTotalSize / kb) + " K";
	this.attRtfAmount += attRtfAmount;
}


/**
 * 计算FD_ID
 */
private String getStartIndex(int field, int n) {
	Calendar cal = Calendar.getInstance();
	cal.setTime(new Date());
	cal.add(field, n);
	return Long.toHexString(cal.getTimeInMillis());
}

/**
 * 获取字段值
 */
private String getFieldValue(String fieldName) throws Exception {
	Field field = this.getClass().getDeclaredField(fieldName);
	
	if(field != null) {
		return field.get(this).toString();
	}
	
	return null;
}

private void loadAppLogDate(HttpServletRequest request) throws Exception {
	StringBuffer appLogDate = new StringBuffer();
	int logAppBackupBefore = Integer.parseInt(ResourceUtil
			.getKmssConfigString("kmss.logAppBackupBefore"));
	appLogDate.append("<option value='all'>" + "近" + logAppBackupBefore
			+ "天" + "</option>");
	for (int i = 1; i < logAppBackupBefore + 1; i++) {
		Calendar begincal = Calendar.getInstance();
		begincal.add(Calendar.DATE, -i);
		begincal.set(Calendar.HOUR_OF_DAY, 0);
		begincal.set(Calendar.MINUTE, 0);
		begincal.set(Calendar.SECOND, 0);
		begincal.set(Calendar.MILLISECOND, 0);
		appLogDate.append("<option value="
				+ DateUtil.convertDateToString(begincal.getTime(),
						DateUtil.TYPE_DATE, request.getLocale())
				+ ">"
				+ DateUtil.convertDateToString(begincal.getTime(),
						DateUtil.TYPE_DATE, request.getLocale())
				+ "</option>");
	}
	this.appLogDate = appLogDate.toString();
}
private void loadLoginLogDate(HttpServletRequest request) throws Exception {
	StringBuffer loginLogDate = new StringBuffer();
	int logLoginBackupBefore = Integer.parseInt(ResourceUtil
			.getKmssConfigString("kmss.logLoginBackupBefore"));
	loginLogDate.append("<option value='all'>" + "近" + logLoginBackupBefore
			+ "天" + "</option>");
	for (int i = 1; i < logLoginBackupBefore + 1; i++) {
		Calendar begincal = Calendar.getInstance();
		begincal.add(Calendar.DATE, -i);
		begincal.set(Calendar.HOUR_OF_DAY, 0);
		begincal.set(Calendar.MINUTE, 0);
		begincal.set(Calendar.SECOND, 0);
		begincal.set(Calendar.MILLISECOND, 0);
		loginLogDate.append("<option value="
				+ DateUtil.convertDateToString(begincal.getTime(),
						DateUtil.TYPE_DATE, request.getLocale())
				+ ">"
				+ DateUtil.convertDateToString(begincal.getTime(),
						DateUtil.TYPE_DATE, request.getLocale())
				+ "</option>");
	}
	this.loginLogDate = loginLogDate.toString();
}
/**
 * 转换时间
 */
private String formatTimeSpan(long span) {
	long minseconds = span % 1000;
	span = span / 1000;
	long seconds = span % 60;
	span = span / 60;
	long mins = span % 60;
	span = span / 60;
	long hours = span % 24;
	span = span / 24;
	long days = span;
	return (new Formatter()).format("%1$d天,%2$2d小时,%3$2d分", days, hours,
			mins, seconds, minseconds).toString();
}
%>
