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
    <title>管理员问题页面</title>
</head>
<body>
<div id="app" style="display: none">
    <el-container>
        <el-header>Header</el-header>
        <el-main v-loading="loading">Main</el-main>
    </el-container>
</div>
</body>
<script>
    var userName = '${userName}';

    var vm = new Vue({
        el: '#app',
        data: function() {
            return {
                loading:false,
            }
        },
        methods:{

            loadings(){
                $('#app').css('display','block');
                setTimeout(() => {
                    this.loading = false;
                }, 1000);
            },
        },
        created(){
            this.loadings();
        }
    })
</script>
</html>