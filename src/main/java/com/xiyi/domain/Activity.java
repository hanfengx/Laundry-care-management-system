package com.xiyi.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class Activity {

    private Integer actId;

    private String actName;

    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date actCreateDate;

    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date actEndDate;

    private String actOriginator;

    private String actDiscount;

    private String actContent;

    private String actPlace;

    private String actScope;

    private String actState;

    private ClothesType clothesType;

    private City city;



}
