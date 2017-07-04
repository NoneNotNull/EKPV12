<script language="JavaScript">
		Com_IncludeFile("dialog.js|jquery.js");
</script>
<script type="text/javascript">
	self.onload = function() {
		document.getElementsByName("fdIntroduceReason")[0].value = "";
		self.parent.reloadIntroduceIframe();
	}
	options = {
		url : "${KMSS_Parameter_ContextPath}kms/common/resource/ui/kmsSysIntroduceMain.do?method=save",
		type : "post",
		beforeSubmit : beforeSubmit,
		success : submitIntroduceSuccess
	};

	function beforeSubmit() {

		var fdIntroduceToEssence = document
				.getElementById("fdIntroduceToEssence");
		var fdIntroduceToPerson = document
				.getElementById("fdIntroduceToPerson");
		var fdIntroduceGoalIds = document.getElementById("fdIntroduceGoalIds");
		var fdIntroduceToNews = document.getElementById("fdIntroduceToNews");
		var fdNewsCategoryId = document.getElementById("fdNewsCategoryId");
		if ((fdIntroduceToEssence == null || !fdIntroduceToEssence.checked)
				&& (fdIntroduceToPerson == null || !fdIntroduceToPerson.checked)
				&& (fdIntroduceToNews == null || !fdIntroduceToNews.checked)) {
			showAlert("<bean:message key='sysIntroduceMain.introduce.type.error.showMessage' bundle='sys-introduce' />");
			return false;
		}
		if (fdIntroduceToPerson != null && fdIntroduceToPerson.checked) {
			if (fdIntroduceGoalIds.value == '') {
				showAlert("<bean:message key='sysIntroduceMain.fdIntroduceTo.error.showMessage' bundle='sys-introduce' />");
				return false;
			}
		} else {
			fdIntroduceGoalIds.value = '';
		}
		if (fdIntroduceToNews != null && fdIntroduceToNews.checked) {
			if (fdNewsCategoryId.value == '') {
				showAlert("<bean:message key='sysIntroduceMain.fdIntroduceTo.news.error.showMessage' bundle='sys-introduce' />");
				return false;
			}
		} else {
			fdNewsCategoryId.value = '';
		}
		document.getElementById("submintIntroduceButton").disabled = 'true';
		return true;
	}
	function submitIntroduceSuccess() {
		document.getElementById("fdIntroduceReason").value = "";
		showSuccess();
		setTimeout( function() {
			self.parent.reloadIntroduceIframe();
		}, 100);
	}
	function commitForms() {
		$("form[name='sysIntroduceMainForm']").ajaxSubmit(options);
		return false;
	}
	function showSuccess() {
		var success = document.getElementById("success");
		success.style.display = "block";
		setTimeout( function() {
			success.style.display = "none";
			document.getElementById("submintIntroduceButton").disabled = '';
		}, 1000);
	}

	function refreshTypeDisplay() {
		var tbObj = document.getElementById("TB_MainTable");
		for ( var i = 0; i < tbObj.rows.length; i++) {
			var attVal = tbObj.rows[i].getAttribute("KMSS_RowType");
			if (attVal == 'IntroduceToNews') {
				var introduceToNews = document
						.getElementsByName("fdIntroduceToNews")[0];
				if (introduceToNews != null && introduceToNews.checked) {
					$(tbObj.rows[i]).show();
				} else {
					$(tbObj.rows[i]).hide();
				}
			}
			if (attVal == 'IntroduceToPerson') {
				var introduceToPerson = document
						.getElementsByName("fdIntroduceToPerson")[0];
				if (introduceToPerson.checked) {
					$(tbObj.rows[i]).show();
				} else {
					$(tbObj.rows[i]).hide();
				}
			}
		}
	}

	function commitForm() {
		var fdIntroduceToEssence = document
				.getElementById("fdIntroduceToEssence");
		var fdIntroduceToPerson = document
				.getElementById("fdIntroduceToPerson");
		var fdIntroduceGoalIds = document.getElementById("fdIntroduceGoalIds");
		var fdIntroduceToNews = document.getElementById("fdIntroduceToNews");
		var fdNewsCategoryId = document.getElementById("fdNewsCategoryId");
		if ((fdIntroduceToEssence == null || !fdIntroduceToEssence.checked)
				&& (fdIntroduceToPerson == null || !fdIntroduceToPerson.checked)
				&& (fdIntroduceToNews == null || !fdIntroduceToNews.checked)) {
			showAlert("<bean:message key='sysIntroduceMain.introduce.type.error.showMessage' bundle='sys-introduce' />");
			return;
		}
		if (fdIntroduceToPerson != null && fdIntroduceToPerson.checked) {
			if (fdIntroduceGoalIds.value == '') {
				showAlert("<bean:message key='sysIntroduceMain.fdIntroduceTo.error.showMessage' bundle='sys-introduce' />");
				return;
			}
		} else {
			fdIntroduceGoalIds.value = '';
		}
		if (fdIntroduceToNews != null && fdIntroduceToNews.checked) {
			if (fdNewsCategoryId.value == '') {
				showAlert("<bean:message key='sysIntroduceMain.fdIntroduceTo.news.error.showMessage' bundle='sys-introduce' />");
				return;
			}
		} else {
			fdNewsCategoryId.value = '';
		}
		Com_Submit(document.sysIntroduceMainForm, 'save');
	}
</script>
