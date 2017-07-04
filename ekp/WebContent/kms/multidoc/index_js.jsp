<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>
	function bindButton() {
		var docOptions = {
			s_modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
			open : '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=',
			width : '440px',
			extendFilter:"fdExternalId is null"
		};
		var createDoc = new KMS.opera(docOptions, $('.btn_share'));
		createDoc.bind_add();
	}

	//显示评分星
	var staron = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_on.gif'/>";
	var staroff = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_off.gif'/>";
	var starhalf = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_half.gif'/>";

	function showStars(param) {
		var starons = "";
		var staroffs = "";
		var score = param.toString();
		var a = score.substr(0, 1);
		var b = score.substr(2, 1);
		var count = 0;
		if (a > 0) {
			for (i = 0; i < a; i++) {
				starons = starons + staron;
				count++;
			}
		}
		if (b > 0) {
			starons = starons + starhalf;
			count++;
		}
		if (count < 5) {
			for (j = count; j < 5; j++) {
				staroffs = staroffs + staroff;
			}
		}
		return starons + staroffs;
	}

	function docListPage(fdTemplateId) {
		window.open(
				"${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?"
						+ "method=index&fdId=${param.fdId}&templateId=" + fdTemplateId
						+ "&filterType=template", "_blank");
	}

	// 积分取整
	function subStr(score) {
		var str = score.toString();
		var index = str.indexOf('.');
		if (index > 0) {
			return str.slice(0, index);
		}
		return str;
	}
</script>