package com.xiyi.mapper;

import com.xiyi.domain.InsertOrder;
import com.xiyi.domain.Login;
import com.xiyi.domain.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrderManagementMapper {

    public String getCity(@Param("cityId") String cityId);

    public String getGoods(@Param("goodsId") String goodsId);

    public List<InsertOrder> getOrder(@Param("userId") String userId,
                                       @Param("activity") String activity,
                                       @Param("state") String state,
                                       @Param("date") String date);

    public Integer pay(@Param("loId") String loId);

    public Integer payUser(@Param("userId") String userId,
                           @Param("sum") Double sum);

    public List<Login>  balance(@Param("userId") String userId);

    public Integer payVip(@Param("userId") String userId,
                           @Param("sum") Double sum);

    public Integer revise(@Param("loId") String loId,
                          @Param("cityName") String cityName,
                          @Param("orderPlace") String orderPlace);

    public Integer deleteOrder(@Param("loId") String loId);


    public Integer deleteGoods(@Param("loId") String loId);


}
