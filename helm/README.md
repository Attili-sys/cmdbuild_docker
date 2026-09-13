# openMAINT Helm Chart

Deploys openMAINT 2.4.2 / CMDBuild 4.2.0 (`itmicus/cmdbuild:om-2.4.2-4.2.0`) with the
demo dataset, as a Kubernetes equivalent of `openmaint-2.4.2-4.2.0/docker-compose.yml`.

## Quick start

```bash
helm upgrade openmaint helm/ -n openmaint --install --create-namespace \
  --set app.hostname=openmaint.example.com \
  --set app.database.adminPassword="$PG_ADMIN_PASSWORD" \
  --set app.database.appPassword="$PG_APP_PASSWORD"
```

Both passwords are **required** — the chart refuses to render without them rather than
deploying with an empty password. They are never stored in `values.yaml`.

First start restores `demo.dump.xz` and takes several minutes. Watch it with:

```bash
kubectl logs -f deployment/openmaint -c openmaint -n openmaint
```

## What this chart deploys

| Resource | Purpose |
|---|---|
| `Deployment/<release>` | openMAINT (Tomcat) + `dms-config` sidecar |
| `StatefulSet/<release>-postgresql` | PostGIS 17-3.5 (optional) |
| `Service/<release>` | ClusterIP :80 → :8080 |
| `Service/<release>-postgresql`, `-postgresql-hl` | DB access + StatefulSet governance |
| `Ingress/<release>-ingress` | Traefik (`kommander-traefik`) + cert-manager TLS |
| `ConfigMap/<release>-env`, `-postgress` | App and DB connection settings |
| `Secret/<release>-secret` | `POSTGRES_PASSWORD`, `OPENMAINT_DB_PASSWORD` |
| `PersistentVolumeClaim/<release>-data` | Tomcat directory (see below) |

## Differences from docker-compose, and why

### PostGIS is deployed by this chart, not a sub-chart

openMAINT requires the PostGIS extension. The Bitnami PostgreSQL chart has never
shipped PostGIS, and its public Docker Hub images were retired — `bitnami/postgresql:17`
no longer resolves. There is no maintained upstream chart that provides PostGIS, so it
is templated directly in `templates/postgresql.yaml`.

**For production, prefer a managed PostGIS-enabled PostgreSQL:**

```bash
--set postgresql.enabled=false \
--set app.database.host=my-postgis.example.com
```

The chart fails to render if `postgresql.enabled=false` and no host is set.

### The Tomcat volume is seeded by an init container

`docker-compose.yml` mounts a named volume at `/usr/local/tomcat`. Docker populates an
empty named volume from the image; **Kubernetes does not** — a fresh PVC would mount
empty over the Tomcat install and the container would never start.

The `seed-tomcat` init container copies the image's `/usr/local/tomcat` into the PVC on
first run and writes a `.cmdbuild-seeded` marker so later starts leave it alone.

**Upgrade caveat:** like the compose named volume, the PVC then pins the webapp to the
image it was first seeded from. Bumping `image.tag` alone will *not* update the
application. To upgrade openMAINT, either delete the PVC (the database holds the data,
but on-disk config such as `gis-geoservers.json` is lost) or set
`app.persistence.enabled=false` and keep all state in PostgreSQL.

### DMS configuration runs as a sidecar

The compose README requires three `docker exec ... cmdbuild.sh restws setconfig` calls
after startup to enable attachments. The `dms-config` sidecar shares the pod's network
namespace, so it reaches the app on `127.0.0.1` exactly as `docker exec` did: it waits
for `/cmdbuild/ui` to respond, applies the three settings, then idles.

A failure there is logged as a warning and does **not** crash-loop the pod. Check it with:

```bash
kubectl logs deployment/openmaint -c dms-config -n openmaint
```

Disable with `--set app.dms.autoConfigure=false`.

### Single replica, `Recreate` strategy

CMDBuild holds workflow state in-process and the Tomcat PVC is `ReadWriteOnce`, so a
rolling update would deadlock on the volume. `replicaCount` above 1 is not supported.

### Long startup probe

The demo dump restore takes minutes. A `startupProbe` allows up to 15 minutes
(`failureThreshold: 90` × `periodSeconds: 10`) before the liveness probe takes over.

### amd64 only

The openMAINT image is `linux/amd64` only — `nodeSelector` defaults to
`kubernetes.io/arch: amd64`. Clear it with `--set nodeSelector=null` on a homogeneous cluster.

### Not included

- **pgAdmin** — a local development convenience. Use `kubectl port-forward
  svc/<release>-postgresql 5432:5432` and a local client instead.
- **Al Jazeera branding** — the patched `app.js` is 9.2 MB, far over the 1 MB ConfigMap
  limit, so the compose bind-mount approach does not translate. It would need a derived
  image with the logo and patched bundle baked in, and `image.repository`/`image.name`
  pointed at it.

## Access

The webapp is served from `/cmdbuild/ui/`. Tomcat has no ROOT application, so the bare
hostname returns 404.

```
https://<app.hostname>/cmdbuild/ui/
```

Without ingress:

```bash
kubectl port-forward svc/openmaint 8090:80 -n openmaint
# http://127.0.0.1:8090/cmdbuild/ui/
```

## Security notes

- `app.database.adminPassword` and `app.database.appPassword` must be supplied at
  install time. Use `--set`, a gitignored values file, or a secrets manager
  (Vault / External Secrets) — never commit them.
- The demo dump ships a default `admin` account. **Change its password immediately
  after first login** — it is a well-known default and the dump is public.
- The database superuser is used only by the entrypoint on first start, to create the
  database and restore the dump. The application connects as `app.database.appUser`.
- Containers run as non-root (`uid 1001` for openMAINT, `uid 70` for PostGIS).

## Common commands

```bash
helm template openmaint helm/ --debug \
  --set app.database.adminPassword=x --set app.database.appPassword=y

helm lint helm/ --set app.database.adminPassword=x --set app.database.appPassword=y

helm status openmaint -n openmaint

helm rollback openmaint -n openmaint
```
