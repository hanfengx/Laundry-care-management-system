package com.xiyi.controller;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import com.xiyi.service.Impservice.MainActivityServiceImp;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/washclothes/")
public class WashclothesController {
    @Autowired
    private WashclothesServiceImp washclothesServiceImp;

    @Autowired
    private MainActivityServiceImp mainActivityServiceImp;

    /*查询活动列表*/
    @GetMapping("getActivity")
    public List<Activity> getActivity(){

        return washclothesServiceImp.getActivity();
    }

    /*回显子节点城市*/
    @GetMapping("getChildCity")
    public List<Map<String, Object>> getChildCity(@RequestParam("cityId") String cityId){

        return washclothesServiceImp.getChildCity(cityId);
    }

    /*根据活动的大类型 回显衣服类型和价格*/
    @GetMapping("findAllClothesType")
    public List<ClothesType> findAllClothesType(@RequestParam("cloId") String cloId){

        return washclothesServiceImp.findAllClothesType(cloId);

    }
}
