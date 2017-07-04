<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var paging = layout.parent;
{$
			<div class="lui_paging_box">
                <div class="lui_paging_header_left">
                    <div class="lui_paging_header_right">
                        <div class="lui_paging_header_centre">
                        </div>
                    </div>
                </div>
                <div class="lui_paging_content_left">
                    <div class="lui_paging_content_right">
                        <div class="lui_paging_content_centre">
                            <ul class="lui_paging_contentBox simple clearfloat">
$}
	                         	if (paging.hasPre) {
									{$
										<div class="lui_paging_next_left">
											<div class="lui_paging_next_right">
												<div class="lui_paging_next_center">
													<li class="lui_paging_pre"><a href="javascript:;" data-lui-paging-num="{% paging.currentPage-1 %}">${lfn:message('sys-ui:ui.listview.paging.pre') }</a></li>
												</div>
											</div>
										</div>
									$}
								}
								
								if (!paging.marginLeft && !paging.marginRight){
									for(var i = 1;i < paging.totalPage + 1; i++){
										{$
											<div class="lui_paging_num_left $} if(i == paging.currentPage){ {$ selected $} } {$">
												<div class="lui_paging_num_right">
													<div class="lui_paging_num_center">
														<li>
															<a href="javascript:;" data-lui-paging-num="{% i %}">{% i %}</a>
														</li>
													</div>
												</div>
											</div>
										$}
									}
								} else {
									if(paging.marginLeft){
										{$
											<div class="lui_paging_num_left">
												<div class="lui_paging_num_right">
													<div class="lui_paging_num_center">
														<li><a href="javascript:;" data-lui-paging-num="1">1</a></li>
													</div>
												</div>
											</div>
											<div class="lui_paging_ellipsis_left">
												<div class="lui_paging_ellipsis_right">
													<div class="lui_paging_ellipsis_center">
														<li class="lui_paging_ellipsis"><span>...</span></li>
													</div>
												</div>
											</div>
										$}
									}
									var range = paging.range;
									for(var j = range[0]; j < range[1]+1; j++){
										{$
											<div class="lui_paging_num_left $} if(j == paging.currentPage){ {$ selected $} } {$">
												<div class="lui_paging_num_right">
													<div class="lui_paging_num_center">
														<li><a href="javascript:;" data-lui-paging-num="{% j %}">{% j %}</a></li>
													</div>
												</div>
											</div>
										$}
									}
									if(paging.marginRight){
										{$
											<div class="lui_paging_ellipsis_left">
												<div class="lui_paging_ellipsis_right">
													<div class="lui_paging_ellipsis_center">
														<li class="lui_paging_ellipsis"><span>...</span></li>
													</div>
												</div>
											</div>
											<div class="lui_paging_num_left">
												<div class="lui_paging_num_right">
													<div class="lui_paging_num_center">
														<li><a href="javascript:;" data-lui-paging-num="{% paging.totalPage %}">{% paging.totalPage %}</a></li>
													</div>
												</div>
											</div>
										$}
									}
								}            
								if (paging.hasNext) {
									{$
										<div class="lui_paging_next_left">
											<div class="lui_paging_next_right">
												<div class="lui_paging_next_center">
													<li class="lui_paging_next">
														<a href="javascript:;" data-lui-paging-num="{% paging.currentPage+1 %}">${lfn:message('sys-ui:ui.listview.paging.next') }
														</a>
													</li>
												</div>
											</div>
										</div>	
									$}
								}
								{$
									<div class="lui_paging_next_left">
										<div class="lui_paging_next_right">
											<div class="lui_paging_next_center">
												<li class="lui_paging_next"><a href="javascript:;" data-lui-paging-num="0">${lfn:message('sys-ui:ui.listview.paging.refresh') }</a>
												</li>
											</div>
										</div>
									</div>					
								$}
								{$<input type="hidden" data-lui-mark="paging.pageno" value="{%paging.currentPage%}"/>$}
								{$<input type="hidden" data-lui-mark="paging.amount" value="{%paging.pageSize%}"/>$}
{$								
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="lui_paging_foot_left">
                    <div class="lui_paging_foot_right">
                        <div class="lui_paging_foot_centre">
                        </div>
                    </div>
                </div>
            </div>
$}
