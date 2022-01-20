package com.xiyi.controller;

import com.xiyi.domain.Activity;
import com.xiyi.service.Impservice.WashclothesServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@RequestMapping("/washclothes")
public class WashclothesController {
    @Autowired
    private WashclothesServiceImp washclothesServiceImp;

    /*查询活动列表*/
    @GetMapping("/getActivity")
    public List<Activity> getActivity(){

        return washclothesServiceImp.getActivity();
    }

}
