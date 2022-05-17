package com.xiyi.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter extends HttpServlet implements Filter {

    public void doFilter(ServletRequest req, ServletResponse resp,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        HttpSession session = request.getSession(true);

        String url = request.getRequestURI();//获取地址栏的url
        String uname= (String) session.getAttribute("uname");//获取登录时存放的session
        if (uname== null && url.indexOf("login") == -1//未登陆、当前不是登陆的ftl、也不是登陆的.do
                && !url.equals("/login") && !url.equals("/laundry/registration")) {//过滤注册白名单
            String location = "/view/index.ftl";//定义当访客非法访问不被允许的地址时跳转的界面
            request.getRequestDispatcher(location).forward(request, response);//跳转至指定界面
            response.setHeader("Cache-Control", "no-store");
            response.setDateHeader("Expires", 0);
            response.setHeader("Pragma", "no-cache");
        } else {
            chain.doFilter(request, response);
        }
    }

    public void init(FilterConfig arg0) throws ServletException {
    }

    @Override
    public void destroy() {
        // TODO Auto-generated method stub

    }

}
