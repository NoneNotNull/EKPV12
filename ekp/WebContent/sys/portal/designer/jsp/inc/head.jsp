	<template:replace name="head">
		<template:super/>		
		<style type="text/css">
			.portlet_title {
				float: left;
				color: #3e9ece;
				cursor: pointer;
			}
			.portlet_config {
				float: right;
				
			}
			.portlet_table {
				width: 100%;
				overflow-y: auto;
				margin-top: 5px !important;
			}
			.portlet_tr_title {
				background-color: #f8f8f8;
				color: #ffffff;
				height: 25px;
			}
			.portlet_config span {
				cursor: pointer;
			}
			.tb_layout {
				padding: 0px;
				border: 0px;
			}
			.tb_layout .tb_layout_td {
				padding: 0px;
				border: 0px;
			}
		</style>
		<script>
		seajs.use(['theme!form']);
		Com_IncludeFile("dialog.js");
		</script>
	</template:replace>
	<template:replace name="title">${ lfn:message('sys-portal:sysPortalPage.desgin.addWidget') }</template:replace>