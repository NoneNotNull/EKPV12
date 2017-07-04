<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/portal/sys_portal_page/page.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="template.default">  
 <template:replace name="body1">  
  <table width="980" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
   <script type="text/config">{"column":2,"boxWidth":980,"boxStyle":""}</script> 
   <tbody> 
    <tr> 
     <td width="724" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"3","columnWidth":"724","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script>  
      <table width="724" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":2,"boxWidth":724,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="355" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"355","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script>  
          <ui:panel toggle="false" layout="sys.ui.panel.default" height="240" scroll="false" id="p_cd2f45805de325fdad0d">
           <portal:portlet title="快捷方式" var-fdId="15ce8b22a7c422e2d05da394d4c85e77">
            <ui:dataview format="sys.ui.picMenu">
             <ui:source ref="sys.portal.shortcut.source" var-fdId="15ce8b22a7c422e2d05da394d4c85e77"></ui:source>
             <ui:render ref="sys.ui.picMenu.default" var-showMore="true" var-target="_blank"></ui:render>
            </ui:dataview>
           </portal:portlet>
          </ui:panel>  </td> 
         <td style="min-width:15px;" width="15"> </td> 
         <td width="354" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"354","hSpacing":"15","vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
        </tr> 
       </tbody> 
      </table> 
      <div style="height: 15px;"> 
      </div> 
      <table width="724" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":2,"boxWidth":724,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="355" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"355","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script>  
          <ui:tabpanel height="240" scroll="false" layout="sys.ui.tabpanel.default" id="p_45ddc6fe002739ed3ac8">
           <portal:portlet title="二级树菜单" var-fdId="15ce8b37ee2610004314b0241389a1eb">
            <ui:dataview format="sys.ui.treeMenu2">
             <ui:source ref="sys.portal.treeMenu2.source" var-fdId="15ce8b37ee2610004314b0241389a1eb"></ui:source>
             <ui:render ref="sys.ui.treeMenu2.default" var-target="_blank"></ui:render>
            </ui:dataview>
           </portal:portlet>
           <portal:portlet title="常用资料" var-rowsize="6" var-cateid="">
            <ui:dataview format="sys.ui.classic">
             <ui:source ref="km.comminfo.content.source" var-rowsize="6" var-cateid=""></ui:source>
             <ui:render ref="sys.ui.classic.default" var-highlight="" var-showCreator="true" var-showCreated="true" var-showCate="true" var-cateSize="0" var-newDay="0" var-target="_blank"></ui:render>
            </ui:dataview>
            <ui:operation href="/km/comminfo" name="{operation.more}" type="more" align="right"></ui:operation>
            <ui:operation href="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=add&amp;categoryId=${cateid}" name="{operation.create}" type="create" align="right"></ui:operation>
           </portal:portlet>
          </ui:tabpanel>  </td> 
         <td style="min-width:15px;" width="15"> </td> 
         <td width="354" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"354","hSpacing":"15","vSpacing":"15","columnStyle":"","columnLock":false}</script>  
          <ui:panel toggle="false" layout="sys.ui.panel.default" height="240" scroll="false" id="p_62a18c0390a0dae5af61">
           <portal:portlet title="常用链接" var-fdId="15ce8b2d1088218debcfa55458da8a60">
            <ui:dataview format="sys.ui.textMenu">
             <ui:source ref="sys.portal.linking.source" var-fdId="15ce8b2d1088218debcfa55458da8a60"></ui:source>
             <ui:render ref="sys.ui.textMenu.default" var-cols="1" var-target="_blank"></ui:render>
            </ui:dataview>
           </portal:portlet>
          </ui:panel>  </td> 
        </tr> 
       </tbody> 
      </table> 
      <div style="height: 15px;"> 
      </div> 
      <table width="724" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":2,"boxWidth":724,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="355" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"355","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
         <td style="min-width:15px;" width="15"> </td> 
         <td width="354" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"354","hSpacing":"15","vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
        </tr> 
       </tbody> 
      </table>  </td> 
     <td style="min-width:15px;" width="15"> </td> 
     <td width="241" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"241","hSpacing":"15","vSpacing":"15","columnStyle":"","columnLock":false}</script>  
      <table width="241" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":1,"boxWidth":241,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="241" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"241","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
        </tr> 
       </tbody> 
      </table> 
      <div style="height: 15px;"> 
      </div> 
      <table width="241" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":1,"boxWidth":241,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="241" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"241","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
        </tr> 
       </tbody> 
      </table> 
      <div style="height: 15px;"> 
      </div> 
      <table width="241" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
       <script type="text/config">{"column":1,"boxWidth":241,"boxStyle":""}</script> 
       <tbody> 
        <tr> 
         <td width="241" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"241","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
        </tr> 
       </tbody> 
      </table>  </td> 
    </tr> 
   </tbody> 
  </table> 
  <div style="height: 15px;"> 
  </div> 
  <table width="980" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
   <script type="text/config">{"column":1,"boxWidth":980,"boxStyle":""}</script> 
   <tbody> 
    <tr> 
     <td width="980" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"980","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script></td> 
    </tr> 
   </tbody> 
  </table>  
 </template:replace>  
</template:include>