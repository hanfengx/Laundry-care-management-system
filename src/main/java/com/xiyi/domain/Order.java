package com.xiyi.domain;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class Order {

    private Integer lo_id;

    private List<OderChild> dynamicItem;

    private  Integer[] place;

    private  String date;

    private String delivery;

    private Integer actId;

    private Integer num;

    private Integer[] clothesType;

    private String userName;

    private String address;

    private String note;



}
