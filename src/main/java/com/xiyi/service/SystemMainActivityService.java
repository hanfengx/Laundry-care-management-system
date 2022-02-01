package com.xiyi.service;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.mapper.SystemMainActivityMapper;
import com.xiyi.service.Impservice.SystemMainActivityServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SystemMainActivityService implements SystemMainActivityServiceImp {

    @Autowired
    SystemMainActivityMapper systemMainActivityMapper;

    @Override
    public Integer addAct(String actName, List<String> actPlace, List<String> actDate, String actRegion, String actContent,String userName) {
        /*过滤添加的数据*/
        /*提取搜索框日期*/
        String startDate = "";
        String endDate = "";
        if (actDate.size()>0){
            startDate = actDate.get(0);
            endDate = actDate.get(1);
        }
        /*提取搜索框城市id*/
        int size = actPlace.size();
        int placeId = 0;
        if (size!=0){
            placeId = Integer.parseInt(actPlace.get(actPlace.size()-1));
        }


        return systemMainActivityMapper.addAct(actName,startDate,endDate,placeId,actRegion,actContent,userName);
    }

    @Override
    public Integer online(String actId) {
        return systemMainActivityMapper.online(actId);
    }

    @Override
    public Integer offline(String actId) {
        return systemMainActivityMapper.offline(actId);
    }

    @Override
    public Integer delete(String actId) {
        return systemMainActivityMapper.delete(actId);
    }

    @Override
    public List<Activity> queryOne(String actId) {
        return systemMainActivityMapper.queryOne(actId);
    }

    @Override
    public Integer setAct(int actId, String actName, List<String> actPlace, List<String> actDate, String actRegion, String actContent, String userName,String actDiscount) {
        /*过滤添加的数据*/
        /*提取搜索框日期*/
        String startDate = "";
        String endDate = "";
        if (actDate.size()>0){
            startDate = actDate.get(0);
            endDate = actDate.get(1);
        }
        /*提取搜索框城市id*/
        int size = actPlace.size();
        int placeId = 0;
        if (size!=0){
            placeId = Integer.parseInt(actPlace.get(actPlace.size()-1));
        }

        return systemMainActivityMapper.setAct(actId,actName,startDate,endDate,placeId,actRegion,actContent,userName,actDiscount);
    }

    @Override
    public City getOneCity(String cityId) {
        City oneCity = systemMainActivityMapper.getOneCity(cityId);
        return systemMainActivityMapper.getOneCity(cityId);
    }
}
