<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="key" value="${param.key}"/>
<c:set var="criteria" value="${param.criteria}"/>
				<ui:content title="${ lfn:message('km-imissive:kmImissive.nav.Send')}" expand="${param.key != 'kmImissiveSend'?'false':'true' }" >
				<ul class='lui_list_nav_list'>
				    <li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSend','mydoc','');">${ lfn:message('km-imissive:kmImissive.tree.allSend') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSend','mydoc','create');">${ lfn:message('km-imissive:kmImissive.tree.create.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSend','mydoc','approval');">${ lfn:message('km-imissive:kmImissive.tree.myapproval') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSend','mydoc','approved');">${ lfn:message('km-imissive:kmImissive.tree.myapproved') }</a></li>
				</ul>
				</ui:content>
				<ui:content title="${ lfn:message('km-imissive:kmImissive.nav.Receive') }" expand="${param.key != 'kmImissiveReceive'?'false':'true' }" >
				<ul class='lui_list_nav_list'>
				    <li><a href="javascript:void(0)" onclick="setUrl('kmImissiveReceive','mydoc','');">${ lfn:message('km-imissive:kmImissive.tree.allReceive') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveReceive','mydoc','create');">${ lfn:message('km-imissive:kmImissive.tree.create.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveReceive','mydoc','approval');">${ lfn:message('km-imissive:kmImissive.tree.myapproval') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveReceive','mydoc','approved');">${ lfn:message('km-imissive:kmImissive.tree.myapproved') }</a></li>
				</ul>
				</ui:content>
				<%--签报--%>
				<ui:content title="${ lfn:message('km-imissive:kmImissive.nav.Sign') }" expand="${param.key != 'kmImissiveSign'?'false':'true' }" >
				<ul class='lui_list_nav_list'>
				    <li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSign','mydoc','');">${ lfn:message('km-imissive:kmImissive.tree.allSign') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSign','mydoc','create');">${ lfn:message('km-imissive:kmImissive.tree.create.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSign','mydoc','approval');">${ lfn:message('km-imissive:kmImissive.tree.myapproval') }</a></li>
					<li><a href="javascript:void(0)" onclick="setUrl('kmImissiveSign','mydoc','approved');">${ lfn:message('km-imissive:kmImissive.tree.myapproved') }</a></li>
				</ul>
				</ui:content>
				<ui:content title="${ lfn:message('km-imissive:kmImissive.nav.Exchange')}" expand="${param.key == 'reg' or param.key == 'regdetail'?'true':'false'}">
	            <ul class='lui_list_nav_list'>
				      <li><a href="javascript:void(0)" onclick="setUrl('reg','fdDeliverType','1');">${ lfn:message('km-imissive:kmImissive.tree.mydistribute') }</a></li>
					  <li><a href="javascript:void(0)" onclick="setUrl('reg','fdDeliverType','2');">${ lfn:message('km-imissive:kmImissive.tree.myreport') }</a></li>
					  <li><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath}/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList_mySign.jsp');">${ lfn:message('km-imissive:kmImissive.tree.mysign') }</a></li>
					  <li><a href="javascript:void(0)" onclick="setUrl('regdetail','fdStatus','');">${ lfn:message('km-imissive:kmImissive.tree.myreceive') }</a></li>
				</ul>
			    </ui:content>
				<ui:content title="${ lfn:message('list.otherOpt') }" expand="false">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=km/imissive" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
	<script type="text/javascript">
	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog'], function($, strutil, dialog){
		window.setUrl= function (key,mykey,type){
		     if(key!="${key}"){
		    	 if(key == 'kmImissiveSend'){
			        if(type ==''){
			         openUrl('km_imissive_send_main','',key);
				    }else{
		    		 openUrl('km_imissive_send_main','cri.q='+mykey+':'+type,key);
				    }
			     }
			     if(key == 'kmImissiveReceive'){
			    	 if(type ==''){
			    	 openUrl('km_imissive_receive_main','',key);
				    }else{
			    	 openUrl('km_imissive_receive_main','cri.q='+mykey+':'+type,key);
				    }
			     }
			     if(key == 'kmImissiveSign'){
			    	 if(type ==''){
			    	 openUrl('km_imissive_sign_main','',key);
				    }else{
			    	 openUrl('km_imissive_sign_main','cri.q='+mykey+':'+type,key);
				    }
			     }
			     if(key == 'reg'){
				     openUrl('km_imissive_reg','cri.q='+mykey+':'+type,key);
			     }
			     if(key == 'regdetail'){
			    	 openUrl('km_imissive_regdetail_list','',key);
			     }
				}else{
					openQuery();
					if(type==''){
						LUI('${criteria}').clearValue();
					}else{
					 LUI('${criteria}').setValue(mykey, type);
					}
				}
			 };
		window.openUrl = function(prefix,hash,key){
			    var srcUrl = "${LUI_ContextPath}/km/imissive/";
			    if(key=='kmImissiveSend'){
			    	 srcUrl = srcUrl+"index.jsp";
			    }else{
				   srcUrl = srcUrl+ prefix+"/index.jsp";
			    }
				if(hash!=""){
					srcUrl+="#"+hash;
			    }
				window.open(srcUrl,"_self");
			};
	});
	 </script>
