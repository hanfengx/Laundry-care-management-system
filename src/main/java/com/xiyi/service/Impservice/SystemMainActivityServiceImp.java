package com.xiyi.service.Impservice;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface SystemMainActivityServiceImp {


    public Integer addAct(String actName, List<String> actPlace,List<String> actDate,String actRegion,String actContent,String userName);

    public Integer online(String actId);

    public Integer offline(String actId);

    public Integer delete(String actId);

    public List<Activity> queryOne(String actId);

    public Integer setAct(int actId,String actName, List<String> actPlace,List<String> actDate,String actRegion,String actContent,String userName,String actDiscount);


    public City getOneCity(String cityId);
}
