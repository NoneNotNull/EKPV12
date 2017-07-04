<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<ui:ajaxtext>
	<list:data>
		<list:data-columns var="item" list="${queryPage.list }">
			<c:if test='${time=="fdWeek"}'>
				<list:data-column title="头像" col="gradeImg" escape="false">
					<person:headimageUrl personId="${item.fdPerson.fdId}" size="m" />
				</list:data-column>
				<list:data-column title="用户名" col="name" escape="false">
					<ui:person personId="${item.fdPerson.fdId }" personName="${item.fdPerson.fdName }">
					</ui:person>
				</list:data-column>
				<list:data-column title="等级" property="gradeLevel" escape="false">
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				
				
				<list:data-column title="头衔" col="fdGrade" escape="false">
					${grades[item.fdId]}
				</list:data-column>
				<list:data-column title="部门" col="fdDeps" escape="false">
					${deps[item.fdId]}
				</list:data-column>
			</c:if>
			<c:if test='${time=="fdMonth"}'>
				<list:data-column title="头像" col="gradeImg" escape="false">
				<person:headimageUrl personId="${item.fdPerson.fdId}" size="m" />
				</list:data-column>
				<list:data-column title="用户名" col="name" escape="false">
					<ui:person personId="${item.fdPerson.fdId }" personName="${item.fdPerson.fdName }">
					</ui:person>
				</list:data-column>
				<list:data-column title="等级" property="gradeLevel" escape="false">
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				
				<list:data-column title="头衔" col="fdGrade" escape="false">
					${grades[item.fdId]}
				</list:data-column>
				<list:data-column title="部门" col="fdDeps" escape="false">
					${deps[item.fdId]}
				</list:data-column>
			</c:if>
			
			<c:if test='${time=="fdYear"}'>
				<list:data-column title="头像" col="gradeImg" escape="false">
				<person:headimageUrl personId="${item.fdPerson.fdId}" size="m" />
				</list:data-column>
				<list:data-column title="用户名" col="name" escape="false">
					<ui:person personId="${item.fdPerson.fdId }" personName="${item.fdPerson.fdName }">
					</ui:person>
				</list:data-column>
				<list:data-column title="等级" property="gradeLevel" escape="false">
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdYear.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdYear.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				
				<list:data-column title="头衔" col="fdGrade" escape="false">
					${grades[item.fdId]}
				</list:data-column>
				<list:data-column title="部门" col="fdDeps" escape="false">
					${deps[item.fdId]}
				</list:data-column>
			</c:if>
			
			<c:if test='${time=="fdTotal"}'>
				<list:data-column title="头像" col="gradeImg" escape="false">
					<person:headimageUrl personId="${item.fdPerson.fdId}" size="m" />
				</list:data-column>
				<list:data-column title="用户名" col="name" escape="false">
					<ui:person personId="${item.fdPerson.fdId }" personName="${item.fdPerson.fdName }">
					</ui:person>
				</list:data-column>
				<list:data-column title="等级" property="gradeLevel" escape="false">
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				
				<list:data-column title="头衔" col="fdGrade" escape="false">
					${grades[item.fdId]}
				</list:data-column>
				<list:data-column title="部门" col="fdDeps" escape="false">
					${deps[item.fdId]}
				</list:data-column>
			</c:if>
		</list:data-columns>
	
		<list:data-paging page="${queryPage }">
		</list:data-paging>
	</list:data>
</ui:ajaxtext>