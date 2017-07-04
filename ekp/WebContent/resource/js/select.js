/*压缩类型：标准*/
Com_RegisterFile("select.js");
function Select_AddOptions(optField, selField, isAll){
	if(typeof optField == "string")
		optField = document.getElementsByName(optField)[0];
	if(optField==null)
		return;
	if(typeof selField == "string")
		selField = document.getElementsByName(selField)[0];
	if(selField==null)
		return;
	outloop:
	for(var i=0; i<optField.options.length; i++){
		if(!isAll && !optField.options[i].selected)
			continue;
		for(var j=0; j<selField.options.length; j++)
			if(selField.options[j].value==optField.options[i].value)
				continue outloop;
		selField.options[selField.options.length] = new Option(optField.options[i].text, optField.options[i].value);
	}
}

function Select_DelOptions(selField, isAll){
	if(typeof selField == "string")
		selField = document.getElementsByName(selField)[0];
	if(selField==null)
		return;
	for(var i=selField.options.length-1; i>=0; i--)
		if(isAll || selField.options[i].selected)
			selField.options[i] = null;
}

function Select_MoveOptions(selField, direct){
	if(typeof selField == "string")
		selField = document.getElementsByName(selField)[0];
	if(selField==null)
		return;
	var i1 = selField.selectedIndex;
	var i2 = i1 + direct;
	if(i1==-1 || i2<0 || i2>=selField.options.length)
		return;
	var opt1 = new Option(selField.options[i1].text, selField.options[i1].value);
	var opt2 = new Option(selField.options[i2].text, selField.options[i2].value);
	selField.options[i1] = opt2;
	selField.options[i2] = opt1;
	selField.selectedIndex = i2;
}