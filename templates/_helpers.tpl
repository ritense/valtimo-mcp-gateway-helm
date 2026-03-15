{{/*
Expand the name of the chart.
*/}}
{{- define "valtimo-mcp-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "valtimo-mcp-gateway.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label.
*/}}
{{- define "valtimo-mcp-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "valtimo-mcp-gateway.labels" -}}
helm.sh/chart: {{ include "valtimo-mcp-gateway.chart" . }}
{{ include "valtimo-mcp-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "valtimo-mcp-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "valtimo-mcp-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the name of the secret containing admin credentials.
*/}}
{{- define "valtimo-mcp-gateway.adminSecretName" -}}
{{- if .Values.admin.existingSecret }}
{{- .Values.admin.existingSecret }}
{{- else }}
{{- printf "%s-admin" (include "valtimo-mcp-gateway.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the name of the secret containing database credentials.
*/}}
{{- define "valtimo-mcp-gateway.dbSecretName" -}}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else }}
{{- printf "%s-db" (include "valtimo-mcp-gateway.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the database host.
When the bundled PostgreSQL sub-chart is enabled, derive the service name
from the postgresql sub-chart's naming convention.
*/}}
{{- define "valtimo-mcp-gateway.dbHost" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" .Release.Name }}
{{- else }}
{{- required "database.host is required when postgresql.enabled is false" .Values.database.host }}
{{- end }}
{{- end }}

{{/*
Return the database password secret name when using the bundled PostgreSQL.
*/}}
{{- define "valtimo-mcp-gateway.postgresqlSecretName" -}}
{{- if .Values.postgresql.auth.existingSecret }}
{{- .Values.postgresql.auth.existingSecret }}
{{- else }}
{{- printf "%s-postgresql" .Release.Name }}
{{- end }}
{{- end }}
