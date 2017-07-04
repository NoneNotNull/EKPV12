<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<div class="lui_step_tabs_1">
		<div class="lui_step_tabs_1_titleL">
			<div class="lui_step_tabs_1_titleR">
				<div class="lui_step_tabs_1_titleM">
					<ul data-lui-mark="step.title">
$}
					for(var i=0;i<layout.parent.contents.length;i++){
{$				
						<li data-lui-index="{% i %}" $} if(i==0){{$ class="current" $}} {$>
							<div class="no"><span><a>{% i+1 %}</a></span></div>
							<div class="title">{% layout.parent.contents[i].title %}</div>
						</li>
$}
					}
{$
					</ul>
				</div>
			</div>
		</div>
		
		<div class="lui_step_tabs_1_contentL">
			<div class="lui_step_tabs_1_contentR">
				<div class="lui_step_tabs_1_contentM">
					<div>
						<div class="lui_step_sheet_wrapper mb20">
							<div class="lui_step_sheet_topL">
								<div class="lui_step_sheet_topR">
									<div class="lui_step_sheet_topC"></div>
								</div>
							</div>
							<div class="lui_step_sheet_centreL">
								<div class="lui_step_sheet_centreR">
									<div class="lui_step_sheet_centreC">
										<div class="lui_step_sheet_content">
											<div class="lui_step_sheet_c_table" data-lui-mark='step.contents'>
											</div>
											<div class="lui_step_buttons_wrapper">
												<div class="lui_step_buttons_wrapperL">
													<div class="lui_step_buttons_wrapperR">
														<div class="lui_step_buttons_wrapperC">
															<div class="lui_step_buttons_btnList">
																<input type="button" class="btn_step_cur"$} if(!layout.parent.hasPre()){ {$ style="display: none;" $} } {$ value="${lfn:message('sys-ui:ui.step.pre')}" data-lui-mark="step.pre"/>
																<input type="button" class="btn_step_cur"$} if(!layout.parent.hasNext()){ {$ style="display: none;" $} } {$value="${lfn:message('sys-ui:ui.step.next')}" data-lui-mark="step.next"/>
																<input type="button" class="btn_step_cur"$} if(!layout.parent.hasSubmit()){ {$ style="display: none;" $} } {$value="${lfn:message('sys-ui:ui.step.submit')}" data-lui-mark="step.submit"/>
															</div>
														</div>
													</div>
												</div>	
											</div>			
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
$}