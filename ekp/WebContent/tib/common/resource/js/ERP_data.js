/**
 * base on jquery 
 * 用来解决数据kmssdata xml嵌套xml导致不可以使用问题
 * @return
 */
function ERP_data(){
	this.ERP_UNIT_URL=Com_Parameter.ContextPath+"tib/common/resource/js/erp_data.jsp";
	this.SendToBean=ERP_DataFunc_SendToBean;
}
function ERP_DataFunc_SendToBean(beanName,action, synch){
//  if(!jQuery){
//	    alert("没有引入jQuery库~!");
//	    return ;
//	}
	var param="erpServcieName="+beanName;
	if (synch == null) {
		synch = true;
	}
	jQuery.ajax({
		url:this.ERP_UNIT_URL,
		type:"POST",
		data:param,
		async : synch,
		dataType:'json',
		contentType:'application/x-www-form-urlencoded',
		success:function (data){
			var rtnData={
					curData:data,
					GetHashMapArray:function(){
						return this.curData;
					}
			}
			action(rtnData);
	    },
		error:function(XMLHttpRequest, textStatus, errorThrown){
	    	alert(textStatus);
	    	alert(XMLHttpRequest.responseText);
	    
	    }	
	});
}
