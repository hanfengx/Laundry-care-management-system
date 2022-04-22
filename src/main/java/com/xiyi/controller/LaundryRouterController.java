package com.xiyi.controller;


import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class LaundryRouterController {

    ModelAndView modelAndView=new ModelAndView();


    @RequestMapping("/login")
    public ModelAndView login(){
        modelAndView.setViewName("login");
        return modelAndView;
    }

    @RequestMapping(value = "/laundry/main")
    public ModelAndView main(@RequestParam("username") String userName,
                             @RequestParam("password") String passWord, Model mm, HttpServletRequest request){
        mm.addAttribute("userName",userName);
        mm.addAttribute("passWord",passWord);
        HttpSession session = request.getSession(true);
        session.setAttribute("userName",userName);
        modelAndView.setViewName("main");
        return modelAndView;
    }

    @RequestMapping(value = "/laundry/activity")
    public ModelAndView activity(){
        modelAndView.setViewName("activity");
        return modelAndView;
    }


    @RequestMapping(value = "/laundry/mainSystem")
    public ModelAndView mainSystem(@RequestParam("username") String userName,
                                   @RequestParam("password") String passWord, Model mm, HttpServletRequest request){
        mm.addAttribute("userName",userName);
        mm.addAttribute("passWord",passWord);
        HttpSession session = request.getSession(true);
        session.setAttribute("userName",userName);
        modelAndView.setViewName("mainsystem");
        return modelAndView;
    }

    @RequestMapping(value = "/laundry/systemActivity")
    public ModelAndView systemActivity(@RequestParam("username") String userName, Model mm){
        mm.addAttribute("userName",userName);
        modelAndView.setViewName("systemactivity");
        return modelAndView;
    }

    @RequestMapping(value="/laundry/washClothes")
    public ModelAndView washClothes(HttpServletRequest request,Model mm,@RequestParam(value = "actId",required = false,defaultValue = "") String actId){
        HttpSession session = request.getSession(true);
        mm.addAttribute("actId",actId);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("washclothes");
        return modelAndView;
    }

    @RequestMapping(value = "/laudry/orderManagement")
    public ModelAndView orderManagement(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("ordermanagement");
        return modelAndView;
    }


    @RequestMapping("/laudry/membercentre")
    public ModelAndView membercentre(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("user_membercentre");
        return modelAndView;


    }

    @RequestMapping("/laudry/sysmembercentre")
    public ModelAndView sysMembercentre(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("sys_membercentre");
        return modelAndView;
    }

    @RequestMapping("/laudry/sysordermanagement")
    public ModelAndView sysOrdermanagement(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("sys_ordermanagement");
        return modelAndView;
    }

    @RequestMapping("/laudry/sysClothesType")
    public ModelAndView sysClothesType(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("sys_clothestype");
        return modelAndView;
    }

    @RequestMapping("/laudry/userQuestion")
    public ModelAndView userQuestion(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("user_question");
        return modelAndView;
    }

    @RequestMapping("/laudry/sysQuestion")
    public ModelAndView sysQuestion(HttpServletRequest request,Model mm){
        HttpSession session = request.getSession(true);
        mm.addAttribute("userName",session.getAttribute("userName"));
        modelAndView.setViewName("sys_question");
        return modelAndView;
    }

}
