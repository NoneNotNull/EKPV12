<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/portal/sys_portal_page/page.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="person.home">  
 <template:replace name="content">  
  <ui:panel toggle="false" layout="sys.ui.panel.default" height="240" scroll="false" id="p_c190b89274d669165363">
   <portal:widget file="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory_portlet.jsp"></portal:widget>
  </ui:panel> 
  <div style="height: 15px;"> 
  </div> 
  <table width="815" style="table-layout: fixed;" data-lui-type="lui/portal!VBox">
   <script type="text/config">{"column":1,"boxWidth":815,"boxStyle":""}</script> 
   <tbody> 
    <tr> 
     <td width="815" valign="top" data-lui-type="lui/portal!Container"><script type="text/config">{"columnProportion":"1","columnWidth":"815","hSpacing":null,"vSpacing":"15","columnStyle":"","columnLock":false}</script>  
      <ui:tabpanel height="240" scroll="false" layout="sys.ui.tabpanel.default" id="p_752bde8c282e56669dfd">
       <portal:portlet title="待阅" var-sortType="datetime" var-rowSize="10">
        <ui:dataview format="sys.ui.iframe">
         <ui:source ref="sys.notify.toview.source" var-sortType="datetime" var-rowSize="10"></ui:source>
         <ui:render ref="sys.ui.iframe.default" var-frameName=""></ui:render>
        </ui:dataview>
        <ui:operation href="/sys/notify?dataType=toview#cri.status1.q=fdType:2" name="{operation.more}" type="more" align="right"></ui:operation>
       </portal:portlet>
       <portal:portlet title="待处理" var-sortType="datetime" var-rowSize="10">
        <ui:dataview format="sys.ui.iframe">
         <ui:source ref="sys.notify.todo.source" var-sortType="datetime" var-rowSize="10"></ui:source>
         <ui:render ref="sys.ui.iframe.default" var-frameName=""></ui:render>
        </ui:dataview>
        <ui:operation href="/sys/notify?dataType=todo#cri.status1.q=fdType:13" name="{operation.more}" type="more" align="right"></ui:operation>
       </portal:portlet>
       <portal:portlet title="待阅" var-sortType="datetime" var-rowSize="10">
        <ui:dataview format="sys.ui.iframe">
         <ui:source ref="sys.notify.toview.source" var-sortType="datetime" var-rowSize="10"></ui:source>
         <ui:render ref="sys.ui.iframe.default" var-frameName=""></ui:render>
        </ui:dataview>
        <ui:operation href="/sys/notify?dataType=toview#cri.status1.q=fdType:2" name="{operation.more}" type="more" align="right"></ui:operation>
       </portal:portlet>
      </ui:tabpanel>  </td> 
    </tr> 
   </tbody> 
  </table>  
 </template:replace>  
</template:include>