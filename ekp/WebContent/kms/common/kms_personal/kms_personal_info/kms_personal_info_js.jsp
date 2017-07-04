<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	$(document)
			.ready(
					function() {

						$('#editButton')
								.bind(
										'click',
										function(event) {
											var docScrollTop = "docScrollTop="
													+ (document.documentElement || document.body).scrollTop;

											var href = [
													'<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do?method=personalInfo" />',
													'fdExpertId=${param.fdExpertId}',
													'expert=${param.expert}',
													'fdPersonId=${param.fdPersonId}',
													'type=true', docScrollTop ]
													.join('&');

											window.open(href, '_self');
											event.preventDefault();
										});
					});
</script>