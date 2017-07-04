<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content"> 
			<br/>
			<p class="txttitle">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.selectHoldPlace" />
			</p>
			<br/>
			<table class="tb_normal" width="98%">
				<tr>
					<%--会议室名称--%>
					<td class="td_normal_title" width=15%>
					  	<bean:message bundle="km-imeeting" key="kmImeetingRes.fdName" />
					</td>
					<td width=35%>
						<xform:text property="fdName" showStatus="edit" style="width:80%"></xform:text>
					</td>
					<%--所属类别--%>
					<td class="td_normal_title" width=15%>
					  	<bean:message bundle="km-imeeting" key="kmImeetingRes.docCategory" />
					</td>
					<td width=35% >
						<xform:dialog propertyId="docCategoryId" propertyName="docCategoryName" showStatus="edit" className="inputsgl" style="width:90%;float:left">
							Dialog_SimpleCategory('com.landray.kmss.km.imeeting.model.KmImeetingResCategory','docCategoryId','docCategoryName',true,';','00');
						</xform:dialog>
					</td>
				</tr>
				<tr>
					<%--查询按钮--%>
					<td colspan="4" style="text-align: center;">
					  	<%--查询所有资源--%>
						<ui:button id="res_all_btn" text="查询"   onclick="queryResource('all');"/>
					</td>
				</tr>
				<tr>
					<%--资源列表--%>
					<td colspan="4">
						<list:listview id="listview" style="height:200px;overflow-y:scroll;">
							<ui:source type="AjaxJson" >
								{url:'/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=listResources&type=all&rowsize=3'}
							</ui:source>
							<list:colTable isDefault="false" layout="sys.ui.listview.listtable"  name="columntable" onRowClick="selectResouce('!{fdId}','!{fdName}');">
								<list:col-html title=" " style="text-align:left">
									<c:if test="${empty param.multiSelect }">
										{$ <input type="radio" value="{%row['fdId']%}" name="resId" data="{%row['fdName']%}"> $}
									</c:if>
									<c:if test="${not empty param.multiSelect and param.multiSelect==true }">
										{$ <input type="checkbox" value="{%row['fdId']%}" name="resId" data="{%row['fdName']%}"> $}
									</c:if>
								</list:col-html>
								<list:col-serial></list:col-serial>
								<list:col-auto props="fdName;docStatus;docCategory.fdName" ></list:col-auto>
							</list:colTable>
							<ui:event topic="list.loaded">
								if("${param.multiSelect}"){
									var resIds="${param.resId}".split(";");
									for(var i in resIds){
										if(resIds[i]){
											$('[name="resId"][value="'+resIds[i]+'"]').prop('checked',true);
										}
									}
								}else{
									$('[name="resId"][value="${param.resId}"]').prop('checked',true);
								}
							</ui:event>
						</list:listview>
					</td>
				</tr>
				<tr>
					<%--查询按钮--%>
					<td colspan="4" style="text-align: center;">
					  	<%--选择--%>
						<ui:button id="select_resource_submit" text="选择"   onclick="selectSubmit();"/>
						<%--取消--%>
						<ui:button id="select_resource_cancel" text="取消"  onclick="selectCancel();"/>
						<%--取消选定--%>
						<ui:button id="select_resource_cancel" text="取消选定"  onclick="selectCancelSubmit();"/>
					</td>
				</tr>
			</table>
	</template:replace>
</template:include>
<script>
	seajs.use([
 	      'lui/jquery',
 	      'lui/dialog',
 	      'lui/topic'
 	        ],function($,dialog,topic){
		
		//选择资源时触发
		window.selectResouce=function(resId,resName){
			//资源radio置为选中
			$('[name="resId"][value="'+resId+'"]').prop('checked',true);
		};
		
		//查询资源
		window.queryResource=function(type){
			var url=LUI('listview').source.url;
			LUI('listview').source.setUrl(replaceParameter(url,{
				"type":type,
				"fdName":$('[name="fdName"]').val(),
				"fdHoldDate":$('[name="fdHoldDate"]').val(),
				"fdFinishDate":$('[name="fdFinishDate"]').val(),
				"docCategoryId":$('[name="docCategoryId"]').val()
			}));
			LUI('listview').source.get();
		};
		//提交
		window.selectSubmit=function(){
			var resId="",resName="";
			var resElement=$('[name="resId"]');
			for(var i=0;i<resElement.length;i++){
				if($(resElement[i]).prop('checked')==true){
					resId+=$(resElement[i]).val()+";";
					resName+=$(resElement[i]).attr("data")+";";
				}
			}
			if(resId){
				resId=resId.substring(0,resId.length-1);
				resName=resName.substring(0,resName.length-1);
			}
			if(typeof($dialog)!="undefined"){
				//dialog.iframe形式
				$dialog.hide({resId:resId,resName:resName});
			}else{
				//兼容window.open和dialog.showModalDialog形式
				if(window.showModalDialog){
					window.returnValue={resId:resId,resName:resName};
				}else{
					opener.dialogCallback({resId:resId,resName:resName});
				}
				window.close();
			}
		};
		//取消
		window.selectCancel=function(){
			if(typeof($dialog)!="undefined"){
				//dialog.iframe形式
				$dialog.hide(null);
			}else{
				//兼容window.open和dialog.showModalDialog形式
				if(window.showModalDialog){
					window.returnValue=null;
				}else{
					opener.dialogCallback(null);
				}
				window.close();
			}
		};
		//取消选定
		window.selectCancelSubmit=function(){
			if(typeof($dialog)!="undefined"){
				//dialog.iframe形式
				$dialog.hide({resId:"",resName:""});
			}else{
				//兼容window.open和dialog.showModalDialog形式
				if(window.showModalDialog){
					window.returnValue={resId:"",resName:""};
				}else{
					opener.dialogCallback({resId:"",resName:""});
				}
				window.close();
			}
		};
		//修改source的URL
		var replaceParameter=function(url,parameterObj){
			for(var key in parameterObj){
				url=Com_SetUrlParameter(url,key,parameterObj[key]);
			}
			return url;
		}
		
	});
</script>