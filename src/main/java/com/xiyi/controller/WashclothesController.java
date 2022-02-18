package com.xiyi.controller;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import com.xiyi.domain.Order;
import com.xiyi.service.Impservice.MainActivityServiceImp;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/*
* @date:2022/2/16
* @name:hanfx
* */
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
    @GetMapping("findActivityClothesType")
    public List<ClothesType> findActivityClothesType(@RequestParam("cloId") String cloId){

        return washclothesServiceImp.findActivityClothesType(cloId);

    }

    /*不选择活动 回显衣服类型和价格*/
    @GetMapping("findAllClothesType")
    public List<ClothesType> findAllClothesType(){

        return washclothesServiceImp.findAllClothesType();

    }

    /*
    * 新增订单
    * */
    @PostMapping("newOrders")
    @ResponseBody
    public Integer newOrders(@RequestBody Order oder){

        return washclothesServiceImp.newOrders(oder);
    }


}
