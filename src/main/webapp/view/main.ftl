<html lang="zh-CN">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <title>洗衣平台</title>
    <meta charset="UTF-8">
    <#include "__ref_common_js.ftl" parse=true />
    <!-- import Vue before Element -->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <!-- import JavaScript -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <script src="https://unpkg.com/vue-router@2.0.0/dist/vue-router.js"></script>
    <#--<script src="/js/jquery.min.js"> </script>-->
</head>
<style>
    .el-header{
        background-color: #545c64;
        color: #333;
        text-align: center;
        line-height: 60px;
    }
    .el-footer {
        background-color: #B3C0D1;
        color: #333;
        text-align: center;
        line-height: 60px;
    }

    .el-aside {
        background-color: #D3DCE6;
        color: #333;
        text-align: center;
        line-height: 200px;
    }

    .el-main {
        background-color: #E9EEF3;
        color: #333;
        text-align: center;
        line-height: 160px;
    }

    body > .el-container {
        margin-bottom: 40px;
    }

    .el-container:nth-child(5) .el-aside,
    .el-container:nth-child(6) .el-aside {
        line-height: 260px;
    }

    .el-container:nth-child(7) .el-aside {
        line-height: 320px;
    }
    .el-avatar--circle {
        /*margin-left: 640px;*/
        margin-top: 9px;
    }
    .el-dropdown {
        margin-left: 840px;
    }
    .el-dropdown-link {
        cursor: pointer;
        color: #409EFF;
    }
    .el-icon-arrow-down {
        font-size: 12px;
    }
    .my-label {
        background: #E1F3D8;
    }

    .my-content {
        background: #FDE2E2;
    }
</style>
<body>
<div id="app">
    <el-container>
        <el-container>
            <el-container>
                <el-header>
                    <div style="float: left">
                        <el-menu
                                :default-active="activeIndex"
                                class="el-menu-demo"
                                mode="horizontal"
                                @select="handleSelect"
                                background-color="#545c64"
                                text-color="#fff"
                                active-text-color="#ffd04b">
                            <template v-for="(item, index) in title" >
                                <el-menu-item :index = "item.url" :key = "index">
                                    {{item.tit}}
                                </el-menu-item>
                            </template>

                        </el-menu>
                    </div>
                    <div>
                        <el-dropdown
                                @command="handleCommand"
                                trigger="click"
                                placement="bottom-start">
                            <span class="el-dropdown-link">
                               <el-avatar> {{name}} </el-avatar>
                            </span>
                            <el-dropdown-menu slot="dropdown">
                                <el-dropdown-item icon="el-icon-mobile-phone" command="information">修改密码</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-circle-plus-outline" command="joinUs">加入我们</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-chat-line-round" command="question">常见问题</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-switch-button" command="exitOut">退出账号</el-dropdown-item>
                            </el-dropdown-menu>
                        </el-dropdown>
                    </div>
                </el-header>
                <#--修改密码-->
                <el-dialog title="修改密码" :visible.sync="dialogFormVisible">
                    <el-form :rules="rules" ref="form" :model="form">
                        <el-form-item prop="password" label="原新密码" :label-width="formLabelWidth">
                            <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="form.password" placeholder="请输入密码"></el-input>
                        </el-form-item>
                        <el-form-item prop="newPassword" label="新密码" :label-width="formLabelWidth">
                            <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="form.newPassword" placeholder="请输入密码"></el-input>
                        </el-form-item>
                        <el-form-item prop="newAgainPassword" label="确认密码" :label-width="formLabelWidth">
                            <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="form.newAgainPassword" placeholder="请输入密码"></el-input>
                        </el-form-item>
                    </el-form>
                    <div slot="footer" class="dialog-footer">
                        <el-button @click="dialogFormVisible = false">取 消</el-button>
                        <el-button type="primary" @click="submit('form')">确 定</el-button>
                    </div>
                </el-dialog>
                <el-main>

                    <iframe id="iframe" width="1460px" height="750px"  frameBorder="0" scrolling="false" ></iframe>
                </el-main>
            </el-container>
        </el-container>
    </el-container>
</div>
</body>
<script>
    var _name='${userName}';
    var _pass ='${passWord}';
    var vm = new Vue({
        el: '#app',
        src:'',
        data: function() {
            var validatePwdAgainRegistration = (rule, value, callback) => {
                if (!value) {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.form.newPassword) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                formLabelWidth: '120px',
                form:{},
                rules: {
                    password: [
                        { required: true, message: '请输入密码', trigger: 'blur' },
                        { min: 6, max: 10, message: '长度在 6 到 10 个字符', trigger: 'blur'}
                    ],
                    newPassword: [
                        { required: true, message: '请输入新密码', trigger: 'blur' },
                        { min: 6, max: 10, message: '长度在 6 到 10 个字符', trigger: 'blur'}
                    ],
                    newAgainPassword: [
                        {required: true,validator:validatePwdAgainRegistration,trigger:'blur'}
                    ],
                },
                dialogFormVisible:false,
                title:[
                    {tit: '最新活动',url:'/laundry/activity'},
                    {tit: '我要洗衣',url:'/laundry/washClothes'},
                    {tit: '订单管理',url:'/laudry/orderManagement'},
                    {tit: '会员中心',url:'/laudry/membercentre'},
                    {tit: '常见问题',url:'/laudry/userQuestion'}
                ],
                name:_name,
                pass:_pass,
                visible: false,
                activeIndex: '/laundry/activity',

            }
        },
        methods: {
            //修改密码
            submit(form){
                var _self = this;
                _self.$refs[form].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url:'/laundry/changePassword',
                            type:'post',
                            dataType: 'json',
                            data:_self.form,
                            success:function (res) {
                                if (res.code==200){
                                    _self.$notify({
                                        title: '成功',
                                        message: res.msg,
                                        type: 'success'
                                    });
                                }else {
                                    _self.$notify({
                                        title: '失败',
                                        message: res.msg,
                                        type: 'warning'
                                    });
                                }
                                _self.dialogFormVisible = false;
                                _self.form={};
                            }
                        })
                    }else {
                        return false;
                    }
                });
            },
            //退出账号
            //右上角点击
            handleCommand(command){
                if (command=='exitOut'){
                    window.location.href = '/login';
                }else if (command == 'information'){
                    // this.$notify.error({
                    //     title: '错误',
                    //     message: '请联系管理员充值'
                    // });
                    this.dialogFormVisible = true;
                }else if (command == 'question'){
                    var iframe = document.getElementById("iframe");
                    iframe.src='/laudry/sysQuestion';
                } else {
                    this.$notify({
                        title: '失败',
                        message: '此功能暂不开放',
                        type: 'warning'
                    });
                }
            },
            /*初始化页面*/
            Initialize(){
                var iframe = document.getElementById("iframe")
                iframe.src='/laundry/activity';
            },

            handleSelect(key, keyPath) {
                console.log(key);
                console.log(keyPath);
                var iframe = document.getElementById("iframe")
                if (keyPath=='/laundry/washClothes'||keyPath=='/laudry/membercentre'||keyPath=='/laudry/userQuestion'){
                    iframe.style.height = '580';
                }else {
                    iframe.style.height = '750';
                }
                iframe.src=keyPath;

            },

        },
        created(){
            this.Initialize();
        }
    })
</script>
</html>