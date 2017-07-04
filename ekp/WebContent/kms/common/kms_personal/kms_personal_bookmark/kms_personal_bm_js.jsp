<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script>

	function bindButton() {

		// 新增删除数据源
		var options = {
			s_modelName:'com.landray.kmss.sys.bookmark.model.SysBookmarkCategory',
			s_bean : 'kmsBookmarkPersonalPortlet',
			s_method : 'getBookmarkCategoryList',
			s_isCustom : true,
			open : '<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=add&docCategoryId=',
			width : '320px',
			delUrl : '<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=deleteall'
		};

		// 新建
		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, $('#delButton'));
		delEvent.bind_del();

	}

	</script>
</script>