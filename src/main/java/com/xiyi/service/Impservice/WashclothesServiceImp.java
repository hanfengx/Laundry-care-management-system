package com.xiyi.service.Impservice;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;

import java.util.List;
import java.util.Map;

public interface WashclothesServiceImp {

    public List<Activity> getActivity();

    public List<Map<String, Object>> getChildCity(String cityId);

}
