# Datvi - Date Trivia Apps

This apps will try to generate a trivia based on a date!

## Prerequisite
- Kubernetes cluster, I use minikube for easy of installation
- [Helm charts](https://helm.sh/docs/intro/install/)
- [Docker](https://docs.docker.com/engine/install/)

## Installation
We will use makefile to automate the installation, the frontend will exposed using kubernetes LoadBalancer service type
After installation finish to expose the frontend service you can execute **minikube tunnel datvi-frontend** manually if the automation script failed

1. Execute below command
### for non-production
```sh
make
```

### for production
```sh
make autoscaling="true"
```

2. Wait for sometimes until the script finish you might need to input the sudo password for minikube tunneling
3. Visit the frontend application on your browser http://service_ip:8082/index.html
4. After finish run below command to clean up your workspaces
```sh
make clean
```

## Post script
This program is still unfinished since the frontend can not make a http request to the backend because it is a web app running on client side. Still trying to find a way to render it on server side
