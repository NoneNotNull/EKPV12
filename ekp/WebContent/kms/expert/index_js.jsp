<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_port.js"></script>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>

<script>
	// 向爱问达人提问
	function askToExpert(fdId) {
		window
				.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
	}

	$.getExpertPath = function(data) {
		var tmpl = $('#kms_current_path').html();
		var html = $.getTemplate(tmpl).render(data);
		$('.location').html(html);
	};

	function kmapListPath(templateId) {
		var portlet = $('#portlet_location'), para = {
			fdCategoryId : templateId
		}, param = KMS_JSON(portlet.attr("parameters")), beanParm = KMS_JSON(param.kms.beanParm);
		$.extend(beanParm, para);
		param.kms.beanParm = JSON.stringify(beanParm);
		portlet.attr("parameters", JSON.stringify(param));
		portlet.attr("load", false);
		eval(" " + param.kms.renderer + "('" + param.kms.id + "');");
	}

	function expertListPage(fdId) {
		KMS.page.listDocByCate(fdId);
		kmapListPath(fdId);
	}

	function bindButton() {
		var options = {
			s_modelName:'com.landray.kmss.kms.expert.model.KmsExpertType',	
			s_bean : 'kmsHomeExpertService',
			s_method : 'getCategoryList',
			open : '<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />?method=add&fdCategoryId=',
			width : '440px'
		};
		// 新建
		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();
		var createEvent = new KMS.opera(options, $('#createExpert'));
		createEvent.bind_add();
	}
</script>