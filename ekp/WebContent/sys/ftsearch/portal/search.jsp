<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="
	java.util.Iterator,
	com.landray.kmss.sys.ftsearch.config.LksConfigBuilder,
	com.landray.kmss.sys.ftsearch.config.LksConfig,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%
	String com_url=request.getServletPath();
  	boolean isSearchPath = (com_url.equals("/sys/ftsearch/search_ui.jsp")||com_url.equals("/sys/ftsearch/result_ui.jsp"));
  	pageContext.setAttribute("__isSearchPath__",isSearchPath);
%>
 
	<div id="lui_portal_header_search_include" class="lui_portal_header_search_include">
		<div class="lui_portal_header_search_input">
			<div class="lui_portal_header_search_keyword_l">
				<div class="lui_portal_header_search_keyword_r">
					<div class="lui_portal_header_search_keyword_c">
						<input type="text" placeholder="${lfn:message('sys-ftsearch-db:search.ftsearch.textDefaultValue')}" name="SEARCH_KEYWORD" onkeydown="if (event.keyCode == 13 && this.value !='') __portal_search__full();"/ >
					</div>
				</div>
			</div>
		</div>
		<div class="lui_portal_header_search_btn">
	        <div class="lui_portal_header_search_full_l">
				<div class="lui_portal_header_search_full_r">
					<div class="lui_portal_header_search_full_c">
						<input type="button" value="${lfn:message('sys-ftsearch-db:search.ftsearch.all.system')}" onclick="__portal_search__full()"/>
					</div>
				</div>
			</div>
		</div>
		<div class="lui_portal_header_search_btn" id="_SEARCH_MODEL_" style="display: none" >
			<div class="lui_portal_header_search_model_l">
				<div class="lui_portal_header_search_model_r">
					<div class="lui_portal_header_search_model_c">
						<input type="button" value="${lfn:message('sys-ftsearch-db:search.ftsearch.local.model')}" onclick="__portal_search__()"/>
					</div>
				</div>
			</div>
		</div>    
    </div> 
	<script>
		var newLUI="true";
		if("${__isSearchPath__}" == "true"){
	 		document.getElementById("lui_portal_header_search_include").style.display='none';
		}else{ 
			document.getElementById("lui_portal_header_search_include").style.display='block'; 
		}	
		function __portal_search__(){
			var keyField = document.getElementsByName("SEARCH_KEYWORD")[0];
			if(keyField.value==""){
				keyField.focus();
				return;
			}else{
				var url = Com_Parameter.ContextPath + 'sys/ftsearch/searchBuilder.do?method=search';
			 	url = url + "&modelName=" + encodeURIComponent(SYS_SEARCH_MODEL_NAME);
				url = url + "&queryString=" + encodeURIComponent(keyField.value);
				url = url + "&newLUI=" + newLUI;
				window.open(url,"_blank");
			}
		}
		function __portal_search__full(){
			var keyField = document.getElementsByName("SEARCH_KEYWORD")[0];
			if(keyField.value==""){
				keyField.focus();
				return;
			}else{
				var url = Com_Parameter.ContextPath + 'sys/ftsearch/searchBuilder.do?method=search';
				url = url + "&queryString=" + encodeURIComponent(keyField.value);
				url = url + "&newLUI=" + newLUI;
				window.open(url,"_blank");
			}
		}
		var SYS_SEARCH_MODEL_NAME;
   		LUI.ready(function(){
   			if(SYS_SEARCH_MODEL_NAME != null){
   				LUI.$("#_SEARCH_MODEL_").show();
   			}
   		});
	</script>