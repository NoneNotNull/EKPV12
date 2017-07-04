<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
.popup_floatLayer_wrapper{
    margin:0 6%;
    border:1px solid #d7d7d7;
    background-color:#fff;
    box-shadow:3px 3px 8px rgba(0,0,0,0.15);
    position:relative;
}
.tab_img{
    width:100%;
    word-break:break-all
}
.tab_img li{
    float:left;
    padding:10px;
    text-align:center;
    color:#575757;
    font-size:12px;
    cursor:pointer;
}

.img_wrapper{
    width:120px;
    height:75px;
    background-color:#fff;
    box-shadow:3px 3px 8px rgba(0,0,0,0.15);
    position:relative;
}
.img_content{
    background-color:#f6f6f6;
}

.popup_floatLayer_content{
    height:300px;
    background-color:#f6f6f6;
    border-top:1px solid #d7d7d7;
    border-bottom:1px solid #d7d7d7;
}

.btn_canncel{
    width:33px;
    height:33px;
    background:url(${KMSS_Parameter_ContextPath}sys/lbpmservice/pda/images/closeDiv.png) no-repeat 50%;
    display:block;
    cursor:pointer;
    position:absolute;
    right:-14px;
    top:-13px;
    z-index:999;
}
.btn_canncel_img{
    width:20px;
    height:20px;
    background:url(${KMSS_Parameter_ContextPath}sys/lbpmservice/pda/images/closeDiv.png) no-repeat 50%;
    background-size: 20px; 
    display:block;
    cursor:pointer;
    position:absolute;
    right:-11px;
    top:-11px;
    z-index:999;
}
.tab_header{
    width:100%;
    height:52px;
    background-color:#f6f6f6;
    display:table;
}

.tab_header li{
    width:25%;
    display:table-cell;
    height:52px;
    line-height:52px;
    color:#575757;
    font-size:12px;
    border-left:1px solid #fff;
    border-right:1px solid #d7d7d7;
    background:-webkit-linear-gradient(top,#fafafa 0%,#ededed 100%);
    background:-moz-linear-gradient(top,#fafafa 0%,#ededed 100%);
    background:-o-linear-gradient(top,#fafafa 0%,#ededed 100%);
    background:-ms-linear-gradient(top,#fafafa 0%,#ededed 100%);
    background:linear-gradient(top,#fafafa 0%,#ededed 100%);
    cursor:pointer;
}

.tab_btn{
    width:100%;
    height:40px;
    display:table;
}
.tab_btn li{
    width:25%;
    display:table-cell;
    height:40px;
    line-height:40px;
    text-align:center;
    color:#575757;
    font-size:12px;
    cursor:pointer;
}

.tab_header li:first-child{
    border-left:0;
}
.tab_header li:last-child{
    border-right:0;
}

.btn_submit{
    margin:0 auto;
    padding:0 5px;
    width:80px;
    height:30px;
    line-height:30px;
    text-align:center;
    color:#fff;
    font-size:12px;
    border-radius:5px;
    border:1px solid #54adef;
    box-shadow:inset 0 0 3px rgba(255,255,255,0.7);
    background:-webkit-linear-gradient(top, #77c4fa 0%, #3ea0e7 50%, #3495d9 51%, #278ace 100%);
    background:-moz-linear-gradient(top, #77c4fa 0%, #3ea0e7 50%, #3495d9 51%, #278ace 100%);
    background:-o-linear-gradient(top, #77c4fa 0%, #3ea0e7 50%, #3495d9 51%, #278ace 100%);
    background:-ms-linear-gradient(top, #77c4fa 0%, #3ea0e7 50%, #3495d9 51%, #278ace 100%);
    background:linear-gradient(top, #77c4fa 0%, #3ea0e7 50%, #3495d9 51%, #278ace 100%);
    display:block;
    cursor:pointer;
}

.setting_contentBox{
    padding:2% 3%;
}
.setting_contentBox li>ul{
    width:100%;
    display:table;
    font-size:1.6em;
}
.setting_contentBox li>ul li{
    display:table-cell;
}

.setting_color li{
    vertical-align:middle;
}
.setting_color span{
    margin:6px;
    width:28px;
    height:28px;
    display:inline-block;
}
.setting_brushwork li{
    vertical-align:middle;
}
.setting_brushwork li div{
    width:40px;
    height:40px;
}
.setting_brushwork span{
    background-color:#848484;
    display:inline-block;
}
</style>
      <div class="popup_floatLayer_wrapper" id="idBox">
            <span class="btn_canncel" onclick="closex();"></span>
            <ul class="tab_header">
                <li>笔触：</li>
                <li><select name="selectPenWidth" id="selectPenWidth" onchange="dowidthchange();">
                     <option value="1">1</option>   
                     <option value="2">2</option>   
                     <option value="3">3</option>   
                     <option value="4">4</option>   
                     <option value="5" selected>5</option> 
                     <option value="6">6</option> 
                     <option value="7">7</option> 
                     <option value="8">8</option> 
                     <option value="9">9</option> 
                     <option value="10">10</option>
                   </select>
                </li>
                <li>颜色：</li>
                <li><select name="selectPenColor2" id="selectPenColor2" onchange="docolorchange2()"> 
                       <option value="black" >黑色</option>  
					   <option value="red" >红色</option> 
					   <option value="blue">蓝色</option>
	                 </select>
	            </li>
            </ul>
            <div class="popup_floatLayer_content" id="canvasDiv"></div>
            <div class="popup_floatLayer_btnBox">
               <ul class="tab_btn">
	                <li></li>
	                <li><a class="btn_submit" href="javascript:void(0)" onclick="save();" >确定</a></li>
	                <li><a class="btn_submit" href="javascript:void(0)" onclick="clean();" >清除</a></li>
	                <li></li>
                </ul>
               
            </div>
        </div>
<script>
		var box ;
		$(document).ready(function() {
			//初始按钮位置
			var obj = $("#commonUsagesRow td:nth-child(2)");
			var html = '<span id="handwriting" onclick="show();" style="cursor: pointer; font-size: 12px; margin-right: 8px;margin-left:10px">';
				html +='<img src='+'<c:url value="/sys/lbpmservice/pda/images/handwrite.png"/>'+' width="25px" height="25px" style="margin-bottom:-8px"><c:out value="手写" /></span>';
			obj.append(html);

			//弹出框对象
			box = new LightBox("idBox", {
				'Lay': 'boxdiv'
			});
			lbpm.events.addListener(lbpm.constant.EVENT_validateMustSignYourSuggestion,function() {
				var imageDiv = $("#imgUl");
				if(imageDiv.children().length > 0 ){
					return true;
				}
				return false;
			});
		});

		var canvasDiv = document.getElementById('canvasDiv');
		var canvas = document.createElement('canvas');
		var width = canvasDiv.offsetWidth;
		var height = canvasDiv.offsetHeight;
		var canvasWidth = width, canvasHeight=height;
		canvas.setAttribute('width', canvasWidth);
		canvas.setAttribute('height', canvasHeight);
		canvas.setAttribute('id', 'canvas');
		canvasDiv.appendChild(canvas);

		var point = {};
		point.notFirst = false;

		var context = canvas.getContext("2d");
		context.lineWidth = 5;   //初始画笔笔宽为5
		context.strokeStyle = "black";  //初始画笔颜色为红色

		var $canvas = $(canvas);
		var pos1;
		function show(){
			box.Show();
			clean();
			pos1 = $canvas.offset(); 
		}   
		$(window).scroll(function() {
			pos1 = $canvas.offset();
		});
		canvas.addEventListener("touchstart", function(e){
			e.preventDefault();
			pos1 = $canvas.offset();
		  var mouseX = e.touches[0].pageX - pos1.left ;  
		  var mouseY = e.touches[0].pageY - pos1.top;  
		  paint = true; 
		  addClick(mouseX, mouseY);
		  redraw();
		});
		canvas.addEventListener("mousedown", function(e){
			  var mouseX = e.pageX -  pos1.left ;
			  var mouseY = e.pageY -  pos1.top;
			  paint = true;
			  addClick(mouseX, mouseY);
			  redraw();
		});
		canvas.addEventListener("mousemove", function(e){
			  if(paint){
			    addClick(e.pageX -  pos1.left, e.pageY - pos1.top, true);
			    redraw();
			  }
			});
		canvas.addEventListener("mouseup", function(e){
			  paint = false;
			});

		canvas.addEventListener("touchmove", function(e){
			e.preventDefault();     
		  if(paint){
		    addClick(e.touches[0].pageX - pos1.left, e.touches[0].pageY - pos1.top, true);
		    redraw(); 
		  }
		});

		canvas.addEventListener("touchend", function(e){
			e.preventDefault();
		  paint = false;
		});

		var clickX = new Array();
		var clickY = new Array();
		var clickDrag = new Array();
		var paint;

		function addClick(x, y, dragging)
		{
		  clickX.push(x);
		  clickY.push(y);
		  clickDrag.push(dragging);
		}

		function redraw(){
		  //canvas.width = canvas.width; // Clears the canvas
		  
		  //context.strokeStyle = "#df4b26";
		  context.lineJoin = "round";
		  context.lineCap="round";
		 // context.lineWidth = 5;
		  
		  while (clickX.length > 0 ) {
			  point.bx = point.x;
			  point.by = point.y;
			  point.x = clickX.pop();
			  point.y = clickY.pop();
			  point.drag = clickDrag.pop();
			  context.beginPath();
			  if (point.drag && point.notFirst) {
				  context.moveTo(point.bx, point.by);
			  } else {
				  point.notFirst = true;
				  context.moveTo(point.x - 1, point.y);
			  }
		     context.lineTo(point.x, point.y);
		     context.closePath();
		     context.stroke();
		  }
		}
			

		////改变画笔笔宽
		function dowidthchange(){
		    var lbxPenWidth = document.getElementById("selectPenWidth");
		    var penWidth = lbxPenWidth.options[lbxPenWidth.selectedIndex].getAttribute("value");
		    context.lineWidth = penWidth;
		}

		//改变画笔颜色
		function docolorchange2(){
		    var lbxPenColor = document.getElementById("selectPenColor2");
		    var color = lbxPenColor.options[lbxPenColor.selectedIndex].getAttribute("value");
		    context.strokeStyle= color;
		}

		//清除canvas内容
		function clean(){
			context.clearRect(0,0,canvas.width,canvas.height);
		}

		

		function ajax(url, data, async,submitform) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("POST", url, async);
			if(submitform!=""&&submitform!=null){
				xmlhttp.setRequestHeader("Content-Type",
							"application/x-www-form-urlencoded;charset=UTF-8");
			}
			xmlhttp.send(data);
			return xmlhttp;
		}

		function getNodesByPath(xmlNode, path) {
			if (window.XPathEvaluator) {
				try {
					var xpe = new XPathEvaluator();
					var nsResolver = xpe
							.createNSResolver(xmlNode.ownerDocument == null
									? xmlNode.documentElement
									: xmlNode.ownerDocument.documentElement);
					var result = xpe.evaluate(path, xmlNode, nsResolver, 0,
							null);
					var found = [];
					var res;
					while (res = result.iterateNext())
						found.push(res);
					return found;
				} catch (e) {
					if (xmlNode.querySelectorAll) {
						path = path.replace(/\//gi, " ");
						return xmlNode.querySelectorAll(path);
					}
					throw e;
				}
			} else if ("selectNodes" in xmlNode) {
				return xmlNode.selectNodes(path);
			} else if (xmlNode.querySelectorAll) {
				path = path.replace(/\//gi, " ");
				return xmlNode.querySelectorAll(path);
			}
		}

		// 解析获取xml中return节点中的内容
		function xmlparse(xmlContent) {
			// 转换为jsxml对象
			var xml = document.implementation.createDocument("", "", null);
			var dp = new DOMParser();
			var newDOM = dp.parseFromString(xmlContent, "text/xml");
			var newElt = xml.importNode(newDOM.documentElement, true);
			xml.appendChild(newElt);
			var ret = getNodesByPath(xml, "/return")[0].childNodes, val = {};
			for (i = 0; i < ret.length; i++) {
				if (ret[i].nodeType == 1) {
					val[ret[i].nodeName] = ret[i].firstChild.nodeValue;
				}
			}
			return val;
		}

		//获取token
		function ajaxToken(file) {
			var xdata = "filesize=" + file.size + "&md5=";
			var xmlhttp = ajax("${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=getuserkey", xdata, false);
			return xmlparse(xmlhttp.responseText.trim());
		}


		Com_Parameter.event["submit"].push(function(){     //流程提交生成附件信息
			var flag = false;
		if(fileIds.length>0){
			for(var j= 0;j<fileIds.length;j++){
				var xdatax = "filename=" + fileIds[j].fileKey + "&filekey="
				+ fileIds[j].fileKey + "&fdKey=${param.auditNoteFdId}_hw&fdAttType=pic&fdModelId=${param.modelId}&fdModelName=${param.modelName}";
				var result = ajax("${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=submit", xdatax,false,"submitform");
				var val = xmlparse(result.responseText.trim());
				if (val.status.trim() == "1") {
					flag = true;
				}
			}
		}else{
			flag = true;
		}
			return flag;
		});


var fileIds=[];  //存放附件的id,提交时生成附件信息
		
//删除附件
function deletex(obj){
		var tmpfileIds = [];
        for(var i= 0;i<fileIds.length;i++){
	        if(fileIds[i].fileKey != obj.id){
	        	tmpfileIds.push(fileIds[i]);
		    }
        }
        fileIds = tmpfileIds;
        $("li[id='"+obj.id+"']").remove();
}
		var dataURL;     //图片展示的url
		
		//异步提交附件流
		function ajaxUpload(file) {
			var token = ajaxToken(file);
			if (token.status.trim() != "1")
				return;
			//var d = new FormData;
			//d.append("userkey", token.userkey);
			//d.append("NewFile", file);
			var uploadurl = "${KMSS_Parameter_ContextPath}sys/attachment/uploaderServlet?gettype=uploadStream&type=pic";
			 $.ajax({    
			     type:"post",     
			     url:uploadurl,     
			     data:{data:file},    
			     async:true,
			     success:function(data){ 
			    	 var xml = JSON.parse(data);
						if (xml.status == '1') {
							var file = {
									    fileKey:xml.filekey
							          };
							fileIds.push(file);
							//图片上传完拼装显示的html
							var imageDiv = $("#imgUl");
							var html = '<li id="'+xml.filekey+'"><div class="img_wrapper">';
							    html +='<span class="btn_canncel_img" onclick="deletex(this);" id="'+xml.filekey+'"></span>';
								html +='<div class="img_content"><img width="100" height="75" src="'+dataURL+'"></div></div></li>';
							if(imageDiv.length > 0){
								if(imageDiv.innerHTML==""){
									 imageDiv.html(html);
									}else{
									 imageDiv.append(html);
								}
						    }else{
							    var rowhtml = '<tr><td colspan="4"><div class="tab_img"><ul id="imgUl">'+html+'</td></tr></ul></div>';
							    $("#commonUsagesRow").after(rowhtml);
						    }
						    box.Close();
						} 
				   }     
		      });
		}


		function save(){
			//把canvas内容转为base64字符串
			dataURL = canvas.toDataURL("image/png");
			  ajaxUpload(dataURL);
		}
		function closex(){
			box.Close();
		}

</script>
<script type="text/javascript" src='<c:url value="/sys/lbpmservice/pda/lightbox.js"/>' charset="UTF-8"></script>