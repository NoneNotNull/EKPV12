<%@ page language="java" pageEncoding="UTF-8"
	import="com.landray.kmss.sys.zone.forms.SysZonePersonInfoForm"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super /> - ${lfn:message('sys-zone:sysZonePersonInfo') }
	</template:replace>
	<template:replace name="head">
		<script>
			seajs.use(['theme!zone']);
			Com_IncludeFile("base64.js");
		</script>
	</template:replace>
	<template:replace name="content">
	<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
	    <ui:content title="${lfn:message('sys-zone:sysZonePersonInfo') }">
		<div class="lui_zone_per_right">
			<ul class="lui_zone_per_tab">
			       <li class="lui_zone_per_header">
						<span class="title">基本信息</span>
						<div class="content-r">
							完善个人基本信息
						</div>
						<span  class="lui_zone_base_up arrow">收起</span>
					</li>
					<li class="lui_zone_edit_content_show">
					    <table width=100% class="lui-per-r-t">
							<tr>
								<td><html:form
										action="/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do"
										styleId="sysZonePersonInfoForm">
										<%-- <ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
							 <ui:content title="${lfn:message('sys-zone:sysZonePersonInfo') }"> --%>
										<table class="tb_normal" width=90%>
											<html:hidden property="fdId" value="${KMSS_Parameter_CurrentUserId}" />
											<tr>
												<%--姓名 --%>
												<td width="15%" class="td_normal_title"><bean:message
														bundle="sys-zone" key="sysZonePersonInfo.username" /></td>
												<td width="85%"><html:text property="personName"
														readonly="true" style="width:90%" value="${sysOrgPerson.fdName}"/></td>
											</tr>
											<tr>
												<%--电子邮件--%>
												<td width="15%" class="td_normal_title"><bean:message
														bundle="sys-zone" key="sysZonePersonInfo.email" /></td>
												<td width="85%"><html:text property="email"
														readonly="true" style="width:90%" value="${sysOrgPerson.fdEmail}"/></td>
											</tr>
			
											<tr>
												<%--手机号码--%>
												<td width="15%" class="td_normal_title"><bean:message
														bundle="sys-zone" key="sysZonePersonInfo.fdMobilePhone" /></td>
												<td width="85%"><xform:text property="mobilPhone" validators="phone"
														style="width:90%" value="${sysOrgPerson.fdMobileNo}"  /></td>
											</tr>
			
											<tr>
												<%--公司电话--%>
												<td width="15%" class="td_normal_title"><bean:message
														bundle="sys-zone" key="sysZonePersonInfo.fdCompanyPhone" /></td>
												<td width="85%"><xform:text property="fdCompanyPhone" validators="tel"
														style="width:90%"  value="${sysOrgPerson.fdWorkPhone}" /></td>
											</tr>
											<tr>
												<td width=15% class="td_normal_title"><bean:message
														bundle="sys-organization" key="sysOrgPerson.fdDefaultLang" />
												</td>
												<td width="85%">
													<%
														SysZonePersonInfoForm sysZonePersonForm = (SysZonePersonInfoForm) request
																			.getAttribute("sysZonePersonInfoForm");
																	out.write(sysZonePersonForm.getLangSelectHtml(request,
																			"fdDefaultLang",
																			sysZonePersonForm.getFdDefaultLang()));
													%>
												</td>
											</tr>
											<tr>
											     <td colspan="2" align="center">
											     	 <ui:button text="${lfn:message('button.save') }" order="2" onclick="formSubmit();"></ui:button>
											    </td>						
										    </tr>
										</table>
										<html:hidden property="method_GET" />
									</html:form>  
								</td>
							</tr>
						</table>
					</li>
					<li class="lui_zone_per_header">
						<span class="title">个人签名</span>
						<div id="fdSignatureTextSpan" class="content-r textEllipsis">
							<c:out value="${sysZonePersonInfoForm.fdSignature}"/>
						</div>
						<span  class="lui_zone_base_up arrow">编辑</span>
					</li>
					<li class="lui_zone_edit_content_show lui_zone_edit_content_hide">
					   <table width=100% class="lui-per-r-t" id="signature">
						    <tr>
						     	<td align="center">
						    		<textarea validate="maxLength(600)" 
						    			class="lui_zone_edit_signature" id="fdSignatureArea"><c:out value="${sysZonePersonInfoForm.fdSignature}"/></textarea>
						    	</td>
						    </tr>
						    <tr>
						    	<td  align="center">
						    		<ui:button text="${lfn:message('button.save') }" order="2" onclick="saveFdSignature(this);"/>
						    	</td>
						    </tr>
					    </table>
					</li>
					<li class="lui_zone_per_header"><span class="title">个人资料</span><div class="content-r">尽可能的完善个人资料，让大家更了解你 </div>
					     <span  class="lui_zone_base_up arrow">编辑</span></li>
					<li class="lui_zone_edit_content_show lui_zone_edit_content_hide staffYpage_detailResume" id="person_data_details">
						<c:import url="/sys/zone/sys_zone_personInfo/sysZonePersonInfo_personData_edit_import.jsp" charEncoding="UTF-8"> 
							<c:param name="userId" value="${KMSS_Parameter_CurrentUserId}"/>
							<c:param name="method" value="edit"/>
						</c:import>
					</li>
					<li class="lui_zone_per_header"><span class="title">个人标签</span>
						<div id="tags" class="content-r">${sysZonePersonInfoForm.sysTagMainForm.fdTagNames}</div>
						<span  class="lui_zone_base_up arrow">编辑</span>
                    </li>
                    <li class="lui_zone_edit_content_show  lui_zone_edit_content_hide" id="tag_li">
                       <dl class="lui_zone_info_board_tag" id="tagsEdit" >
							<c:import url="/sys/zone/import/sysTagMain_edit.jsp"
								charEncoding="UTF-8">
								<c:param name="formName" value="sysZonePersonInfoForm" />
								<c:param name="fdKey" value="zonePersonInfoDoc" /> 
								<c:param name="modelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo" />
								<c:param name="fdQueryCondition" value="${KMSS_Parameter_CurrentUserId};${sysZonePersonInfoForm.personName}" /> 
								<c:param name="method"  value="edit"/>
								<c:param name="dialogElement" value=".lui_zone_per_right"></c:param>
							</c:import>
						</dl>
                    </li>
					<li class="lui_zone_per_header" >
						<span class="title">个人简历</span> 
						<span  class="lui_zone_base_up arrow">编辑</span>
					</li>
					<li class="lui_zone_edit_content_show lui_zone_edit_content_hide">
						<input type="hidden" id="oldResumeId" name="oldResumeId" value="">
				        <input type="hidden" id="resumeId" name="resumeId" value="">
						<table class="tb_normal" width=100%>
							<tr>
								<td align="center">
									<ui:button text="保存简历" onclick="saveResume();" id="saveResume" style="display:none;"/>
								</td>
							</tr>
							<tr>
								<td>
									<html:form action="/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do">
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								          <c:param name="fdKey" value="personResume"/>
								          <c:param name="fdMulti" value="false" />
								          <c:param name="enabledFileType" value="*.doc;*.docx;*.ppt;*.pptx" />
								        </c:import> 
							        </html:form>
								</td>
							</tr>
							<c:if test="${personResume == null }">
								<tr id="person_resume_content" style="display: none;">
									<td align="center">
										<span id="person_resume_content_show"></span>
										&nbsp;&nbsp;&nbsp;
										<a id="person_resume_content_del" href="javascript:;" onclick="delPersonResume();">删除</a>
									</td>
								</tr>
							</c:if>
							<c:if test="${personResume != null }">
								<tr id="person_resume_content">
									<td align="center">
										<span id="person_resume_content_show">${personResume.fdFileName }</span>
										&nbsp;&nbsp;&nbsp;
										<a id="person_resume_content_donwload" href="${LUI_ContextPath}/sys/attachment/sys_att_main/sysAttMain.do?${LUI_Cache}&method=download&fdId=${personResume.fdId}">下载</a>
										&nbsp;&nbsp;&nbsp;
										<a id="person_resume_content_del" href="javascript:;" onclick="delPersonResume();">删除</a>
									</td>
								</tr>
							</c:if>
						</table>
					</li>
			</ul> 
		</div>
	</ui:content>
 </ui:panel>
 <script type="text/javascript">
	Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|doclist.js|dialog.js");
</script>
 <script>
 	var NoValidator = {
 			'phone': {
				error : '请输入正确的手机号码。',
				test  : function(value) {
 							var isMobile=/^1\d{10}$/.test(value) && value != 11111111111||value=="";
 							return isMobile;
						}
			},
			'tel' : {
				error : '请输入正确的电话号码。',
				test : function (value) {
							var isWorkPhone=/^(0[0-9]{2,3}\-)?([1-9][0-9]{6,7})+(\-[0-9]{1,4})?$/.test(value)||value=="";
							return isWorkPhone;
					   }
			}

 	};
 	var valid = $KMSSValidation(document.forms['sysZonePersonInfoForm']);
 	valid.addValidators(NoValidator);
 	function formSubmit() {
 		if (!valid.validate()) {
			return;
 		}
		seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
			$.ajax({
				url : '${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=saveOrgPersonInfo',
				type : 'POST',
				dataType : 'text',
				async : false,
				data : $("#sysZonePersonInfoForm").serialize(),
				success:function(data) {
					if(data == 'true') {
						dialog.success('<bean:message key="return.optSuccess" />', $('#sysZonePersonInfoForm'));
					} else {
						dialog.failure('<bean:message key="return.optFailure" />', $('#sysZonePersonInfoForm'));
					}
				} 
			});
		});
 	}
 	// 个性签名保存
	function saveFdSignature() {
		var validate = $KMSSValidation(document.getElementById("signature"));
		if(!validate.validate()) {
			return;
		}
		seajs.use(['lui/jquery', 'lui/dialog','lui/util/env'], function($, dialog, env){
			 var fdSignatureArea=$.trim($("#fdSignatureArea").val());
			 var sign = base64Encode(encodeURI(fdSignatureArea));
			 $.ajax({
					url : '${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=saveFdSignature',
					type : 'POST',
					dataType:"json",
					async : false,
					data :"fdSignatureArea=" + sign,
					success : function(data) {
						if (data == true) {
							dialog.success('<bean:message key="return.optSuccess" />', $("#signature"));
							$("#fdSignatureTextSpan").html(env.fn.formatText($.trim($("#fdSignatureArea").val())));
						} else {
							dialog
							.failure('<bean:message key="return.optFailure" />',$("#signature"));
						}
					}
				});
		});
	}
	LUI.ready(function(){	
		seajs.use('lui/jquery',function($){
			$(".lui_zone_per_tab .lui_zone_per_header").click(function(){
				 if($(this).next().hasClass("lui_zone_edit_content_hide")){
					 $(this).next().show();
					 $(this).next().removeClass("lui_zone_edit_content_hide");
					 $(this).find(".arrow").html("收起");
				 }else{
					 $(this).next().hide();
					 $(this).next().addClass("lui_zone_edit_content_hide");
					 $(this).find(".arrow").html("编辑");
				 }
			 });
		});
	});
			/*
			*简历上传
			*/
			var fileId = null;
			var attName = null;
			var hasSaveResume = false;
			attachmentObject_personResume.on("uploadSuccess", function() {
				//清空附件机制生成的信息
				var fileList =  attachmentObject_personResume.fileList;
				fileId = fileList[fileList.length - 1].fileKey;
				attName = $("#att_xtable_personResume tr").children(".upload_list_filename_edit").text();
				fileList.length = 0;
				//展示附件
				$("#person_resume_content").show();
				$("#person_resume_content_show").text(attName);
				$("#att_xtable_personResume").empty();
				$("#resumeId").val(fileId);
				$("#saveResume").show();
			});
			/*
			*保存简历
			*/
			function saveResume() {
				<c:choose>
					<c:when test="${personResume == null}">
						if($("#resumeId").val() == "" && !hasSaveResume){
							seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic){
								dialog.failure("请上传简历");
							 });
							return;
						}
					</c:when>
					<c:otherwise>
						
					</c:otherwise>
				</c:choose>
				var load = null;
				seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
					load = dialog.loading('简历保存中...');
				});
				$.ajax({
					type:"post",
					url:"${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=saveResume",		
					data:{personId:"${KMSS_Parameter_CurrentUserId}"
						,fileName:attName,
						fileId:$("#resumeId").val()},
					success:function(data) {
						load.hide();
						$("#saveResume").hide();
						seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic){
							dialog.success("保存成功");
						 });
						hasSaveResume = true;
					},
					error:function() {
						load.hide();
						seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic){
							dialog.failure("保存失败");
						 });
					}
				});
			}
			/*
			*删除简历
			*/
			function delPersonResume() {
				seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
					dialog.confirm('确定删除吗', function(flag, d) {
						if (flag) {
							$('#person_resume_content').hide();
							$("#resumeId").val("");
							$("#saveResume").show();
						} else {
							//nothing
						}
					});
				});
				
			}
		</script>
	</template:replace>
</template:include>
