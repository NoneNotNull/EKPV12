<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/personal/style/personal.css" />
<div class="lui-personal">
	<template:block name="header">
		<header class="lui-header" style="position: relative;">
			<ul class="clearfloat">
				<li class="lui-back">
					<a data-lui-role="button">
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon'
						}
						</script>		
					</a>
				</li>
				<li class="lui-docSubject">
					<h2>常用查询</h2>
				</li>
			</ul>
		</header>
	</template:block>
	<div class="content" >
		<template:block name="content">
			<template:block name="info">
				<ul class="lui-content info">
					<li>
						<% 
							String userId = UserUtil.getKMSSUser().getUserId();
							if(userId != null){
						%>
							<img src="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&size=90&fdId=<%=userId %>" width="70px" height="70px">
						<%	}
						%>
					</li>
					<li style="padding-bottom: 10px;">
						<%
		 					String userName = UserUtil.getKMSSUser().getUserName();
		 					if(userName != null ){
	 					%>
								<a class="userName" href="javascript:;"><%=userName %></a>
						<%	} 
		 				%>
					</li>
					<%
		 					String[] postName = UserUtil.getKMSSUser().getPostNames();
		 					if(postName != null && postName.length > 0 ){
 					%>
						<li>
							<span>岗位：</span><span class="strong">
							<%
								for (int i = 0; i < postName.length; i++) {
												out.print(i == 0 ? postName[i] : ";" + postName[i]);
											}
							%>
							</span>
						</li>
					<% }%>
					
					<li>
						<span>部门：</span><span class="strong"><%=UserUtil.getKMSSUser().getDeptName()%></span>
					</li>
				</ul>
			</template:block>
			<div class="myfilter">
				<template:block name="myfilter">
				</template:block>
			</div>
			
			<script>
				function myfilter(key, value) {
					var evt = {
						'type' : 'listChange',
						'prop' : {},
						'filterReset' : true
					};
					if (key) {
						evt.prop['key'] = 'q.' + key;
						evt.prop['value'] = value;
					}
					Pda.Topic.emit(evt);
					Pda.Element('personal-panel').slideLeft__();
					// 加上当前选中标识
					var evt = event || arguments[0];
					$(evt.target).addClass('current');
				}
				
				Pda.Topic.on('listChange',function(){
					$('.myfilter li').removeClass('current');
				});
			</script>
		</template:block>
	</div>
</div>