<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var paging = layout.parent;
{$
	<div class="lui_paging_t_box">
		<div class="lui_paging_t_content_l">
			<div class="lui_paging_t_content_r">
			  <div class="lui_paging_t_content_c">
				<table class="lui_paging_t_content_box clearfloat"> 
					<tr>
						<td>
							<div class="lui_paging_t_pre_l">
								<div class="lui_paging_t_pre_r">
									<div class="lui_paging_t_pre_c">
										<a  href="javascript:;" $}
											if(paging.hasPre) { 
												{$	
													title="${lfn:message('sys-ui:ui.listview.paging.pre') }"
													data-lui-paging-num="{% paging.currentPage-1 %}"
													class="lui_icon_s  lui_paging_t_haspre"
												$}
											}
											else {
												{$class="lui_icon_s lui_paging_t_notpre"$}
											}
										{$></a>
									</div>
								</div>
							</div>
						</td>
						<td>
							<span class="lui_paging_t_page_info">
								<input type="hidden" data-lui-mark="paging.pageno" value="{%paging.currentPage%}"/>
								<input type="hidden" data-lui-mark="paging.amount" value="{%paging.pageSize%}"/>
								<span class="lui_paging_t_page_info_current">
									{%paging.currentPage%}
								</span>
								/<span class="lui_paging_t_page_info_total_page">
									{%paging.totalPage%}
								</span>
							</span>
						</td>
						<td>
							<div class="lui_paging_t_next_l">
								<div class="lui_paging_t_next_r">
									<div class="lui_paging_t_next_c">
									 
										<a  href="javascript:;" $}
											if(paging.hasNext) { 
												{$
													title="${lfn:message('sys-ui:ui.listview.paging.next') }"
													data-lui-paging-num="{% paging.currentPage+1 %}"
													class="lui_icon_s  lui_paging_t_hasnext"
												$}
											}
											else {
												{$class="lui_icon_s  lui_paging_t_notnext"$}
											}
										{$></a>
									</div>
								</div>
							</div>
						</td>$}
						if(paging.config.refresh !== "false") {		
							{$<td>
								<div class="lui_paging_t_refresh_l">
									<div class="lui_paging_t_refresh_r">
										<div class="lui_paging_t_refresh_c">
											<a href="javascript:;" data-lui-mark="paging.jump" 
														title="${lfn:message('button.refresh')}"
														class="lui_icon_s lui_paging_t_refresh">
											</a>
										</div>
									</div>
								</div>
							</td>$}
						}
						{$
					</tr>
				</table>
			  </div>
			</div>
		</div>
		
	</div>
$}