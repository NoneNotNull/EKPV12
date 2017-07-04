 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<script>
	seajs.use(['theme!zone']);
	Com_IncludeFile("ckfilter.js|ckeditor.js", "ckeditor/");
</script>

 <script type="text/javascript"	src="${LUI_ContextPath}/resource/ckeditor/ckeditor.js"></script>
		
		<c:set var="userId" value="${ not empty param.userId ? param.userId : KMSS_Parameter_CurrentUserId }"></c:set>
		<div class="lui_zone_detail" id="person_data_details">
			<ui:dataview>
				<ui:source type="AjaxJson">
					{url:"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=loadPersonData&fdId=${userId }"}
				</ui:source>
				<ui:render type="Template">
					 var editText = "${lfn:message('button.edit')}";
					 var saveText = "${lfn:message('button.save')}";
					 var cancelText = "${lfn:message('button.cancel') }"
					if(data != null && data.length > 0) {
						for(var i = 0; i < data.length; i++) {
							{$	
								<div class="lui_zone_info_data" id="info_{%data[i]['fdId']%}">
									<div id="{%i%}_person_data_name">
										<div class="lui_zone_detail_header">
											<div class="lui_zone_detail_header_r">
												<div class="lui_zone_detail_header_c">
													{%data[i]['fdName']%}
													<c:if test="${param.method eq 'edit' }">
														<a name="{%i%}_person_data_btn"
															data-role = "cancel" 
															class="lui_zone_btn_edit" 
															href="javascript:;" 
															style="display:none;"
														    title="{%editText%}" >
														   <span class="lui_zone_btn_edit_r">
														  	  <span class="lui_zone_btn_edit_c" >
														  	  	{%cancelText%}
														  	  </span>
														   </span>
														</a>
														
														<a name="{%i%}_person_data_btn" 
															data-role = "edit" 
															class="lui_zone_btn_edit" 
															href="javascript:;" 
														    title="{%editText%}" >
														   <span class="lui_zone_btn_edit_r">
														  	  <span class="lui_zone_btn_edit_c" >
														  	  	{%editText%}
														  	  </span>
														   </span>
														</a>
											            <a name="{%i%}_person_data_btn" 
											               class="lui_zone_btn_edit" 
											               data-role = "save" 
											               href="javascript:;" 
											               title="{%saveText%}" 
											               style="display:none;">
											               <span class="lui_zone_btn_edit_r">
											              		 <span class="lui_zone_btn_edit_c">
											              		 	{%saveText%}
											              		 </span>
											               </span>
											              </a>
											          </c:if>
												</div>
											</div>
										</div>
										<div id="{%i%}_person_data_content_div" class="clearfloat lui_zone_detail_content">
											<div class="lui_zone_content_replace">
												{%data[i]['docContent']%}
											</div>
											<form style="display:none;" 
												  id="{%i%}_sysZonePersonDataForm" 
												  name="sysZonePersonDataForm" 
												  action="${LUI_ContextPath}/sys/zone/sys_zone_person_data/sysZonePersonData.do?method=update">
												<input type="hidden"  name="fdDataCateId" value="{%data[i]['fdDataCateId']%}"/>
											  	<input type="hidden"  name="fdName" value="{%data[i]['fdName']%}"/>
											  	<input type="hidden"  name="fdId" value="{%data[i]['fdId']%}"/>
											  	<input type="hidden"  name="fdOrder" value="{%data[i]['fdOrder']%}"/>
											  	<input type="hidden"  name="docContent" value="{%data[i]['docContent']%}"/>
											  	<input type="hidden"  name="fdPersonId" value="${userId}"/>
											</form>
										</div>
									</div>
								</div>
							$}
						}
					}else { {$ <div/>$} }
				</ui:render>
				<ui:event event="load">
						
						var editors = {}
						$("[name$='_person_data_btn']").on("click", function() {
							var thisName = $(this).attr("name");
							var index = thisName.substr(0,1);
							var type = $(this).attr("data-role");
							$(this).hide();
							var replaceObj = $("#" + index + "_person_data_content_div").find(".lui_zone_content_replace")[0];
							if(type == "edit") {
								if(replaceObj) {
									var editor =  CKEDITOR.replace(replaceObj);
									editors[index] = editor;
								}
								
								$("[name=" + thisName + "][data-role='save']").show();
								$("[name=" + thisName + "][data-role='cancel']").show();
							} else if("cancel" == type) {
								if(editors[index] != null) {
									/*不更新*/
									editors[index].destroy(true);
									editors[index] = null;
								}
								$("[name=" + thisName + "][data-role='save']").hide();
								$("[name=" + thisName + "][data-role='edit']").show();
							} else if("save" == type) {
								if(editors[index] != null) {		
									var content = editors[index].getData();
										content = base64Encode(content);
									$("form[id='"+ index +"_sysZonePersonDataForm'] input[name='docContent']").val(content);
									
									seajs.use(['lui/dialog' ], function(dialog) {
										var load = dialog.loading('', $('body'));
										$.ajax({
											dataType:"json",
											type:"post",
											url:$("form[id='"+ index +"_sysZonePersonDataForm']").attr("action"),
											data:$("form[id='"+ index +"_sysZonePersonDataForm']").serialize(),
											success:function(data) {										
													load.hide();
													dialog.success(data.title);
													editors[index].destroy(false);
													editors[index] = null;
											},
											error : function() {
												editors[index].destroy(true);
												$("form[id='"+ index +"_sysZonePersonDataForm'] input[name='docContent']").val(replaceObj.innerHTML);
												editors[index] = null;
												load.hide();
												dialog.failure("${lfn:message('return.optFailure')}");
											}
											
										});
									});
									$("[name=" + thisName + "][data-role='edit']").show();
									$("[name=" + thisName + "][data-role='cancel']").hide();
								}
								
							}
						});

				</ui:event>
			</ui:dataview>
		</div>
		