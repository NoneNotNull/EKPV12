<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">	
	</template:replace>
	<%--标题 --%>
	<template:replace name="title">
		帮助提示
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			 <!-- 关闭 -->
			 <ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow();" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" >
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="积分帮助提示">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<template:replace name="content">
		<div class="lui_form_content_frame">
			<div >
				<div class="lui_form_subject">
					知识问答帮助提示
				</div>
				<div class="lui_form_summary_frame">
				<p>
					<span>发表问题=“提出问题后,作为提问者获得的积分值”</span>
				</p>
				<p>
					<span>回答问题=“回答问题后,作为回答者获得的积分值”</span>
				</p>
				<p>
					<span>置为最佳答案=“给出的答案被至为最佳时,获得的积分值”</span>
				</p>
				<p>
					<span>回复被赞=“给出的答案被称赞成时,获得的积分值”</span>
				</p>
				<p>
					<span>问题被推荐=“提出的问题被推荐时,作为提问者获得的积分值”</span>
				</p>
				<p>
					<span>问题被删=“提出的问题被删除时,作为提问者被扣除的积分值”</span>
				</p>
				<p>
					<span>答案被删=“给出的答案被删除时,作为回答者者被扣除的积分值”</span>
				</p>
				<p>
					<span>被修改积分=“在知识问答模块内被修改的积分值”</span>
				</p>
				<p>
					<span>知识问答积分 = 发表问题得分 + 回答问题得分 + 置为最佳答案得分 + 回复被赞得分  + 问题被推荐得分 + 问题被删扣分 + 答案被删扣分</span>
				</p>
				</div>
				<div class="lui_form_subject">
					知识问答财富币帮助提示
				</div>
				<div class="lui_form_summary_frame">
					<p>
						<span>总货币值=“当前财富币总值”</span>
					</p>
					<p>
						<span>已支付币值=“已支付给他人的财富币值”</span>
					</p>
					<p>
						<span>获得币值=“回答问题被置为最佳得到的财富币值”</span>
					</p>
					<p>
						<span>被修改币值=“被修改的财富币值”</span>
					</p>
					<p>
						<span>总币值 = 已支付币值 + 获得币值 + 被修改币值 + 初始货币值</span>
					</p>
				</div>
			</div>
			<div>
				<div class="lui_form_subject">
					维基知识库积分帮助提示
				</div>
				<div class="lui_form_summary_frame">
					<p>
						<span>创建词条=“创建词条时,作为创建者获得的积分值”</span>
					</p>
					<p>
						<span>原创词条=“创建词条时,作为作者获得的积分值”</span>
					</p>
					<p>
						<span>完善词条=“完善词条时,作为完善者获得的积分值”</span>
					</p>
					<p>
						<span>词条推荐=“词条被推荐,作为作者获得的积分值”</span>
					</p>
					<p>
						<span>词条点评=“词条被点评,作为作者获得的积分值”</span>
					</p>
					<p>
						<span>词条被删除=“词条被删除时,作为作者扣除的积分值”</span>
					</p>
					<p>
						<span>被修改积分=“在维基知识库内被修改的积分值”</span>
					</p>
					<p>
						<span>维基库积分 = 创建词条得分+ 原创词条得分 + 完善词条得分 + 词条推荐得分 + 词条被删扣分 + 被修改积分</span>
					</p>
				</div>
			</div>
			<div>
				<div class="lui_form_subject">
						文档知识库积分帮助提示
				</div>
				<div class="lui_form_summary_frame">
					<p>
						<span>贡献积分=“所创建的文档被点评、被推荐、被阅读时所获得的积分”</span>
					</p>
					<p>
						<span>阅读积分=“阅读文档获得的积分值”</span>
					</p>
					<p>
						<span>录入积分=“上传文档时所获得的积分值”</span>
					</p>
					<p>
						<span>原创积分=“文档作者所获得的积分值”</span>
					</p>
					<p>
						<span>点评积分=“点评文档时所获得的积分值”</span>
					</p>
					<p>
						<span>推荐积分=“推荐文档时所获得的积分值”</span>
					</p>
					<p>
						<span>被修改积分=“在文档知识库内被修改的积分值”</span>
					</p>
					<p>
						<span>个人文档知识库积分 = 贡献积分 + 阅读积分 + 录入积分 + 原创积分 + 点评积分 + 推荐积分 + 被修改积分</span>
					</p>
				</div>
			</div>
			<div>
				<div class="lui_form_subject">
						知识地图积分帮助提示
				</div>
				<div class="lui_form_summary_frame">
					<p>
						<span>贡献积分=“所创建的文档被点评、被推荐、被阅读时所获得的积分”</span>
					</p>
					<p>
						<span>阅读积分=“阅读文档获得的积分值”</span>
					</p>
					<p>
						<span>录入积分=“上传文档时所获得的积分值”</span>
					</p>
					<p>
						<span>原创积分=“文档作者所获得的积分值”</span>
					</p>
					<p>
						<span>点评积分=“点评文档时所获得的积分值”</span>
					</p>
					<p>
						<span>推荐积分=“推荐文档时所获得的积分值”</span>
					</p>
					<p>
						<span>被修改积分=“在知识地图内被修改的积分值”</span>
					</p>
					<p>
						<span>个人知识地图积分 = 贡献积分 + 阅读积分 + 录入积分 + 原创积分 + 点评积分 + 推荐积分 + 被修改积分</span>
					</p>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
