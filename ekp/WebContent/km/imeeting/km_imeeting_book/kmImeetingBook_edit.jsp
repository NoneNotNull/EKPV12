<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
		<html:form action="/km/imeeting/km_imeeting_book/kmImeetingBook.do"  styleId="bookform">
			<html:hidden property="fdId" />
			<html:hidden property="docCreatorId" />
			<table class="tb_normal" width="98%" style="margin-top: 15px;">
				<tr>
					<td colspan="4" class="com_subject" style="font-weight: bold;">基础信息</td>
				</tr>
				<tr>
	     			<%--会议名称--%>
	              	<td width="15%" class="td_normal_title" >
	              		<bean:message bundle="km-imeeting" key="kmImeetingBook.fdName" />
	              	</td>
	              	<td width="85%" colspan="3" >
	              		<xform:text property="fdName" style="width:90%"></xform:text>
	              	</td>
	            </tr>
				<tr>
					<%--召开时间/结束时间--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate" />
					</td>
					<td width="85%" colspan="3">
						<xform:datetime property="fdHoldDate" dateTimeType="datetime" validators="after compareTime" required="true" onValueChange="changeHoldDate"></xform:datetime>
						<span style="position: relative;top:-5px;">~</span>
						<xform:datetime property="fdFinishDate" dateTimeType="datetime" validators="after compareTime" required="true"></xform:datetime>
						<input type="hidden" name="fdHoldDuration" />
					</td>
				</tr>
				<tr>
	     			<%--备注--%>
	              	<td width="15%" class="td_normal_title"  valign="top">
	              		<bean:message bundle="km-imeeting" key="kmImeetingBook.fdRemark" />
	              	</td>
	              	<td width="85%" colspan="3" >
	              		<xform:textarea property="fdRemark" style="width:90%"/>
	              	</td>
	            </tr>
	            <tr>
					<td colspan="4" class="com_subject" style="font-weight: bold;">会议室信息</td>
				</tr>
				<tr>
					<%--会议地点--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingBook.fdPlace" />
					</td>
					<td width="35%"  >
						<input type="hidden" name="fdPlaceId" value="${kmImeetingBookForm.fdPlaceId }">
						<input type="hidden" name="fdPlaceName" value="${kmImeetingBookForm.fdPlaceName }">
						<c:out value="${res.fdName}"></c:out>
					</td>
					<%--保管员--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.docKeeper" />
					</td>
					<td width="35%" >
						<c:out value="${res.docKeeper.fdName}"></c:out>
					</td>
				</tr>
				<tr>
					<%--地点楼层--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdAddressFloor" />
					</td>
					<td width="35%" >
						<c:out value="${res.fdAddressFloor}"></c:out>
					</td>
						<%--容纳人数--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdSeats" />
					</td>
					<td width="35%" >
						<c:out value="${res.fdSeats}"></c:out>
					</td>
				</tr>
				<tr>
					<%--设备详情--%>
					<td width="15%" class="td_normal_title" >
						<bean:message bundle="km-imeeting" key="kmImeetingRes.fdDetail" />
					</td>
					<td width="85%" colspan="3" >
						<c:out value="${res.fdDetail}"></c:out>
					</td>
				</tr>
			</table>
			<div style="margin: 15px auto;width: 200px;">
				<center>
					<ui:button text="${lfn:message('button.save')}"  onclick="save();" />&nbsp;
					<c:if test="${kmImeetingBookForm.method_GET=='edit' }">
						<ui:button text="${lfn:message('button.delete')}" styleClass="lui_toolbar_btn_gray" onclick="del();" />&nbsp;
					</c:if>
			        <ui:button text="${lfn:message('button.close')}"  styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"/> 
		        </center>
			</div>
		</html:form>
	</template:replace>
</template:include>
<script>Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");</script>
<script>
	seajs.use(['theme!form']);
	seajs.use([
		'km/imeeting/resource/js/dateUtil',
	    'lui/jquery',
	    'lui/dialog',
	    'lui/topic',
	    'lui/toolbar'
	    ], function(dateUtil,$, dialog,topic,toolbar) {
			var validation=$KMSSValidation();

			//校验召开时间不能晚于结束时间
			var _compareTime=function(){
				var fdHoldDate=$('[name="fdHoldDate"]');
				var fdFinishedDate=$('[name="fdFinishDate"]');
				var result=true;
				if( fdHoldDate.val() && fdFinishedDate.val() ){
					var start=dateUtil.parseDate(fdHoldDate.val());
					var end=dateUtil.parseDate(fdFinishedDate.val());
					if( start.getTime()>=end.getTime() ){
						result=false;
					}
				}
				return result;
			};
			
			//自定义校验器:校验召开时间不能晚于结束时间
			validation.addValidator('compareTime','${lfn:message("km-imeeting:kmImeetingMain.fdDate.tip")}',function(v, e, o){
				 var docStartTime=document.getElementsByName('fdHoldDate')[0];
				 var docFinishedTime=document.getElementsByName('fdFinishDate')[0];
				 var result= _compareTime();
				 if(result==false){
					KMSSValidation_HideWarnHint(docStartTime);
					KMSSValidation_HideWarnHint(docFinishedTime);
				}
				return result;
			});
			
			//召开时间变化时触发
			window.changeHoldDate=function(){
				var fdHoldDate=$('[name="fdHoldDate"]');
				var fdFinishedDate=$('[name="fdFinishDate"]');
				if(!fdFinishedDate.val() 
						|| dateUtil.parseDate(fdFinishedDate.val()).getTime()<dateUtil.parseDate(fdHoldDate.val()).getTime() ){
					$('[name="fdFinishDate"]').val(fdHoldDate.val());
				}
			};
			
			
			//删除会议室预约
			window.del=function(){
				var fdId=$('[name="fdId"]').val();
				var url="${LUI_ContextPath}/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=delete&fdId="+fdId;
				dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
					if(value==true){
						$.get(url,function(data){
							if (data && data['status'] === true) {
								if(window.$dialog!=null){
									$dialog.hide("success");
								}else{
									window.close();
								}
							}
						},'json');
					}
				});
			};
			
			//保存会议室预约
			window.save=function(){
				//校验
				if(validation.validate()==false){
					return;
				}
				var method = "save";
				var last_method = Com_GetUrlParameter(window.location.href, "method");
				if("edit"==last_method){
					method = "update";
				}
				//资源冲突检测
				var fdPlaceId=$('[name="fdPlaceId"]').val();
				$.ajax({
					url: "${LUI_ContextPath}/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=checkConflict",
					type: 'POST',
					dataType: 'json',
					data: {bookId:$('[name="fdId"]').val() , fdPlaceId: $('[name="fdPlaceId"]').val(), "fdHoldDate":$('[name="fdHoldDate"]').val() , "fdFinishDate":$('[name="fdFinishDate"]').val() },
					success: function(data, textStatus, xhr) {//操作成功
						if(data && !data.result ){
							//不冲突
							ajaxSubmit(method);
						}else{
							//冲突
							dialog.alert("${lfn:message('km-imeeting:kmImeetingBook.conflict.tip')}".replace('%Place%',$('[name="fdPlaceName"]').val()));
						}
					}
				});
			};

		var ajaxSubmit=function(method){
			var start=dateUtil.parseDate($('[name="fdHoldDate"]').val()),
				end=dateUtil.parseDate($('[name="fdFinishDate"]').val());
			$('[name="fdHoldDuration"]').val(end.getTime()-start.getTime());//记录会议历时
			var url='${LUI_ContextPath}/km/imeeting/km_imeeting_book/kmImeetingBook.do?method='+method;
			$.ajax({
				url: url,
				type: 'POST',
				dataType: 'json',
				async: false,
				data: $("#bookform").serialize(),
				success: function(data, textStatus, xhr) {//操作成功
					if (data && data['status'] === true) {
						if(window.$dialog!=null){
							$dialog.hide("success");
						}else{
							window.close();
						}
					}
				},
				error:function(xhr, textStatus, errorThrown){//操作失败
					dialog.success('<bean:message key="return.optFailure" />');
					if(window.$dialog!=null){
						$dialog.hide(null);
					}else{
						window.close();
					}
				}
			});
		};
	});
</script>