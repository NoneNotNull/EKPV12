<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	window.onload = function() {
		//setTimeout("resizeParent();", 100);
		setInterval("resizeParent();", 100);
	};
	function resizeParent() {
		try {
			// 调整高度
			var height = LUI.$('.cont2').height();
			var iFrame = window.parent.document.getElementById("___content");
			iFrame.style.height = height + "px";
		} catch (e) {
		}
	}

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
	};

	function firePortletEvent(pid) {
		$('.display_box').each( function() {
			$(this).hide();
		});
		var selector = $( [ '#' + pid, 'selector' ].join('-'));
		if (selector[0]) {
			selector.show();
		}
	}

	function bindButton() {

		// 新增删除数据源
		var options = {
			s_modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
			type : 'all',
			extendFilter:"fdExternalId is null",
			open : '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=',
			width : '320px',
			delUrl : '<c:url value ="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=deleteall'
		};

		// 新建
		var addEvent = new KMS.opera(options, $('#addButton'));
		addEvent.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, $('#delButton'));
		delEvent.bind_del();
	}

	function bindHelp() {
		var flag=1;
	    LUI.$(".help_cko").click(function(){
	        if(flag==1){
	        	LUI.$('.help_cko').addClass('help_slideDown');
				LUI.$(".help_cko_info").slideDown("slow");
	            flag=0;
	        }else{
	        	LUI.$('.help_cko').removeClass('help_slideDown');
				LUI.$(".help_cko_info").slideUp("slow");
	            flag=1;
	        }
	    });
	}
	function setDocStatus(key,status){
		seajs.use( [ 'lui/topic' ], function(topic) {
			var evt = {
				query : {
					key : key,
					value : [status.value]
				}
			};
			topic.channel(key).publish('criteria.changed', evt);
		});
	}
</script>