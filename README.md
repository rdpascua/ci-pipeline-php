# Continous Integration Pipeline

Sample `.gitlab-ci.yml`

```yaml
# Variables
variables:
  MYSQL_ROOT_PASSWORD: root
  MYSQL_USER: homestead
  MYSQL_PASSWORD: secret
  MYSQL_DATABASE: homestead
  DB_HOST: mysql

test:
  stage: test
  services:
    - mysql:5.7
  image: rdpascua/ci-pipeline-php
  script:
    - yarn
    - composer install --prefer-dist --no-ansi --no-interaction --no-progress
    - cp .env.example .env
    - php artisan key:generate
    - php artisan migrate:refresh --seed
    - php artisan test
```

### Sample with private dependencies

```yaml
# Variables
variables:
  MYSQL_ROOT_PASSWORD: root
  MYSQL_USER: homestead
  MYSQL_PASSWORD: secret
  MYSQL_DATABASE: homestead
  DB_HOST: mysql

test:
  stage: test
  services:
    - mysql:5.7
  image: rdpascua/ci-pipeline-php
  script:
    - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
    - yarn
    - composer install --prefer-dist --no-ansi --no-interaction --no-progress
    - cp .env.example .env
    - php artisan key:generate
    - php artisan migrate:refresh --seed
    - php artisan test
```

### Sample Bitbucket Pipelines `bitbucket-pipelines.yml`

```yaml
image: rdpascua/ci-pipeline-php

pipelines:
  default:
    - step:
        caches:
          - composer
          - node
        script:
          - apt-get update && apt-get install -qy git curl libzip-dev libmcrypt-dev default-mysql-client
          - composer install --prefer-dist --no-ansi --no-interaction --no-progress
          - yarn
          - cp .env.example .env
          - php artisan key:generate
          - php artisan migrate:fresh --seed
          - php artisan test
        services:
          - mysql
        artifacts:
          - storage/logs/**
          - tests/Browser/screenshots/**
          - tests/Browser/console/**

definitions:
  services:
    mysql:
      image: mysql:5.7
      environment:
        MYSQL_DATABASE: 'homestead'
        MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
        MYSQL_USER: 'homestead'
        MYSQL_PASSWORD: 'secret'
```

