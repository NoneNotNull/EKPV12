<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>组织架构同步参数配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">组织导入提交每批次数量</td>
		<td>
			<html:text property="value(kmss.oms.in.batch.size)" style="width:85%"/>
		</td>
	</tr>
	
</table>