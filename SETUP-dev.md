1. Set environment

```sh
cp .env.example .env
```

2. Start containers

```sh
docker compose up -d --build --remove-orphans
```

3. Set your admin user accessing http://localhost:1337/admin

4. Set permissions for the routes:

* Admin Panel settings -> Users & Permissions plugin -> Roles
* Choose Public role
* Find Url-access-data 
* Enable access for routes: check, set
* Save