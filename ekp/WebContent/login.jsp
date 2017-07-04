<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.login">
	<template:replace name="head" >
		<link href="${ LUI_ContextPath }/resource/style/default/login/css/reset.css" rel="stylesheet" type="text/css" />
  		<link href="${ LUI_ContextPath }/resource/style/default/login/css/main.css" rel="stylesheet" type="text/css" />
  		<link href="${ LUI_ContextPath }/resource/style/default/login/css/login.css" rel="stylesheet" type="text/css" />
 	</template:replace>
	<template:replace name="body">
	
	
	<!--头部信息 Starts-->
    <div class="v11_login_header">
        <div class="mWidth clr">
            <div class="logoBox">
            	<div class="logoImg"></div>
            	<span class="logoTxt">知识管理与协同领导品牌</span>
            </div>
        </div>
    </div>
    <!--头部信息 Ends-->
    <!--中间主体 Starts-->
    <div class="v11_loginWrapper">
        <div class="v11_loginBox">
            <!--登录框 Starts-->
            <div class="v11_loginBar">
                 <div class="v11_loginBar_headL">
                    <div class="v11_loginBar_headR">
                        <div class="v11_loginBar_headC">
                        </div>
                    </div>
                </div>
                        <div class="v11_loginBar_tabContent">
                        	<table border="0" cellpadding="0" cellspacing="0">
                        		<tr>
                        			<td style="height: 240px;" valign="middle">
                            			<ui:combin ref="login.form"></ui:combin>
                            		</td>
                            	</tr>
                            </table>
                        </div>
                      <div class="v11_loginBar_footerL">
                    <div class="v11_loginBar_footerR">
                        <div class="v11_loginBar_footerC">
                        </div>
                    </div>
                </div>
            </div>
            <!--登录框 Ends-->
			 <!-- 扫一扫 Starts -->
			 <div class="v11_richScan_w">
                <a class="v11_richScan_c"></a>
                <div class="v11_richScan_mask">
                    <div class="v11_richScan_mask_headL">
                        <div class="v11_richScan_mask_headR">
                            <div class="v11_richScan_mask_headC">
                            </div>
                        </div>
                    </div>
                    <div class="v11_richScan_mask_contentL">
                        <div class="v11_richScan_mask_contentR">
                            <div class="v11_richScan_mask_contentC">
                                <ul class="clr">
                                    <li>
                                        <h3>
                                            iPone/iPad
                                        </h3>
                                        <img src="${ LUI_ContextPath }/resource/style/default/login/codes/code_iphone.png" alt="" /><p>
                                            下载iPhone客户端
                                        </p>
                                    </li>
                                    <li>
                                        <h3>
                                            Android
                                        </h3>
                                        <img src="${ LUI_ContextPath }/resource/style/default/login/codes/code_android.png" alt="" /><p>
                                            下载Android客户端
                                        </p>
                                    </li>
                                    <li>
                                        <h3>
                                           蓝凌微云
                                        </h3>
                                        <img src="${ LUI_ContextPath }/resource/style/default/login/codes/micooffice.jpeg" alt="" /><p>
                                            开启微信移动办公之旅
                                        </p>
                                    </li>
                                    <li class="last">
                                        <h3>
                                            微服务平台
                                        </h3>
                                        <img src="${ LUI_ContextPath }/resource/style/default/login/codes/code_service.png" alt="" /><p>
                                           获得蓝凌实时在线服务
                                        </p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="v11_richScan_mask_footL">
                        <div class="v11_richScan_mask_footR">
                            <div class="v11_richScan_mask_footC">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
			 <!-- 扫一扫 Ends -->

        </div>
    </div>
    <!--中间主体 Ends-->
    <!--链接信息 Starts-->
    <div class="mWidth clr">
        <!--产品信息 Starts-->
        <ul class="v11_proInfo clr">
            <li><a title="企业移动社交平台"><span class="icon_pro_KK"></span>企业移动社交平台</a></li>
            <li><a title="KMS知识管理平台"><span class="icon_pro_KMS"></span>KMS知识管理平台</a></li>
            <li><a title="EKP协同办公平台"><span class="icon_pro_EKP"></span>EKP协同办公平台</a></li>
        </ul>
        <!--产品信息 Ends-->
    </div>
    <!--链接信息 Ends-->
    <!--注脚 Starts-->
    <div class="v11_loginFooter">
        <p>为了获得最佳操作体验，建议您使用最新版本的浏览器，支持1024 X 768以上分辨率</p>
        <p>蓝凌软件 版权所有</p>
    </div>
    <!--注脚 Ends-->
<script>		
/*** 扫一扫 ***
*********************************************************************************************************************************************************/

seajs.use(['lui/jquery'], function($) {
	$(document).ready(function () {
	    var MoreLinksShowHandles = null;
	    var NoneHandles = null;
	    var w = $(".v11_richScan_mask").width();
	    var h = $(".v11_richScan_mask").height();
	    $(".v11_richScan_mask").css({ "width": "0px", "height": "0px", "display": "none" });
	    function showMoreLinks() {
	        clearTimeout(MoreLinksShowHandles);
	        clearTimeout(NoneHandles);
	        $(".v11_richScan_mask").css("display", "block");
	        $('.v11_richScan_mask').stop().animate({ "width": w, "height": h }, 1500);
	    }
	    function hideMoreLinks() {
	        MoreLinksShowHandles = setTimeout(function () {
	            $('.v11_richScan_mask').stop().animate({ "width": "0px", "height": "0px" }, 1000);
	        }, 500);
	        NoneHandles = setTimeout(function () { $(".v11_richScan_mask").css("display", "none"); }, 1500);
	    }
	    $(".v11_richScan_c").mouseover(function () {
	        showMoreLinks();
	    });
	    $(".v11_richScan_c").mouseout(function () {
	        hideMoreLinks();
	    });
	    $(".v11_richScan_mask").mouseover(function () {
	        showMoreLinks();
	    });
	    $(".v11_richScan_mask").mouseout(function () {
	        hideMoreLinks();
	    });
	});
});
		
</script> 	
	</template:replace>
</template:include>