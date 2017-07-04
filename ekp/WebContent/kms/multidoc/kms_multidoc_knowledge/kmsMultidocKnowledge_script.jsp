<script type="text/javascript">
function commitMethod(commitType, saveDraft){
	submitTagApp();
	var formObj = document.kmsMultidocKnowledgeForm;
	var docStatus = document.getElementsByName("docStatus")[0];
	if(saveDraft=="true"){
		docStatus.value="10";
	}else{
		docStatus.value="20";
	}
	Com_Submit(formObj, commitType);
}
</script>
