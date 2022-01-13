<!DOCTYPE html>
<html>
<head>
    <title>洗衣平台</title>
    <!-- import Vue before Element &ndash;&gt;-->
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
    <!-- import JavaScript &ndash;&gt;-->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- import CSS &ndash;&gt;-->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">

    <#--<script  src="webjars/jquery/3.5.1/jquery.min.js"> </script>-->

    <#--<%--引入jquery的在线包--%>-->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <meta charset="UTF-8">
</head>
<STYLE>
    body{
        background-image: url("/img/01.jpg");
    }
    .el-input{
        width: 206px;
    }
    .login{
        position: absolute;
        display: block;
        width: 666px;
        height:400px;
        z-index: 10001;
        box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);
        background-color: #fff;
        margin: 100px;
        margin-left: 500px;
        border-radius: 30px
    }
    .el-dialog{
        border-radius: 30px
    }
</STYLE>
<body>
<div id="app">
    <div class="login">
        <div style="width: 300px;">
            <p style="font-size: 20px;text-align: center">欢迎来到洗衣平台</p>
        </div>
        <div style="width: 300px;height: 200px;margin:auto;margin-top: 80px">
            <el-form ref="form" :rules="rules" label-width="80px" class="demo-ruleForm" :model="form" >
                <el-form-item label="账号" prop="userName">
                    <el-input prefix-icon="el-icon-user" v-model="form.userName" placeholder="请输入用户名"></el-input>
                </el-form-item>
                <el-form-item label="密码" prop="userPwd">
                    <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="form.userPwd" placeholder="请输入密码"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="onSubmit('form')">登录</el-button>
                    <el-button @click="dialogFormVisible = true">注册</el-button>
                </el-form-item>
            </el-form>
        </div>

        <el-dialog title="注册"
                   :visible.sync="dialogFormVisible"
                   width="30%"
                   center
                   class="registered">
            <el-form :rules="registrationRules" ref="registrationForm" label-width="80px" :model="registrationForm">
                <el-form-item label="账号" prop="userName">
                    <el-input prefix-icon="el-icon-user" v-model="registrationForm.userName" placeholder="请输入用户名"></el-input>
                </el-form-item>
                <el-form-item label="密码" prop="userPwd">
                    <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="registrationForm.userPwd" placeholder="请输入密码"></el-input>
                </el-form-item>
                <el-form-item label="确认密码" prop="userPwdAgain">
                    <el-input prefix-icon="el-icon-lock"  show-password auto-complete="off" v-model="registrationForm.userPwdAgain" placeholder="请输入密码"></el-input>
                </el-form-item>
                <el-form-item label="权限代码" prop="userPermissions">
                    <el-input prefix-icon="el-icon-s-custom" v-model="registrationForm.userPermissions" placeholder="请输入权限代码(可不填)"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary"  @click="Registration('registrationForm')">确 定</el-button>
                <el-button @click="dialogFormVisible = false">取 消</el-button>
            </div>
        </el-dialog>
    </div>


</div>
</body>
<script>
    new Vue({
        el: '#app',
        data: function() {
            /*登录*/
            var validatePass = (rule, value, callback) => {
                if (!value) {
                    return callback(new Error('密码不能为空'));
                }
            };
            var validateUser = (rule, value, callback) => {
                if (!value) {
                    return callback(new Error('账号不能为空'));
                }
            };

            /*注册*/
            var validatePwdAgainRegistration = (rule, value, callback) => {
                if (!value) {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.registrationForm.userPwd) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                dialogFormVisible: false,
                /*登录*/
                form:{},
                rules: {
                    userPwd: [
                        { validator: validatePass, trigger: 'blur' }
                    ],
                    userName: [
                        { validator: validateUser, trigger: 'blur' }
                    ],
                },

                /*注册*/
                registrationForm:{},
                registrationRules:{
                    userName:[
                        { required: true, message: '请输入账号', trigger: 'blur' },
                        { min: 5, max: 10, message: '长度在 6 到 10 个字符', trigger: 'blur' }
                    ],
                    userPwd:[
                        { required: true, message: '请输入密码', trigger: 'blur' },
                        { min: 6, max: 10, message: '长度在 6 到 10 个字符', trigger: 'blur'}
                    ],
                    userPwdAgain:[
                        {required: true,validator:validatePwdAgainRegistration,trigger:'blur'}
                    ]
                }
            }
        },
        methods:{
            /*注册*/
            Registration(registrationForm) {
                this.$refs[registrationForm].validate((valid) => {
                    if (valid) {
                        var _self = this;
                        var registrationForm = _self.registrationForm;
                        if (registrationForm.userName!=null&&registrationForm.userName!=''&&registrationForm.userPwd!=null&&registrationForm.userPwd!=''){
                            $.ajax({
                                url: "/laundry/registration",
                                type:'post',
                                dataType: "json",
                                data:registrationForm,
                                success:function (resp){
                                    if (resp){
                                        _self.$message({
                                            message: '注册成功',
                                            type: 'success'
                                        });
                                    }
                                },
                                error:function (){
                                    _self.$message.error('注册失败,账号已存在');
                                }
                            })
                        }else {

                        }
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            /*登录*/
            onSubmit:function (form1){
                var _self = this;
                var form = _self.form;
                if (form.userName!=null&&form.userName!=''&&form.userPwd!=null&&form.userPwd!=''){
                    $.ajax({
                        url: "/laundry/login",
                        type:'post',
                        dataType: "json",
                        data:form,
                        success:function (resp){
                            if (resp.userName==form.userName&&resp.userPwd==form.userPwd){

                                _self.$message({
                                    message: '登录成功',
                                    type: 'success'
                                });
                                if (resp.userPermissions==1){
                                    var f=document.createElement('form');
                                    f.style.display='none';
                                    f.action='/laundry/main';
                                    f.method='post';
                                    f.innerHTML='<input type="hidden" name="username" value="'+form.userName+'"/>';
                                    f.innerHTML+='<input type="hidden" name="password" value="'+form.userPwd+'"/>';
                                    document.body.appendChild(f);
                                    f.submit();
                                    // window.location = "/laundry/main?username="+form.userName+"&password="+form.userPwd;
                                }else {
                                    var f=document.createElement('form');
                                    f.style.display='none';
                                    f.action='/laundry/mainSystem';
                                    f.method='post';
                                    f.innerHTML='<input type="hidden" name="username" value="'+form.userName+'"/>';
                                    f.innerHTML+='<input type="hidden" name="password" value="'+form.userPwd+'"/>';
                                    document.body.appendChild(f);
                                    f.submit();
                                }
                            }
                        },
                        error:function (err){
                            _self.$message.error('登录失败,账号或密码不正确');
                        }
                    })
                }else {
                    this.$message.error('登录失败,账号或密码不能为空');
                    return false;
                }

            }

        },
        created:function (){

        }
    })
</script>
</html>