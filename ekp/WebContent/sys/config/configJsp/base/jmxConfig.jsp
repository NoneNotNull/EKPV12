<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script type="text/javascript">
function config_jmx_open(){
	var tbObj = document.getElementById("config.jmx");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}
}

config_addOnloadFuncList(config_jmx_open);
</script>

<table class="tb_normal" width=100% id="config.jmx">
	<tr>
		<td class="td_normal_title" colspan=2>
				<label>
					<b>
                    <xform:checkbox property="value(kmss.jmx.enabled)" onValueChange="config_jmx_open()" showStatus="edit">
						<xform:simpleDataSource value="true">启用JMX服务</xform:simpleDataSource>
					</xform:checkbox>
				</label>
		</td>
	</tr>
	<tr style="display:none" id="kmss.jmx.port">
		<td class="td_normal_title" width="15%">端口号</td>
		<td>
			<xform:text property="value(kmss.jmx.port)" subject="端口号" validators="required number" required="true"  style="width:50px" showStatus="edit" /><br>
			<span class="message">同一个IP地址上的JMX应该设置不同的端口号，例：1991，为了配置方便，建议在JVM的参数中通过：-DLandray.kmss.jmx.port=1991 进行设置</span>
		</td>
	</tr>	
</table>
