<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>
	// 向爱问达人提问
	function askToExpert(fdId) {
		window
				.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId );
	}

	// 爱问概览点击跳转
	function docListPage(fdId) {
		var hrefArray = [ '${kmsBasePath}/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&more=4&fdId=${param.fdId}' ];
		if (fdId) {
			hrefArray[1] = [ '&fdCategoryId=' ];
			hrefArray[2] = [ fdId ];
		}
		var href = hrefArray.join('');
		window.open(href, "_blank");
	}

	// 积分取整
	function subStr(score){
		var str = score.toString();
		var index = str.indexOf('.');
		if(index>0){
			return str.substring(0,index); 
		}
		return str;
	}

	// 新建按钮绑定事件
	function bindButton(){
		var askOptions = {
				s_modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
				s_bean : 'kmsHomeAskService',
				s_method : 'getCategoryList',
				open : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdCategoryId=',
				width : '440px'
			};
		var createAsk = new KMS.opera(askOptions, $('.btn_ask'));
		createAsk.bind_add();
	}
</script>