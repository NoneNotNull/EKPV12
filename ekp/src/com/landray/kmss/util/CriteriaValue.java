package com.landray.kmss.util;

import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

public class CriteriaValue implements Map<String, String[]> {
	private static final String prefix = "q.";
	private Map<String, String[]> map = new HashMap<String, String[]>();

	public CriteriaValue(HttpServletRequest request) {
		Enumeration enume = request.getParameterNames();
		while (enume.hasMoreElements()) {
			String name = (String) enume.nextElement();
			if (name != null && name.trim().startsWith(prefix)) {
				map.put(name.trim().substring(prefix.length()),
						request.getParameterValues(name));
			}
		}
	}

	public void clear() {
		this.map.clear();
	}

	public boolean containsKey(Object key) {
		return map.containsKey(key);
	}

	public boolean containsValue(Object value) {
		return map.containsValue(value);
	}

	public Set<Entry<String, String[]>> entrySet() {
		return map.entrySet();
	}

	public String poll(String key) {
		String[] v = map.get(key);
		if (v != null && v.length > 0) {
			map.remove(key);
			return v[0];
		} else {
			return null;
		}
	}

	public String[] polls(String key) {
		String[] v = map.get(key);
		if (v != null) {
			map.remove(key);
			return v;
		} else {
			return null;
		}
	}

	public String[] get(Object key) {
		return map.get(key);
	}

	public boolean isEmpty() {
		return map.isEmpty();
	}

	public Set<String> keySet() {
		return map.keySet();
	}

	public String[] put(String key, String[] value) {
		return map.put(key, value);
	}

	public void putAll(Map<? extends String, ? extends String[]> m) {
		map.putAll(m);
	}

	public String[] remove(Object key) {
		return map.remove(key);
	}

	public int size() {
		return map.size();
	}

	public Collection<String[]> values() {
		return map.values();
	}

}
