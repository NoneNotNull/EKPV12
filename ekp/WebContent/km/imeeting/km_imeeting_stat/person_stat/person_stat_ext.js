seajs.use(["lui/jquery","lui/topic"],function($,topic){
	
	var method_GET=$('[name="method_GET"]').val();
	
	if(method_GET=="view"){
		//查看明细
		topic.subscribe("list.click",function(context,datas){
			var data = context.data;
			var url = Com_SetUrlParameter(location.href, "personId", data['personId']);
			url = Com_SetUrlParameter(url,"listDetail","true");
			window.open(url,"_self");
		});
	}
	
});