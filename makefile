.PHONY: all build_backend build_frontend load_images_to_minikube \
deploy_backend deploy_frontend tunnel_frontend clean

all: build_backend build_frontend load_images_to_minikube \
deploy_backend deploy_frontend tunnel_frontend

autoscaling = false 

build_backend:
	@echo "Dockerize datvi-backend"
	docker build -t datvi-backend ./src/datvi-backend

build_frontend:
	@echo "Dockerize datvi-frontend"
	docker build -t datvi-frontend ./src/datvi-frontend

load_images_to_minikube:
	@echo "Load docker image to minikube registry"
	minikube image load datvi-backend datvi-frontend

deploy_backend:
	@echo "Deploy datvi-backend using helm"
	helm install datvi-backend --set autoscaling.enabled=${autoscaling} ./helm_charts/datvi-backend

deploy_frontend:
	@echo "Deploy datvi-frontend using helm"
	helm install datvi-frontend --set autoscaling.enabled=${autoscaling} ./helm_charts/datvi-frontend

tunnel_frontend:
	@echo "IP Tunnel datvi-frontend service"
	@minikube tunnel datvi-frontend > /dev/null 2>&1 &
	@export SERVICE_IP=$$(@kubectl get svc --namespace default datvi-frontend --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
	@echo "Visit http://$$SERVICE_IP:8082 on your browser"

clean:
	@echo "Clean up workspaces..." 
	@echo "Uninstalling Datvi charts..."
	@helm uninstall datvi-frontend datvi-backend
	@ps -ef | grep "minikube tunnel" | grep -v grep | awk '{print $$2}'| xargs kill 
	@echo "Deleting the minikube images..."
	@sleep 25
	@minikube image rm datvi-frontend datvi-backend
	@echo "Deleting docker images..."
	@docker rmi datvi-frontend datvi-backend
