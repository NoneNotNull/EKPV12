<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<%@page import="com.landray.kmss.sys.authentication.user.KMSSUser"%>
<div data-dojo-type="kms/ask/mobile/js/list/AskView"
	data-dojo-mixins="kms/ask/mobile/js/list/AskScrollableViewMixin">
	<%
		KMSSUser user = UserUtil.getKMSSUser(request);
		request.setAttribute("user", user);
	%>
	<div data-dojo-type="mui/header/Header"
		data-dojo-props="'name'
				:'${user.userName }',imgUrl:'<person:headimageUrl personId="${user.userId}" size="90" />'"
		data-dojo-mixins="kms/ask/mobile/js/list/AskHeaderMixin">

		<div data-dojo-type="mui/header/HeaderItem"
			data-dojo-mixins="mui/folder/_Folder,kms/ask/mobile/js/list/AskHomeButton"></div>

		<div data-dojo-type="mui/nav/MobileCfgNavBar"
			data-dojo-props="defaultUrl:'/kms/ask/mobile/nav.jsp',modelName:'com.landray.kmss.kms.ask.model.KmsAskTopic'">
		</div>
		<div data-dojo-type="mui/header/HeaderItem"
			data-dojo-mixins="mui/folder/Folder"
			data-dojo-props="tmplURL:'/kms/ask/mobile/query.jsp'"></div>
	</div>

	<div data-dojo-type="mui/list/NavSwapScrollableView"
		class="muiAskListView gray"
		data-dojo-mixins="kms/ask/mobile/js/list/AskListScrollableViewMixin">
		<ul data-dojo-type="mui/list/JsonStoreList"
			data-dojo-mixins="kms/ask/mobile/js/list/AskItemListMixin">
		</ul>
	</div>
</div>

