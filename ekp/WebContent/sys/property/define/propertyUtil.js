
/**
 * 全选
 * @param id
 * @return
 */
function allSelect(){
	if(method!="view"){
		var srcElement = event.srcElement;
		var id = srcElement.id;
		var name;
		$("#"+id+" input[type='checkbox']").each(function(){
			this.checked = true;
			name = this.name;
		});	
		srcElement.onclick=cancelAllSelect;
		srcElement.innerText = "取消";
		select__valueChange(name);
	}
}

/**
 * 取消全选
 * @param id
 * @return
 */
function cancelAllSelect(){
	var srcElement = event.srcElement;
	var id = srcElement.id;
	var name;
	$("#"+id+" input[type='checkbox']").each(function(){
		this.checked = false;
		name = this.name;
	});	
	srcElement.onclick=allSelect;
	srcElement.innerText = "全选";
	select__valueChange(name);
}

function select__valueChange(name){
	if(name){
		__cbClick(name.substring(1),'null',false,null);
	}
}

/**
 * 取消选择
 * @param id
 * @return
 */
function cancelSelect(id){
	if(method!="view"){
		$("#"+id+" input[type='radio']").each(function(){
			this.checked = false;
		});	
	}
}

