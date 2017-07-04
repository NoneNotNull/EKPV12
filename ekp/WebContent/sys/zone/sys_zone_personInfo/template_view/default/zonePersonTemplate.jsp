<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld"
	prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use([ 'theme!list', 'theme!portal', 'theme!zone' ]);
</script>

<title><template:block name="title" /></title>

<template:block name="head" />
</head>
<body class="lui_list_body">
	<c:set var="frameWidth" scope="page"
		value="${empty param.width ? '980px' : param.width}" />
	<portal:header var-width="${frameWidth}" />
	<table
		style="width:${frameWidth}; min-width:100%; margin:0px auto 15px auto;">
		<tr>
			<td valign="top">
				<div class="lui_list_body_frame">
					<div id="queryListView" style="width: 100%">
						<template:block name="path" />
						<div class="lui_zone_info_wrap">
							<div class="lui_zone_info_board">

								<div class="lui_zone_info_board_tl">
									<div class="lui_zone_info_board_tr">
										<div class="lui_zone_info_board_tc"></div>
									</div>
								</div>

								<div class="lui_zone_info_board_ml">
									<div class="lui_zone_info_board_mr">
										<div class="lui_zone_info_board_mc">
											<div class="lui_zone_info_board_photo">
												<template:block name="photo" />
											</div>
											<div class="lui_zone_info_board_rcode">
												<template:block name="qrcode" />
											</div>
											<div class="lui_zone_info_board_medal">
												<template:block name="medal" />
											</div>
											<div class="lui_zone_info_board_fans">
												<template:block name="fans" />
											</div>
											<div class="lui_zone_info_board_info">
												<div class="lui_zone_item first">
													<template:block name="signature" />
												</div>

												<div class="lui_zone_item sec">
													<template:block name="Position" />
												</div>

												<div class="lui_zone_item lui_zone_area_field">
													<template:block name="field" />
												</div>

												<dl class="lui_zone_info_board_tag">
													<template:block name="tag" />
												</dl>

											</div>
											<!--个人信息墙 中间 Ends-->
										</div>
									</div>
								</div>

								<div class="lui_zone_info_board_bl">
									<div class="lui_zone_info_board_br">
										<div class="lui_zone_info_board_bc"></div>
									</div>
								</div>

							</div>
						</div>
						<!--员工个人信息墙 Ends-->
						<!--导航栏 Starts-->
						<div class="lui_zone_nav_box">
							<ul class="lui_zone_nav_bar" id="showNavBarUl">
							    <template:block name="navBar" />
							</ul>
						</div>
						<!--导航栏 Ends-->
						<!--主体区域 Starts-->
						<div class="lui_zone_mbody">
							<!--左侧区域 Starts-->
							<div class="lui_zone_mbody_l">
							    <template:block name="bodyL" />
							</div>
							<!--左侧区域 Ends-->
							<!--右侧区域 Starts-->
							<div class="lui_zone_mbody_r">
								<div class="lui_zone_slide_wrap">
								    <template:block name="mbodyR" />
								</div>
							</div>
							<!--右侧区域 Ends-->
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<portal:footer var-width="${frameWidth}" />
	<ui:top id="top"></ui:top>
	<script>
		domain.register("fireEvent",function(data){
			if("resize" == data.name  ) {
				var irameId = data.target || "iframe_body";
				document.getElementById(irameId).style.height = data.data.height + "px";
			}
		});
	</script>
</body>
</html>
