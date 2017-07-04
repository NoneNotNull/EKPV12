<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>

<html>
<head>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/util.js"></script>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/jquery.js"></script>

<div id="optBarDiv">
	<input type="button" class="btnopt" value="保存" onclick="_submitForm();" />
</div>

</head>
<body>
	<html:form action="/sys/ftsearch/expand/fieldBoostingConfig.do?method=save">
		<p class="txttitle">
		<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.jspTitle"/>
		
		</p>
		<center>
		<table class="tb_normal" width=100% id="fieldBoostingConfig">
			<tr>
				<td>
					<table class="tb_normal" width=100%>
						<tbody>
						<tr id="title">
							<td class="td_normal_title" width="15%">
								<bean:message bundle="sys-ftsearch-expand" key="field.title"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(title)"
									style="width:150px" /> 
								<span class="txtstrong">*</span>
								<span class="message">
									<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.title"/>
								</span></td>
						</tr>
						<tr id="content">
							<td class="td_normal_title" width="15%">
								<bean:message bundle="sys-ftsearch-expand" key="field.content"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(content)"
									style="width:150px" /> <span class="txtstrong">*</span>
								<span class="message">
									<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.content"/>
								</span></td>
						</tr>
						<tr id="creator">
							<td class="td_normal_title" width="15%">
								<bean:message bundle="sys-ftsearch-expand" key="field.creator"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(creator)"
									style="width:150px" /> <span class="txtstrong">*</span>
								<span class="message">
									<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.creator"/>
								</span></td>
						</tr>
						<tr id="keyword">
							<td class="td_normal_title" width="15%">
								<bean:message bundle="sys-ftsearch-expand" key="field.keyword"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(keyword)"
									style="width:150px" /> <span class="txtstrong">*</span>
								<span class="message">
								<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.tag"/>
								</span></td>
						</tr>
						<tr id="fileName">
							<td class="td_normal_title" width="15%">
								<bean:message bundle="sys-ftsearch-expand" key="field.attachmentName"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(fileName)"
									style="width:150px" /> <span class="txtstrong">*</span>
								<span class="message">
								<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.attachmentName"/>
								</span></td>
						</tr>
						<tr id="fullText">
							<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-ftsearch-expand" key="field.attachmentContent"/>
							</td>
							<td class="td_normal_title" width="85%"><html:text property="value(fullText)"
									style="width:150px" /> <span class="txtstrong">*</span>
								<span class="message">
								<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.attachmentContent"/>
								</span></td>
						</tr>
							<tr id="text">
							
							<td class="td_normal_title" width="15%">
								
							</td>
							<td>
								<span class="message" style ="color:red">
									<bean:message bundle="sys-ftsearch-expand" key="fieldBoosting.explain"/>
								</span>
							</td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		</center>
	</html:form>
</body>
<script>
	$.ready()
	{
		$(".inputsgl").bind("focusout", function(e) {
			_checkdata(e.currentTarget);
		});

	}

	function _submitForm() {
		if (_check()) {
			Com_Submit(document.fieldBoostingConfigForm, "save");
		}
	}
	function _checkdata(e){
		if (validata($.trim(e.value))){
			$($(e).siblings("span")[0]).html("请输入1~50之间的数字").css("color",
			"red");
			return;
		}
		var text = $($(e).siblings("span")[0]).text();
		if (text == "请输入1~50之间的数字"
				|| text == "*") {
			$($(e).siblings("span")[0]).html("√").css("color",
					"green");
		}
	}
	function _check() {
		var allField = $(".inputsgl");
		for ( var i = 0; i < allField.length; i++) {
			if (validata($.trim(allField[i].value))) {
				$($(allField[i]).siblings("span")[0]).html("请输入1~50之间的数字").css("color",
				"red");
				return false;
			}
			var text = $($(allField[i]).siblings("span")[0]).text();
			if (text == "请输入0~50之间的数字"
					|| text == "*") {
				$($(allField[i]).siblings("span")[0]).html("√").css("color",
						"green");
			}
		}
		return true;
	}

	function validata(value) {
		if(value>50 || value < 1){
			return true;
		}
		if(value == "0"){
			return true;
		}
		if (value
				.match("^[0-9]+(\.[0-9]{0,1})?$")) {
			return false;
		}
		return true;
		
	}
</script>
</html>
