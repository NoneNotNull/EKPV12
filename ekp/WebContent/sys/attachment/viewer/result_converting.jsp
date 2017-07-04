<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.message">
	<template:replace name="title">文件正在转换</template:replace>
	<template:replace name="body">
		<div class="prompt_frame">
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div>
								<div class="prompt_content_success"></div>
								<div class="prompt_content_right">
									<div class="prompt_content_inside">
										<bean:message key="return.title" />
										<div class="msgtitle">${ lfn:message('sys-filestore:result_converting') }</div>
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