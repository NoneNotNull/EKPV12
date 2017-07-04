$(function(){
	var moduleType = $("input:radio[name=moduleType]:checked").val();
	if (moduleType != undefined) {
		chooseType(moduleType);
	}
});

function chooseType(tableId) {
	$("#outterTableId table").hide("fast");
	$("#"+tableId).show("fast");
}

