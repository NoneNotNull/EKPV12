<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<tr>
	<td>
		表格内容中的文字必须以“#明细表#”开头,如果在此内容后加上其他信息，系统会将该信息作为明细表详细配置信息所在sheet。如：”#明细表#工作明细“，
			在系统会查找excel中“工作明细”对应sheet中内容，作为明细表的详细配置信息。。
	</td>
	<td>
		1、明细引用定义：<br/>
		<img src="${LUI_ContextPath}/sys/xform/impt/help/images/detailtable_define.png"/>
		<br/>2、明细配置所在sheet定义：<br/>
		<img src="${LUI_ContextPath}/sys/xform/impt/help/images/detailtable_define1.png"/>
		<br/>3、明细配置定义：<br/>
		<img src="${LUI_ContextPath}/sys/xform/impt/help/images/detailtable_define2.png"/>
	</td>
	<td>
		<img src="${LUI_ContextPath}/sys/xform/impt/help/images/detailtable_preview.png"/>
	</td>
</tr>
