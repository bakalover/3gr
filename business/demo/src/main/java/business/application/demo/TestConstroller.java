package business.application.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestConstroller {
    @GetMapping("/")
    public String hello(){
        return "Haha";
    }
}
