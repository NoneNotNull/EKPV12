<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
JDBC_MAP_URL = new Array();
JDBC_MAP_DIALECT = new Array();
//SQL Server配置
JDBC_MAP_URL["net.sourceforge.jtds.jdbc.Driver"] = "jdbc:jtds:sqlserver://db.landray.com.cn:1433/ekp";
JDBC_MAP_DIALECT["net.sourceforge.jtds.jdbc.Driver"] = "org.hibernate.dialect.SQLServerDialect";
//Oracle配置
JDBC_MAP_URL["oracle.jdbc.driver.OracleDriver"] = "jdbc:oracle:thin:@db.landray.com.cn:1521:ekp";
JDBC_MAP_DIALECT["oracle.jdbc.driver.OracleDriver"] = "org.hibernate.dialect.Oracle9Dialect";
//DB2配置
JDBC_MAP_URL["com.ibm.db2.jcc.DB2Driver"] = "jdbc:db2://db.landray.com.cn:50000/ekp:driverType=4;fullyMaterializeLobData=true;fullyMaterializeInputStreams=true;progressiveStreaming=2;progresssiveLocators=2;";
JDBC_MAP_DIALECT["com.ibm.db2.jcc.DB2Driver"] = "org.hibernate.dialect.DB2Dialect";
//My Sql配置
JDBC_MAP_URL["com.mysql.jdbc.Driver"] = "jdbc:mysql://db.landray.com.cn:3306/ekp?useUnicode=true&characterEncoding=UTF-8";
JDBC_MAP_DIALECT["com.mysql.jdbc.Driver"] = "org.hibernate.dialect.MySQL5Dialect";
function config_db_selectJdbcType(value){
	var url = document.getElementsByName("value(hibernate.connection.url)")[0];
	if(JDBC_MAP_URL[value]) {
		url.value = JDBC_MAP_URL[value];
	}
	var dialect = document.getElementsByName("value(hibernate.dialect)")[0];
	if(JDBC_MAP_DIALECT[value]) {
		dialect.value = JDBC_MAP_DIALECT[value];
	}
	config_db_JdbcChange(dialect.value);
}
function config_db_JdbcChange(dialect) {
	var oracle = document.getElementById("oracle");
	var sqlserver = document.getElementById("sqlserver");
	var db2 = document.getElementById("db2");
	var mysql = document.getElementById("mysql");
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
function config_db_selectConnType(value) {
	var tr_url = document.getElementById("tr_url");
	var tr_userName = document.getElementById("tr_userName");
	var tr_password = document.getElementById("tr_password");
	var tr_datasource = document.getElementById("tr_datasource");

	var url = document.getElementsByName("value(hibernate.connection.url)")[0];
	var userName = document.getElementsByName("value(hibernate.connection.userName)")[0];
	var password = document.getElementsByName("value(hibernate.connection.password)")[0];
	var datasource = document.getElementsByName("value(hibernate.connection.datasource)")[0];
	if("jndi" == value) {
		tr_url.style.display = 'none';
		tr_userName.style.display = 'none';
		tr_password.style.display = 'none';
		tr_datasource.style.display = '';

		url.disabled = true;
		userName.disabled = true;
		password.disabled = true;
		datasource.disabled = false;
	} else {
		tr_url.style.display = '';
		tr_userName.style.display = '';
		tr_password.style.display = '';
		tr_datasource.style.display = 'none';

		url.disabled = false;
		userName.disabled = false;
		password.disabled = false;
		datasource.disabled = true;
	}
}
function config_db_onloadFunc(){
	var dialect = document.getElementsByName("value(hibernate.dialect)")[0].value;
	config_db_JdbcChange(dialect);
	var _type = document.getElementsByName("value(kmss.connection.type)"), type = null;
	for(var i = 0; i < _type.length; i++) {
		if(_type[i].checked) {
			type = _type[i].value;
			break;
		}
	}
	if(type == null) {
		_type[0].checked = true;
		type = "jdbc";
	}
	config_db_selectConnType(type);
}
config_addOnloadFuncList(config_db_onloadFunc);

function dbProcessRequest(request){
	var flag = Com_GetUrlParameter(request.responseText, "flag");
	if(flag){
		alert("数据库连接成功！");
	}else{
		alert("数据库连接失败，请重新配置");
    }
}
function testDbConn(){
	var data = new KMSSData();
	var _type = document.getElementsByName("value(kmss.connection.type)");
	var type = "jdbc";
	for(var i = 0; i < _type.length; i++) {
		if(_type[i].checked) {
			type = _type[i].value;
			break;
		}
	}
	if("jndi"==type) {
		data.AddFromField("datasource", 
			"value(hibernate.connection.datasource)");
	} else {
		data.AddFromField("driver:connurl:username:password", 
			"value(hibernate.connection.driverClass):"+
			"value(hibernate.connection.url):"+
			"value(hibernate.connection.userName):"+
			"value(hibernate.connection.password)");
	}
	data.SendToUrl("admin.do?method=testDbConn", dbProcessRequest);
}
</script>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>数据库配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">连接类型</td>
		<td>
			<xform:radio property="value(kmss.connection.type)" showStatus="edit" onValueChange="config_db_selectConnType(this.value);" subject="连接类型" required="true">
				<xform:simpleDataSource value="jdbc">JDBC</xform:simpleDataSource>
				<xform:simpleDataSource value="jndi">JNDI</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">数据库类型</td>
		<td>
			<xform:select property="value(hibernate.connection.driverClass)" showStatus="edit" onValueChange="config_db_selectJdbcType(this.value);" subject="数据库类型" required="true" showPleaseSelect="true">
				<xform:simpleDataSource value="oracle.jdbc.driver.OracleDriver">Oracle</xform:simpleDataSource>
				<xform:simpleDataSource value="net.sourceforge.jtds.jdbc.Driver">SQL Server</xform:simpleDataSource>
				<xform:simpleDataSource value="com.mysql.jdbc.Driver">My SQL</xform:simpleDataSource>
				<xform:simpleDataSource value="com.ibm.db2.jcc.DB2Driver">DB2</xform:simpleDataSource>
			</xform:select>
			<html:hidden property="value(hibernate.dialect)"/>
		</td>
	</tr>
	<tr id="tr_url">
		<td class="td_normal_title" width="15%">数据库连接URL</td>
		<td>
			<xform:text property="value(hibernate.connection.url)" subject="数据库连接URL" required="true" style="width:85%" showStatus="edit"/><br>
			<div id='oracle' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：1521，实例名：ekp
				</span>
			</div>
			<div id='sqlserver' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：1433，数据库名：ekp
				</span>
			</div>
			<div id='mysql' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：3306，数据库名：ekp
				</span>
			</div>
			<div id='db2' style="display:none">
				<span class="message">
					服务器地址：db.landray.com.cn，默认连接端口：50000，数据库名：ekp
				</span>
			</div>
		</td>
	</tr>
	<tr id="tr_userName">
		<td class="td_normal_title" width="15%">用户名</td>
		<td>
			<xform:text property="value(hibernate.connection.userName)" subject="用户名" required="true" style="width:150px" showStatus="edit"/>
		</td>
	</tr>
	<tr id="tr_password">
		<td class="td_normal_title" width="15%">密码</td>
		<td>
			<xform:text property="value(hibernate.connection.password)" subject="密码" required="true" style="width:150px" showStatus="edit" htmlElementProperties="type='password'"/>
		</td>
	</tr>
	<tr id="tr_datasource">
		<td class="td_normal_title" width="15%">数据源名称</td>
		<td>
			<xform:text property="value(hibernate.connection.datasource)" subject="数据源名称" required="true" style="width:150px" showStatus="edit" /><br />
			样例，数据源名称：jdbc/ekpds
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">测试数据库连接</td>
		<td>	
			<input type="button" class="btnopt" value="测试" onclick="testDbConn()"/>
		</td>
	</tr>
</table>
