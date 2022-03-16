package com.xiyi.domain;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Login {

    private Integer userId;

    private String userName;

    private String userPwd;

    private String userPermissions;

    private String userAmount;

}
