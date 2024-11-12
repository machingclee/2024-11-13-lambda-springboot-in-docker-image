package com.example.demo.controller

import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

data class Response (val success: Boolean, val result:Any)

@RestController
@RequestMapping("/")
class HelloController(
    @Value("\${stage.env}") private val env: String
) {
    @GetMapping("/hello")
    fun helloWorld (): Response {
        return Response(true, "hello world $env")
    }
}