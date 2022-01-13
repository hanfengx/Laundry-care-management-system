package com.xiyi.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.xiyi.common.PageResult;
import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import com.xiyi.mapper.MainActivityMapper;
import com.xiyi.service.Impservice.MainActivityServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class MainActivityService implements MainActivityServiceImp {

    @Autowired
    MainActivityMapper mainActivityMapper;

    /*获取所有最新活动*/
    @Override
    public PageResult allActivity(Integer pageSize, Integer pageNum, String actName, String region,List<String> date,List<String> place) {
        PageHelper.startPage(pageNum,pageSize);
        /*提取搜索框日期*/
        String startDate = "";
        String endDate = "";
        if (date.size()>0){
            startDate = date.get(0);
            endDate = date.get(1);
        }
        /*提取搜索框城市id*/
        int size = place.size();
        int placeId = 0;
        if (size!=0){
            placeId = Integer.parseInt(place.get(place.size()-1));
        }
        List<Activity> list = mainActivityMapper.allActivity(actName,region,startDate,endDate,placeId);
        PageInfo pageInfo = new PageInfo(list);
        PageResult pageResult = new PageResult(pageInfo.getPageNum(),pageInfo.getPageSize(), (int) pageInfo.getTotal(),list);


        return pageResult;
    }

    /*获取城市*/
    @Override
    public List<Map<String, Object>> getCity() {
        List<City> city = mainActivityMapper.getCity();

        //创建一个List集合来存放最终的树状结构数据
        List<Map<String, Object>> menuList = new ArrayList<>();
        for (City cc:city) {
            Map<String, Object> map = new HashMap<>();
            if (cc.getType().equals(1)){
                map.put("value",cc.getId());
                map.put("label",cc.getCityName());
                menuList.add(map);
                map.put("children", getChildren(city, cc.getId()));
            }
        }
        return menuList;
    }

    /**
     * 递归处理：通过id获取子级，查询子级下的子级
     *
     * @param data 数据库的原始数据
     * @param id   主id
     * @return  该id下得子级
     */
    public List<Map<String, Object>> getChildren(List<City> data, Integer id) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (data == null || data.size() == 0 || id == null) {
            return list;
        }
        for (City entity : data) {
            Map<String, Object> map = new HashMap<>();
            //如果本级id与数据的父id相同，就说明是子父级关系
            if (id.equals(entity.getPId())) {
                map.put("value", entity.getId());
                map.put("label", entity.getCityName());
                //查询子级下的子级
                map.put("children", getChildren(data, entity.getId()));
                list.add(map);
            }
        }
        return list;
    }

    @Override
    public List<ClothesType> clothesType() {

        return mainActivityMapper.clothesType();
    }
}
