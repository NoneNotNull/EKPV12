package com.landray.kmss.spi.service;

import java.util.List;

import com.landray.kmss.spi.query.CriteriaQuery;
import com.sunbor.web.tag.Page;

public interface QueryService {
	public abstract Page searchPage(CriteriaQuery query) throws Exception;

	public abstract long searchCount(CriteriaQuery query) throws Exception;

	public abstract List searchList(CriteriaQuery query) throws Exception;
}
