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
        float: right;
    }
</style>
<body>
<div id="app" style="display: none">
    <div>
        <div>
            <el-row align="middle" type="flex">
                <el-col :span="20">
                    <span>您好，尊敬的:<span style="color: #67C23A">管理员</span></span>
                </el-col>
                <el-col :span="2">
                    <el-button type="success" @click="giftFormVisible = true" round>添加礼品</el-button>
                </el-col>
                <el-col :span="1">
                    <el-button type="primary" @click="cashGiftVisible = true" round>兑换礼品</el-button>
                </el-col>
            </el-row>
        </div>
        <div v-loading="loading">
            <el-row >
                <el-col :span="4"  v-for="item in dataList">
                    <el-card shadow="hover"  style="margin-left: 20px;margin-top: 20px" :body-style="{ padding: '0px' }">
                        <img  :src="'/membercentre/queryImage?mgId='+item.mgId" style="height: 220px" class="image">
                        <div style="padding: 14px;">
                            <span>{{item.name}}</span>
                            <div class="bottom clearfix">
                                <time class="time">兑换积分:{{item.integral}}</time>
                                <el-button type="danger" size="mini" @click="deleteGift(item.mgId)" round>删除</el-button>
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>
        <!-- Form -->
        <el-dialog title="新增礼品" :visible.sync="giftFormVisible">
            <el-form :inline="true" ref="form" :rules="rules" :model="form">
                <el-row>
                    <el-form-item  prop="name" label="礼品名称" label-width="120">
                        <el-col :span="15">
                            <el-input v-model="form.name" autocomplete="off"></el-input>
                        </el-col>
                    </el-form-item>
                    <el-form-item
                            :rules="[
                              { required: true, message: '积分不能为空'},
                              { type: 'number', message: '积分必须为数字值'}
                            ]"
                            prop="integral"
                            label="礼品积分"
                            label-width="120">
                        <el-col :span="15">
                            <el-input type="integral" v-model.number="form.integral" autocomplete="off"></el-input>
                        </el-col>
                    </el-form-item>
                    <el-form-item  prop="file" label="礼品图片" label-width="120">
                        <el-col :span="25">
                            <el-upload
                                    class="upload-demo"
                                    action="/membercentre/import"
                                    :limit="1"
                                    ref="upload"
                                    :on-remove="handleRemove"
                                    :on-exceed="handleExceed"
                                    :file-list="fileList"
                                    :before-upload="beforeAvatarUpload"
                                    list-type="picture">
                                <el-button size="small" type="primary">点击上传</el-button>
                                <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div>
                            </el-upload>
                        </el-col>
                    </el-form-item>
                </el-row>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="giftFormVisible = false">取 消</el-button>
                <el-button type="primary" @click="onSubmit(form)">确 定</el-button>
            </div>
        </el-dialog>

        <#--兑换礼品-->
        <el-dialog title="查询礼品" :visible.sync="cashGiftVisible">
            <el-form :inline="true" ref="formGift" :model="formGift" label-width="80px">
                <el-form-item label="兑换码">
                    <el-input v-model="formGift.goRandom" placeholder="请输入兑换码"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="queryGift(formGift)">查询</el-button>
                </el-form-item>
            </el-form>
            <div v-show="gridDataType=='1'">
                <el-table :data="gridData">
                    <el-table-column width="100" align="center" label="序号" >
                        <template slot-scope="scope">
                            <span>{{scope.$index+1}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column property="membershipGift.name" label="礼品名称" width="100"></el-table-column>
                    <el-table-column property="goUserId" label="兑换用户" width="100"></el-table-column>
                    <el-table-column :formatter="changeState" property="goState" label="兑换状态" width="100"></el-table-column>
                    <el-table-column  label="操作" width="100">
                        <template slot-scope="scope">
                            <el-button :disabled="scope.row.goState=='1'?true:false" @click="handleClick(scope.row)" type="text">兑换</el-button>
                        </template>
                    </el-table-column>

                </el-table>
            </div>

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
                cashGiftVisible:false,
                gridDataType:'0',
                gridData:[],
                dataList:[],
                userIntegral : '',
                giftFormVisible:false,
                loading:true,
                form: {},
                formGift:{},
                fileList: [],
                rules:{
                    name:[{required: true, message: '请输入礼品名称', trigger: 'blur'}],
                    file:[{required: true, message: '请添加图片'}],
                }
            }
        },
        methods:{
            //兑换礼品
            handleClick(data){
                var _self = this;
                var id = data.id;
                $.ajax({
                    url:'/membercentre/cashGift?id='+id,
                    type:'get',
                    dataType:'json',
                    success:function (resp) {
                        if (resp>0){
                            _self.$notify({
                                title: '成功',
                                message: '兑换成功！',
                                type: 'success'
                            });
                            _self.formGift = {};
                            _self.gridData = [];
                            _self.cashGiftVisible = false;
                            _self.loading=true;
                            _self.loadings();
                        }
                    }
                })
            },
            //查询兑换的礼品
            queryGift(form){
                var _self = this;
                $.ajax({
                    url:'/membercentre/queryGift',
                    type:'get',
                    dataType:'json',
                    data:form,
                    success:function (resp) {
                        _self.gridData = resp;
                        _self.gridDataType = '1';
                    }
                })

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

            //删除
            deleteGift(mgId) {
                var _self = this;
                _self.$confirm('此操作将永久删除该礼品, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    $.ajax({
                        url:'/membercentre/deleteGift?mgId='+mgId,
                        type:'get',
                        dataType:'json',
                        success:function (resp) {
                            if (resp>0){
                                _self.$notify({
                                    title: '成功',
                                    message: '删除成功！',
                                    type: 'success'
                                });
                                _self.loading=true;
                                _self.loadings();
                                _self.query();
                                _self.giftFormVisible = false;
                            }else {
                                _self.$notify.error({
                                    title: '错误',
                                    message: '删除失败！'
                                });
                            }
                        }
                    })
                }).catch(() => {
                    _self.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            //提交
            onSubmit(form) {
                var _self = this;
                $.ajax({
                    url : '/membercentre/insert',
                    type : 'post',
                    dataType: 'json',
                    data : form,
                    success:function (resp) {
                        if (resp>0){
                            _self.$notify({
                                title: '成功',
                                message: '新增成功！',
                                type: 'success'
                            });
                        }else {
                            _self.$notify.error({
                                title: '错误',
                                message: '新增失败！'
                            });
                        }
                        _self.loading=true;
                        _self.query();
                        _self.loadings();
                        _self.giftFormVisible = false;
                        _self.form = {};
                    }
                })
            },
            handleRemove(file, fileList) {
                console.log(file, fileList);
            },
            handleExceed(files, fileList) {
                this.$message.warning('当前限制选择 1 个文件');
            },
            beforeAvatarUpload(file) {
                const isJPG = file.type === 'image/jpeg';
                const isLt2M = file.size / 1024 / 1024 < 2;

                if (!isJPG) {
                    this.$message.error('上传礼品图片只能是 JPG 格式!');
                }
                if (!isLt2M) {
                    this.$message.error('上传礼品图片大小不能超过 2MB!');
                }
                return isJPG && isLt2M;
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