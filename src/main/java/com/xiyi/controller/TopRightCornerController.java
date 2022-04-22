package com.xiyi.controller;

import com.xiyi.domain.Login;
import com.xiyi.service.Impservice.TopRightCornerServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/*
* @author hanfx
* 右上角功能
* */
@RestController
@RequestMapping("/moreAndMore/")
public class TopRightCornerController {

    @Autowired
    private TopRightCornerServiceImp topRightCornerServiceImp;


    //初始化用户
    @GetMapping("InitializeUser")
    public List<Login> InitializeUser(){

        return topRightCornerServiceImp.InitializeUser();
    }

    //充值用户
    @GetMapping("topUp")
    public Integer topUp(@RequestParam("name") String userId,
                         @RequestParam("num") String amount){


        return topRightCornerServiceImp.topUp(userId,amount);
    }


}
