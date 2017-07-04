<script type="text/javascript">
function refreshTypeDisplay(){
	var tbObj = document.getElementById("TB_MainTable");
	for(var i=0; i<tbObj.rows.length; i++){
		var attVal = tbObj.rows[i].getAttribute("KMSS_RowType");
		if(attVal=='IntroduceToNews'){
			var introduceToNews = document.getElementsByName("fdIntroduceToNews")[0];
			if(introduceToNews!=null && introduceToNews.checked){
				$(tbObj.rows[i]).show();
			}else{
				$(tbObj.rows[i]).hide();
			}
		}
		if(attVal=='IntroduceToPerson'){
			var introduceToPerson = document.getElementsByName("fdIntroduceToPerson")[0];
			if(introduceToPerson.checked){
				$(tbObj.rows[i]).show();
			}else{
				$(tbObj.rows[i]).hide();
			}
		}
	}
}

function commitForm(){
	var fdIntroduceToEssence = document.getElementsByName("fdIntroduceToEssence")[0];
	var fdIntroduceToPerson = document.getElementsByName("fdIntroduceToPerson")[0];
	var fdIntroduceGoalIds =  document.getElementsByName("fdIntroduceGoalIds")[0];
	var fdIntroduceToNews =  document.getElementsByName("fdIntroduceToNews")[0];
	var fdNewsCategoryId = document.getElementsByName("fdNewsCategoryId")[0];
	if((fdIntroduceToEssence==null || !fdIntroduceToEssence.checked) &&
			(fdIntroduceToPerson==null || !fdIntroduceToPerson.checked) &&
			(fdIntroduceToNews==null || !fdIntroduceToNews.checked)){
		alert("<bean:message key='sysIntroduceMain.introduce.type.error.showMessage' bundle='sys-introduce' />");
		return;
	}
	if(fdIntroduceToPerson!=null && fdIntroduceToPerson.checked){
		if(fdIntroduceGoalIds.value == ''){
			alert("<bean:message key='sysIntroduceMain.fdIntroduceTo.error.showMessage' bundle='sys-introduce' />");
			return;
		}
	}else{
		fdIntroduceGoalIds.value = '';
	}
	if(fdIntroduceToNews!=null && fdIntroduceToNews.checked){
		if(fdNewsCategoryId.value == ''){
			alert("<bean:message key='sysIntroduceMain.fdIntroduceTo.news.error.showMessage' bundle='sys-introduce' />");
			return;
		}
	}else{
		fdNewsCategoryId.value = '';
	}
	Com_Submit(document.sysIntroduceMainForm, 'save');
}
</script>	