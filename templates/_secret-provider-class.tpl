{{- define "app.secrets" -}}
  {{- if .Values.keyVault.enabled -}}
  {{- printf "|" }}
array:
  {{- range .Values.keyVault.secrets }}
  {{ printf "- |" | indent 2 }}
  {{ printf "objectName: %s" . | indent 4 }}
  {{ printf "objectType: secret" | indent 4 }}
  {{- end }}
  {{- end -}}
{{- end -}}

{{- define "spc.tpl" -}}
{{- if .Values.keyVault.enabled }}
apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: {{ .Values.keyVault.spcName | default (printf "%s-%s" .Release.Name "secret-privider-class") }}
spec:
  provider: {{ .Values.keyVault.provider }}
  parameters:
    keyvaultName: {{.Values.keyVault.kvName}}
    tenantId: {{.Values.keyVault.tenantId}}
    objects: {{ include "app.secrets" $ | indent 6 }}
 {{- end }}
{{- end }}

{{- define "spc.volumeMounts" }}
{{- if .Values.keyVault.enabled }}
- mountPath: {{ .Values.keyVault.secretsDir | default "/secrets" }}
  name: {{ .Values.keyVault.volumeName | default "kvsecrets" }}
  readOnly: true
{{- end }}
{{- end }}

{{- define "spc.volume" }}
{{- if .Values.keyVault.enabled }}
- name: {{ .Values.keyVault.volumeName | default "kvsecrets" }}
  csi:
    driver: secrets-store.csi.k8s.io
    readOnly: true
    volumeAttributes:
      secretProviderClass: {{ .Values.keyVault.spcName | default (printf "%s-%s" .Release.Name "secret-privider-class") }}
    nodePublishSecretRef:
      name: {{ .Values.keyVault.servicePrincipalSecretName }}
{{- end -}}
{{- end }}
