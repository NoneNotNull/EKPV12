<#list topPrevList as topPrev>
<#-- 当一级分类数多于5个的时候，不显示 -->
<#if (topPrev_index + 1 > 5)><#break></#if>
<dl class="dl_a">
<dt>
	<a href="javascript:void(0)" title="${topPrev.tempName}" onclick="docListPage('${topPrev.categoryId}')">${stringCutOf(topPrev.tempName, 15)}<span>${(topPrev.docAmount > 0) ? string("(${topPrev.docAmount})", "") }</span></a></dt>
<dd <#if topPrev_index+1==topPrevList?size> style="border-bottom:0px" </#if>>
	<#list topPrev.tempList as secondPrev>
	<a href="javascript:void(0)" title="${secondPrev.tempName}" onclick="docListPage('${secondPrev.categoryId}')">${stringCutOf(secondPrev.tempName, 8)}<span>${(secondPrev.docAmount > 0) ? string("(${secondPrev.docAmount})", "") }</span></a>
	</#list>
</dd></dl>
</#list>