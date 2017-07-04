<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<%@ include file="/kms/wiki/index_tmpl.jsp" %>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_list_allVersion_js.jsp" %>
<title>维基库-查看历史版本</title>
</head>
<body>
<div id="wrapper">
<div id="main" class="box c">
		<div class="content3" style="width: 1030px;">
			<div class="location">
				<a title="首页" class="home" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=index">首页</a>&gt;
				<a title="维基库" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.wiki">维基库</a>&gt;
				查看历史版本
			</div>
			<br/>
			<div class="clear"></div>
			<h1 class="title">${docSubject}</h1> 
			<div class="title4 tabview">
				<span>共${editionCount}个版本</span>
			</div>
			<kms:tabportlet id="allVersionTab" cssClass="con con2 con2_2 m_t20">
				<kms:portlet cssClass="tagContent" id="allVersion" title="版本比对" dataType="Bean" dataBean="kmsWikiMainVersion" beanParm="{s_method:\"findVersionList\",ordertype:\"down\",fdFirstId :\"${param.fdFirstId}\",orderby:\"docAlterTime\"}" template="wiki_allversion_list_tmpl" callBack="KMS.listCallBack"></kms:portlet>
			</kms:tabportlet>
			
			
		</div>
	</div><!-- main end -->
</div>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>