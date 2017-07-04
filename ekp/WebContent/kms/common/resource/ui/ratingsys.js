﻿
var sMax;	// 最大数量的星星即最大评分值
var holder; // 鼠标停留的评分控件
var preSet; // 保存了评分值（通过单击来进行评分）
var rated; //是否评分过，并保存了结果（注意此值一旦设为空，就不能再评分）

// 鼠标停留事件
function rating(num){
	sMax = 0;	// 默认值为0
	for(n=0; n<num.parentNode.childNodes.length; n++){
		if(num.parentNode.childNodes[n].nodeName == "A"){
			sMax++;	
		}
	}
	
	if(!rated){
		s = num.id.replace("_", ''); // 获取选中的星星的索引，这里使用_1,_2,_3,_4,_5来做为评分控件的ID，当然也有其他的方式。
		a = 0;
		for(i=1; i<=sMax; i++){		
			if(i<=s){
				document.getElementById("_"+i).className = "on";
				document.getElementById("rateStatus").innerHTML = num.title;	
				holder = a+1;
				a++;
			}else{
				document.getElementById("_"+i).className = "";
			}
		}
	}
}

// 离开事件
function off(me){
	if(!rated){
		if(!preSet){	
			for(i=1; i<=sMax; i++){		
				document.getElementById("_"+i).className = "";
				document.getElementById("rateStatus").innerHTML = me.parentNode.title;
			}
		}else{
			rating(preSet);
			//document.getElementById("rateStatus").innerHTML = document.getElementById("ratingSaved").innerHTML;
		}
	}
}

// 点击进行评分
function rateIt(me){
	if(!rated){
		document.getElementById("rateStatus").innerHTML = me.title;//document.getElementById("ratingSaved").innerHTML + " :: "+
		preSet = me;
		//rated=1;  //设为1以后，就变成了最终结果，不能再修改评分结果
		sendRate(me);
		rating(me);
	}
}

//使用Ajax或其他方式发送评分结果 
function sendRate(sel){
	  document.getElementById("fdEvaluationScore").value=sel.rev  ;
	  //alert("评分结果: "+ssa.value );
}

function reSetRate(){
	preSet=null ;
	for(i=1; i<=sMax; i++){	
	 document.getElementById("_"+i).className = "off";
	}
	document.getElementById("fdEvaluationScore").value='';
	document.getElementById("rateStatus").innerHTML =  document.getElementById("rateMe").title;
}