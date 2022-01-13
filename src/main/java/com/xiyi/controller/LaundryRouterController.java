package com.xiyi.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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
                             @RequestParam("password") String passWord, Model mm){
        mm.addAttribute("userName",userName);
        mm.addAttribute("passWord",passWord);
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
                             @RequestParam("password") String passWord, Model mm){
        mm.addAttribute("userName",userName);
        mm.addAttribute("passWord",passWord);
        modelAndView.setViewName("mainsystem");
        return modelAndView;
    }

    @RequestMapping(value = "/laundry/systemActivity")
    public ModelAndView systemActivity(@RequestParam("username") String userName, Model mm){
        mm.addAttribute("userName",userName);
        modelAndView.setViewName("systemactivity");
        return modelAndView;
    }

}
