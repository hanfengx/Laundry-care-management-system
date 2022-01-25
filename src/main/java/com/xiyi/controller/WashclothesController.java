package com.xiyi.controller;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@RequestMapping("/washclothes/")
public class WashclothesController {
    @Autowired
    private WashclothesServiceImp washclothesServiceImp;

    /*查询活动列表*/
    @GetMapping("getActivity")
    public List<Activity> getActivity(){

        return washclothesServiceImp.getActivity();
    }

    /*根据活动id确定城市*/
    @GetMapping("getCity")
    public List<City> getCity(@RequestParam("actId") String actId){

        return washclothesServiceImp.getCity(actId);
    }

}
