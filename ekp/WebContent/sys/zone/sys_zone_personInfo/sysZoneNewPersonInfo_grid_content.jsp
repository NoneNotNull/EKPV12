<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
{$
     <div class="content">
           <ul class="clrfix">
	           <li>
	                <a class="img" target="_blank"  href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}">
	                <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%grid['fdId']%}&size=m" />
      				 </a>
      				<p class="p1 textEllipsis">
                       <em>${ lfn:message('sys-zone:sysZonePerson.name') }：</em> <a title="{%grid['fdName']%}" class="author" target="_blank"  href="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%grid['fdId']%}">{%grid['fdName']%}</a>
                    </p>
                    <p class="p2 textEllipsis" >
                       <em >${ lfn:message('sys-zone:sysZonePerson.dept') }：</em><span title="{%grid['fdDept']%}">{%grid['fdDept']%}</span>
                    </p>
	            </li>
           </ul>
      </div>
			
$}
