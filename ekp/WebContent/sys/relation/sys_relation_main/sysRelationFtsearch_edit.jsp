<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp" %>
<center>
<table class="tb_normal" width="100%" id="tb_ftsearch_Container">
 	<tr>
		<%--关键字--%>
		<td width="15%" style="height: 40; padding-left: 15px;">
			<bean:message bundle="sys-ftsearch-db" key="search.search.keyword"/>
		</td>
		<td style="height: 40">
			<input type="hidden" name="fdId">
			<input type="hidden" name="fdType">
			<input type="hidden" name="fdModuleModelName">
			<input type='text' name="fdKeyWord" class="inputsgl" style="width:80%"  />
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<%--创建者--%>
		<td width="15%" style="height: 40; padding-left: 15px;">
			<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.Creator"/>
		</td>
		<td style="height: 40">
			<input type='hidden' name='docCreatorId' />
			<input type='text' name='docCreatorName' readonly="readonly" class="inputsgl" style="width:80%"  />
			 <a href="#" onclick="Dialog_Address(false, 'docCreatorId','docCreatorName', ';',ORG_TYPE_PERSON);"> 
				<bean:message key="dialog.selectOrg" />
			</a>
			<a href=# onclick="clearField('docCreatorId;docCreatorName');"><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.clearTime"/></a>
		</td>
	</tr>
	<tr>
		<%--创建时间--%>
		<td width="15%" style="height: 40; padding-left: 15px;">
			<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.CreateTime"/>
		</td>
		<td>
			<table border="0" width="100%">
				<tr>
					<td style="text-align: left; border: none;">
						<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.fromCreateTime"/>
						<input type='text' name="fdFromCreateTime" readonly="readonly" class="inputsgl" />
						<nobr>
						<a href="#" onclick="selectDate('fdFromCreateTime');" ><bean:message key="dialog.selectTime" /></a>
						</nobr>
						<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.toCreateTime"/>
						<input type='text' name="fdToCreateTime" readonly="readonly" class="inputsgl" />
						<nobr>
						<a href="#" onclick="selectDate('fdToCreateTime');" ><bean:message key="dialog.selectTime" /></a>
						</nobr>
						<nobr>
						<a href="#" onclick="clearField('fdFromCreateTime;fdToCreateTime');"><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.clearTime"/></a>
				   		</nobr>
				   	</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
		<td colspan="2">
		<%--搜索范围---%>
		<div style="width: 100%;margin-top: 5px;margin-bottom: 15px">
			<div style="height: 30px;">
				<div style="float: left;padding-left: 10px;margin-top: 5px">
					<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.searchRange"/>
				</div>
				<div style="float: right;margin-right: 10px">
					<input id="checkAll" type="checkbox" onclick="selectAll(this)" >
					<span id='checkBoxAll' style="color: red">
						<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>
					</span>
	 			</div>
			</div>
			<div style="width: 100%;text-align: center;">
				<table style="width:97%;border: 1px dotted #0066FF;">
					<tr>
			  		<c:forEach items="${entriesDesign}" var="element" varStatus="status">
				  		<td style="border: 0" width="25%">
							<input type="checkbox" name="fdSearchScope"
								onclick="selectElement(this);" value="${element['modelName']}" /> 
									${element['title']} 
						</td>
						<c:if test="${(status.index+1) mod 4 eq 0}">
							</tr>
							<c:if test="${!(status.last)}">
								<tr>
							</c:if>
						</c:if>
					</c:forEach>
					<c:if test="${entriesDesignCount mod 4 ne 0}">
						<c:if test="${entriesDesignCount mod 4 eq 1}">
							<td style="border: 0" width="25%"></td>
							<td style="border: 0" width="25%"></td>
							<td style="border: 0" width="25%"></td>
						</c:if>
						<c:if test="${entriesDesignCount mod 4 eq 2}">
							<td style="border: 0" width="25%"></td>
							<td style="border: 0" width="25%"></td>
						</c:if>
						<c:if test="${entriesDesignCount mod 4 eq 3}">
							<td style="border: 0" width="25%"></td>
						</c:if>
					</c:if>
					</tr>
				</table>
			</div>
		</div>
		</td>
	</tr> 
</table>
<br /><br />
<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="doOK();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" class="btnopt" value="<bean:message key="button.close" />" onclick="Com_CloseWindow();" />
</center>
<%@ include file="sysRelationFtsearch_edit_script.jsp"%>
<%@ include file="/resource/jsp/edit_down.jsp" %>
