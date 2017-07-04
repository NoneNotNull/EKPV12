<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<kmss:auth
	requestURL="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=cancelIntro&fdModelName=${param.fdModelName}">
	<script>
	function introduce_cancelIntroduce(){
		var values = [];
		LUI.$("input[name='List_Selected']:checked").each(function(){
				values.push(LUI.$(this).val());
			}); 
		if(values.length>0) {
				seajs.use(['lui/dialog','lui/topic'],function(dialog,topic){
					dialog.confirm("${lfn:message('sys-introduce:sysIntroduceMain.cancel.confirm')}",function(val,dia){
						if(val){
							window.del_load = dialog.loading();
							var xurl = "<c:url value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=cancelIntro&fdModelName=${param.fdModelName}" />";
							var xdata = {};
							LUI.$.post(xurl,LUI.$.param({"List_Selected":values},true),function(json){
								if(window.del_load!=null)
									window.del_load.hide();
								topic.publish("list.refresh");
								if(json.status){
									dialog.success("${lfn:message('return.optSuccess')}");
								}else{
									dialog.failure("${lfn:message('return.optFailure')}");									
								}
							},'json');
						}
					});
				});
		}else{
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${lfn:message('page.noSelect')}");
			});
		}
	}
</script>
	<ui:button id="cancelIntroduce"
		text="${ lfn:message('sys-introduce:sysIntroduceMain.cancel.button') }"
		onclick="introduce_cancelIntroduce();" order="4"></ui:button>
</kmss:auth>