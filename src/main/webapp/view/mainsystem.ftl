<html lang="zh-CN">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <title>洗衣管理员平台</title>
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
        margin-left: 980px;
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
                    <div >
                        <el-dropdown
                                @command="handleCommand"
                                trigger="click"
                                placement="bottom-start">
                    <span class="el-dropdown-link">
                       <el-avatar> {{name}} </el-avatar>
                    </span>
                            <el-dropdown-menu slot="dropdown">
                                <el-dropdown-item icon="el-icon-mobile-phone" command="topUp">充值</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-circle-plus-outline" command="joinUs">加入我们</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-chat-line-round" command="question">常见问题</el-dropdown-item>
                                <el-dropdown-item icon="el-icon-switch-button" command="exitOut">退出账号</el-dropdown-item>
                            </el-dropdown-menu>
                        </el-dropdown>
                    </div>
                </el-header>
                <#--充值-->
                <el-dialog title="充值" :visible.sync="dialogFormVisible">
                    <el-form :rules="rules" ref="form" :model="form">
                        <el-form-item prop="name" label="用户名称" :label-width="formLabelWidth">
                            <el-select filterable  v-model="form.name" placeholder="请选择用户">
                                <el-option
                                        v-for="item in userList"
                                        :key="item.userId"
                                        :label="item.userName"
                                        :value="item.userId">
                                </el-option>
                            </el-select>

                        </el-form-item>
                        <el-form-item prop="num" label="充值金额" :label-width="formLabelWidth">
                            <el-input v-model.number="form.num" placeholder="请输入金额" autocomplete="off"></el-input>
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
            return {
                rules: {
                    name: [
                        {required: true, message: '请选择用户', trigger: 'blur'},
                    ],
                    num: [
                        {required: true, message: '请输入金额', trigger: 'blur'},
                        { type: 'number', message: '金额必须为数字值', trigger: 'blur'},
                    ],
                },
                userList:[],
                form:{},
                dialogFormVisible:false,
                formLabelWidth: '120px',
                title:[
                    {tit: '活动',url:'/laundry/systemActivity?username='+_name},
                    {tit: '订单',url:'/laudry/sysordermanagement'},
                    {tit: '衣服',url:'/laudry/sysClothesType'},
                    {tit: '会员',url:'/laudry/sysmembercentre'},
                    {tit: '问题',url:'/laudry/sysQuestion'},
                ],
                name:_name,
                pass:_pass,
                visible: false,
                activeIndex: '/laundry/systemActivity?username='+_name,

            }
        },
        methods: {
            //充值
            submit(form){
                var _self = this;
                _self.$refs[form].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url:'/moreAndMore/topUp',
                            type:'get',
                            dataType: 'json',
                            data:_self.form,
                            success:function (res) {
                                if (res>0){
                                    _self.$notify({
                                        title: '成功',
                                        message: '充值成功',
                                        type: 'success'
                                    });
                                }
                                _self.dialogFormVisible = false;
                                _self.form={};
                            }
                        })
                    } else {
                        return false;
                    }
                });
            },
            //右上角点击
            handleCommand(command){
                if (command=='exitOut'){
                    window.location.href = '/login';
                }else if (command == 'topUp'){
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
                var _self = this;
                var username = _self.name;
                var iframe = document.getElementById("iframe")
                iframe.style.height = '750';
                iframe.src=_self.activeIndex;
            },

            handleSelect(key, keyPath) {
                console.log(key);
                console.log(keyPath);
                var iframe = document.getElementById("iframe")
                if (keyPath=='/laudry/sysClothesType'||keyPath=='/laudry/sysmembercentre'||'/laudry/sysQuestion'){
                    iframe.style.height = '580';
                }else {
                    iframe.style.height = '750';
                }

                iframe.src=keyPath;

            },
            //初始化用户信息
            query(){
                var _self = this;
                $.ajax({
                    url:'/moreAndMore/InitializeUser',
                    type: 'get',
                    dataType:'json',
                    success:function (res){
                        _self.userList = res;
                    }
                })
            },

        },
        created(){
            this.Initialize();
            this.query();
        }
    })
</script>
</html>