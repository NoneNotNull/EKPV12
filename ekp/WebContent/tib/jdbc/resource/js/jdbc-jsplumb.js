jsPlumb.bind("jsPlumbConnection", function(conn) {	

        //conn.connection.setPaintStyle({strokeStyle:nextColour()});
        //fieldName
		var sourceText = $(conn.source[0].parentNode).parent().children("td:eq(3)").text();
        var targetText = $(conn.target[0].parentNode).parent().children("td:eq(1)").text();
        //field DataType
        var sourceArr =$(conn.source[0].parentNode).parent().children("td:eq(2)").text();
        var targetArr = $(conn.target[0].parentNode).parent().children("td:eq(2)").text();
        
        var sourceLeng = getFieldLength(sourceArr);
        var targetLeng = getFieldLength(targetArr);
        
        //field all null
        var sourceRequired=$(conn.source[0].parentNode).parent().children("td:eq(1)").text();;
        var targetRequired=$(conn.target[0].parentNode).parent().children("td:eq(3)").text();
        
        if(sourceRequired!=null)sourceRequired=sourceRequired.toUpperCase();
        if(targetRequired!=null)targetRequired=targetRequired.toUpperCase();
        
        var sourceFlag="";
            sourceFlag=sourceRequired=='PRIMARY'?true:(sourceRequired=='NOTNULL'?true:false);
        var targetFlag="";
            targetFlag=targetRequired=='PRIMARY'?true:(targetRequired=='NOTNULL'?true:false);
        
         //set table border color
        if(targetRequired=='PRIMARY'){
        	var tabId =$(conn.target[0].parentNode).parent().parent().children("tr:eq(0)").text();
        	var parentTd= $("#mapp_"+tabId).parent();
        	$(parentTd).removeAttr("style");
        }
            
        var sourceFieldType;
        var targetFieldType;
        if(sourceArr!=null){
        	sourceFieldType =getFieldType(sourceArr);
        }
        
        if(targetArr!=null){
        	targetFieldType =getFieldType(targetArr);
        }
        
        if(sourceFieldType!=targetFieldType){
              //data Type not the same 
        	//conn.connection.setPaintStyle({strokeStyle:"rgb(255,255,0)"});
        	//conn.connection.getOverlay("label").setLabel("");
              jsPlumbDemo.setPaintStyleYellow(conn);
              
        }else if(parseInt(sourceLeng)>parseInt(targetLeng)){
            // sourceField dataLength > endField dataLength
            jsPlumbDemo.setPaintStyleYellow(conn);
        }else if(!sourceFlag && targetFlag ){
             //sourceField was allowed null but endField is not allowed null
             jsPlumbDemo.setPaintStyleYellow(conn);
        }
      
});

 $(function(){
	 jsPlumb.unbind("dblclick");
	 jsPlumb.bind("dblclick", function(conn) { 
		 var targetRequired=$(conn.target[0].parentNode).parent().children("td:eq(3)").text();
		 if(targetRequired=='PRIMARY'){
			 var tabId =$(conn.target[0].parentNode).parent().parent().children("tr:eq(0)").text();
			 var parentTd= $("#mapp_"+tabId).parent();
			 var fieldGenerate=$(conn.target[0].parentNode).parent().children("td:eq(4)").children("input[name='fieldInitData']").val();
			 
			 if(!(fieldGenerate!=null && fieldGenerate.length>0)){
				 $(parentTd).attr("style","border-color: #FF0000");
			 }
		 }
		 jsPlumb.detach(conn); 
	 });
 });

function getFieldType(fieldInfo){
	if(fieldInfo!=null && fieldInfo.length>0){
		var beginIndex =fieldInfo.indexOf("(");
		if(beginIndex!=null ){
			  var fieldType = fieldInfo.substring(0,beginIndex);
			  return fieldType;
		}else{
			 return fieldInfo;
		}
	}else{
		return null;
	}
}



function getFieldLength(fieldInfo){
	if(fieldInfo!=null && fieldInfo.length>0){
		var beginIndex =fieldInfo.indexOf("(");
		var endIndex = fieldInfo.indexOf(")");
		if(beginIndex!=null && endIndex!=null){
		  var fieldLeng = fieldInfo.substring(beginIndex+1,endIndex);
		  return fieldLeng;
		}else{
		  return null;
		}
	}
	   return null;
}

function  getFieldDetailInfoMessage(fieldContent){
	  if (fieldContent != null && fieldContent.length > 0) {
		var startIndex = fieldContent.indexOf("(");
		var endIndex = fieldContent.lastIndexOf(")");
		var fieldInfo = fieldContent.substring(startIndex + 1, endIndex);
		var fieldInfoArray = fieldInfo.split(",");
		return fieldInfoArray;
	}
	return null;
}






	


