<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script type="text/javascript">
function config_lang_openLang(){
	var tbObj = document.getElementById("config_language");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}
}
config_addOnloadFuncList(config_lang_openLang);
</script>
<table class="tb_normal" width=100% id="config_language">
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label>
					<xform:checkbox property="value(kmss.lang.suportEnabled)" onValueChange="config_lang_openLang()" showStatus="edit">
						<xform:simpleDataSource value="true">多语言支持</xform:simpleDataSource>
					</xform:checkbox>
				</label>
			</b>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">官方语言</td>
		<td>
			<xform:text property="value(kmss.lang.official)" subject="官方语言" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">例：中文为zh-CN，英文为en-US 说明：当用户没有设置默认语言、选择语言的时候，使用官方语言</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">语言配置</td>
		<td>
			<xform:text property="value(kmss.lang.support)" subject="语言配置" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">例：中文|zh-CN;English|en-US</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">语言选择模式</td>
		<td>
			<xform:radio property="value(kmss.lang.select.mode)" subject="语言选择模式" showStatus="edit">
				<xform:simpleDataSource value="select">下拉框</xform:simpleDataSource>
				<xform:simpleDataSource value="radio">单选框</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
</table>
