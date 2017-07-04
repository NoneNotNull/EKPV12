<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>个人中心</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">个人空间信息扩展点对应扩展点</td>
		<td>
			<xform:select property="value(sys.person.info.plugin)" showStatus="edit" required="true" showPleaseSelect="false">
				<xform:customizeDataSource className="com.landray.kmss.sys.person.service.plugin.PersonInfoPluginDataSource" />
			</xform:select>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">个人头像扩展点对应扩展点</td>
		<td>
			<xform:select property="value(sys.person.image.plugin)" 
				showStatus="edit" required="true" showPleaseSelect="false">
				<xform:customizeDataSource className="com.landray.kmss.sys.person.service.plugin.PersonImagePluginDataSource" />
			</xform:select>
		</td>
	</tr>
</table>
 