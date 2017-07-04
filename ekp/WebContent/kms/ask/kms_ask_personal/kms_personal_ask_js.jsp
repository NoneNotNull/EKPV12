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

	/*
	function bindButton() {

		// 新增删除数据源
		var options = {
			s_modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
			s_bean : 'kmsHomeAskService',
			s_method : 'getCategoryList',
			type : 'all',
			open : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdKmsAskCategoryId=',
			width : '320px',
			delUrl : '<c:url value ="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=deleteall'
		};

		// 新建
		var addEvent = new KMS.opera(options, LUI.$('#addButton'));
		addEvent.bind_add();

		// 删除
		var delEvent = new KMS.opera(options, LUI.$('#delButton'));
		delEvent.bind_del();
	}*/

	function bindCkoHelp() {
		var flag=1;
	    LUI.$(".help_cko.score").click(function(){
	        if(flag==1){
	        	LUI.$('.help_cko.score').addClass('help_slideDown');
				LUI.$(".help_cko_info.score").slideDown("slow");
	            flag=0;
	        }else{
	        	LUI.$('.help_cko.score').removeClass('help_slideDown');
				LUI.$(".help_cko_info.score").slideUp("slow");
	            flag=1;
	        }
	    });
	}

	function bindMoneyHelp(){
		var flag=1;
	    LUI.$(".help_cko.money").click(function(){
	        if(flag==1){
	        	LUI.$('.help_cko.money').addClass('help_slideDown');
				LUI.$(".help_cko_info.money").slideDown("slow");
	            flag=0;
	        }else{
	        	LUI.$('.help_cko.money').removeClass('help_slideDown');
				LUI.$(".help_cko_info.money").slideUp("slow");
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