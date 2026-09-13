{{/*
Hostname of the PostgreSQL server the application connects to.
Falls back to the in-chart PostGIS service, and fails loudly if neither
an external host nor the in-chart database is available.
*/}}
{{- define "openmaint.dbHost" -}}
{{- if .Values.app.database.host -}}
{{- .Values.app.database.host -}}
{{- else if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- else -}}
{{- fail "postgresql.enabled is false, so app.database.host must point at an external PostGIS-enabled PostgreSQL. Set it with --set app.database.host=<hostname>" -}}
{{- end -}}
{{- end -}}

{{/*
PostgreSQL superuser password. Required — the entrypoint uses it to create
the database and restore the dump on first start.
*/}}
{{- define "openmaint.adminPassword" -}}
{{- if .Values.app.database.adminPassword -}}
{{- .Values.app.database.adminPassword -}}
{{- else -}}
{{- fail "app.database.adminPassword is required. Set it at install time, e.g. --set app.database.adminPassword='<value>'" -}}
{{- end -}}
{{- end -}}

{{/*
CMDBuild application database password. Required.
*/}}
{{- define "openmaint.appPassword" -}}
{{- if .Values.app.database.appPassword -}}
{{- .Values.app.database.appPassword -}}
{{- else -}}
{{- fail "app.database.appPassword is required. Set it at install time, e.g. --set app.database.appPassword='<value>'" -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified application image reference.
*/}}
{{- define "openmaint.image" -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.image.name .Values.image.tag -}}
{{- end -}}

{{/*
Fully qualified PostGIS image reference.
*/}}
{{- define "openmaint.postgresImage" -}}
{{- printf "%s/%s:%s" .Values.postgresql.image.repository .Values.postgresql.image.name .Values.postgresql.image.tag -}}
{{- end -}}

{{/*
Common labels applied to every resource.
*/}}
{{- define "openmaint.labels" -}}
app: {{ .Release.Name }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
release: {{ .Release.Name }}
{{- end -}}
