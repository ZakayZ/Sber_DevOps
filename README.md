# Инструкция по запуску

## Запуск minikube

```shell
minikube delete
minikube start
```

## Запуск приложения

```shell
./deploy.sh
```

Отправить запросы внутри кластера:
```shell
kubectl run -it --rm --image=curlimages/curl test -- sh
curl http://app-service/status
curl -X POST http://app-service/log -d '{"message": "test"}'
curl http://app-service/logs
```

Посмотреть вывод log-agent:
```shell
kubectl get pods -o wide
kubectl logs log-agent-xxxxxxx
```
