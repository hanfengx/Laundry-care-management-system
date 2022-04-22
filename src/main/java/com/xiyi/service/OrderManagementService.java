package com.xiyi.service;

import com.xiyi.domain.InsertOrder;
import com.xiyi.domain.Login;
import com.xiyi.domain.Order;
import com.xiyi.domain.OrdersGoods;
import com.xiyi.mapper.OrderManagementMapper;
import com.xiyi.mapper.WashclothesMappers;
import com.xiyi.service.Impservice.OrderManagementServiceImp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OrderManagementService implements OrderManagementServiceImp {

    @Autowired
    private OrderManagementMapper orderManagementMapper;


    /*
    * 获取该用户所有订单
    * */
    @Override
    public List<InsertOrder> getOrder(String userId,String activity, String state, String date) {
        List<InsertOrder> insertOrder = orderManagementMapper.getOrder(userId, activity, state, date);
        for (InsertOrder order : insertOrder) {
            //截取cityId
            String loCityId = order.getLoCityId();
            String replace = loCityId.replace("[", "").replace("]","");
            String[] split = replace.split(",");
            String cityId = split[split.length-1];
            //查询cityName并存入工具类
            String cityName = orderManagementMapper.getCity(cityId);
            order.setCityName(cityName);

            //获取商品中文名
            for (OrdersGoods good : order.getOrdersGoods()) {
                String ogName = good.getOgName();
                String replaceGood = ogName.replace("[", "").replace("]", "");
                String[] splitGood = replaceGood.split(",");
                String goodsId = splitGood[splitGood.length-1];
                String goodsName = orderManagementMapper.getGoods(goodsId);
                good.setGoodName(goodsName);
            }

        }
        return insertOrder;
    }

    @Override
    public Integer pay(String userId, Double sum, String loId) {
        Map<String, Object> map = new HashMap<>();
        //查询余额是否能够支撑此次支付
        List<Login> balance = orderManagementMapper.balance(userId);
        int amount = Integer.parseInt(balance.get(0).getUserAmount());
        //余额大于此次支付
        if (amount>sum){
            orderManagementMapper.payUser(userId, sum);
            Integer pay = orderManagementMapper.pay(loId);
            orderManagementMapper.payVip(userId, sum*10);
            return pay;
        }

        return 0;
    }

    @Override
    public Integer revise(String loId, String[] orderCity, String orderPlace) {
        //处理城市数据
        String cityName = Arrays.toString(orderCity);


        return orderManagementMapper.revise(loId,cityName,orderPlace);
    }

    @Override
    public Integer deleteOrder(String loId) {
        Integer delOr = orderManagementMapper.deleteOrder(loId);
        Integer goods = null;
        if (delOr>0){
            goods = orderManagementMapper.deleteGoods(loId);
        }
        return goods;
    }

    @Override
    public Integer updateState(String value, String id) {
        return orderManagementMapper.updateState(value, id);
    }


}
