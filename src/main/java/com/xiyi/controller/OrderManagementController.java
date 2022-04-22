package com.xiyi.controller;

import com.xiyi.domain.InsertOrder;
import com.xiyi.domain.Order;
import com.xiyi.service.Impservice.OrderManagementServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/management/")
public class OrderManagementController {

    @Autowired
    private OrderManagementServiceImp orderManagementServiceImp;

    //查询和初始化数据
    @GetMapping("getOrder")
    public List<InsertOrder> getOrder(@RequestParam(value = "userId",required = false,defaultValue = "") String userId,
                                      @RequestParam(value = "activity",required = false,defaultValue = "") String activity,
                                      @RequestParam(value = "state",required = false,defaultValue = "") String state,
                                      @RequestParam(value = "date",required = false,defaultValue = "") String date){


        return orderManagementServiceImp.getOrder(userId, activity, state, date);
    }
    //付款
    @GetMapping("pay")
    public Integer pay(@RequestParam("userId") String userId,
                       @RequestParam("sum") Double sum,
                       @RequestParam("loId") String loId){


        return orderManagementServiceImp.pay(userId, sum, loId);
    }

    //修改订单
    @PostMapping("revise")
    public Integer revise(@RequestParam("loId") String loId,
                          @RequestParam("orderCity[]") String[] orderCity,
                          @RequestParam("orderPlace") String orderPlace){


        return orderManagementServiceImp.revise(loId, orderCity, orderPlace);
    }

    //删除订单
    @GetMapping("deleteOrder")
    public Integer deleteOrder(@RequestParam("loId") String loId){

        return orderManagementServiceImp.deleteOrder(loId);
    }

    //管理员修改订单状态
    @GetMapping("updateState")
    public Integer updateState(@RequestParam("value") String value,
                               @RequestParam("id") String id){

        return orderManagementServiceImp.updateState(value, id);
    }

}
