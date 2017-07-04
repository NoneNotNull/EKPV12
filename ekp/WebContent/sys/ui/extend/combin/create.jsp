<%@ page language="java" pageEncoding="UTF-8"%>

<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!--快捷按钮1 Begin-->
<div class="lui_list_create_frame">
    <div class="lui_list_create_header_l">
        <div class="lui_list_create_header_r">
            <div class="lui_list_create_header_c">
                <i class="lui_list_create_header_trig"></i>
            </div>
        </div>
    </div>
    <div class="lui_list_create_center_l">
        <div class="lui_list_create_center_r">
            <div class="lui_list_create_center_c">
                <div class="lui_list_create_wrapper">
                    <h1>${varParams.title}</h1>
	                <ui:dataview format="sys.ui.picMenu.module">
						<ui:source type="Static">
						${varParams.button}
						</ui:source>
						<ui:render ref="sys.ui.picMenu.module"/>
					</ui:dataview>
                    <div class="lui_list_create_wrapper_foot clr">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="lui_list_create_footer_l">
        <div class="lui_list_create_footer_r">
            <div class="lui_list_create_footer_c">
            </div>
        </div>
    </div>
</div>
