Com_IncludeFile("jquery.js");
$( function() {
	//单机事件
	$("#fdIsExternal").click( function() {
		var isChecked = $(this).is(":checked");
		if (isChecked) {
			hideLabels(false);
			hideBaseInfos(false);
		} else {
			hideLabels(true);
			hideBaseInfos(true);
		}
	 });
});

	/**
	 * 显示/隐藏table标签
	 *  
	 */
	function hideLabels(isShow) {
		var number = 1;
		$(".td_label0 nobr").each( function(a, b) {
			if (number != 1) {
				if (isShow) {
					$(this).show();
				} else {
					$(this).hide();
				}
			}
			number++;
		});
	};
	/**
	 * 显示/隐藏字段
	 * 
	 */
	function hideBaseInfos(isShow){
		if(isShow){
			$("#fdFeedbackModify").show();
            $("#number").show();
			$("#fdKeywordIds").show();
			$("#fdExternalUrl").hide();
		}else{
			$("#fdFeedbackModify").hide();
            $("#number").hide();
			$("#fdKeywordIds").hide();
			$("#fdExternalUrl").show();
		}
	}
