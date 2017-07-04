<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<center>
<table class="tb_normal" width=100% id="TABLE_DocList">
	 		<tr>	
				<td class="td_normal_title" width="10%">
					排序号
				</td> 
				<td class="td_normal_title" width="30%">
					目录名
				</td>
				<td class="td_normal_title" width="60%">
					默认可编辑者
				</td>
			</tr>
			<%---内容行--%>
			<c:forEach items="${kmsWikiTemplateForm.fdCatelogList}" var="kmsWikiCatelogTemplateForm" varStatus="vstatus">
			<tr KMSS_IsContentRow="1">
				<td><c:out value='${kmsWikiCatelogTemplateForm.fdOrder}'/></td>
				<td>
					<c:out value='${kmsWikiCatelogTemplateForm.fdName}'/>
				</td>
				<td>
					<c:out value='${kmsWikiCatelogTemplateForm.authTmpEditorNames}'/>
				</td>
			</tr>
			</c:forEach>
</table>
</center>