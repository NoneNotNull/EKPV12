<script type="text/javascript">
function commitMethod(commitType, saveDraft){
	var formObj = document.kmDocKnowledgeForm;
	var docStatus = document.getElementsByName("docStatus")[0];
	if(window.submitTagApp)
		window.submitTagApp();
	if(saveDraft=="true"){
		docStatus.value="10";
	}else{
		docStatus.value="20";
	}
	if('save'==commitType){
		Com_Submit(formObj, commitType,'fdId');
    }else{
    	Com_Submit(formObj, commitType); 
    }
}

function changeDocCate(modeName,url,canClose) {
	if(modeName==null || modeName=='' || url==null || url=='')
		return;
	seajs.use(['sys/ui/js/dialog'],
			function(dialog) {
				dialog.simpleCategoryForNewFile(modeName,url,false,null,null,null,"_self",canClose);
			});
}

</script>