<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>

var jsonUrl = '<c:url value="/kms/common/kms_common_portlet/kmsCommonPortlet.do" />';

	function resetStrLength(str, length) {
		//原字符串即使全部按中文算，仍没有达到预期的长度，不需要截取
		if (str.length * 2 <= length)
			return str;
		var rtnLength = 0; //已经截取的长度
		for ( var i = 0; i < str.length; i++) {
			//字符编码号大于200，将其视为中文，该判断可能不准确
			if (Math.abs(str.charCodeAt(i)) > 200)
				rtnLength = rtnLength + 2;
			else
				rtnLength++;
			//超出指定范围，直接返回
			if (rtnLength > length)
				return str.substring(0, i)
						+ (rtnLength % 2 == 0 ? ".." : "...");
		}
		return str;
	}
	// 显示更多
	function showMore(obj) {
		var list = $("#portlet_filterAsk");
		var nextall = $(list).find('br').nextAll();
		$(nextall).each( function() {
			$(this).toggle();
		});

		if ($(obj).text() == '收起') {
			$(obj).text('更多');
			$(obj).attr("title", '更多');
		} else {
			$(obj).text('收起');
			$(obj).attr("title", '收起');
		}
	}

	// 页面加载默认隐藏更多的内容
	function hideMore() {
		var list = $("#portlet_filterAsk");
		var nextall = $(list).find('br').nextAll();
		$(nextall).each( function() {
			$(this).hide();
		});
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

	// 时间绑定
	function bindButton(){
		// 新增删除数据源
		var options = {
			s_modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
			s_bean : 'kmsHomeAskService',
			s_method : 'getCategoryList',
			type : 'all',
			open : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdCategoryId=',
			width : '320px',
			delUrl : '<c:url value ="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=deleteall'
		};

		// 新建
		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, $('#delButton'));
		delEvent.bind_del();
	}

</script>