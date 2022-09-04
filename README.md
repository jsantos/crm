# CRM Application

Management tool from users and groups within different companies.

## Docker Setup

Before starting, create a `.env` file to store the database credentials. Use the following format:
```
DB_USER=crm
DB_PASSWORD=my_secret_password
```

1. `docker-compose build`
2. `docker-compose run app rake db:create RAILS_ENV=production`
3. `docker-compose run app rake db:migrate db:seed RAILS_ENV=production`
4. `docker-compose up -d`

**Access production Console:** `docker-compose run app rails c -e production`
**Run test suite:** `docker-compose run app rails t`

## API Overview

## Companies

1. Create a new Company
```shell
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json;" localhost:80/api/v1/companies --data '{"company": {"code": "GlobalSign"}}'

	# {"id":1,"code":"GlobalSign"}
```
A company code should only have alphanumeric characters and optionally a dash (less than 50 characters long).

2. List Existing Companies
```shell
curl -H "Accept: application/json" -H "Content-Type: application/json;" localhost:80/api/v1/companies/

	# [{"id":1,"code":"GlobalSign"},{"id":2,"code":"E-Corp"}]
```

3. Delete an existing Company (with ID=1)
```shell
curl -X DELETE -H 'Content-Type: application/json' localhost:80/api/v1/companies/1
```
When a company is deleted, all groups and users associated to it will also be deleted.

### Users

1. Create a new user within a Company (whose ID is 1)
```shell
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json;" localhost:80/api/v1/companies/1/users --data '{"user": {"first_name": "Jorge", "last_name":"Santos", "email": "jorge@santos.com", "age": "35"}}'

	# {"id":1,"first_name":"Jorge","last_name":"Santos","email":"jorge@gs.com","company_id":1}
```
A user should be at least 18 years old, otherwise a 400 HTTP code (bad request) will be returned.
### Groups

1. Create a new group within a Company (whose ID is 1)
```shell
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json; charset=utf-8" localhost:80/api/v1/companies/1/groups --data '{"group": {"name": "Human Resources"}}'

	# {"id":1,"name":"Human Resources","company_id":1,"user_count":0}
```

2. List existing groups with a Company (whose ID is 1)
```shell
curl -H "Accept: application/json" -H "Content-Type: application/json;" localhost:80/api/v1/companies/1/groups

	# [{"id":1,"name":"Human Resources","company_id":1,"user_count":0},{"id":2,"name":"Engineering","company_id":1,"user_count":0}]
```

3. Delete an existing group (whose ID is 1) within a company (whose ID is 1)
```shell
curl -X DELETE -H 'Content-Type: application/json' localhost:80/api/v1/companies/1/groups/1
```
When a group is deleted, all users assigned to this groups will be un-assigned from it.
### Users & Groups

1. Assign a user (whose ID is 1) to a group (whose ID is 2) within a company (whose ID is 1)
```shell
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json; charset=utf-8" localhost:80/api/v1/companies/1/groups/2/users --data '{"user": {"id": "1"}}'
```

2. Un-assign a user (whose ID is 1) from a group (whose ID is 2) within a company (whose ID is 1)
```shell
curl -X DELETE -H 'Content-Type: application/json' localhost:80/api/v1/companies/1/groups/2/users/1
```
