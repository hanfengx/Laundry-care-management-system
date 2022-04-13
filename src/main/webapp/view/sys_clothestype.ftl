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
    <title>衣服类型</title>
</head>
<style>
    #tree{
        height: 400px;
        border: solid 1px #DCDFE6;
        margin-left: 50px;
        margin-top: 30px;
    }
    .page-scroll .el-scrollbar__wrap {
        overflow-x: hidden;
    }
    .table{
        width: 900px;
        height: 400px;
        margin-left: 300px;
        margin-top: 30px;
        display: block;
    }



</style>
<style>
    .contextmenu__item {
        display: block;
        line-height: 34px;
        text-align: center;
    }
    .contextmenu__item:not(:last-child) {
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }
    .menu {
        position: absolute;
        background-color: #fff;
        width: 100px;
        /*height: 106px;*/
        font-size: 12px;
        color: #444040;
        border-radius: 4px;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
        border-radius: 3px;
        border: 1px solid rgba(0, 0, 0, 0.15);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
        white-space: nowrap;
        z-index: 1000;
    }
    .contextmenu__item:hover {
        cursor: pointer;
        background: #66b1ff;
        border-color: #66b1ff;
        color: #fff;
    }
</style>
<body>
<div id="app" style="display: none" >
    <div style="background-color: white;width: 1450px;height: 540px">
        <div style="height: 10px"></div>
        <div id="tree" style="width: 200px;display: block;float: left">
            <el-scrollbar class="page-scroll" style="height:100%;">
                <el-tree
                        :data="dataTree"
                        :props="defaultProps"
                        @node-click="NodeClick"
                        @node-contextmenu="rightClick">
                </el-tree>
            </el-scrollbar>
        </div>
        <div class="table" v-loading="loading">
            <el-scrollbar class="page-scroll" style="height:100%;">
                <el-table stripe style="width: 100%" :data="tableData" height="400" :header-cell-style="{'text-align':'center'}" :cell-style="{'text-align':'center'}" border>
                    <el-table-column  prop="index" label="序号" >
                        <template slot-scope="scope">
                            <span>{{scope.$index+1}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column show-overflow-tooltip prop="label" label="名称" ></el-table-column>
                    <el-table-column :formatter="price" prop="cloPrice" label="价格" ></el-table-column>
                </el-table>
            </el-scrollbar>
            <div id="contextmenu"
                 v-show="menuVisible"
                 class="menu">
                <div v-show="outlineVisible" class="contextmenu__item" @click="addData(CurrentRow)">
                    <i class="el-icon-circle-plus-outline">新增</i></div>
                <div class="contextmenu__item" @click="editData(CurrentRow)">
                    <i class="el-icon-edit">修改</i></div>
                <div class="contextmenu__item" @click="deleData(CurrentRow)">
                    <i class="el-icon-delete">删除</i></div>
            </div>

            <div>
                <el-dialog :title="operationTitles" :visible.sync="dialogFormVisible">
                    <el-form :rules="rules" ref="form" :model="form">
                        <el-form-item prop="name" label="衣服名称" label-width="120">
                            <el-col :span="8">
                                <el-input v-model="form.name" autocomplete="off"></el-input>
                            </el-col>
                        </el-form-item>
                        <el-form-item prop="category" label="衣服分类" label-width="120">
                            <el-col :span="8">
                                <el-select v-model="form.category" placeholder="请选择衣服分类">
                                    <el-option label="一级" value="1"></el-option>
                                    <el-option label="二级" value="2"></el-option>
                                </el-select>
                            </el-col>
                        </el-form-item>
                        <el-form-item prop="price" v-if="form.category=='2'?true:false" label="衣服价格" label-width="120">
                            <el-col :span="8">
                                <el-input v-model="form.price" autocomplete="off"></el-input>
                            </el-col>
                        </el-form-item>
                    </el-form>
                    <div slot="footer" class="dialog-footer">
                        <el-button @click="takeAway('form')">取 消</el-button>
                        <el-button type="primary" @click="submit(CurrentRow,'form')">确 定</el-button>
                    </div>
                </el-dialog>
            </div>

        </div>
    </div>
</div>
</body>
<script>
    var userName='${userName}';
    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                form:{
                    name:'',
                    category:'',
                    price:''
                },
                outlineVisible:true,
                dialogFormVisible:false,
                operationTitles:'',
                menuVisible:false,
                tableData:[],
                dataTree: [],
                defaultProps: {
                    children: 'children',
                    label: 'label',
                    value:'value'
                },
                rules: {
                    name:[{ required: true, message: '请输入衣服名称', trigger: 'blur' },],
                    category:[{required: true, message: '请选择衣服类别', trigger: 'blur'}],
                    price:[{required: true, message: '请输入衣服价格', trigger: 'blur'}]
                },
                loading:true,
            }
        },
        methods:{
            //提交
            submit(CurrentRow,form){
                var _self = this;
                this.$refs[form].validate((valid) => {
                    if (valid) {
                        _self.dialogFormVisible = false;
                        var addForm = {
                            name:_self.form.name,
                            category:_self.form.category,
                            price:_self.form.price||'',
                            parentId:CurrentRow.value||''
                        }
                        console.log(addForm)
                        var operationTitles = _self.operationTitles;
                        var url='';
                        var message = '';
                        if (operationTitles=='新增衣服'){
                            url = '/clothesType/addClothes';
                            message = '增加成功！';
                        }else {
                            url = '/clothesType/editClothes';
                            message = '修改成功！';
                        }
                        $.ajax({
                            url:url,
                            dataType:'json',
                            type:'get',
                            data:addForm,
                            success:function (res) {
                                if (res>0){
                                    _self.$message({
                                        message: message,
                                        type: 'success'
                                    });
                                }
                                _self.getTree();
                                _self.form={};
                            }
                        })
                    } else {
                        return false;
                    }
                });
            },
            //tree新增
            addData(CurrentRow){
                var _self = this;
                _self.operationTitles='新增衣服';
                _self.dialogFormVisible = true;
            },
            //tree修改
            editData(CurrentRow){
                var _self = this;
                console.log(CurrentRow)
                //回显
                _self.form={
                    name:CurrentRow.label,
                    category:CurrentRow.cloCategory||CurrentRow.cltCategory,
                    price:CurrentRow.cloPrice,
                }
                _self.operationTitles='修改衣服';
                _self.dialogFormVisible = true;

            },
            //tree删除
            deleData(CurrentRow){
                var _self = this;
                console.log(CurrentRow);
                _self.$confirm('此操作将永久删除'+CurrentRow.label+', 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                   $.ajax({
                       url:'/clothesType/deleteClothes?id='+CurrentRow.value+'&category='+CurrentRow.cltCategory,
                       type:'get',
                       dataType:'json',
                       success:function (res) {
                           if (res>0){
                               _self.$message({
                                   type: 'success',
                                   message: '删除成功!'
                               });
                           }
                           _self.getTree();
                       }
                   })
                }).catch(() => {
                    _self.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });

            },
            rightClick(row, column, event) {
                this.testModeCode = row.testModeCode
                this.menuVisible = false // 先把模态框关死，目的是 第二次或者第n次右键鼠标的时候 它默认的是true
                this.menuVisible = true // 显示模态窗口，跳出自定义菜单栏
                if (column.cloCategory=='2'){
                    this.outlineVisible = false;
                }else {
                    this.outlineVisible = true;
                }
                this.CurrentRow = column;
                var menu = document.querySelector('.menu')
                this.styleMenu(menu)
            },
            //关闭弹窗
            takeAway(form){
                var _self = this;
                _self.dialogFormVisible = false;
                _self.$refs[form].resetFields();
            },
            foo() {
                // 取消鼠标监听事件 菜单栏
                this.menuVisible = false
                document.removeEventListener('click', this.foo) // 关掉监听，
            },
            styleMenu(menu) {
                if (event.clientX > 1800) {
                    menu.style.left = event.clientX - 100 + 'px'
                } else {
                    menu.style.left = event.clientX + 1 + 'px'
                }
                document.addEventListener('click', this.foo) // 给整个document新增监听鼠标事件，点击任何位置执行foo方法
                if (event.clientY > 700) {
                    menu.style.top = event.clientY - 30 + 'px'
                } else {
                    menu.style.top = event.clientY - 10 + 'px'
                }
            },
            price(row){
                return row.cloPrice+"元";
            },
            //树tree 点击
            NodeClick(data) {
                var _self = this;
                $.ajax({
                    url:'/clothesType/getClothes?value='+data.value+'&cltCategory='+data.cltCategory,
                    type:'get',
                    dataType: 'json',
                    success:function (res) {
                        _self.tableData = res;
                        _self.loadings();
                    }
                })
            },
            //树tree 初始话
            getTree(){
              var _self = this;
              $.ajax({
                  url:'/clothesType/getTree',
                  type:'get',
                  dataType:'json',
                  success:function (res) {
                      _self.dataTree = res;
                  }
              })
            },
            loadings(){
                this.loading=true;
                $('#app').css('display','block');
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
        },
        created(){
            this.loadings();
            this.getTree();
        }
    })
</script>
</html>