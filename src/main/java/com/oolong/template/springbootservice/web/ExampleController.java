package com.oolong.template.springbootservice.web;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/example")
public class ExampleController {

    private static final Map<String, String> EXAMPLE_MAP = new HashMap<>();

    @GetMapping("/map") @ResponseBody
    public Map<String, String> map() {
        return EXAMPLE_MAP;
    }

    @PostMapping("/map")
    public ModelAndView reset() {
        EXAMPLE_MAP.clear();
        return new ModelAndView("redirect:/example/map");
    }

    @GetMapping("/map/{key}") @ResponseBody
    public String value(@PathVariable final String key) {
        return EXAMPLE_MAP.get(key);
    }

    @PostMapping("/map/{key}/{value}")
    public ModelAndView put(@PathVariable final String key, @PathVariable final String value) {
        EXAMPLE_MAP.put(key, value);
        return new ModelAndView("redirect:/example/map/" + key);
    }
}
