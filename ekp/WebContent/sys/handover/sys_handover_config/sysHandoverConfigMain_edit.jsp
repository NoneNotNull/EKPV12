<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.landray.kmss.util.ResourceUtil,java.io.File"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="auto" width="980px">
    <template:replace name="head">
		<script type="text/javascript">
				seajs.use("${LUI_ContextPath}/sys/handover/resource/css/handover.css");
				seajs.use(['${LUI_ContextPath}/sys/handover/sys_handover_config/js/hand.js','lui/jquery'], function(hand,$) {
					    _hand = hand;
						//查询全选
						window.searchCheckAll = function() {
							hand.searchCheckAll();
					    };
					    //处理全选
					    window.executeCheckAll = function() {
							hand.executeCheckAll("resultContent");
					    };
					    //查询
					    window.searchOperation = function(){
					    	hand.searchOperation();
					        $("#_executeSelectAll").prop("checked",'checked');
						};
						//重置
					    window.resetOperation = function(){
					    	$("#resultDiv").hide();
					    	$("#searchDiv").show();
		    		 		$("#resultContent").html('');
		    		 		$("#noResultContent").html('');

		    		 		$("input[name='fdFromId']").val("");
		    		 		$("input[name='fdFromName']").val("");
		    		 		$("input[name='fdToId']").val("");
		    		 		$("input[name='fdToName']").val("");

		    		 	    $("#from_edit").show();
		    		 		$("#from_view").hide();

		    		 		$("#_searchSelectAll").prop("checked",'checked');
		    		 		//全选
		    		 		searchCheckAll();

					    };
						//处理
					    window.executeOperation = function(){
					    	hand.executeOperation();
						};
                        //一键展开折叠
						window.oneKeyShow = function(isShow){
							if(isShow == true){
								 $(".a_spead_onekey").hide();
								 $(".a_retract_onekey").show();
								
							}else{
								 $(".a_retract_onekey").hide();
								 $(".a_spead_onekey").show();
						    }
							hand.oneKeySpead(isShow);
							
						};
						window.moduleCheckOperation = function(obj){
							var isChecked = $(obj).is(":checked"); 
							var id = obj.id;
							id = id.replace(/\./g,"\\\.");
							$("#"+id+"_table").find(":checkbox").each(function () {
								if (isChecked) {
									 $(this).prop("checked",'checked');
							     } else {
							    		if($(this).attr("disabled")!="disabled"){
											 $(this).removeAttr("checked");
										}
							     }
						    }); 
						};
						window.openUrl = function(url){
								if(url==''){
									return;
							    }
				 			  window.open("${LUI_ContextPath}"+url,"_blank");
				 		};
				 		window.changeValue = function(){
					 	      $($("input[name='fdFromName']")[1]).val($("input[name='fdFromName']")[0].value);
				 		};
				 		window.closeDoc = function(){
					 		window.close();
				 		};
				});
		</script>
	</template:replace>
	<%-- 标题 --%>
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-handover:sysHandoverConfigMain.create') } - ${ lfn:message('sys-handover:module.sys.handover') }"></c:out>
	</template:replace>
	<%-- 按钮栏 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<ui:button text="${lfn:message('button.close') }" order="5" onclick="closeDoc();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<%-- 路径 --%>
	<template:replace name="path">
	    <ui:menu layout="sys.ui.menu.nav">
		    <ui:menu-item text="${ lfn:message('home.home')}" icon="lui_icon_s_home">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-handover:module.sys.handover') }" >
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	<%-- 内容 --%>
	<template:replace name="content"> 
	   <!-- 主体开始 -->
        <div class="lui_handover_w main_body">
            <div class="lui_handover_header">
                <%--参数配置 --%>
                <span>${ lfn:message('sys-handover:sysHandoverConfigMain.config') }</span>
                <%-- 重置 --%>
                <ui:button styleClass="btn_reset" text="${ lfn:message('sys-handover:sysHandoverConfigLog.operation.reset') }" id="search" onclick="resetOperation();"/>
            </div>
            <div class="lui_handover_content">
                <%-- 查询条件 --%>
                <table class="tb_simple lui_handover_headTb lui_sheet_c_table">
                    <tr>
                        <%-- 交接人 --%>
                        <td width="7%"> <span>${lfn:message('sys-handover:sysHandoverConfigMain.fdFromName') }</span></td>
						<td width="43%" id="from_edit"><xform:address propertyId="fdFromId"
							propertyName="fdFromName" style="width:65%"
							onValueChange="changeValue()"
							subject="${lfn:message('sys-handover:sysHandoverConfigMain.fdFromName')}"
							showStatus="edit" orgType="ORG_TYPE_POSTORPERSON|ORG_FLAG_AVAILABLEALL" textarea="false"></xform:address>
						</td>
						<td width="43%" id="from_view" style="display: none">
						    <input style="width:65%;height:23px" type="text" name="fdFromName" disabled/>
						</td>
						<%-- 接收人 --%>
						<td width="7%">
                            <span>${lfn:message('sys-handover:sysHandoverConfigMain.fdToName') }</span>
                        </td>
                        <td width="43%">
                           <xform:address propertyId="fdToId" propertyName="fdToName" style="width:65%"
						subject="${lfn:message('sys-handover:sysHandoverConfigMain.fdToName')}"
						showStatus="edit" orgType="ORG_TYPE_POSTORPERSON" textarea="false"></xform:address>
                        </td>
                    </tr>
                </table>
                <%-- 查询部分--%>
                <div class="lui_handover_search" id="searchDiv">
                	<%-- 交接内容--查询全选 --%>
                    <h3 class="title"> ${ lfn:message('sys-handover:sysHandoverConfigMain.content') } 
                         <span class="item ck_all">
                               <input type="checkbox" name="_searchSelectAll" checked="checked" id="_searchSelectAll" onclick="searchCheckAll();"/>
                               <label for="_searchSelectAll">${ lfn:message('sys-handover:sysHandoverConfigLog.operation.selectAll') }</label> 
                          </span>
                    </h3>
                    <div class="lui_handover_search_c">
                        <ul class="clrfix">
                                 <%int n = 0;%>
                          <table>
                           <tr>
                             <c:forEach items="${moduleMapList}" var="module">   
							      <c:forEach items="${module}" var="moduleMap">   
										 <td width="25%">
										     <li><span class="item item_unck">
											      <input type="checkbox" name="searchModuleCheckBox" id="${moduleMap.key}_searchCheck" value="${moduleMap.key}" checked="checked"/>
											      <label for="${moduleMap.key}_searchCheck">${moduleMap.value}</label>
											      </span>
											 </li>
										 </td>
								   <% 
									 n++;
									 if(n%4 == 0){
										 out.print("</tr><tr>");
								  	 }
								   %>
							      </c:forEach>
					  	 	</c:forEach>
					  	 </tr>
					   </table>
                      </ul>
                    </div>
                    <div class="lui_handover_btn_w">
                       <ui:button style="width:100px" text="${ lfn:message('sys-handover:sysHandoverConfigLog.operation.search') }" id="search" onclick="searchOperation();"/>&nbsp;&nbsp;
                   </div>
                </div> 
                <%-- 结果部分--%> 
                <div class="lui_handover_searchResult" style="display: none" id="resultDiv">
                    <input type="hidden" id="mainId" name="mainId"/>
                    <h3 class="title"> ${ lfn:message('sys-handover:sysHandoverConfigMain.searchResult') }
	                      <span class="item item_unck ck_all">
	                        	 <input type="checkbox" name="_executeSelectAll" checked="checked" id="_executeSelectAll" onclick="executeCheckAll();"/>
						    	 <label for="_executeSelectAll">${ lfn:message('sys-handover:sysHandoverConfigLog.operation.selectAll') }</label> 
						    	 <%-- 一键展开/折叠--%> 
						    	 <span class="a_spead_onekey" onclick="oneKeyShow(true);">${ lfn:message('sys-handover:sysHandoverConfigMain.onekeySpred') }</span>
						    	 <span class="a_retract_onekey" onclick="oneKeyShow(false);" style="display: none">${ lfn:message('sys-handover:sysHandoverConfigMain.onekeyRetract') }</span>
	                  	  </span>
                  	</h3>
	                  	<%--记录显示--%> 
	                    <div name="resultContent" class="resultContent" id="resultContent">
	                    </div>
	                    <%--无记录显示--%> 
	                    <div name="noResultContent" class="noResultContent" id="noResultContent">
	                    </div>
	                    <div class="lui_handover_btn_w">
	                         <ui:button style="width:100px" text="${ lfn:message('sys-handover:sysHandoverConfigLog.operation.execute') }" id="execute" onclick="executeOperation();"/>
	                    </div>
                   </div>
               </div>
        </div>
        <!-- 主体结束 -->
	  
	</template:replace>
</template:include>