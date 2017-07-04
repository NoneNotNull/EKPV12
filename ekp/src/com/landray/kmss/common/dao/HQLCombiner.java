package com.landray.kmss.common.dao;

import java.util.Set;

public class HQLCombiner implements IHQLBuilder {

	private IHQLBuilder hqlBuilder;
	
	private Set<IQueryHQLPart> hqlParts;

	public void setHqlBuilder(IHQLBuilder hqlBuilder) {
		this.hqlBuilder = hqlBuilder;
	}

	public void setHqlParts(Set<IQueryHQLPart> hqlParts) {
		this.hqlParts = hqlParts;
	}

	public HQLWrapper buildQueryHQL(HQLInfo hqlInfo) throws Exception {
		HQLInfo tmpInfo = null;
		
		if(hqlParts != null && !hqlParts.isEmpty()){
			tmpInfo = (HQLInfo) hqlInfo.clone();
			
			// 数据过滤
			for(IQueryHQLPart hqlPart : hqlParts) {
				hqlPart.buildHQLInfo(tmpInfo);
			}					
		}
		
		if(tmpInfo == null) {
			return hqlBuilder.buildQueryHQL(hqlInfo);	
		} 
		
		return hqlBuilder.buildQueryHQL(tmpInfo);
	}

}
