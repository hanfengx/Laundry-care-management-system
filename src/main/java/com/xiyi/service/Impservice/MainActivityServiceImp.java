package com.xiyi.service.Impservice;

import com.xiyi.common.PageResult;
import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface MainActivityServiceImp {

    /*查询所有最新活动*/
    public PageResult allActivity(Integer pageSize, Integer pageNum, String actName, String region,List<String> date,List<String> place);

    /*显示所有城市*/
    public List<Map<String, Object>> getCity();

    /*衣服类型*/
    public List<ClothesType> clothesType();

}
