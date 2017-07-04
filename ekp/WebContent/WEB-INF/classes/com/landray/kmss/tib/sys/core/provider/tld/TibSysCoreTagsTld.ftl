		<INPUT style="WIDTH: 85%" class="inputsgl" onblur="TIB_SysUtil.tag_isFocus('id_application_div');" 
			onfocus="TIB_SysUtil.tag_toggle('id_application_div',true)" name="${propertyId}" value="${propertyIdVal}" isChannel="true">
		<INPUT style="WIDTH: 85%;display:none" class="inputsgl" 
			onfocus="TIB_SysUtil.tag_toggle('id_application_div',true);"  name="${propertyName}" value="${propertyNameVal}" isChannel="true"/>
				
		<!--mulSelect, idField, nameField, splitStr, dataBean, action, searchBean, isMulField, notNull, winTitle -->
		<A
			onclick="Dialog_List(false,null,null,' ','tibSysCoreTagsListBean',function(rtn){TIB_SysUtil.tag_callBack.call(TIB_SysUtil,rtn,'${propertyId}','${propertyName}');  },null,true,false,'标签树')"
			href="#" isChannel="true">选择</A>
		<DIV style="WIDTH: 85%; BACKGROUND: #ffffcc;display:none" id="id_application_div" >
		<DIV style="FLOAT: right"><SPAN style="align: right"><A
			id=a_close onclick="TIB_SysUtil.tag_toggle('id_application_div',false)" href="###"><FONT
			size=5>×</FONT></A></SPAN></DIV>
		<DIV style="MARGIN-TOP: 10px; WIDTH: 100%; HEIGHT: 20%"><B>标签间请用“空格”隔开！</DIV>
		<DIV style="MARGIN-TOP: 10px; WIDTH: 100%; MARGIN-BOTTOM: 10px"><FONT color=red size=2><B>Top 10标签：</B></FONT>
		<#list tags as tag>
  		 <A id="tagNameListId" onclick="TIB_SysUtil.tag_click(this,'${propertyId}','${propertyName}')" href="###" isChannel="true">${tag.fdTagName}</A>
		</#list>
			</DIV>
		</DIV>
		</B>
		
		
