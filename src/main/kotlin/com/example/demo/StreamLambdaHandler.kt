package com.example.demo

import com.amazonaws.serverless.exceptions.ContainerInitializationException
import com.amazonaws.serverless.proxy.model.AwsProxyRequest
import com.amazonaws.serverless.proxy.model.AwsProxyResponse
import com.amazonaws.serverless.proxy.spring.SpringBootLambdaContainerHandler
import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestStreamHandler
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream


class StreamLambdaHandler : RequestStreamHandler {
    @Throws(IOException::class)
    override fun handleRequest(inputStream: InputStream, outputStream: OutputStream, context: Context) {
        handler!!.proxyStream(inputStream, outputStream, context)
    }

    companion object {
        private var handler: SpringBootLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse>? = null

        init {
            try {
                handler = SpringBootLambdaContainerHandler.getAwsProxyHandler(DemoApplication::class.java)
            } catch (e: ContainerInitializationException) {
                e.printStackTrace()
                throw RuntimeException("Could not initialize Spring Boot application", e)
            }
        }
    }
}