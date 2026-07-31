### Deploy by docker run
**openMAINT with demo database**  
```bash
docker compose up -d --wait
# configure attachments
docker exec -ti openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled false
docker exec -ti openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.service.type postgres
docker exec -ti openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled true

```  


#### CMDBUILD_DUMP values
* `demo.dump.xz`
* `empty.dump.xz`


#### Environment variables (.env)

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `postgres` | PostgreSQL superuser |
| `POSTGRES_PASSWORD` | `postgres` | PostgreSQL superuser password |
| `POSTGRES_PORT` | `5432` | PostgreSQL port |
| `POSTGRES_HOST` | `openmaint_db` | PostgreSQL hostname |
| `POSTGRES_DB` | `openmaint` | CMDBuild database name |
| `OPENMAINT_DB_USER` | `openmaint` | CMDBuild application database user |
| `OPENMAINT_DB_PASSWORD` | `openmaint` | CMDBuild application database password |
| `JAVA_OPTS` | `-Xmx6000m -Xms3000m` | JVM options for Tomcat |
| `PGADMIN_DEFAULT_EMAIL` | `admin@example.com` | pgAdmin login email |
| `PGADMIN_DEFAULT_PASSWORD` | `admin` | pgAdmin login password |

#### Please change credentials for postgres and tomcat server
* @ `openmaint-2.4.2-4.2.0/.env` — all environment variables
* @ `openmaint-2.4.2-4.2.0/files/context.xml`
* @ `openmaint-2.4.2-4.2.0/files/tomcat-users.xml`

#### Credentials and access to Openmaint
* **Link to CMDbuild app** — http://localhost:8090/cmdbuild/ui/
* **username** — admin (default)
* **password** — admin (default)

#### Credentials and access to Openmaint Database
* **Host** — openmaint_db:5432
* **username** — postgres (default)
* **password** — postgres (default)

#### Credentials and access to Tomcat
* **Link to Tomcat manager** — http://localhost:8090/manager
* **username** — admin
* **password** — password

#### Credentials and access to PGAdmin
* **Link to PGAdmin** — http://localhost:5050 (localhost only)
* **username** — admin@example.com
* **password** — admin
* **Note:** pgAdmin runs only with `--profile admin` flag. Master password is required on first login.