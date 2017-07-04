<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="/kms/common/resource/ui/kms_edit_top.jsp"%>
	<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do"
	   onsubmit="return true;">
	<html:hidden property="docSubject"  styleId="docSubject" value="${kmsWikiMainForm.docSubject}"/> 
		<div>
			<nobr><strong>文档属性 </strong><span align="left"></span></nobr>
		</div>
		<table id='sysPropertyTemplateTable' border="0" cellpadding="0" align="center" width=720px style="table-layout:fixed;word-wrap: break-word;" >
			<!-- 属性 -->
			<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsWikiMainForm" />
				<c:param name="fdDocTemplateId" value="${kmsWikiMainForm.fdCategoryId}" />
			</c:import>
		</table>
		<span style="color:#ffffff;">.</span>
		<html:hidden property="idList"/>
	</html:form>
	<div class="btns_box btn_div" align='center'>
		<div class="btn_a" style="width:60px;">
			<a href="javascript:void(0)" id="ok" title="保存"><span><strong>保存</strong>
				</span></a>
		</div>
		<div class="btn_a" style="width:60px;">
			<a href="javascript:void(0)" id="cancel" title="关闭" ><span><strong>关闭</strong>
			</span></a>
		</div>
	</div>
</body>
</html>

<style>
.btn_div{position:absolute;bottom:20px;height:30px;padding-top:15px;text-align:center;margin-bottom:0px;margin-left:300px;}
table{margin-bottom:60px;border:#B0A89C 1px solid;border-collapse:collapse;table-layout:fixed;word-wrap:break-word;word-break:break-all}
td{border:#B0A89C 1px solid}
th{width:100px;border:#B0A89C 1px solid;height:22px;background-color:#f0f0f0;font-size: 12px;}
</style>
<script>
$(function() {

	~~function() {
		$('#ok').bind('click', function() {
			jQuery.ajax({
				url: KMS.basePath + '/wiki/kms_wiki_main/kmsWikiMain.do?method=updateProperty',
				type: 'POST',
				dataType: 'json',
				data: $(document.getElementsByName('kmsWikiMainForm')[0]).serialize(),
				success: function(data, textStatus, xhr) {
					if (data && data['flag'] === true) {
						top.showSuccessMsg();
						top.closePropertyWindow();
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("调整属性出现错误！请联系管理员！");
				}
			});
		});;

		$('#cancel').bind('click', function() {
			top.closePropertyWindow();
		});
	}()
})

$KMSSValidation();
</script>