<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="navForm" value="${requestScope[param.formName] }" scope="page" />
				<tr>
					<td colspan="2">
						<table id="linksTable" class="tb_normal" width="100%">
							<col width="5%">
							<col width="30%">
							<col width="40%">
							<col width="25%">
							<tr class="tr_normal_title">
								<td>
									<span style="white-space:nowrap;">序号</span>
								</td>
								<td>名称</td>
								<td>链接</td>
								<td>打开方式</td>
							</tr>
							<c:forEach items="${navForm.sysNavCategoryForm.fdLinks}" var="link" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td align="left">
									${vstatus.index + 1}
								</td>
								<td>
									<c:out value="${link.fdName}" />
								</td>
								<td>
									<c:out value="${link.fdUrl}" />
								</td>
								<td>
									<sunbor:enumsShow enumsType="sysPerson_urlTarget" value="${link.fdTarget}" />
								</td>
							</tr>
							</c:forEach>
						</table>
						<script>
						$(document).ready(function() {
							$('[name="fdName"]').attr('readonly', true).css("border", 'none');
						});
						</script>
					</td>
				</tr>
