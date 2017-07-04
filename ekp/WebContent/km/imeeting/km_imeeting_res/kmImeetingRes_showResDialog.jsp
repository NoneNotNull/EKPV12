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
					<%--召开时间--%>
					<td class="td_normal_title" width=15%>
					  	<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDate" />
					</td>
					<td width=35%>
						<xform:datetime property="fdHoldDate" showStatus="edit" required="true" value="${param.fdHoldDate}"></xform:datetime>
					</td>
					<%--结束时间--%>
					<td class="td_normal_title" width=15%>
					  	<bean:message bundle="km-imeeting" key="kmImeetingMain.fdFinishDate" />
					</td>
					<td width=35%>
						<xform:datetime property="fdFinishDate" showStatus="edit" required="true" value="${param.fdFinishDate}"></xform:datetime>
					</td>
				</tr>
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
					<td width=35%>
						<xform:dialog propertyId="docCategoryId" propertyName="docCategoryName" showStatus="edit" className="inputsgl" style="width:90%;float:left">
							Dialog_SimpleCategory('com.landray.kmss.km.imeeting.model.KmImeetingResCategory','docCategoryId','docCategoryName',true,';','00');
						</xform:dialog>
					</td>
				</tr>
				<tr>
					<%--查询按钮--%>
					<td colspan="4" style="text-align: center;">
					  	<%--查询所有资源--%>
						<ui:button id="res_all_btn" text="查询所有资源"   onclick="queryResource('all');"/>
						<%--查询空闲资源--%>
						<ui:button id="res_free_btn" text="查询空闲资源"  onclick="queryResource('free')"/>
					</td>
				</tr>
				<tr>
					<%--资源列表--%>
					<td colspan="4">
						<list:listview id="listview" style="height:200px;overflow-y:scroll;">
							<ui:source type="AjaxJson" >
								{url:'/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=listResources&type=free&rowsize=3&fdHoldDate=${param.fdHoldDate}&fdFinishDate=${param.fdFinishDate} }'}
							</ui:source>
							<list:colTable isDefault="false" layout="sys.ui.listview.listtable"  name="columntable" onRowClick="selectResouce('!{fdId}','!{fdName}','!{select}');">
								<list:col-html title=" " style="text-align:left">
									var disabled="";
									if(row['select']==0) 
										disabled='disabled="disabled"'
									{$ <input type="radio" value="{%row['fdId']%}" name="resId"  {%disabled%} onclick="selectResouce('{%row['fdId']%}','{%row['fdName']%}','{%row['select']%}');"> $}
								</list:col-html>
								<list:col-serial></list:col-serial>
								<list:col-auto props="fdName;docStatus;docCategory.fdName" ></list:col-auto>
							</list:colTable>
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

		//已选资源
		var selectedResource={resId:"${param.resId}",resName:"${param.resName}"};
		$('[name="resId"][value="${param.resId}"]').prop('checked',true);
		
		//选择资源时触发
		window.selectResouce=function(resId,resName,select){
			//可选中才触发此事件
			if(select=="1"){
				//资源radio置为选中
				$('[name="resId"][value="'+resId+'"]').prop('checked',true);
				selectedResource['resId']=resId;
				selectedResource['resName']=resName;
			}
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
			selectedResource.fdHoldDate=$('[name="fdHoldDate"]').val();
			selectedResource.fdFinishDate=$('[name="fdFinishDate"]').val();
			$dialog.hide(selectedResource);
		};
		//取消
		window.selectCancel=function(){
			$dialog.hide(null);
		};
		//取消选定
		window.selectCancelSubmit=function(){
			$dialog.hide({resId:"",resName:""});
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