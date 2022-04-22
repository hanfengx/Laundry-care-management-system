# 欢迎来到洗衣毕业设计

## 	一.请不要随意提交代码

## 	二.无私有库  直接maven下载启动

## 	三.ssm项目需要tomcat	

## 四.数据库导入

### 	1.jdbc.properties文件

```properties
jdbc.url=jdbc:mysql://localhost:3307/xiyi?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
jdbc.driver=com.mysql.jdbc.Driver
jdbc.username=root
jdbc.password=123456
```

### 	2.数据库表脚本

```mysql
-- xiyi.activity definition

CREATE TABLE `activity` (
  `act_id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `act_name` varchar(100) NOT NULL COMMENT '活动名称',
  `act_createdate` date NOT NULL COMMENT '活动开始时间',
  `act_enddate` date NOT NULL COMMENT '活动结束时间',
  `act_originator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动发起人',
  `act_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '活动内容',
  `act_place` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动地点',
  `act_scope` varchar(100) NOT NULL COMMENT '活动范围',
  `act_state` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态  0新增或修改  1上线    2下线',
  `act_discount` varchar(100) DEFAULT NULL COMMENT '折扣',
  PRIMARY KEY (`act_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='活动表';

-- xiyi.city definition

CREATE TABLE `city` (
  `id` int NOT NULL DEFAULT '0' COMMENT 'id',
  `pid` int DEFAULT NULL COMMENT '父子id',
  `cityname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '城市名',
  `cy_type` int DEFAULT NULL COMMENT '城市类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='城市表';

-- xiyi.clothes definition

CREATE TABLE `clothes` (
  `clo_id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `clo_typeid` int NOT NULL COMMENT '衣服类型id',
  `clo_name` varchar(50) NOT NULL COMMENT '衣服具体名字',
  `clo_price` varchar(20) NOT NULL COMMENT '衣服价格',
  `clo_category` varchar(5) NOT NULL DEFAULT '2' COMMENT '类别 2小类',
  PRIMARY KEY (`clo_id`),
  KEY `clothes_FK` (`clo_typeid`),
  CONSTRAINT `clothes_FK` FOREIGN KEY (`clo_typeid`) REFERENCES `clothes_type` (`clt_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='衣服类型详细表';

-- xiyi.clothes_type definition

CREATE TABLE `clothes_type` (
  `clt_id` int NOT NULL AUTO_INCREMENT COMMENT '衣服类型id',
  `clt_name` varchar(50) NOT NULL COMMENT '衣服类型名',
  `clt_category` varchar(5) NOT NULL DEFAULT '1' COMMENT '识别类别  1大类 ',
  PRIMARY KEY (`clt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='衣服类型表';

-- xiyi.gift_orders definition

CREATE TABLE `gift_orders` (
  `go_id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `go_user_id` varchar(100) NOT NULL COMMENT '兑换用户id',
  `go_random` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '兑换码',
  `go_mg_id` varchar(100) NOT NULL COMMENT '礼品id',
  `go_state` varchar(5) DEFAULT NULL COMMENT '兑换状态  0未兑换  1已兑换',
  PRIMARY KEY (`go_id`),
  UNIQUE KEY `gift_orders_un` (`go_random`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='礼品订单表';

-- xiyi.laundry_orders definition

CREATE TABLE `laundry_orders` (
  `lo_id` int NOT NULL AUTO_INCREMENT COMMENT '订单id   主键',
  `lo_user_id` varchar(50) NOT NULL COMMENT '订单用户id   外键',
  `lo_date` date NOT NULL COMMENT '订单时间',
  `lo_act_id` int DEFAULT NULL COMMENT '参加活动id   可以为空  外键',
  `lo_city_id` varchar(50) NOT NULL COMMENT '城市id  外键',
  `lo_address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `lo_order_amount` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单金额',
  `lo_state` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单状态 0未支付  1已支付  2洗衣中 3已完成',
  `lo_note` varchar(100) DEFAULT NULL COMMENT '备注',
  `lo_delivery` varchar(100) DEFAULT NULL COMMENT '配送类型  true及时配送  false延迟配送',
  PRIMARY KEY (`lo_id`),
  KEY `newtable_FK_1` (`lo_act_id`),
  KEY `newtable_FK` (`lo_user_id`),
  KEY `newtable_FK_2` (`lo_city_id`),
  CONSTRAINT `newtable_FK_1` FOREIGN KEY (`lo_act_id`) REFERENCES `activity` (`act_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- xiyi.login definition

CREATE TABLE `login` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(30) NOT NULL COMMENT '用户名',
  `user_pwd` varchar(30) NOT NULL COMMENT '密码',
  `user_permissions` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限 0普通 1管理员',
  `user_amount` int DEFAULT '0' COMMENT '用户余额',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- xiyi.member_stored_value definition

CREATE TABLE `member_stored_value` (
  `msv_id` int NOT NULL AUTO_INCREMENT COMMENT '会员id',
  `msv_amount` int DEFAULT '0' COMMENT '积分数量',
  `msv_user_id` varchar(100) DEFAULT NULL COMMENT '用户名',
  PRIMARY KEY (`msv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员储值表';

-- xiyi.membership_gift definition

CREATE TABLE `membership_gift` (
  `mg_id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mg_name` varchar(100) NOT NULL COMMENT '礼品名称',
  `mg_integral` varchar(100) NOT NULL COMMENT '所需积分',
  `mg_img` longblob COMMENT '图片地址',
  PRIMARY KEY (`mg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员礼品表';

-- xiyi.orders_goods definition

CREATE TABLE `orders_goods` (
  `og_id` int NOT NULL AUTO_INCREMENT COMMENT '订单商品编号',
  `og_lo_id` int NOT NULL COMMENT '订单id',
  `og_name` varchar(100) NOT NULL COMMENT '商品名',
  `og_num` varchar(100) DEFAULT NULL COMMENT '商品数量',
  `og_price` varchar(100) DEFAULT NULL COMMENT '商品价格',
  PRIMARY KEY (`og_id`),
  KEY `orders_goods_FK` (`og_lo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单商品表';

-- xiyi.questions_common definition

CREATE TABLE `questions_common` (
  `qcn_id` int NOT NULL AUTO_INCREMENT COMMENT '问题id',
  `qcn_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提出问题',
  `qcn_ask` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '回答问题',
  PRIMARY KEY (`qcn_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='常见问题表';

-- xiyi.questions_common_like definition

CREATE TABLE `questions_common_like` (
  `qcl_id` int NOT NULL AUTO_INCREMENT COMMENT '问题点赞id',
  `qcn_id` int NOT NULL COMMENT '问题id',
  `is_like` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '喜欢',
  `not_like` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '不喜欢',
  PRIMARY KEY (`qcl_id`),
  KEY `questions_common_like_FK` (`qcn_id`),
  CONSTRAINT `questions_common_like_FK` FOREIGN KEY (`qcn_id`) REFERENCES `questions_common` (`qcn_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='问题点赞表';
```



以上为构建表脚本，创建者hanfengx。
