<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script>
	/**
	 * 绑定按钮
	 */
	function bindButton() {
		var options = {
			s_modelName:'com.landray.kmss.kms.kmaps.model.KmsKmapsCategory',
			s_bean : 'kmsKmapsCategoryList',
			s_type : 'ekp',
			s_dialog : 'true',
			type : 'all',
			open : '<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" />?method=add&categoryId=',
			width : '320px',
			delUrl : '<c:url value ="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" />?method=deleteall'
		};

		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();
		var createEvent = new KMS.opera(options, $('#createMap'));
		createEvent.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, $('#delButton'));
		delEvent.bind_del();

	}

	function kmapsListPath(templateId) {
		var portlet = $('#portlet_location');
		var para = {
				fdCategoryId : templateId
		};
		var param = KMS_JSON(portlet.attr("parameters"));
		;
		var beanParm = KMS_JSON(param.kms.beanParm);
		$.extend(beanParm, para);
		param.kms.beanParm = JSON.stringify(beanParm);
		portlet.attr("parameters", JSON.stringify(param));
		portlet.attr("load", false);
		eval(" " + param.kms.renderer + "('" + param.kms.id + "');");
	}

	function kmapListPage(fdId) {
		KMS.page.listDocByCate(fdId);
		kmapsListPath(fdId);
	}
</script>
