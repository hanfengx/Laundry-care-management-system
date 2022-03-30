package com.xiyi.mapper;

import com.xiyi.domain.GiftOrders;
import com.xiyi.domain.MemberStoredValue;
import com.xiyi.domain.MembershipGift;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MemberCentreMapper {


    public Integer insert(@Param("name") String name,
                          @Param("integral") String integral,
                          @Param("encode") String encode);

    public List<MembershipGift> queryImage(@Param("mgId") String mgId);


    public List<MembershipGift> query();

    public Integer deleteGift(@Param("mgId") String mgId);

    public MemberStoredValue queryIntegral(@Param("userName") String userName);

    //对用户积分进行下降
    public Integer updateUserIntegral(@Param("sum") Integer sum,
                                      @Param("userName") String userName);

    //生成礼品订单信息
    public Integer insertGiftOrders(@Param("userName") String userName,
                                   @Param("random") String random,
                                    @Param("mgId") String mgId);

    public List<GiftOrders> getGiftOrders(@Param("userName") String userName);
}
