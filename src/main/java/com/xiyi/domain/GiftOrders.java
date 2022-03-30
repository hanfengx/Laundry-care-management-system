package com.xiyi.domain;

import lombok.Data;

/*
* @author hanfx
* @return 礼品订单表
* */
@Data
public class GiftOrders {

    private Integer id;

    private String goRandom;

    private String goUserId;

    private String goState;

    private MembershipGift membershipGift;

}
