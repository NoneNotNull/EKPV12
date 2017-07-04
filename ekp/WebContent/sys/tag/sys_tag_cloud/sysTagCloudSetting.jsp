<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/resource/jsp/edit_top.jsp"%>
<style type="text/css">

.tagclass{
margin-top:5px;
background-color:orange;
padding-left:5px;
margin-right:5px;
text-align: center;
display:inline-block;
}
.deleicon{
margin-left:10px;

text-decoration:none; 
}
.tagsettingtitle{
text-align: center;
font-size:18px;
}
</style>
<script type="text/javascript">
Com_IncludeFile("dialog.js|jquery.js");
</script>
<Script type="text/javascript">
function deletag(id){

	 $.ajax({
	 	   type: "POST",
	 	   url: "<c:url value='/sys/tag/sys_tag_tags/sysTagTags.do'/>?method=deletag",
	 	   data: "fdTagId="+id,
	 	   success: function(msg){
		 	  
		 	   var obj=GetID(id);
		 	  obj.parentNode.removeChild(obj);
		 	 alert("${lfn:message('return.optSuccess')}");
	 		   }
	
		});
	}
	function GetID(id) {
		return document.getElementById(id);
	}
	
	function afterSelectValue(rtnVal){
		if(rtnVal==null)
			return;
		var a=rtnVal.GetHashMapArray().length;
		
		   var obj= GetID("selectedtag").getElementsByTagName('span').length;
		 	  var b=a+obj;
		if(b>30){
           alert("${lfn:message('sys-tag:sysTag.tags.num.limit')}");
           return;
			}
		var docContent="";
		
		for(var i=0;i<rtnVal.GetHashMapArray().length;i++){
			var newName=rtnVal.GetHashMapArray()[i]['name'];
			var newId=rtnVal.GetHashMapArray()[i]['id'];
			var fdId=GetID(newId);
			if(fdId==null){
				var tableObj = GetID('selectedtag');
				var divObj = document.createElement("span"); 
				    divObj.id=newId;
				    divObj.className = "tagclass";
				var newId0 ="'"+newId+"'";
				    divObj.innerHTML=newName+'<a href="javascript:deletag('+newId0+')" class="deleicon">X</a>';
				    tableObj.appendChild(divObj); 
					 docContent=docContent+newId+";";
				 
						}else{
					}
		
			 
			
		}
		 $.ajax({
		 	   type: "POST",
		 	   url: "<c:url value='/sys/tag/sys_tag_tags/sysTagTags.do'/>?method=selectedtag",
		 	   data: "docContent="+docContent,
		 	   success: function(msg){
		 		   }
		 	   
		 	});
		
	}

	function deletagall(){
		  
	 	   var obj=GetID("selectedtag");
	 	   if(!obj.hasChildNodes()){
		 	   alert("${lfn:message('page.noSelect')}");
		 	   return;
		 	   }
		
		 event.returnValue =confirm("${lfn:message('sys-tag:sysTag.tags.setting.confirm.delete')}");
		 if(event.returnValue)
		 {
		 $.ajax({
		 	   type: "POST",
		 	   url: "<c:url value='/sys/tag/sys_tag_tags/sysTagTags.do'/>?method=deletagall",
		 	   
		 	   success: function(msg){
			 	  
			 	   var obj=GetID("selectedtag");
			 	  while(obj.hasChildNodes()) //当div下还存在子节点时 循环继续
			 	    {
			 		 obj.removeChild(obj.firstChild);
			 	    }
			 				 	   
			 	 alert("${lfn:message('return.optSuccess')}");
		 		   }
		
			});
		 }else{
			 return;
			 }
		}
</Script>

<body>
<div class="tagsettingtitle"><b>${lfn:message('sys-tag:sysTag.tags.cloud.setting')}</b>    </div>
<div><span>${lfn:message('sys-tag:sysTag.tags.cloud.setting.please.msg')}</span>
     <span class="btn_g">
		 <a href="javascript:void(0);" 
		 	style="text-decoration: underline;"
		 	onclick="Dialog_Tree(true,null,null,' ','sysTagCategorApplicationTreeService&fdCategoryId=!{value}','标签树',false,afterSelectValue,null,false,true,null)">
		 <span>${lfn:message('sys-tag:sysTag.tags.cloud.setting.add')}</span></a>
	</span>
	<span class="btn_g">
		 <a href="javascript:void(0);" onclick="deletagall()" style="text-decoration: underline;">
		 <span>${lfn:message('sys-tag:sysTag.tags.cloud.setting.clear')}</span></a>
    </span> 
</div>
<div style="width: 50%;margin-top:10px;">
<ul style="width: 100%">
<li style="font-size: 14px;"><b>${lfn:message('sys-tag:sysTag.tags.theSelectedTags') }：</b></li>
<li id="selectedtag">
<c:forEach items="${selectedList}" var="sysTagCloudSelected" varStatus="vstatus">
		<span class="tagclass"  id="${sysTagCloudSelected.fdSysTagTags.fdId}"><c:out value="${sysTagCloudSelected.fdSysTagTags.fdName}"/>
		<a  href="javascript:deletag('${sysTagCloudSelected.fdSysTagTags.fdId}')" class="deleicon" >X</a>
		</span>
</c:forEach>
</li>
 </ul>
 </div>
</body>
