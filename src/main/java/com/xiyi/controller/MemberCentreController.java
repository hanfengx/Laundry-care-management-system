package com.xiyi.controller;

import com.xiyi.domain.GiftOrders;
import com.xiyi.domain.MemberStoredValue;
import com.xiyi.domain.MembershipGift;
import com.xiyi.service.Impservice.MemberCentreServiceImp;
import com.xiyi.service.MemberCentreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

/*
* @author hanfx
* @return 会员中心
* */
@RestController
@RequestMapping("/membercentre/")
public class MemberCentreController {

    @Autowired
    private MemberCentreServiceImp memberCentreServiceImp;

    //图片导入
    @PostMapping("import")
    public void importImg(@RequestParam("file") MultipartFile file) throws Exception{
        if (!file.isEmpty()){
            BASE64Encoder encoder = new BASE64Encoder();
            //通过base64 转化图片
            String encode = encoder.encode(file.getBytes());
            memberCentreServiceImp.importImg(encode);
        }
    }

    //增加会员礼品
    @PostMapping("insert")
    public Integer insert(@RequestParam("name") String name,
                          @RequestParam("integral") String integral){



        return memberCentreServiceImp.insert(name, integral);
    }

    //查询图片
    @GetMapping("queryImage")
    public void queryImage(HttpServletResponse response,@RequestParam("mgId") String mgId){
        List<MembershipGift> queryImage = memberCentreServiceImp.queryImage(mgId);
        for (MembershipGift gift:queryImage) {
            if (gift.getImage()!=null){
                byte[] byteAry = (byte[]) gift.getImage();
                try {
                    String data = new String(byteAry, "UTF-8");
                    BASE64Decoder decoder = new BASE64Decoder();
                    byte[] bytes = decoder.decodeBuffer(data);
                    for (int i=0;i>bytes.length;i++){
                        if (bytes[i]<0){
                            bytes[i]+=256;
                        }
                    }
                    response.setContentType("image/jpg");
                    try {
                        ServletOutputStream out = response.getOutputStream();
                        out.write(bytes);
                        out.flush();
                        out.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    //查询除图片的数据
    @GetMapping("query")
    public List<MembershipGift> query(){
        return memberCentreServiceImp.query();
    }

    //删除礼品
    @GetMapping("deleteGift")
    public Integer deleteGift(@RequestParam("mgId") String mgId){
       return memberCentreServiceImp.deleteGift(mgId);
    }

    //查询个人积分
    @GetMapping("queryIntegral")
    public MemberStoredValue queryIntegral(@RequestParam("user") String userName){

        return memberCentreServiceImp.queryIntegral(userName);
    }

    //兑换奖品  兑换成功生成唯一兑换码  用户名
    @GetMapping("exchangeGift")
    public Integer exchangeGift(@RequestParam("user") String userName,
                                @RequestParam("giftIntegral") Integer giftIntegral,
                                @RequestParam("sum") Integer sum,
                                @RequestParam("mgId") String mgId){


        return memberCentreServiceImp.exchangeGift(userName,giftIntegral,sum,mgId);
    }

    //查看奖品订单
    @GetMapping("getGiftOrders")
    public List<GiftOrders> getGiftOrders(@RequestParam("user") String userName){

        return memberCentreServiceImp.getGiftOrders(userName);
    }


    //管理员根据礼品码查询用户的礼品
    @GetMapping("queryGift")
    public List<GiftOrders> queryGift(@RequestParam("goRandom") String goRandom){

        return memberCentreServiceImp.queryGift(goRandom);
    }

    //兑换礼品
    @GetMapping("cashGift")
    public Integer cashGift(@RequestParam("id") String id){

        return memberCentreServiceImp.cashGift(id);
    }


}
