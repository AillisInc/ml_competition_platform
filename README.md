**This README is still work in progress**

# Machine learning competition platform
- Machine learning platform just like private Kaggle written in Ruby on Rails framework.

## Overall Architecture
- English version is currently in the making.

<img src="https://img.esa.io/uploads/production/attachments/9766/2020/03/15/40878/e786c502-340b-4ac2-845e-4ad075912311.png"  alt="imaeg" width="1000"/>

## Demo environment

### URL
https://demo-ml-competition-platform.herokuapp.com/

### Demo user account
| ID | demo1@example.com |
| --- | --- |
| Password | ^dvTT0JgIPS4V@RWW$Kw |

### Sample JSON file for submission
- [AUC Competition](https://github.com/AillisInc/ml_competition_platform/blob/master/db/fixtures/jsons/classification_prediction.json)
- [mAP Competition](https://github.com/AillisInc/ml_competition_platform/blob/master/db/fixtures/jsons/detection_prediction.json)

## Developer's manual
- Developer's manual is written in [Github Wiki Page (Still WIP)](https://github.com/AillisInc/ml_competition_platform/wiki)

## How to setup development environment

### Deploy API server
- Clone codes of [API Server](https://github.com/AillisInc/ml_competition_api_server) to calculate metrics for competition
  ```bash
  git clone https://github.com/AillisInc/ml_competition_platform.git
  ```

- Deploy API server according to the following steps
  - https://github.com/AillisInc/ml_competition_api_server/blob/master/README.md

### Setup environment variables.

```bash
cp .env.sample .env
vim .env
```

Copy the following text to .env file.
```bash
METRICS_API_ENDPOINT=http://host.docker.internal:8000/
METRICS_API_AUTH_KEY=secret_key  # In production environment, a strong key is recommended.
```

#### About `METRICS_API_AUTH_KEY`
- `METRICS_API_AUTH_KEY` is used for authorization with API server to calculate metrics 
- Therefore, in production environment, it is recommended to use `METRICS_API_AUTH_KEY` value that cannot be easily guessed.
- `METRICS_API_AUTH_KEY` value should be matched to `API_KEY_TOKEN` value in API server

### Build docker container with docker-compose
```bash
$ docker-compose run web bundle install
$ docker-compose run web rails db:setup
$ docker-compose up
```

### Create User Account
- create admin account with the following command in rails console.

```ruby
User.create(email: 'admin@example.com', password: 'password', name: "admin_user", role: "admin")
```
- in case of creating normal user account, execute the following command.
```ruby
User.create(email: 'test@example.com', password: 'password', name: "test_user", role: "member")
```

### Server URL for development environment
[http://localhost:3000](http://localhost:3000)

## Web API to calculate metrics
- To calculate metrics to determine ranking of each competitor, Web API written in Flask should be also deployed.
- The github code of this Web API server is [here](https://github.com/AillisInc/ml_competition_api_server)
 
## License
MIT