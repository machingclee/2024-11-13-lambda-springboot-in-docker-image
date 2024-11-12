FROM gradle:8.10.0-jdk21-alpine AS build
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon

FROM public.ecr.aws/lambda/java:21
RUN mkdir -p $LAMBDA_TASK_ROOT/lib/
ARG JAR_FILE="demo-0.0.1-SNAPSHOT.jar"
COPY --from=build /app/build/libs/${JAR_FILE} $LAMBDA_TASK_ROOT
RUN mkdir -p ${LAMBDA_TASK_ROOT}/extract && \
    cd ${LAMBDA_TASK_ROOT}/extract && \
    jar -xf ${LAMBDA_TASK_ROOT}/${JAR_FILE} && \
    mv ${LAMBDA_TASK_ROOT}/extract/BOOT-INF/classes/* ${LAMBDA_TASK_ROOT}/ && \
    mv ${LAMBDA_TASK_ROOT}/extract/BOOT-INF/lib/* ${LAMBDA_TASK_ROOT}/lib && \
    mv ${LAMBDA_TASK_ROOT}/extract/META-INF/* ${LAMBDA_TASK_ROOT}/META-INF/ && \
    if [ -d ${LAMBDA_TASK_ROOT}/BOOT-INF/classes/META-INF ]; then \
        mv ${LAMBDA_TASK_ROOT}/BOOT-INF/classes/META-INF/* ${LAMBDA_TASK_ROOT}/META-INF/ && \
        rmdir ${LAMBDA_TASK_ROOT}/BOOT-INF/classes/META-INF; \
    fi && \
    rm -rf ${LAMBDA_TASK_ROOT}/extract ${LAMBDA_TASK_ROOT}/${JAR_FILE} ${LAMBDA_TASK_ROOT}/BOOT-INF

CMD ["com.example.demo.StreamLambdaHandler::handleRequest"]