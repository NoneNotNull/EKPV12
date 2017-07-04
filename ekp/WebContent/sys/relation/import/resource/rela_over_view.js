	
function queryRelateDoc(){
	var searchRange = $("#searchRange").val();
	var fdSearchTarget = $("input[name='fdSearchTarget']:checked").val();
	var relateDocSubject = $("input[name='relateDocSubject']").val();
	seajs.use('lui/topic',function(topic){
		 topic.channel('main').publish('criteria.changed',
					{'criterions':[{'key':'searchRange','value':[searchRange]},
					               {'key':'fdSearchTarget','value':[fdSearchTarget]},
					               {'key':'relateDocSubject','value':[relateDocSubject]}]});
	 });
}
	
