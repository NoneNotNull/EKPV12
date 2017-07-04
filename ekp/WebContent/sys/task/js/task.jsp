<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<script type="text/javascript">

var _bx = document.body.offsetWidth/2-100,_by=10;	//以任务图标作为基点
var _gzx=20,_gzy=-20;	//关注度相对位置
var _hqx=5,_hqy=-20;	//小红旗相对位置
var _btx=10,_bty=8;		//任务相对位置
var _fbx=103,_fby=26;	//百分比相对位置
var _taskIco = {t_1:"1-1.jpg",t_2:"1-2.jpg",t_3:"1-3.jpg",t_4:"1-4.jpg",t_5:"1-5.jpg",t_6:"1-6.jpg"};
var _taskIco_r = {t_1:"r1-1.jpg",t_2:"r1-2.jpg",t_3:"r1-3.jpg",t_4:"r1-4.jpg",t_5:"r1-5.jpg",t_6:"r1-6.jpg"};
var _jg = new jsGraphics("taskCanvas"); 

drawTaskCanvas();

function getCo(tasko,id){
	var co = tasko[id];
	return co;
}

function getGroupCs(tasko,cs){
	var mc=null,lc=[],rc=[];
	var cl = cs.length;
	if(cl==2){
		lc[lc.length]=getCo(tasko,cs[0]);
		rc[rc.length]=getCo(tasko,cs[1]);
	}else if(cl>0){
		var m = cl/2|0;
			mc = getCo(tasko,cs[m]);
			for(var j=m-1;j>=0;j--){
				lc[lc.length]=getCo(tasko,cs[j]);
			}
			for(var j=m+1;j<cl;j++){
				rc[rc.length]=getCo(tasko,cs[j]);
			}
	}
	return {mc:mc,lc:lc,rc:rc};
}


function adjustPosition(tasko,_w){
	var e=getSameX(tasko);
	while(e!=""){
		tasko[e]["bx"]=tasko[e]["bx"]+_w;
		tasko[e]["direct"]="rc";
		e=getSameX(tasko);
	}
}

function getSameX(dx){
	for(var e in dx){
		var t = dx[e];
		for(var e1 in dx){
			var t1 = dx[e1]
			if(e!=e1 && t["level"]==t1["level"] && t["bx"]==t1["bx"]){
				return e1;
			}
		}
	}
	return "";
}

function initPosition(tasko,_w){
	_bx = document.body.clientWidth/2-100;_by=10;
	for(var i=0;i<_pc.length;i++){
		var pid = _pc[i]["id"];
		var cs = _pc[i]["c"];
		if(pid==_rootId){
			tasko[pid]["bx"] = _bx;tasko[pid]["by"] = _by;
		}else{
			if(tasko[pid]["bx"])
				_bx = tasko[pid]["bx"];
			if(tasko[pid]["by"])
				_by= tasko[pid]["by"];
		}
		var group = getGroupCs(tasko,cs);
		var mc = group["mc"];
		var lc = group["lc"];
		var rc = group["rc"];
		if(mc!=null){
			var _xPos = 0,_yPos=105;
			var _x = _bx+_xPos,_y=_by+_yPos;
			mc["bx"]=_x;mc["by"]=_y;
			mc["direct"]="mc";
		}
		if(lc.length>0){
			for(var j=0;j<lc.length;j++){
				var _lRwXPos = -_w*(j+1),_lRwYPos=105;
				var _lx = _bx+_lRwXPos,_ly=_by+_lRwYPos;
				lc[j]["bx"]=_lx;lc[j]["by"]=_ly;
				lc[j]["direct"]="lc";
			}
		}
		if(rc.length>0){
			for(var j=0;j<rc.length;j++){
				var _rRwXPos = _w*(j+1),_rRwYPos=105;
				var _rx = _bx+_rRwXPos,_ry=_by+_rRwYPos;
				rc[j]["bx"]=_rx;rc[j]["by"]=_ry;
				rc[j]["direct"]="rc";
			}
		}
	}
}

function drawTaskCanvas(){
	initPosition(_tasko,140);
	adjustPosition(_tasko,140);
	for(var e in _tasko){
		drawTask(_jg,_tasko[e],_tasko[e]["bx"],_tasko[e]["by"],131,45);
	}
	drawLines(_tasko,_jg,65,45,130);
	_jg.paint(); 
}

function drawLines(tasko,jg,_w,_h,_s){
	for(var i=0;i<_pc.length;i++){
		var pid = _pc[i]["id"];
		var cs = _pc[i]["c"];
		var po =tasko[pid];
		for(var j=0;j<cs.length;j++){
			var co = tasko[cs[j]];
			if(co["direct"]=="mc"){
				drawLine(jg,po["bx"]+_w,po["by"]+_h,co["bx"]+_w,co["by"],co["direct"]);
			}
			if(co["direct"]=="lc"){
				drawLine(jg,po["bx"]+_w,po["by"]+_h,co["bx"]+_s,co["by"],co["direct"]);
			}
			if(co["direct"]=="rc"){
				drawLine(jg,po["bx"]+_w,po["by"]+_h,co["bx"],co["by"],co["direct"]);
			}
		}
	}
}

function drawLine(jg,_bx,_by,_ex,ey,direct){

	jg.setColor("#000000");
	jg.setStroke(1.5);
	jg.drawLine(_bx,_by,_ex,ey);  

}

function drawTask(jg,task,_x,_y,_w,_h){
	jg.setColor("#000000");
	
	//关注度
	var gzOp = "<span "+getGzString(task)+"><bean:message bundle='sys-task' key='sysTaskMain.focus.times'/>："+task["attentionCount"]+"</span>";
	jg.setFont("宋体","12px",Font.PLAIN); 
	jg.drawString(gzOp,_x+_gzx,_y+_gzy); 

	//小红旗
	jg.drawImage(_rurl+"images/hq.png", _x+_hqx,_y+_hqy,10,10); 

	//任务图标
	var str = getOpString(task);
	jg.drawImage(_rurl+"images/"+(_currentId==task["id"]?_taskIco_r[task["fdStatus"]]:_taskIco[task["fdStatus"]]), _x,_y,_w,_h,str); 

	//任务标题
	var title = "<span "+str+">"+_getTaskTitle(task)+"</span>";
	jg.setFont("宋体","12px",Font.PLAIN); 
	jg.drawString(title,_x+_btx,_y+_bty); 

	//进度
	jg.setColor("#ffffff");  
	jg.setFont("宋体","12px",Font.PLAIN); 
	jg.drawString(task["progress"],(task["progress"].length<=3?(_x+_fbx+1):(_x+_fbx-task["progress"].length)),_y+_fby); 

	function _getTaskTitle(task){
		s = task["subject"];
		if(s.length>10){
			s = s.substring(0,10)+"....";
		}	
		if(s.length>6){
			s = s.substring(0,6)+"<br>"+s.substring(6);
		}
		s = (_currentId==task["id"]?("<font color='red'>"+s+"</font>"):s);
		return s;
	}
	
	function getOpString(task){
		var str= "";
		str+="onmouseover='taskOnMouseOver(this,\""+task["id"]+"\","+task["level"]+",\""+task["subject"]+"\",\""+task["progress"]+"\",\""+task["performer"]+"\",\""+task["feedbackTime"]+"\",\""+task["weight"]+"\","+task["bx"]+","+task["by"]+");'";
		str+="onmouseout='taskOnMouseOut(this,\""+task["id"]+"\");'"
		str+="onclick='taskOnClick(\""+task["url"]+"\");'";
		return str;
	}
	
	function getGzString(task){
		var str ="";
		str+="onmouseover='gzOnMouseOver(this,\""+task["id"]+"\",\""+task["gzPersons"]+"\","+task["bx"]+","+task["by"]+");'";
		str+="onmouseout='gzOnMouseOut(this,\""+task["id"]+"\");'"
		return str;
	}
	
}

function taskOnMouseOver(el,id,level,subject,progress,performer,feedbackTime,weight,bx,by){
	bx = bx+140;
	by = by-25;
	el.style.cursor="pointer";
	var nt = document.getElementById(id);
	if(nt){
		nt.style.display="";
	}else{
		var str = '<bean:message bundle="sys-task" key="sysTaskMain.principal"/>：'+performer+
					'<br><bean:message bundle="sys-task" key="sysTaskMain.progress"/>：'+progress+
					((level>1)?',<bean:message bundle="sys-task" key="sysTaskMain.parent.percentage"/>：'+weight:'')+
					'<br><bean:message bundle="sys-task" key="sysTaskMain.task.name"/>：'+subject+
					'<br><bean:message bundle="sys-task" key="sysTaskMain.response.time"/>：'+feedbackTime;
		
		var t = '<table class="ttb_noborder" width="100%" height="95px">'+
			'<tr>'+
			'<td width="18px"><img src="'+_rurl+'images/left.gif"></td>'+
			'<td background="'+_rurl+'images/middle.gif" >'+str+'</td>'+
			'<td width="8px"><img border="0" src="'+_rurl+'images/right.gif"></td>'+
			'</tr>'+
			'</table>';

		var vo = document.createElement("DIV");
		vo.setAttribute("id",id);
		vo.className="noteDiv";
		vo.style.left=bx+"px";
		vo.style.top=by+"px";

		vo.innerHTML=t;
		document.getElementById("taskCanvas").appendChild(vo);
	}
}

function gzOnMouseOver(el,id,gzPerons,bx,by){
	bx = bx+140;
	by = by-25;
	el.style.cursor="pointer";
	var nt = document.getElementById("gz_"+id);
	if(nt){
		nt.style.display="";
	}else{
		var str = '<bean:message bundle="sys-task" key="sysTaskMain.focus.members"/>：'+gzPerons;
		
		var t = '<table class="ttb_noborder" width="100%" height="95px">'+
			'<tr>'+
			'<td width="18px"><img src="'+_rurl+'images/left.gif"></td>'+
			'<td background="'+_rurl+'images/middle.gif" >'+str+'</td>'+
			'<td width="8px"><img border="0" src="'+_rurl+'images/right.gif"></td>'+
			'</tr>'+
			'</table>';

		var vo = document.createElement("DIV");
		vo.setAttribute("id","gz_"+id);
		vo.className="noteDiv";
		vo.style.left=bx+"px";
		vo.style.top=by+"px";

		vo.innerHTML=t;
		document.getElementById("taskCanvas").appendChild(vo);
	}
}

function gzOnMouseOut(el,id){
	var nt = document.getElementById("gz_"+id);
	if(nt){
		nt.style.display="none";
	}
}

function taskOnMouseOut(el,id){
	var nt = document.getElementById(id);
	if(nt){
		nt.style.display="none";
	}
}

function taskOnClick(url){
	window.open(_url+url,"_self");
}

//====================责任人================//

var _personIco = {t_r:"R.jpg"};
var _personIco_r = {t_r:"RC.png"};
var _jpg = new jsGraphics("personCanvas"); 
var _personO = {};

var _zrx=50,_zry=20;

drawPersonCanvas();

function drawPersonCanvas(){
	for(var e in _tasko){
		var o = {};
		for(var ee in _tasko[e]){
			o[ee] = _tasko[e][ee];
		}
		_personO[e]=o;
	}
	
	initPosition(_personO,120);
	adjustPosition(_personO,120);
	for(var e in _personO){
		drawPerson(_jpg,_personO[e],_personO[e]["bx"],_personO[e]["by"],34,35);
	}
	drawLines(_personO,_jpg,17,45,57);
	_jpg.paint(); 
}

function drawPerson(jp,task,_x,_y,_w,_h){
	jp.setColor("#000000");

	var str = getOpString(task);
	jp.drawImage(_rurl+"images/"+(_currentId==task["id"]?_personIco_r["t_r"]:_personIco["t_r"]), _x,_y,_w,_h,str); 

	//责任人 进度
	jp.setFont("宋体","12px",Font.PLAIN); 
	jp.drawString(_getPersonTitle(task),_x+_zrx,_y+_zry); 

	function _getPersonTitle(task){
		var s = task["performer"]+"  "+task["progress"];
		return s;
	}
	
	function getOpString(task){
		var str= "";
		str+="onmouseover='personOnMouseOver(this,\""+task["id"]+"\","+task["level"]+",\""+task["subject"]+"\",\""+task["progress"]+"\",\""+task["performer"]+"\",\""+task["feedbackTime"]+"\",\""+task["weight"]+"\","+task["bx"]+","+task["by"]+");'";
		str+="onmouseout='personOnMouseOut(this,\""+task["id"]+"\");'"
		str+="onclick='taskOnClick(\""+task["url"]+"\");'";
		return str;
	}
}

function personOnMouseOver(el,id,level,subject,progress,performer,feedbackTime,weight,bx,by){
	bx = bx+50;
	by = by-25;
	el.style.cursor="pointer";
	var nt = document.getElementById("zrr_"+id);
	if(nt){
		nt.style.display="";
	}else{
		var str = '<bean:message bundle="sys-task" key="sysTaskMain.principal"/>：'+performer+
					'<br>' + '<bean:message bundle="sys-task" key="sysTaskMain.progress"/>：'+progress+
					((level>1)?',<bean:message bundle="sys-task" key="sysTaskMain.parent.percentage"/>：'+weight:'')+
					'<br><bean:message bundle="sys-task" key="sysTaskMain.task.name"/>：'+subject+
					'<br><bean:message bundle="sys-task" key="sysTaskMain.response.time"/>：'+feedbackTime;
		
		var t = '<table class="ttb_noborder" width="100%" height="95px">'+
			'<tr>'+
			'<td width="18px"><img src="'+_rurl+'images/left.gif"></td>'+
			'<td background="'+_rurl+'images/middle.gif" >'+str+'</td>'+
			'<td width="8px"><img border="0" src="'+_rurl+'images/right.gif"></td>'+
			'</tr>'+
			'</table>';

		var vo = document.createElement("DIV");
		vo.setAttribute("id","zrr_"+id);
		vo.className="noteDiv";
		vo.style.left=bx+"px";
		vo.style.top=by+"px";

		vo.innerHTML=t;
		document.getElementById("personCanvas").appendChild(vo);
	}
}

function personOnMouseOut(el,id){
	var nt = document.getElementById("zrr_"+id);
	if(nt){
		nt.style.display="none";
	}
}

var _count = 0;
function repeatDrawProcess(){
	if(_count==0){
		_jg.clear();
		_jpg.clear();
		drawTaskCanvas();
		drawPersonCanvas();
		_count = 1;
	}else{
		_count=0;
	}
}

//Com_AddEventListener(window, "resize",repeatDrawProcess);

</script>
<body>
</body>
