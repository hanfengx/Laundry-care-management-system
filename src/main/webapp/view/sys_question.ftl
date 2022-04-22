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
    <title>问题页面</title>
</head>
<style>
    .el-row {
        margin-bottom: 20px;
    }
    last-child {
        margin-bottom: 0;
    }
    .el-col {
        border-radius: 4px;
    }
    .bg-purple-dark {
        background: #99a9bf;
    }
    .bg-purple {
        background: #d3dce6;
    }
    .bg-purple-light {
        background: #e5e9f2;
    }
    .grid-content {
        border-radius: 4px;
        min-height: 36px;
    }
    .row-bg {
        padding: 10px 0;
        background-color: #f9fafc;
    }
    .questionIcon{
        float: left;
        width: 22px;
        height: 22px;
        background: rgba(255, 191, 87, 0.2);
        border-radius: 2px;
        margin-bottom: 5px;
    }

    .question{
        width: 12px;
        height: 17px;
        font-size: 12px;
        font-family: PingFangSC-Medium, PingFang SC;
        font-weight: 500;
        color: #FAA822;
        margin: auto;
        margin-top: 2px;
    }
    .questiontitle{
        margin-left: 30px;
        /*height: 22px;*/
        height: auto;
        margin-bottom: 5px;
        width: 500px;
        word-wrap:break-word;
    }
    .questions{
        margin-top: 2px;
        font-size: 12px;
        font-family: MicrosoftYaHei;
        color: #475669;
    }
    .replyIcon{
        float: left;
        width: 22px;
        height: 22px;
        border-radius: 2px;
        margin-bottom: 5px;
        background: rgba(71, 178, 251, 0.15);
    }
    .reply{
        width: 12px;
        height: 17px;
        font-size: 12px;
        font-family: PingFangSC-Semibold, PingFang SC;
        font-weight: 600;
        color: #47B2FB;
        margin: auto;
        margin-top: 2px;
    }
    .replys{
        z-index: 288;
        width: 439px;
        /*height: auto;
        height: 36px;*/
        display: block;
        overflow-wrap: break-word;
        color: rgba(71, 86, 105, 1);
        font-size: 12px;
        font-family: MicrosoftYaHei;
        line-height: 18px;
        text-align: left;
        margin-left: 6px;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .uex-icon-agree .uex-icon-disagree{
        width: 12px;
        height: 12px;
        font-size: 25px;
        font-family: uex-icon, uex;
        font-weight: normal;
        color: #A2B0C4;
        line-height: 12px;
    }
    .item {
        margin-right: 20px;
    }
</style>
<body>
<div id="app" style="display: none">
    <el-container>
        <el-header>
            <div>
                <el-form :inline="true" :model="form" class="demo-form-inline">
                    <el-col :span="2">
                        <el-form-item>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="问题">
                            <el-input v-model="form.question" placeholder="请输入需要查询的问题"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="回答">
                            <el-input v-model="form.answer" placeholder="请输入需要查询的回答"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="2">
                        <el-form-item>
                            <el-button type="primary" @click="query(form)">查询</el-button>
                        </el-form-item>
                    </el-col>
                </el-form>
            </div>
        </el-header>
        <el-main v-loading="loading" style="background-color: white">
            <div>
                <el-row>
                    <el-col :span="12" v-for="(item,index) in quesList.slice((page.currentPage-1)*(page.pageSize),page.currentPage*(page.pageSize))" :key="index">
                        <div  style="float: left;margin-left: 30px;margin-top: 30px">
                            <div style="margin-left: 0px" class="questionIcon"><p class="question">问</p></div>
                            <div class="questiontitle">
                                <p  class="questions">{{index+1}}.热门Top{{index+1}}:{{item.qcnName}}?</p>
                            </div>
                            <div style="margin-top: 10px" class="group10">
                                <div  class="box-card">
                                    <div class="replyIcon">
                                        <p class="reply">答</p>
                                    </div>
                                    <div>
                                        <span style="float: left;margin-left: 9px;margin-top: 2px" class="replys">{{item.qcnAsk||'未作答'}}</span>
                                    </div>
                                    <div style="margin-left: 450px;width:190px">
                                        <el-button @click="transit(item.qcnId)" size="small">回答</el-button>
                                        <el-button @click="deleteQuestion(item.qcnId)" size="small">删除</el-button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </el-col>
                </el-row>

                <#--弹出框-->
                <el-dialog title="回答问题" :visible.sync="dialogQuestionVisible">
                    <el-form :rules="rules" ref="questionForm" :model="questionForm">
                        <el-form-item prop="name" label="问题" >
                            <el-col :span="22">
                                <el-input v-model="questionForm.name" autocomplete="off"></el-input>
                            </el-col>
                        </el-form-item>
                    </el-form>
                    <div slot="footer" class="dialog-footer">
                        <el-button @click="dialogQuestionVisible = false">取 消</el-button>
                        <el-button type="primary" @click="addAnswer('questionForm')">确 定</el-button>
                    </div>
                </el-dialog>
            </div>
        </el-main>
        <el-footer>
            <div>
                <el-pagination
                        @size-change="handleSizeChange"
                        @current-change="handleCurrentChange"
                        :current-page.sync="page.currentPage"
                        :page-sizes="[6, 10, 15, 20]"
                        :page-size="page.pageSize"
                        layout="total, sizes, prev, pager, next, jumper"
                        :total="quesList.length">
                </el-pagination>
            </div>
        </el-footer>
    </el-container>
</div>
</body>
<script>
    var userName = '${userName}';

    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                page: {
                    currentPage: 1,
                    pageSize: 6,
                },
                rules: {
                    name: [
                        {required: true, message: '请输入回答内容', trigger: 'blur'}
                    ],
                },
                questionForm:{},
                dialogQuestionVisible:false,
                quesList:[],
                form:{
                    question:'',
                    answer:''
                },
                loading:'',
            }
        },
        methods:{
            //前端分页
            handleSizeChange(val) {
                this.page.pageSize = val;
                this.query();
            },
            handleCurrentChange(val) {
                this.page.currentPage = val
                this.query();
            },
            //删除问题
            deleteQuestion(id){
                var _self = this;
                _self.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    $.ajax({
                        url:'/question/deleteQuestion?id='+id,
                        type:'get',
                        dataType:'json',
                        success:function (res) {
                            if (res>1){
                                _self.$message({
                                    message: '删除成功！',
                                    type: 'success'
                                });
                            }
                            _self.query();
                        }
                    })
                }).catch(() => {
                    _self.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                    _self.query();
                });
            },
            //中转
            transit(id){
                var _self = this;
                _self.dialogQuestionVisible = true;
                _self.questionForm.id = id;
            },
            //新增回答
            addAnswer(questionForm){
                var _self = this;
                _self.$refs[questionForm].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url: '/question/addAnswer',
                            type: 'post',
                            data:_self.questionForm,
                            dataType: 'json',
                            success:function (res) {
                                if (res>0){
                                    _self.$message({
                                        message: '回答成功！',
                                        type: 'success'
                                    });
                                }
                                _self.dialogQuestionVisible = false;
                                _self.query();
                                _self.questionForm={};
                            }
                        })
                    } else {
                        return false;
                    }
                });
            },
            //初始化 查询
            query(form){
                var _self = this;
                $.ajax({
                    url:'/question/query',
                    type:'get',
                    data:form,
                    dataType:'json',
                    success:function (res) {
                        _self.quesList = res;
                        _self.loadings();
                    },
                })
            },
            loadings(){
                this.loading = true;
                $('#app').css('display','block');
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
        },
        created(){
            this.loadings();
            this.query();
        }
    })
</script>
</html>