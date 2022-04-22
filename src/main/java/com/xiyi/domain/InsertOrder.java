package com.xiyi.domain;


import lombok.Data;

import java.util.List;

@Data
public class InsertOrder {

    private Integer loId;

    private String loUserId;

    private String loDate;

    private Integer loActId;

    private String loCityId;

    //回显城市名字
    private String cityName;

    //活动城市
    private String actCityId;

    private String loAddress;

    private Integer loOrderAmount;

    private Double fianlMoney;

    private String loState;

    private String loNote;

    private String loDelivery;

    private Activity activity;

    private List<OrdersGoods> ordersGoods;





}
