<!DOCTYPE html>
<html lang="en">
<head>
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- import Vue before Element -->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <!-- import JavaScript -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <meta charset="UTF-8">
    <title>会员中心</title>
</head>
<style>
    .time {
        font-size: 13px;
        color: #999;
    }

    .bottom {
        margin-top: 13px;
        line-height: 12px;
    }

    .button {
        padding: 0;
        float: right;
    }

    .image {
        width: 100%;
        display: block;
    }

    .clearfix:before,
    .clearfix:after {
        display: table;
        content: "";
    }

    .clearfix:after {
        clear: both
    }
    .avatar-uploader .el-upload {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }
    .avatar-uploader .el-upload:hover {
        border-color: #409EFF;
    }
    .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 178px;
        height: 178px;
        line-height: 178px;
        text-align: center;
    }
    .avatar {
        width: 178px;
        height: 178px;
        display: block;
    }
    .el-button--mini, .el-button--mini.is-round {
        /*margin-left: 40px;*/
        float: right;
    }
</style>
<body>
<div id="app" style="display: none">
    <div>
        <div>
            <el-row >
                <el-col :span="22">
                    <span>您当前的积分为:<span style="color: #67C23A">{{userIntegral||'未知'}}</span></span>
                </el-col>
                <el-col :span="1">
                    <el-button type="success" @click="giftOrder" round>礼品订单</el-button>
                </el-col>
            </el-row>
        </div>
        <div v-loading="loading">
            <el-row >
                <el-col :span="4"  v-for="item in dataList">
                    <el-card shadow="hover"  style="margin-left: 20px;margin-top: 20px" :body-style="{ padding: '0px' }">
                        <img  :src="'/membercentre/queryImage?mgId='+item.mgId" class="image">
                        <div style="padding: 14px;">
                            <span>{{item.name}}</span>
                            <div class="bottom clearfix">
                                <time class="time">兑换积分:{{item.integral}}</time>
                                <el-button type="primary" size="mini" @click="exchangeGift(item.mgId,item.integral)" round>兑换</el-button>
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>
        <#--我的礼品订单-->
        <el-dialog title="礼品订单" :visible.sync="giftOrdersVisible">
            <el-table :data="gridData">
                <el-table-column align="center" label="序号" >
                    <template slot-scope="scope">
                        <span>{{scope.$index+1}}</span>
                    </template>
                </el-table-column>
                <el-table-column property="membershipGift.name" label="礼品名称" width="150"></el-table-column>
                <el-table-column property="goRandom" label="兑换码" width="200"></el-table-column>
                <el-table-column :formatter="changeState" property="goState" label="兑换状态" width="200"></el-table-column>
            </el-table>
        </el-dialog>
    </div>
</div>
</body>
<script>
    var userName = '${userName}';

    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                gridData:[],
                giftOrders:[],
                giftOrdersVisible:false,
                dataList:[],
                userIntegral : '',
                loading:true,
            }
        },
        methods:{
            //礼品订单
            giftOrder(){
                var _self = this;
                _self.giftOrdersVisible = true;
                $.ajax({
                    url:'/membercentre/getGiftOrders?user='+userName,
                    type:'get',
                    dataType:'json',
                    success:function (resp) {
                        _self.gridData = resp;
                    }
                })

            },
            //兑换礼品
            exchangeGift(mgId,integral){
              var _self = this;
              var userIntegral = parseInt(_self.userIntegral);
              var giftIntegral = parseInt(integral);
              if (userIntegral<giftIntegral){
                  _self.$notify({
                      title: '失败',
                      message: '积分不足！请消费后再兑换'
                  });
              }else {
                  var sum = userIntegral-giftIntegral;
                  $.ajax({
                      url:'/membercentre/exchangeGift?giftIntegral='+giftIntegral+'&user='+userName+'&sum='+sum+'&mgId='+mgId,
                      type:'get',
                      dataType:'json',
                      success:function (resp){
                            if (resp>0){
                                _self.$notify({
                                    title: '成功',
                                    message: '兑换成功！请前往兑换订单查看兑换码',
                                    type: 'success'
                                });

                                _self.loading=true;
                                _self.loadings();
                                _self.queryIntegral();
                            }else {
                                _self.$notify({
                                    title: '失败',
                                    message: '兑换失败！请联系管理员'
                                });
                            }

                      }
                  })
              }
            },
            //查询积分
            queryIntegral(){
                var _self = this;
                var user = userName;
                $.ajax({
                    url:'/membercentre/queryIntegral?user='+user,
                    type:'get',
                    dataType:'json',
                    success:function (resp) {
                        _self.userIntegral = resp.msvAmount;
                    }
                })

            },
            query(){
                var _self = this;
                $.ajax({
                    url:'/membercentre/query',
                    type:'get',
                    dataType: 'json',
                    success:function (resp){
                        _self.dataList = resp;
                        _self.loading=true;
                        _self.loadings();
                    }
                })
            },
            loadings(){
                $('#app').css('display','block');
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
            changeState(row){
                if (row.goState=='0'){
                    return '未兑换';
                }else if (row.goState == '1'){
                    return '已兑换'
                }else {
                    return '未知';
                }
            }
        },
        created(){
            this.loadings();
            this.query();
            this.queryIntegral();
        }
    })
</script>
</html>