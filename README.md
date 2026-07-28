# Infrastructure Inventory API

## Opis projektu

Infrastructure Inventory API to prosta aplikacja REST API napisana w technologii FastAPI. Projekt został przygotowany w celu zaprezentowania praktycznego narzędzi DevOps.

Celem projektu było zbudowanie kompletnego procesu automatycznego budowania, testowania oraz wdrażania aplikacji do środowiska chmurowego AWS z wykorzystaniem konteneryzacji oraz Infrastructure as code.

## Funkcjonalność aplikacji

Aplikacja udostępnia endpointy:

- GET /health – zwraca status działania aplikacji.
- GET /version – zwraca aktualną wersję aplikacji.
- GET /hosts – zwraca listę hostów.
- POST /hosts – dodaje nowy host do listy.
- DELETE /hosts/{host_id} – usuwa host z listy.

Projekt opiera się o następującą architekturę:

Programista > GitHub > GitHub Actions > Uruchomienie testów > Budowa obrazu Docker > Publikacja obrazu na Amazon ECR > Wdrożenie aplikacji do Amazon ECS > Amazon ECS (fargate) > Publiczne REST API

## Wykorzystane technologie 

- Python 3.9
- FastAPI
- Docker
- GitHub Actions
- Amazon ECS 
- Amazon ECR
- AWS CloudWatch Logs
- Terraform

## Infrastructure as code

Infrastuktura została utworzona przy pomocy Terraform

  - Repozytorium ECR
  - Klaster ECS
  - Usługę ECS
  - Task Defenition
  - Role IAM
  - Security Groups
  - CloudWatch
 
## CI/CD

Proces CI/CD działa w oparciu o GitHub Actions.

  1. Pobieranie kodu z repozytorium oraz instalację zależnosci.
  2. Wykonanie testów automatycznych.
  3. Uwierzytelnienie w AWS wraz z logowaniem do ECR.
  4. Budowa obrazuy Docker.
  5. Publikacja obrazu w Amazon ECR.
  6. Wdrożenie nowej wersji aplikacji w Amazon ECS.
 
## Budowa aplikacji 

Zmiany dokonujemy w katalogu aplikacji
devops-inventory-api\app\
 
## Proces wdrażania

 Każdy wykonany "git push" do repozytorium auotmatycznie uruchamia pipeline GitHub Actrions.

 Po pomyślnym zakończeniu testów, polegających na sprawdzeniu statusu oraz poprawnej wersji aplikacji.

Budowany jest nowy obraz Docker, oraz publikowany w Amazon ECR, wykonuje się automatyczny deployment do amazon ECS a aplikacja zostaje zaktualizowana do najnowszej wersji.

## Publiczny Adres aplikacji 
Aplikacja dostępna jest pod adresem: 
http://44.199.231.111:8000/health
http://44.199.231.111:8000/version
http://44.199.231.111:8000/hosts
  
