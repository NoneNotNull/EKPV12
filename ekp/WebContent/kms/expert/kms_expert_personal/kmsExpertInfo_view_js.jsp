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
													'<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=edit" />',
													'fdExpertId=${param.fdExpertId}',
													'expert=true',
													'fdPersonId=${param.fdPersonId}',
													docScrollTop ].join('&');

											window.open(href, '_self');
											event.preventDefault();
										});
					});
</script>