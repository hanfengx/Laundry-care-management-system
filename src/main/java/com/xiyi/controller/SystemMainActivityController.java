package com.xiyi.controller;

import com.xiyi.domain.Activity;
import com.xiyi.domain.City;
import com.xiyi.service.Impservice.SystemMainActivityServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/main/system/")
public class SystemMainActivityController {

    @Autowired
    SystemMainActivityServiceImp systemMainActivityServiceImp;


    /*增加活动*/
    @PostMapping("addact")
    public Integer addAct(@RequestParam(value = "name",defaultValue = "",required = false) String actName,
                          @RequestParam(value = "place[]",defaultValue = "",required = false)List<String> actPlace,
                          @RequestParam(value = "date[]",defaultValue = "",required = false) List<String> actDate,
                          @RequestParam(value = "region",defaultValue = "",required = false) String actRegion,
                          @RequestParam(value = "actContent",defaultValue = "",required = false) String actContent,
                          @RequestParam(value = "username",defaultValue = "",required = false) String userName){

        return systemMainActivityServiceImp.addAct(actName,actPlace,actDate,actRegion,actContent,userName);
    }

    /*上线活动*/
    @GetMapping("online")
    public Integer online(@RequestParam("actId") String actId){

        return systemMainActivityServiceImp.online(actId);
    }

    /*下线活动*/
    @GetMapping("offline")
    public Integer offline(@RequestParam("actId") String actId){

        return systemMainActivityServiceImp.offline(actId);
    }

    /*删除活动*/
    @GetMapping("delete")
    public Integer delete(@RequestParam("actId") String actId){

        return systemMainActivityServiceImp.delete(actId);
    }

    /*修改活动  查询一个*/
    @GetMapping("queryOne")
    public List<Activity> queryOne(@RequestParam("actId") String actId){

        return systemMainActivityServiceImp.queryOne(actId);
    }

    /*修改活动*/
    @PostMapping("setact")
    public Integer setAct(@RequestParam("actId") int actId,
                          @RequestParam(value = "name",defaultValue = "",required = false) String actName,
                          @RequestParam(value = "place[]",defaultValue = "",required = false)List<String> actPlace,
                          @RequestParam(value = "date[]",defaultValue = "",required = false) List<String> actDate,
                          @RequestParam(value = "region",defaultValue = "",required = false) String actRegion,
                          @RequestParam(value = "actContent",defaultValue = "",required = false) String actContent,
                          @RequestParam(value = "username",defaultValue = "",required = false) String userName){
        return systemMainActivityServiceImp.setAct(actId,actName,actPlace,actDate,actRegion,actContent,userName);
    }

    /*获得一个城市的数组回显*/
    @GetMapping("getOneCity")
    public City getOneCity(@RequestParam("cityId") String cityId){

        return systemMainActivityServiceImp.getOneCity(cityId);
    }


}
