<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.zone.util.SysZoneConfigUtil"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.landray.kmss.util.StringUtil" %>
  <script>
      <%
    		JSONArray commmunicateList = SysZoneConfigUtil.getCommnicateList();
  	   %>
    	function onRender(arr){
        	if(arr == null || arr.length <= 0 ) {
				return;
            }
        	seajs.use(['sys/zone/resource/plugin/Communicate.js', 
        	        	'lui/jquery'
        	           <%
        	           	for(Object map: commmunicateList) {
        	           		JSONObject json = (JSONObject)map;
        	           		if(!"communicate".equals(json.get("showType"))) {
        	           			continue;
        	           		}
        	           		String src = ((String)json.get("js_src")).substring(1);
        	           		//其他服务的扩展
        	           		String key = (String)json.get("server");
        	           		String localKey = SysZoneConfigUtil.getCurrentServerGroupKey();
        	           		if(StringUtil.isNotNull(key) && !key.equals(localKey)) {
        	           			src = SysZoneConfigUtil.getServerUrl(key) +  "/" + src;
        	           		}
        	           		out.print(",'" + src + "#'");
        	           	}
      	        		%>
        	        ],
                	function(Communicate, $  
                			<%
            	           	for(Object map : commmunicateList) {
            	           		JSONObject json = (JSONObject)map;
            	           		if(!"communicate".equals(json.get("showType"))) {
            	           			continue;
            	           		}
            	           		out.print("," + ((String)json.get("js_class")) );
            	           	}
          	        		%>) {
	        	for(var i = 0; i < arr.length; i++){ 
		        	(function() {
		        		var link = new Communicate(arr[i]); 
						
		        		<%
		        			for(Object  map : commmunicateList) {
		        				JSONObject json = (JSONObject)map;
		        				if(!"communicate".equals(json.get("showType"))) {
	        	           			continue;
	        	           		}
		        				//其他服务的扩展
	        	           		String key = (String)json.get("server"); 
	        	           		String contextPathConfig = "";
	        	           		String path = null;
	        	           		String localKey = SysZoneConfigUtil.getCurrentServerGroupKey();
	        	           		if(StringUtil.isNotNull(key) && !key.equals(localKey)) { 
	        	           			path = SysZoneConfigUtil.getServerUrl(key);
	        	           			contextPathConfig = "{'contextPath':'" +  path +"'}";
	        	           		}
		        				out.println("link.push('" + (path == null ? "" : path) + (String)json.get("icon") + "'," 
		        							+ "new " + (String)json.get("js_class")  +"(" + contextPathConfig +"));");
		        			} 
		        		%>

		        		link.show();
			        })();  		
	        	}
        	});
    	}
 </script>