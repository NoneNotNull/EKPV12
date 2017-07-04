<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<list:data>
		<list:data-columns var="item" list="${queryPage.list }">
			<c:if test='${time=="fdWeek"}'>
				<list:data-column title="名字" col="name" escape="false">
					<span class="com_author">
						${item.fdTeam.fdName }
					</span>
				</list:data-column>
				<list:data-column title="总人数" col="fdPersonCount" escape="false">
					<kmss:showNumber value="${item.fdPersonCount}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均积分" col="fdAvgScore" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdAvgScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均财富" col="fdAvgRiches" escape="false">
					<kmss:showNumber value="${item.fdWeek.fdAvgRiches}" pattern="#.#"/>
				</list:data-column>
			</c:if>
			<c:if test='${time=="fdMonth"}'>
				<list:data-column title="名字" col="name" escape="false">
					<span class="com_author">
						${item.fdTeam.fdName }
					</span>
				</list:data-column>
				<list:data-column title="总人数" col="fdPersonCount" escape="false">
					<kmss:showNumber value="${item.fdPersonCount}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均积分" col="fdAvgScore" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdAvgScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均财富" col="fdAvgRiches" escape="false">
					<kmss:showNumber value="${item.fdMonth.fdAvgRiches}" pattern="#.#"/>
				</list:data-column>
			</c:if>
			
			<c:if test='${time=="fdYear"}'>
				<list:data-column title="名字" col="name" escape="false">
					<span class="com_author">
						${item.fdTeam.fdName }
					</span>
				</list:data-column>
				<list:data-column title="总人数" col="fdPersonCount" escape="false">
					<kmss:showNumber value="${item.fdPersonCount}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdYear.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均积分" col="fdAvgScore" escape="false">
					<kmss:showNumber value="${item.fdYear.fdAvgScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdYear.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均财富" col="fdAvgRiches" escape="false">
					<kmss:showNumber value="${item.fdYear.fdAvgRiches}" pattern="#.#"/>
				</list:data-column>
			</c:if>
			
			<c:if test='${time=="fdTotal"}'>
				<list:data-column title="名字" col="name" escape="false">
					<span class="com_author">
						${item.fdTeam.fdName }
					</span>
				</list:data-column>
				<list:data-column title="总人数" col="fdPersonCount" escape="false">
					<kmss:showNumber value="${item.fdPersonCount}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总积分" col="fdTotalScore" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdTotalScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均积分" col="fdAvgScore" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdAvgScore}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="总财富" col="fdTotalRiches" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdTotalRiches}" pattern="#.#"/>
				</list:data-column>
				<list:data-column title="平均财富" col="fdAvgRiches" escape="false">
					<kmss:showNumber value="${item.fdTotal.fdAvgRiches}" pattern="#.#"/>
				</list:data-column>
			</c:if>
		</list:data-columns>
	
		<list:data-paging page="${queryPage }">
		</list:data-paging>
	</list:data>
</ui:ajaxtext>