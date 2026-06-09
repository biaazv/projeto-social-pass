package com.fullstack.gympass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FrontController {

    @GetMapping({"/socialpass/cadastro", "/social-pass/cadastro", "/socialpass", "/social-pass"})
    public String cadastro() {
        return "forward:/social-pass/index.html";
    }

    @GetMapping("/")
    public String raiz() {
        return "forward:/social-pass/index.html";
    }
}
