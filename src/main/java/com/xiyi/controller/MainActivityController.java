package com.xiyi.controller;

import com.xiyi.common.PageResult;
import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.domain.ClothesType;
import com.xiyi.service.Impservice.MainActivityServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/main/")
public class MainActivityController {

    @Autowired
    MainActivityServiceImp mainActivityServiceImp;

    /*返回查询城市city*/
    @GetMapping("city")
    public List<Map<String, Object>> getCity(){

        return mainActivityServiceImp.getCity();
    }

    /*最新活动*/
    @GetMapping("activity")
    public PageResult allActivity(
            @RequestParam("pageSize") Integer pageSize,
            @RequestParam("pageNum") Integer pageNum,
            @RequestParam(value = "name",defaultValue = "",required = false) String actName,
            @RequestParam(value ="region[]",defaultValue = "",required = false) List<String> region,
            @RequestParam(value ="date[]",defaultValue = "",required = false) List<String> date,
            @RequestParam(value ="place[]",defaultValue = "",required = false) List<String> place,
            @RequestParam(value = "system",defaultValue = "0") Integer system){

        PageResult pageResult =  mainActivityServiceImp.allActivity(pageSize,pageNum,actName,region,date,place,system);
        return pageResult;
    }

    /*活动范围  衣服类型表*/
    @GetMapping("clothesType")
    public List<ClothesType> clothesType(){


        return mainActivityServiceImp.clothesType();
    }



}
