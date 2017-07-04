<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
function config_log_db_selectJdbcType(value){
	var url = document.getElementsByName("value(kmss.log.connection.url)")[0];
	if(JDBC_MAP_URL[value]) {
		url.value = JDBC_MAP_URL[value];
	}
	var dialect = document.getElementsByName("value(kmss.log.dialect)")[0];
	if(JDBC_MAP_DIALECT[value]) {
		dialect.value = JDBC_MAP_DIALECT[value];
	}
	config_log_db_JdbcChange(dialect.value);
}
function config_log_db_JdbcChange(dialect) {
	var oracle = document.getElementById("log_oracle");
	var sqlserver = document.getElementById("log_sqlserver");
	var db2 = document.getElementById("log_db2");
	var mysql = document.getElementById("log_mysql");
	if(dialect == 'org.hibernate.dialect.Oracle9Dialect'){
		sqlserver.style.display = 'none';
		oracle.style.display = 'block';
		db2.style.display = 'none';
		mysql.style.display = 'none';
	}else if(dialect == 'org.hibernate.dialect.SQLServerDialect'){
		sqlserver.style.display = 'block';
		oracle.style.display = 'none';
		db2.style.display = 'none';
		mysql.style.display = 'none';
	}else if(dialect == 'org.hibernate.dialect.MySQL5Dialect'){
		sqlserver.style.display = 'none';
		oracle.style.display = 'none';
		db2.style.display = 'none';
		mysql.style.display = 'block';
	}else if(dialect == 'org.hibernate.dialect.DB2Dialect'){
		sqlserver.style.display = 'none';
		oracle.style.display = 'none';
		db2.style.display = 'block';
		mysql.style.display = 'none';
	}else {
		sqlserver.style.display = 'none';
		oracle.style.display = 'none';
		db2.style.display = 'none';
		mysql.style.display = 'none';
	}
}
function config_log_db_selectConnType(value) {
	var detachment = document.getElementsByName("value(kmss.log.detachment)")[0];
	var tr_url = document.getElementById("tr_log_url");
	var tr_userName = document.getElementById("tr_log_userName");
	var tr_password = document.getElementById("tr_log_password");
	var tr_con_type = document.getElementById("tr_log_type");
	var tr_test = document.getElementById("tr_log_test");

	var driverClass = document.getElementsByName("value(kmss.log.connection.driverClass)")[0];
	var url = document.getElementsByName("value(kmss.log.connection.url)")[0];
	var userName = document.getElementsByName("value(kmss.log.connection.userName)")[0];
	var password = document.getElementsByName("value(kmss.log.connection.password)")[0];
	if(!detachment.checked){
		tr_url.style.display = 'none';
		tr_userName.style.display = 'none';
		tr_password.style.display = 'none';
		tr_con_type.style.display = 'none';
		tr_test.style.display = 'none';

		driverClass.value="oracle.jdbc.driver.OracleDriver";
		url.value ="false";
		userName.value ="false";
		password.value ="false";
	}else if(value && value.checked){
		tr_url.style.display = '';
		tr_userName.style.display = '';
		tr_password.style.display = '';
		tr_con_type.style.display = '';
		tr_test.style.display = '';
		
		driverClass.value="";
		url.value ="";
		userName.value ="";
		password.value ="";
	}
}

config_addOnloadFuncList(config_log_db_selectConnType);

function logDbProcessRequest(request){
	var flag = Com_GetUrlParameter(request.responseText, "flag");
	if(flag){
		alert("数据库连接成功！");
	}else{
		alert("数据库连接失败，请重新配置");
    }
}
function testLogDbConn(){
	var data = new KMSSData();
	data.AddFromField("driver:connurl:username:password", 
		"value(kmss.log.connection.driverClass):"+
		"value(kmss.log.connection.url):"+
		"value(kmss.log.connection.userName):"+
		"value(kmss.log.connection.password)");
	data.SendToUrl("admin.do?method=testDbConn", logDbProcessRequest);
}
</script>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>KMS日志独立数据库配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">是否启用</td>
		<td>
			<label style="float: left;">
				<html:checkbox property="value(kmss.log.detachment)" value="true" onclick="config_log_db_selectConnType(this);"/>
					启用
			</label>
		</td>
	</tr>
	<tr id="tr_log_type">
		<td class="td_normal_title" width="15%">数据库类型</td>
		<td>
			<xform:select property="value(kmss.log.connection.driverClass)" showStatus="edit" onValueChange="config_log_db_selectJdbcType(this.value);" subject="数据库类型" required="true" showPleaseSelect="true">
				<xform:simpleDataSource value="oracle.jdbc.driver.OracleDriver">Oracle</xform:simpleDataSource>
				<xform:simpleDataSource value="net.sourceforge.jtds.jdbc.Driver">SQL Server</xform:simpleDataSource>
				<xform:simpleDataSource value="com.mysql.jdbc.Driver">My SQL</xform:simpleDataSource>
				<xform:simpleDataSource value="com.ibm.db2.jcc.DB2Driver">DB2</xform:simpleDataSource>
			</xform:select>
			<html:hidden property="value(kmss.log.dialect)"/>
		</td>
	</tr>
	<tr id="tr_log_url">
		<td class="td_normal_title" width="15%">数据库连接URL</td>
		<td>
			<xform:text property="value(kmss.log.connection.url)" subject="数据库连接URL" required="true" style="width:85%" showStatus="edit"/><br>
			<div id='log_oracle' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：1521，实例名：ekp
				</span>
			</div>
			<div id='log_sqlserver' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：1433，数据库名：ekp
				</span>
			</div>
			<div id='log_mysql' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：3306，数据库名：ekp
				</span>
			</div>
			<div id='log_db2' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：50000，数据库名：ekp
				</span>
			</div>
		</td>
	</tr>
	<tr id="tr_log_userName">
		<td class="td_normal_title" width="15%">用户名</td>
		<td>
			<xform:text property="value(kmss.log.connection.userName)" subject="用户名" required="true" style="width:150px" showStatus="edit"/>
		</td>
	</tr>
	<tr id="tr_log_password">
		<td class="td_normal_title" width="15%">密码</td>
		<td>
			<xform:text property="value(kmss.log.connection.password)" subject="密码" required="true" style="width:150px" showStatus="edit" htmlElementProperties="type='password'"/>
		</td>
	</tr>
	<tr id="tr_log_test">
		<td class="td_normal_title" width="15%">测试数据库连接</td>
		<td>	
			<input type="button" class="btnopt" value="测试" onclick="testLogDbConn()"/>
		</td>
	</tr>
</table>
