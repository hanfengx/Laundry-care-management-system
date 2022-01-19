package com.xiyi.domain;

import lombok.Data;

@Data
public class City {

    private Integer id;

    private Integer pId;

    private String cityName;

    private Integer type;

    private Integer grandpaId;

    private String grandpaName;

    private Integer parentId;

    private String parentName;

    private Integer childId;

    private  String childName;


}
