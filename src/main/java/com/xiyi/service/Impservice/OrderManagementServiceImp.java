package com.xiyi.service.Impservice;

import com.xiyi.domain.InsertOrder;
import com.xiyi.domain.Order;

import java.util.List;

public interface OrderManagementServiceImp {

    public List<InsertOrder> getOrder(String userId,String activity,String state,String date);

    public Integer pay(String userId,Double sum,String loId);

    public Integer revise(String loId,String[] orderCity,String orderPlace);

    public Integer deleteOrder(String loId);

    public Integer updateState(String value,String id);

}
