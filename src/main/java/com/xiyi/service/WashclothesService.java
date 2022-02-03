package com.xiyi.service;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import com.xiyi.mapper.MainActivityMapper;
import com.xiyi.mapper.WashclothesMapper;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class WashclothesService implements WashclothesServiceImp {
    @Autowired
    private WashclothesMapper washclothesMapper;

    @Autowired
    MainActivityMapper mainActivityMapper;

    @Override
    public List<Activity> getActivity() {
        return washclothesMapper.getActivity();
    }

    @Override
    public List<Map<String, Object>> getChildCity(String cityId) {
        List<City> city = mainActivityMapper.getCity();
        //创建一个List集合来存放最终的树状结构数据
        List<Map<String, Object>> menuList = new ArrayList<>();
        for (City cc:city) {
            Map<String, Object> map = new HashMap<>();
            if (cc.getId().equals(Integer.parseInt(cityId))){
                map.put("value",cc.getId());
                map.put("label",cc.getCityName());
                menuList.add(map);
                map.put("children", getChildren(city, cc.getId()));
            }
        }
        return menuList;
    }

    @Override
    public List<ClothesType> findAllClothesType(String cloId) {
        return washclothesMapper.findAllClothesType(cloId);
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


}
