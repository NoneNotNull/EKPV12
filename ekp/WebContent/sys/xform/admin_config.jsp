<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>表单配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">移动端中使用两列模式</td>
		<td>
			<label style="float: left;">
				<html:checkbox property="value(sys.xform.pda.layout.2col)" value="true" />
					开启<br/>
					注:<br/>
					1、默认是展现同pc端相同排版；<br/>
					2、开启后将变成同主数据相同的两列模式，明细表也一样展现为两列模式；<br/>
					3、更改此选项，为确保已生成的自定义表单兼容移动端，需要到sys中执行“重新生成JSP”操作方才有效。
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">移动端中使用JSP片段</td>
		<td>
			<label style="float: left;">
				<html:checkbox property="value(sys.xform.pda.jsp)" value="true" />
					开启<br/>
					注:<br/>
					1、选择未开启（默认），移动端会自动过滤（即屏蔽）表单中JSP片段的内容；<br/>
					2、选择开启，移动端将支持JSP片段，请确保JSP代码兼容多浏览器；<br/>
					3、更改此选项，为确保已生成的自定义表单兼容移动端，需要到sys中执行“重新生成JSP”操作方才有效。
			</label>
		</td>
	</tr>
</table>
 