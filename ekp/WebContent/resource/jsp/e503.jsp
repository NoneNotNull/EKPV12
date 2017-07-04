<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>	
<template:include ref="default.message">
	<template:replace name="title">${lfn:message('return.systemInfo') }</template:replace>
	<template:replace name="body">
		<div class="prompt_frame">
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div>
								<div class="prompt_content_error"></div>
								<div class="prompt_content_right">
									<div class="prompt_content_inside">
										<bean:message key="return.title" />
										<div class="msgtitle">${lfn:message('global.service.unavalable') }</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>