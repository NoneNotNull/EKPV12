<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/view.jsp">
	<template:replace name="title">
		${lfn:message('kms-expert:kmsExpert.tree.title') }
	</template:replace>
	<template:replace name="header">
		<header class="lui-header">
			<ul class="clearfloat">
				<li style="float: left;padding-left: 10px;">
					<a id="column_button" data-lui-role="button">
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon',
							onclick : "setTimeout(function(){history.go(-1)},0)"
						}
						</script>		
					</a>
				</li>
			</ul>
		</header>
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/expert/pda/view/css/view.css">
	</template:replace>
	<template:replace name="docContent">
		<section class="lui-expert-grid">
			<header>
				<ul>
					<li class="img">
						<img src="${expertImgUrl }" width="100%" height="100%" />
					</li>
					<li class="info">
						<span class="name">${kmsExpertInfoForm.fdName }</span>
						<ul class="lui-expert-connect clearfloat">
							<c:if test="${not empty kmsExpertInfoForm.fdEmail }">
								<li class="lui-mail-icon" onclick="person_opt('mailto:','${kmsExpertInfoForm.fdEmail }','mailto')"></li>
							</c:if>
							<c:if test="${not empty kmsExpertInfoForm.fdMobileNo }">
								<li class="lui-phone-icon" onclick="person_opt('tel:','${kmsExpertInfoForm.fdMobileNo }','phone')"></li>
							</c:if>
						</ul>
						<span class="textEllipsis">
							${kmsExpertInfoForm.fdDeptName }
						</span>
						
						<ul class="clearfloat lui-grid-b count">
							<li>
								<em class="lui-icon-s-s lui-knowledge-icon">
									知识
									<em>
										${countsObject["com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"] }
									</em>
								</em>
							</li>
							<li>
								<em class="lui-icon-s-s lui-bookmark-icon">
									收藏
									<em>
										${countsObject["com.landray.kmss.sys.bookmark.model.SysBookmarkMain"] }
									</em>
								</em>
							</li>
							<li>
								<em class="lui-icon-s-s lui-follow-icon"  style="color:#979797">
									关注
									<em>
									</em>
								</em>
							</li>
						</ul>
					</li>
				</ul>
			</header>
			<article class="lui-expert-info-container">
			
				<ul class="lui-grid-a clearfloat lui-expert-nav">
					<li>
						<a data-lui-role="button">
							<script type="text/config">
						{
							currentClass : 'lui-info-icon-view',
							toggleClass : 'lui-info-icon-view-on',
							onclick : "expert_btn_select('expert-info')",
							group : 'group1',
							text : '基本信息',	
							selected : true
						}
						</script>	
						</a>
					</li>
					<li>
						<a data-lui-role="button">
							<script type="text/config">
						{
							currentClass : 'lui-article-icon-view',
							toggleClass : 'lui-article-icon-view-on',
							onclick : "expert_btn_select('expert-article')",
							group : 'group1',
							text : '发布的文章'
						}
						</script>	
						</a>
					</li>
				</ul>
				<div class="lui-expert-content">
					<section data-lui-role="component" id="expert-info" class="content">
						<script type="text/config">
					{
						lazy : false
					}
					</script>
						
						<ul class="lui-expert-info">
							<li>
								<span>手机号码</span>
								<span>${kmsExpertInfoForm.fdMobileNo }</span>
							</li>
							<li>
								<span>电话号码</span>
								<span>${kmsExpertInfoForm.fdWorkPhone }</span>
							</li>
							<li>
								<span>电子邮件</span>
								<span>${kmsExpertInfoForm.fdEmail }</span>
							</li>
							<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
								<li>
									<span>${kmsExpertArea.areaMessageKey }</span>
									<span>${fdKmsExpertAreaListForms[vstatus.index].fdCategoryName}</span>
								</li>
							</c:forEach>
							<li>
								<span>所属岗位</span>
								<span>${kmsExpertInfoForm.fdPostNames }</span>
							</li>
						</ul>
					</section>
					
					<c:import url="/kms/knowledge/pda/mydoc/mydoc.jsp">
						<c:param name="id" value="expert-article"></c:param>
					</c:import>
				</div>
		</section>
	</template:replace>
	
	<template:replace name="footer">
		<ul>
			<li>
				<a data-lui-role="button" class="lui-property-icon-view">
					<script type="text/config">
						{
							onclick : "add_ask('${kmsExpertInfoForm.fdId}')",
							text : '向他提问'
						}
					</script>
				</a>
			</li>
		</ul>
		
		<c:import url="/kms/ask/pda/import/ask_to_him.jsp" charEncoding="UTF-8"/>
		<script>
			function expert_btn_select(id){
				$('.content').each(function(){
					if($(this).attr('id')==id){
						$(this).show();
						Pda.Element(id).draw();
					} else 
						$(this).hide();
				});
			}
		</script>
		<%@ include file="/kms/common/pda/core/connect/connect.jsp" %>
	</template:replace>
</template:include>