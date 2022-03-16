package com.xiyi.domain;


import lombok.Data;

@Data
public class ordersGoods {

    private Integer ogId;

    private Integer ogLoId;

    private String ogName;
    //商品中文名
    private String goodName;

    private String ogNum;

    private String ogPrice;

}
