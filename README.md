# DevOps Demo - A simple HTTP server in Rust with Docker & Kubernetes

![Rust](https://img.shields.io/badge/Rust-1.78+-orange)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-blue)
![Docker](https://img.shields.io/badge/Docker-24.0+-lightblue)

A simple HTTP server in Rust with a full DevOps stack: Docker, Kubernetes, Autoscaling.

## Features

- **Rust Axum** - a modern async web framework
- **Docker** - multi-stage builds, security best practices
- **Kubernetes** - deployment, service, autoscaling
- **Health Checks** - liveness and readiness probes
- **CI/CD** - automatic build and testing

## API Endpoint
- `GET /` - main page
- `GET /health` - health check
- `GET /hello` - hello message in JSON

## Local development
```bash
cargo run
curl http://localhost:3000/health
```

## Docker
```bash
eval $(minikube docker-env -u)
docker build -t devops-demo:latest .
docker run -p 8080:3000 devops-demo:latest
# (in another terminal)
curl http://localhost:8080/health
```

## Kubernetes (Minikube)
```bash
minikube start
eval $(minikube docker-env)
docker build -t devops-demo:latest .
kubectl apply -f k8s/
minikube service devops-demo-service
```

