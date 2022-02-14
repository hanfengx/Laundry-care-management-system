package com.xiyi.domain;

import lombok.Data;

import java.util.List;

@Data
public class ClothesType {

    private Integer cltId;

    private Integer value;

    private String cltName;

    private String label;

    private List<Clothes> children;

}
