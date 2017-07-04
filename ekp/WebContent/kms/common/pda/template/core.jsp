<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:block name="header">
	<header class="lui-header lui-core-header">
		<ul class="clearfloat">
			<li class="lui-back">
				<a id="column_button" data-lui-role="button">
					<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon'
						}
						</script>		
				</a>
			</li>
			<li class="lui-docSubject">
				<template:block name="title">
				</template:block>
			</li>
		</ul>
	</header>
</template:block>
<div style="position: absolute;top: 40px;bottom: 0;width: 100%">
	<template:block name="content">
	</template:block>
</div>
<div>
	<template:block name="footer">
	</template:block>
</div>