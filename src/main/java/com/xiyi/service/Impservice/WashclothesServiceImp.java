package com.xiyi.service.Impservice;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;

import java.util.List;

public interface WashclothesServiceImp {

    public List<Activity> getActivity();

    public List<City> getCity(String actId);
}
