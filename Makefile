BUILD_CMD=docker build -t jenkins-fast-standalone:latest .
RUN_CMD=docker run -p 9090:8080 -p 50000:50000 jenkins-fast-standalone:latest
build:  
	$(BUILD_CMD) && $(RUN_CMD)
