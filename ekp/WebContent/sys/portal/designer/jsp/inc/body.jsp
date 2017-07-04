<%@ page language="java" pageEncoding="UTF-8"%>
	<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
		<ui:button onclick="onStep2()" text="${ lfn:message('sys-portal:sysPortalPage.desgin.prevstep') }" id="btnPrevStep"></ui:button>
		<ui:button onclick="onEnter()" text="${ lfn:message('sys-portal:sysPortalPage.msg.enter') }"></ui:button>
	</ui:toolbar>
	<script src="${LUI_ContextPath}/sys/ui/js/var.js"></script>
	<script>
	function DigitInput(el,e) {
		el.value=el.value.replace(/\D/gi,"");
	}
	String.prototype.startWith=function(str){     
	  var reg=new RegExp("^"+str);     
	  return reg.test(this);        
	}  

	String.prototype.endWith=function(str){     
	  var reg=new RegExp(str+"$");     
	  return reg.test(this);        
	}
	
	</script>
	<script>
	window.panelLayout = {};
	window.scene = "${param['scene']}";
	lodingImg = "<img src='${LUI_ContextPath}/sys/ui/js/ajax.gif'/>"	
	function validation(value){
		if(value.panel == null){
			alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.select') }");
			return false;
		}else if(value.panel=="panel"){
			if($.trim(value.height) == ""){
				alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.height') }");
				return false;
			}
			if($.trim(value.portlet[0].title)==""){
				alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.title') }");
				return false;
			}
			if($.trim(value.portlet[0].sourceId)==""){
				alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.content') }");
				return false;
			}
			if($.trim(value.portlet[0].renderId)==""){
				alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.render') }");
				return false;
			}
			//debugger;
			var jsname = value.portlet[0].sourceOpt['__sourcejsname'];
			if(window[jsname]!=null){
				return window[jsname].validation();
			}
		}else if(value.panel == "tabpanel"){
			if($.trim(value.height) == ""){
				alert("${ lfn:message('sys-portal:sysPortalPage.desgin.err.height') }");
				return false;
			}
			for(var i=0;i<value.portlet.length;i++){
				if($.trim(value.portlet[i].title)==""){
					alert("第"+(i+1)+"个"+"${ lfn:message('sys-portal:sysPortalPage.desgin.err.title') }");
					return false;
				}
				if($.trim(value.portlet[i].sourceId)==""){
					alert("第"+(i+1)+"个"+"${ lfn:message('sys-portal:sysPortalPage.desgin.err.content') }");
					return false;
				}
				if($.trim(value.portlet[i].renderId)==""){
					alert("第"+(i+1)+"个"+"${ lfn:message('sys-portal:sysPortalPage.desgin.err.render') }");
					return false;
				}
				//debugger; 
				var jsname = value.portlet[i].sourceOpt['__sourcejsname'];
				if(window[jsname]!=null){
					if(window[jsname].validation("第"+(i+1)+"个${ lfn:message('sys-portal:sysPortalPage.desgin.err.source') }")==false){
						return false;
					}
				}
			}
		}
		return true;
	}

	function onConfigWidget(value){
		if(value.panel == "panel"){
			LUI.$("input[name='panelType']")[0].checked=true;
			LUI.$("#portlet_panel_height").val(value.height);
			LUI.$("input[name='portlet_panel_type']").each(function(i,ele){
				if($(ele).val()==value.panelType){
					ele.checked = true;
				}
			});
			$("[name='portlet_panel_height_ext']").each(function(i,ele){
				if($(ele).val()==value.heightExt){
					ele.checked = true;
				}
			});			
			
			//填充值
			portletChangePanelType();
			//选择值
			LUI.$("#portlet_panel_layout").val(value.layoutId);
			//选中值后更换图片
			changePortletPanelLayout(document.getElementById("portlet_panel_layout"),value.layoutOpt);
			
			var xtable = LUI.$("#portlet_setting_template"); 
			setPortletConfigData(xtable,value.portlet[0]);			
		}else if(value.panel == "tabpanel"){
			LUI.$("input[name='panelType']")[1].checked=true;
			LUI.$("#portlet_tabpanel_height").val(value.height);
			LUI.$("input[name='portlet_tabpanel_type']").each(function(i,ele){
				if($(ele).val()==value.panelType){
					ele.checked = true;
				}
			});

			$("[name='portlet_tabpanel_height_ext']").each(function(i,ele){
				if($(ele).val()==value.heightExt){
					ele.checked = true;
				}
			});		
			
			portletChangeTabPanelType();
			LUI.$("#portlet_tabpanel_layout").val(value.layoutId);
			changePortletTabPanelLayout(document.getElementById("portlet_tabpanel_layout"),value.layoutOpt);
			
			for(var i=0;i<value.portlet.length;i++){
				var xtable = createPortletConfigTbody(i,value.portlet[i].title);
				LUI.$("#tabpanel_content").append(xtable);
				setPortletConfigData(xtable,value.portlet[i]);		
			}
		}
		onStep1(false);
	}
	
	function getPortletReturnData(){
		var data = {};
		data.panel = LUI.$("input[name='panelType']:checked").val();
		if(data.panel == "panel"){
			//
			data.layoutId = LUI.$("#portlet_panel_layout").val();
			data.layoutName = LUI.$("#portlet_panel_layout").find("option:selected").text();
			var jsname = LUI.$("#portlet_panel_layout_opt").attr("jsname");
			if(window[jsname]!=null){
				data.layoutOpt = window[jsname].getValue();
			}else{
				data.layoutOpt = {};
			}
			data.height = LUI.$("#portlet_panel_height").val();
			data.heightExt = $("input[name='portlet_panel_height_ext']:checked").val();
			data.panelType = LUI.$("input[name='portlet_panel_type']:checked").val();
			//
			data.portlet = [];
			var xtable = LUI.$("#portlet_setting_template"); 
			data.portlet.push(getPortletConfigData(xtable));
		}else if(data.panel == "tabpanel"){
			//
			data.layoutId = LUI.$("#portlet_tabpanel_layout").val();
			data.layoutName = LUI.$("#portlet_tabpanel_layout").find("option:selected").text();
			var jsname = LUI.$("#portlet_tabpanel_layout_opt").attr("jsname");
			if(window[jsname]!=null){
				data.layoutOpt = window[jsname].getValue();
			}else{
				data.layoutOpt = {};
			}
			data.height = LUI.$("#portlet_tabpanel_height").val();
			data.heightExt = $("input[name='portlet_tabpanel_height_ext']:checked").val();
			data.panelType = LUI.$("input[name='portlet_tabpanel_type']:checked").val();
			//
			data.portlet = [];
			var xtables = LUI.$("#tabpanel_content > .portlet_table");
			for(var i=0;i<xtables.length;i++){
				var xtable = LUI.$(xtables[i]);				
				data.portlet.push(getPortletConfigData(xtable));
			}			
		}
		return data;
	}
	function getPortletConfigData(xtable){
		var portlet = {};
		portlet.title = xtable.find(".portlet_input_title").val();
		portlet.refresh = xtable.find(".portlet_refresh_time").val();
		portlet.extendClass = xtable.find(".portlet_extend_class").val();
		portlet.sourceId = xtable.find(".portlet_input_source_id").val();
		portlet.sourceName = xtable.find(".portlet_input_source_name").val();
		portlet.format = xtable.find(".portlet_input_source_format").val();
		portlet.formats = xtable.find(".portlet_input_source_formats").val();
		portlet.operations = [];
		var xchk = xtable.find(".portlet_input_operations").find("input:checked");
		for(var i=0;i<xchk.length;i++){
			var opt = {};
			opt.key = $(xchk[i]).val();
			portlet.operations.push(opt);
		}
		var jsname = xtable.find(".portlet_input_source_opt").attr("jsname");
		if(window[jsname]!=null){
			portlet.sourceOpt = window[jsname].getValue();
			portlet.sourceOpt.__sourcejsname = jsname;
		}else{
			portlet.sourceOpt = {};
		} 
		portlet.renderId = xtable.find(".portlet_input_render_id").val();
		portlet.renderName = xtable.find(".portlet_input_render_name").val();
		var jsname = xtable.find(".portlet_input_render_opt").attr("jsname");
		if(window[jsname]!=null){
			portlet.renderOpt = window[jsname].getValue();
			portlet.renderOpt.__renderjsname = jsname;
		}else{
			portlet.renderOpt = {};
		}
		return portlet;
	}
	function setPortletConfigData(xtable,portlet){
		xtable.find(".portlet_refresh_time").val(portlet.refresh==null?"":portlet.refresh);
		xtable.find(".portlet_extend_class").val(portlet.extendClass==null?"":portlet.extendClass);
		xtable.find(".portlet_input_title").val(portlet.title);
		xtable.find(".portlet_input_source_id").val(portlet.sourceId);
		xtable.find(".portlet_input_source_name").val(portlet.sourceName);
		xtable.find(".portlet_input_source_format").val(portlet.format);
		xtable.find(".portlet_input_source_formats").val(portlet.formats);
		xtable.find(".portlet_input_render_id").val(portlet.renderId);
		xtable.find(".portlet_input_render_name").val(portlet.renderName);
		//debugger;
		if(portlet.sourceOpt!=null&&portlet.sourceOpt.__sourcejsname!=null){
			xtable.find(".portlet_input_source_opt").html(lodingImg).show().attr("jsname",portlet.sourceOpt.__sourcejsname).load("${LUI_ContextPath}/sys/ui/jsp/vars/source.jsp?x="+(new Date().getTime()),{"fdId":portlet.sourceId,"jsname":portlet.sourceOpt.__sourcejsname},function(){
				//debugger;
				if(window[portlet.sourceOpt.__sourcejsname])
					window[portlet.sourceOpt.__sourcejsname].setValue(portlet.sourceOpt);
			});
		}
		if(portlet.renderOpt!=null&&portlet.renderOpt.__renderjsname!=null){
			xtable.find(".portlet_input_render_opt").html(lodingImg).show().attr("jsname",portlet.renderOpt.__renderjsname).load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?x="+(new Date().getTime()),{"fdId":portlet.renderId,"jsname":portlet.renderOpt.__renderjsname},function(){
				//debugger;
				if(window[portlet.renderOpt.__renderjsname])
					window[portlet.renderOpt.__renderjsname].setValue(portlet.renderOpt);
			});
		}
		xtable.find(".portlet_input_operations").html(lodingImg);
		$.getJSON("${LUI_ContextPath}/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=portletOperation&x="+(new Date().getTime()),{"sourceId":portlet.sourceId},function(val){
			xtable.find(".portlet_input_operations").empty();
			for(var i=0;i<val.length;i++){
				xtable.find(".portlet_input_operations").append("<label><input class='"+val[i].key+"' value='"+val[i].key+"' type='checkbox' />"+val[i].name+"</label>");
			}
			if(portlet.operations!=null){
				for(var i=0;i<portlet.operations.length;i++){
					xtable.find(".portlet_input_operations").find("."+portlet.operations[i].key).attr("checked","checked");
				}
			}
		});
	}
	function onStep1(animate){
		//debugger;
		//console.log("sss");
		LUI("btnPrevStep").setVisible(true);
		var t = LUI.$("input[name='panelType']:checked").val();
		LUI.$("input[name='panelType']").each(function(i,ele){
			LUI.$("#panelType_"+LUI.$(ele).val()).hide();
		});
		LUI.$("#panelType_"+t).show();
		
		//
		if(t=="panel"){
			//单标签
			if(LUI.$("#portlet_panel_layout option").length<=0){
				portletChangePanelType(); 
				changePortletPanelLayout(document.getElementById("portlet_panel_layout"));
			}
		}
		if(t=="tabpanel"){
			//多标签
			if(LUI.$("#portlet_tabpanel_layout option").length<=0){
				portletChangeTabPanelType();
				changePortletTabPanelLayout(document.getElementById('portlet_tabpanel_layout'));
			}
		}
		//
		
		if(animate==null||animate==true){
			LUI.$("#step1").slideUp();		
			LUI.$("#step2").slideDown();
		}else{
			LUI.$("#step1").hide();		
			LUI.$("#step2").show();
		}
	}
	function onStep2(){
		//debugger;
		LUI("btnPrevStep").setVisible(false);
		LUI.$("#step2").slideUp();
		LUI.$("#step1").slideDown();
	}
	function changePortletPanelLayout(ele,val){
		var src = LUI.$(LUI.$(ele).find("option")[ele.selectedIndex]).attr("img");
		var layoutId = LUI.$(LUI.$(ele).find("option")[ele.selectedIndex]).val();
		if($.trim(src)!=""){
			LUI.$("#portlet_panel_layout_img").show().attr("src","${LUI_ContextPath}"+src);	
		}else{
			LUI.$("#portlet_panel_layout_img").hide();
		}
		if($.trim(layoutId)!=""){
			LUI.$("#portlet_panel_layout_opt").html(lodingImg).show().attr("jsname","portlet_panel_layout_opt_var").load("${LUI_ContextPath}/sys/ui/jsp/vars/layout.jsp?x="+(new Date().getTime()),{"fdId":layoutId,"jsname":"portlet_panel_layout_opt_var"},function(){
				if(val!=null){
					window['portlet_panel_layout_opt_var'].setValue(val);
				}
			});
		}else{
			LUI.$("#portlet_panel_layout_opt").empty().hide();		
			window['portlet_panel_layout_opt_var'] = null;	
		}
	}
	function changePortletTabPanelLayout(ele,val){
		var src = LUI.$(LUI.$(ele).find("option")[ele.selectedIndex]).attr("img");
		var layoutId = LUI.$(LUI.$(ele).find("option")[ele.selectedIndex]).val();
		if($.trim(src)!=""){
			LUI.$("#portlet_tabpanel_layout_img").show().attr("src","${LUI_ContextPath}"+src);			
		}else{
			LUI.$("#portlet_tabpanel_layout_img").hide();
		}
		if($.trim(layoutId)!=""){
			LUI.$("#portlet_tabpanel_layout_opt").html(lodingImg).show().attr("jsname","portlet_tabpanel_layout_opt_var").load("${LUI_ContextPath}/sys/ui/jsp/vars/layout.jsp?x="+(new Date().getTime()),{"fdId":layoutId,"jsname":"portlet_tabpanel_layout_opt_var"},function(){
				if(val!=null){
					window['portlet_tabpanel_layout_opt_var'].setValue(val);
				}
			});
		}else{
			LUI.$("#portlet_tabpanel_layout_opt").empty().hide();
			window['portlet_tabpanel_layout_opt_var'] = null;
		}
	}
	function openPortletSourceDialog(ele){
		var xtable = LUI.$(ele).closest(".portlet_table");
		seajs.use(['lui/dialog','lui/jquery'],function(dialog){
			dialog.iframe("/sys/portal/designer/jsp/selectportletsource.jsp?scene="+scene+"&sourceId="+xtable.find(".portlet_input_source_id").val(), "${ lfn:message('sys-portal:sysPortalPage.desgin.selectsource') }", function(val){
				if(!val){
					return;
				}
				
				if(xtable.find(".portlet_input_title").val()==""){
					xtable.find(".portlet_input_title").val(val.sourceName);
					xtable.find(".portlet_title").html(xtable.find(".portlet_input_title").val());
				}
				xtable.find(".portlet_input_source_format").val(val.sourceFormat);
				xtable.find(".portlet_input_source_formats").val(val.sourceFormats);
				xtable.find(".portlet_input_source_id").val(val.sourceId);
				xtable.find(".portlet_input_source_name").val(val.sourceName);
				xtable.find(".portlet_input_render_id").val(val.renderId);
				xtable.find(".portlet_input_render_name").val(val.renderName);
				xtable.find(".portlet_input_source_opt").html(lodingImg).show().attr("jsname",val.uuid+"_source").load("${LUI_ContextPath}/sys/ui/jsp/vars/source.jsp?x="+(new Date().getTime()),{"fdId":val.sourceId,"jsname":val.uuid+"_source"});
				xtable.find(".portlet_input_render_opt").html(lodingImg).show().attr("jsname",val.uuid+"_render").load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?x="+(new Date().getTime()),{"fdId":val.renderId,"jsname":val.uuid+"_render"});
				xtable.find(".portlet_input_operations").empty();
				if(val.operations!=null&&val.operations.length>0){
					for(var i=0;i<val.operations.length;i++){
						xtable.find(".portlet_input_operations").append("<label><input type='checkbox' value='"+val.operations[i].key+"' checked='checked' />"+val.operations[i].name+"</label>");
					}
				}
			}, {width:750,height:550,topWin:dialogWin});
		});
	}
	function openPortletRenderDialog(ele){
		var xtable = LUI.$(ele).closest(".portlet_table");
		var formats = xtable.find(".portlet_input_source_formats").val();
		if(LUI.$.trim(formats)==""){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${ lfn:message('sys-portal:sysPortalPage.desgin.selectsource') }");
			},{topWin:dialogWin});
			return;
		}
		seajs.use(['lui/dialog','lui/jquery'],function(dialog){
			dialog.iframe("/sys/portal/designer/jsp/selectportletrender.jsp?format="+encodeURIComponent(formats)+"&scene="+encodeURIComponent(scene), "${ lfn:message('sys-portal:sysPortalPage.desgin.selectrender') }", function(val){
				if(!val){
					return;
				}
				if(val.renderId != xtable.find(".portlet_input_render_id").val()){
					xtable.find(".portlet_input_render_id").val(val.renderId);
					xtable.find(".portlet_input_render_name").val(val.renderName);
					var xopt = xtable.find(".portlet_input_render_opt").html(lodingImg).show();
					window[xopt.attr("jsname")] = null;
					xopt.load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?x="+(new Date().getTime()),{"fdId":val.renderId,"jsname":xopt.attr("jsname")});
					
				}
			}, {width:750,height:550,topWin:dialogWin});
		});
	}
	function addTabPanelPortlet(){
		var len = LUI.$("#tabpanel_content > .portlet_table").length;
		var xdiv = createPortletConfigTbody(len);
		LUI.$("#tabpanel_content").append(xdiv);
		xdiv.find(".portlet_config_setting").click();
	}
	function switchPorgletConfigTable(x){
		LUI.$("#tabpanel_content .portlet_table .portlet_setting_body").filter(function(index) {
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			if(parseInt(index) == x){
				return false;
			}else{
				return true;
			}
		}).hide();
		var currentTable = LUI.$("#portlet_table_"+x).find(".portlet_setting_body");
		if(currentTable.is(":visible")){
			currentTable.hide();
		}else{
			currentTable.show();
		}
	}
	function moveUpPorgletConfigTable(x){
		if(x<=0){
			return;
		}
		var y = x-1;
		LUI.$("#portlet_table_"+y).before(LUI.$("#portlet_table_"+x));
		updatePorgletConfigTableIndex();
	}
	function moveDownPorgletConfigTable(x){
		var len = LUI.$("#tabpanel_content > .portlet_table").length;
		if(x>=len){
			return;
		}
		var y = x+1;
		LUI.$("#portlet_table_"+y).after(LUI.$("#portlet_table_"+x));
		updatePorgletConfigTableIndex();
	}
	function deletePorgletConfigTable(x){
		seajs.use(['lui/dialog','lui/jquery'],function(dialog){
			dialog.confirm("${ lfn:message('sys-portal:sysPortalPage.msg.delete') }",function(val){
				if(val==true){
					LUI.$("#portlet_table_"+x).remove();
					updatePorgletConfigTableIndex();
				}
			})
		});
	}
	function updatePorgletConfigTableIndex(){
		LUI.$("#tabpanel_content > .portlet_table").each(function(i,ele){
			LUI.$(ele).attr("id","portlet_table_"+i);
		});
	}
	function changePortletTitle(ele){
		LUI.$(ele).closest(".portlet_table").find(".portlet_title").html(LUI.$(ele).val());
	}
	function createPortletConfigTbody(x,title){
		var xtobdy = LUI.$("<table class='portlet_table tb_normal' id='portlet_table_"+x+"' ></table>");
		var xtr1 = LUI.$("<tr class='portlet_tr_title'></tr>");
		var xtd1 = LUI.$("<td></td>");
		var xTitle = LUI.$("<div class='portlet_title'>"+(title?title:"${ lfn:message('sys-portal:sysPortalPage.desgin.msg.nonetitle') }")+"</div>");
		xTitle.click(function (evt){
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			switchPorgletConfigTable(parseInt(index));
		});
		var xConfig = LUI.$("<div class='portlet_config'></div>");
		var xSetting = LUI.$("<span class='portlet_config_setting lui_icon_s lui_icon_s_icon_set_green' title=\"${ lfn:message('sys-portal:sysPortalPage.desgin.opt.setting') }\"></span>").click(function(evt){
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			switchPorgletConfigTable(parseInt(index));			 
		});
		var xMoveUp = LUI.$("<span class='lui_icon_s lui_icon_s_icon_arrow_up_blue' title='${ lfn:message('sys-portal:sysPortalPage.desgin.opt.moveup') }'></span>").click(function(evt){
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			moveUpPorgletConfigTable(parseInt(index));
		});
		var xMoveDown = LUI.$("<span class='lui_icon_s lui_icon_s_icon_arrow_down_blue' title='${ lfn:message('sys-portal:sysPortalPage.desgin.opt.movedown') }'></span>").click(function(evt){
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			moveDownPorgletConfigTable(parseInt(index));
		});
		var xMoveDel = LUI.$("<span  class='lui_icon_s lui_icon_s_icon_close_red' title='${ lfn:message('sys-portal:sysPortalPage.desgin.opt.delete') }'></span>").click(function(evt){
			var xid = LUI.$(this).closest(".portlet_table").attr("id");
			var index = xid.substring(xid.lastIndexOf("_")+1,xid.length);
			deletePorgletConfigTable(parseInt(index));
		});
		xtd1.append(xTitle).append(xConfig.append(xMoveUp).append("&nbsp;").append(xMoveDown).append("&nbsp;").append(xMoveDel).append("&nbsp;").append(xSetting)).append("<div style='clear: both;'></div>");		
		xtobdy.append(xtr1.append(xtd1));
		
		var xtr2 = LUI.$("<tr class='portlet_setting_body'></tr>");
		var xtd2 = LUI.$("<td></td>").append(createPortletConfigTable());
		xtobdy.append(xtr2.append(xtd2).hide());
		return xtobdy;
	}
	function createPortletConfigTable(){
		var xtable = LUI.$("#portlet_setting_template").clone();
		xtable.removeAttr("id");
		xtable.find(":input").val("");
		xtable.find("script").remove();
		xtable.find(".portlet_input_source_opt").empty();
		xtable.find(".portlet_input_render_opt").empty();
		return xtable;
	}
	function portletChangeTabPanelType(){
		LUI.$("#portlet_tabpanel_layout").empty();
		//.append("<option value=''>系统默认布局</option>");
		var panelType = LUI.$("input[name='portlet_tabpanel_type']:checked").val();
		if(panelType=="h"){
			LUI.$("#portlet_tabpanel_height_tr").show();
			for(var i=0;i<panelLayout.tabpanel.length;i++){
				var opt = $("<option></option>");
				opt.attr("value",panelLayout.tabpanel[i].id);
				opt.attr("img",panelLayout.tabpanel[i].img);
				opt.text(panelLayout.tabpanel[i].name);
				if(panelLayout.tabpanel[i].id.endWith(".default")){
					opt.attr("selected",true);
				}
				LUI.$("#portlet_tabpanel_layout").append(opt);
			}				
		}else if(panelType=="v"){
			LUI.$("#portlet_tabpanel_height_tr").hide();
			for(var i=0;i<panelLayout.accordionpanel.length;i++){
				var opt = $("<option></option>");
				opt.attr("value",panelLayout.accordionpanel[i].id);
				opt.attr("img",panelLayout.accordionpanel[i].img);
				opt.text(panelLayout.accordionpanel[i].name);
				if(panelLayout.accordionpanel[i].id.endWith(".default")){
					opt.attr("selected",true);
				}
				LUI.$("#portlet_tabpanel_layout").append(opt);
			}	
		}
	}
	function portletChangePanelType(){
		var panelType = LUI.$("input[name='portlet_panel_type']:checked").val();
		LUI.$("#portlet_panel_layout").empty();
		//.append("<option value=''>系统默认布局</option>");
		if(panelType=="panel"){
			//LUI.$("#portlet_panel_layout_tr").show();
			for(var i=0;i<panelLayout.panel.length;i++){
				var opt = $("<option></option>");
				opt.attr("value",panelLayout.panel[i].id);
				opt.attr("img",panelLayout.panel[i].img);
				opt.text(panelLayout.panel[i].name);
				if(panelLayout.panel[i].id.endWith(".default")){
					opt.attr("selected",true);
				}
				LUI.$("#portlet_panel_layout").append(opt);
			}
		}else if(panelType=="none"){
			//LUI.$("#portlet_panel_layout_tr").hide();		
			for(var i=0;i<panelLayout.nonepanel.length;i++){
				var opt = $("<option></option>");
				opt.attr("value",panelLayout.nonepanel[i].id);
				opt.attr("img",panelLayout.nonepanel[i].img);
				opt.text(panelLayout.nonepanel[i].name);
				if(panelLayout.nonepanel[i].id.endWith(".default")){
					opt.attr("selected",true);
				}
				LUI.$("#portlet_panel_layout").append(opt);
			}
		}
	}
	function openPortletRenderSetting(obj){
		var xtable = LUI.$(obj).closest(".portlet_table");
		if(obj.checked)
			xtable.find(".portlet_render_setting").show();
		else
			xtable.find(".portlet_render_setting").hide();
	}
	function changeToPanel(){
		var data = {};
		data.portlet = [];
		var xtables = LUI.$("#tabpanel_content > .portlet_table");
		for(var i=0;i<xtables.length;i++){
			var xtable = LUI.$(xtables[i]);				
			data.portlet.push(getPortletConfigData(xtable));
		}
		var xxx = LUI.$("#portlet_setting_template"); 
		if(LUI.$.trim(xxx.find(".portlet_input_source_name").val()) == "" && data.portlet.length > 0){
			setPortletConfigData(xxx,data.portlet[0]);
		}
	}
	function changeToTabPanel(){
		var data = {};
		data.portlet = [];
		var xtable = LUI.$("#portlet_setting_template"); 
		data.portlet.push(getPortletConfigData(xtable));
		var xtables = LUI.$("#tabpanel_content > .portlet_table");
		if(xtables.length <= 0 && LUI.$.trim(data.portlet[0].sourceId) != ""){
			addTabPanelPortlet();
			var xxx = LUI.$(LUI.$("#tabpanel_content > .portlet_table")[0]);
			setPortletConfigData(xxx,data.portlet[0]);	
		}
	}
	</script>
	
	<div id="step1" style="display:none;">
		<br><br><br>
		<table class="tb_normal" style="width: 300px;"> 
			<tbody>
				<tr >
					<td colspan="2"  class="td_normal_title" style="text-align: center;">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.selectType') }</td>
				</tr>
				<tr>
					<td style="text-align: center;cursor: pointer;" onclick="document.getElementsByName('panelType')[0].checked=true;onStep1();changeToPanel();" width="50%">
						<img src="${ LUI_ContextPath }/sys/portal/designer/images/panel.png"/>
						<br>
						<input name="panelType" type="radio" value="panel"/>${ lfn:message('sys-portal:sysPortalPage.desgin.msg.typepanel') }						 
					</td>
					<td style="text-align: center;cursor: pointer;" onclick="document.getElementsByName('panelType')[1].checked=true;onStep1();changeToTabPanel();">
						<img src="${ LUI_ContextPath }/sys/portal/designer/images/tab.png"/>
						<br>
						<input name="panelType" type="radio" value="tabpanel"/>${ lfn:message('sys-portal:sysPortalPage.desgin.msg.typetab') }
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="step2" style="display:none;">
		<div id="panel_box" style="width:90%;height:380px;border:1px ghostwhite solid;margin:0px auto;margin-top: 60px;">
			<div id="panelType_panel" style="display:none;">
				<ui:tabpanel layout="sys.ui.tabpanel.light">
					<ui:content title="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.contentSetting') }">
						<div class='portlet_table' style="height: 320px;">
							<table id="portlet_setting_template" class="tb_normal" style="width:100%;">
								<tbody>
									<tr>
										<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.title') }</td>
										<td><input name="portlet_input_title" class="inputsgl portlet_input_title" oninput="changePortletTitle(this)" propertychange="changePortletTitle(this)" type="text" style="width:80%" /></td>
									</tr>
									<tr>
										<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.content') }</td>
										<td>
											<input type="hidden" name="portlet_input_source_format" class="portlet_input_source_format" />
											<input type="hidden" name="portlet_input_source_formats" class="portlet_input_source_formats" />
											<input type="hidden" name="portlet_input_source_id" class='portlet_input_source_id' />
											<input type="text" readonly="readonly" name="portlet_input_source_name" class="inputsgl portlet_input_source_name" style="width:80%" />
											<a href="javascript:void(0)" class="com_btn_link" onclick="openPortletSourceDialog(this)">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.select') }</a>
											<div class="portlet_input_source_opt" style="display:none;width:80%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.contentOpt') }</div>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="background: #f6f6f6;"><label><input type="checkbox" onclick="openPortletRenderSetting(this)" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.advOpt') }</label></td>
									</tr>
								</tbody>
								<tbody class="portlet_render_setting" style="display: none;">							
									<tr>
										<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.render') }</td>
										<td>
											<input type="hidden" name="portlet_input_render_id" class="portlet_input_render_id" />
											<input type="text" readonly="readonly" name="portlet_input_render_name" class="inputsgl portlet_input_render_name" style="width:80%" />
											<a href="javascript:void(0)" class="com_btn_link" onclick="openPortletRenderDialog(this)">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.select') }</a>
											<div class="portlet_input_render_opt" style="display:none;width:80%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.renderOpt') }</div>
										</td>
									</tr>
									<tr>
										<td class="td_normal_title">
											${ lfn:message('sys-portal:sysPortalPage.desgin.msg.refresh') }
										</td>
										<td>
											<input type="text" name="portlet_refresh_time" class="inputsgl portlet_refresh_time" onkeyup="this.value=this.value.replace(/\D/gi,'')" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.refresh1') } <span class="com_help">(${ lfn:message('sys-portal:sysPortalPage.desgin.msg.refresh2') })</span>
										</td>
									</tr>
									<tr>
										<td class="td_normal_title">											
											${ lfn:message('sys-portal:sysPortalPage.msg.extClass') }
										</td>
										<td>
											<select name="portlet_extend_class" class="inputsgl portlet_extend_class" >
												<option value=""> == ${ lfn:message('sys-portal:sysPortalPage.msg.selectExt') } == </option>
												<option value="lui_panel_ext_padding">${ lfn:message('sys-portal:sysPortalPage.msg.extPadding') }</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="td_normal_title">
											${ lfn:message('sys-portal:sysPortalPage.msg.optButton') }
										</td>
										<td>
											<div class="portlet_input_operations"></div>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
					</ui:content>
					<ui:content title="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.view') }">
						<table class="tb_normal" style="width:100%">
							<tr>
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.border') }</td>
								<td>
									<label>
										<input onclick="portletChangePanelType();changePortletPanelLayout(document.getElementById('portlet_panel_layout'));" type="radio" name="portlet_panel_type" checked="checked" value="panel" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.panel') }
									</label>
									&nbsp;&nbsp;
									<label>
										<input onclick="portletChangePanelType();changePortletPanelLayout(document.getElementById('portlet_panel_layout'));" type="radio" name="portlet_panel_type" value="none" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.nonepanel') }
									</label>
								</td>
							</tr>
							<tr>
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.height') }</td>
								<td><input type="text" class='inputsgl' style="width: 50px" id="portlet_panel_height" onkeyup="DigitInput(this,event);" name="portlet_panel_height" value="240" />px</td>
							</tr>
							<tr>
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight') }</td>
								<td>
								<label>
									<input type="radio" name="portlet_panel_height_ext" value="auto">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight1') }
								</label>
								<label>
									<input type="radio" name="portlet_panel_height_ext" value="scroll">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight2') }
								</label>
								</td>
							</tr>
							<tr id="portlet_panel_layout_tr">
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.layout') }</td>
								<td>
									<table class="tb_layout" width="100%">
										<tr>
											<td class="tb_layout_td" style="width: 300px;" valign="top">
												<select style="width:280px;" onchange="changePortletPanelLayout(this)" id="portlet_panel_layout" name="portlet_panel_layout">
												</select>
												<div id="portlet_panel_layout_opt" style="display:none;width:280px;">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.layoutOpt') }</p>
											</td>
											<td class="tb_layout_td" style="background: #f6f6f6;"  align="center">
												<img id="portlet_panel_layout_img" src=""   style="  max-width:200px;max-height: 200px;" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</ui:content>
				</ui:tabpanel>
			</div>
			<div id="panelType_tabpanel" style="display:none;">
				<ui:tabpanel layout="sys.ui.tabpanel.light">
					<ui:content title="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.contentSetting') }">
						<table class="tb_noborder" style="width:100%">
							<tbody>
								<tr>
									<td style="height: 20px;padding: 3px;text-align: right;"> <input class='lui_form_button' type="button" title="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.addportlet') }" value="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.addportlet') }" onclick="addTabPanelPortlet()">  </td>
								</tr>
							</tbody>
						</table>
						<div style="height: 300px;overflow-y:auto;">
							<div id="tabpanel_content">
							</div>
						</div>
					</ui:content>
					<ui:content title="${ lfn:message('sys-portal:sysPortalPage.desgin.msg.view') }">
						<table class="tb_normal" style="width:100%">
							<tr>
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.paiban') }</td>
								<td>
									<label>
										<input onclick="portletChangeTabPanelType();changePortletTabPanelLayout(document.getElementById('portlet_tabpanel_layout'));" type="radio" name="portlet_tabpanel_type" checked="checked" value="h" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.shuipin') }
									</label>
									&nbsp;&nbsp;
									<label>
										<input onclick="portletChangeTabPanelType();changePortletTabPanelLayout(document.getElementById('portlet_tabpanel_layout'));" type="radio" name="portlet_tabpanel_type" value="v" />${ lfn:message('sys-portal:sysPortalPage.desgin.msg.cuizhi') }
									</label>
								</td>
							</tr>
							<tbody id="portlet_tabpanel_height_tr">
								<tr>
									<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.height') }</td>
									<td><input type="text" class='inputsgl' style="width: 50px" id="portlet_tabpanel_height" name="portlet_tabpanel_height" onkeyup="DigitInput(this,event);" value="240" />px</td>
								</tr>
								<tr>
									<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight') }</td>
									<td>
									<label>
										<input type="radio" name="portlet_tabpanel_height_ext" value="auto">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight1') }
									</label>
									<label>
										<input type="radio" name="portlet_tabpanel_height_ext" value="scroll">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.autoheight2') }
									</label>
									</td>
								</tr>
							</tbody>
							<tr>
								<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.layout') }</td>
								<td>
									<table class="tb_layout" width="100%">
										<tr>
											<td class="tb_layout_td" style="width: 300px;" valign="top">
												<select style="width:280px;" onchange="changePortletTabPanelLayout(this)" id="portlet_tabpanel_layout" name="portlet_tabpanel_layout_0">
												</select>
												<div id="portlet_tabpanel_layout_opt" style="display:none;width:280px;">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.layoutOpt') }</p>
											</td>
											<td class="tb_layout_td" style="background: #f6f6f6;" align="center">
												<img id="portlet_tabpanel_layout_img" src="" style=" max-width:200px;max-height: 200px; " />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</ui:content>
				</ui:tabpanel>
			</div>
		</div>		
	</div>	