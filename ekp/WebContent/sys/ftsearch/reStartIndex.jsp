<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.component.dbop.ds.DataSet"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
body{
	margin:0px auto;
	text-align:center;
}
.con_div{
	position:absolute;
	top:50px;
	left:50%;
	margin:0 0 0 -200px;
	width:400px;
	height:100px;
}
.hit {
	text-align: left;
	line-height: 20px;
	color: red;
	width: 400px;
	margin-left: 10px;
}
</style>

<title><kmss:message key="sys-ftsearch-db:sysFtsearch.reIndex.title" /></title>
<%
//清除数据库的最后索引时间与临时文件及兼容全文检索引擎删除索引目录
String message = "";
DataSet ds = new DataSet();
try {
	String indexDir = ResourceUtil.KMSS_RESOURCE_PATH+ File.separator + "index";
	String lastindexTimeDir =ResourceUtil.KMSS_RESOURCE_PATH + File.separator+ "lastindextime.properties";
	File dir = new File(indexDir);
	File indexTimeDir = new File(lastindexTimeDir);
	if(dir.exists()){
		FileUtils.deleteDirectory(dir); 
	}
	if(indexTimeDir.exists()){
		indexTimeDir.delete();
	}
	dir.mkdirs();
	ds.beginTran();
	ds.executeUpdate("delete from sys_app_config where fd_key = 'com.landray.kmss.sys.ftsearch.db.SearchConfig'");
	ds.commit();
	message = "【清除数据库索引时间和清除记录模块索引时间临时文件】 操作已成功执行";
} catch (Exception ex) {
	ds.rollback();
	message = "执行失败：原因[" + ex.getMessage() + "]";
} finally {
	ds.close();
}
%>	
<div class="con_div">
	<div>
	<p class="hit">
		<%
			out.print(message);
		%>
	</p>
	<p class="txttitle">
		<kmss:message key="sys-ftsearch-db:sysFtsearch.reIndex.txttitle1"/>
	</p>
	<p class="hit">
		<kmss:message key="sys-ftsearch-db:sysFtsearch.reIndex.hitText"/>
	</p>
	<p class="txttitle">
		<kmss:message key="sys-ftsearch-db:sysFtsearch.reIndex.txttitle2"/>
	</p>
	<input class="btnopt" type=button value="<kmss:message key='sys-ftsearch-db:sysFtsearch.reIndex.btn.execute'/>" onclick="DoUpdate(this);">
	<input class="btnopt" type=button value="<kmss:message key='sys-ftsearch-db:sysFtsearch.reIndex.btn.close'/>" onclick="window.close()">
	</div>
</div>
	

<script>
function DoUpdate(btn) {
	Com_OpenWindow('<c:url value="/sys/quartz/sys_quartz_job/sysQuartzJob.do?method=run&fdJobService=indexTaskRunner&fdJobMethod=index"/>', '_self');
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>