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
apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: {{ .Values.keyVault.spcName }}
spec:
  provider: {{ .Values.keyVault.provider }}
  parameters:
    keyvaultName: {{.Values.keyVault.kvName}}
    tenantId: {{.Values.keyVault.tenantId}}
    objects: {{ include "app.secrets" $ | indent 6 }}
  {{- end }}

{{- define "spc.volumeMounts" }}
- mountPath: {{ .Values.keyVault.secretsDir }}
  name: {{ .Values.keyVault.volumeName }}
  readOnly: true
{{- end }}

{{- define "spc.volume" }}
- name: {{ .Values.keyVault.volumeName }}
  csi:
    driver: secrets-store.csi.k8s.io
    readOnly: true
    volumeAttributes:
      secretProviderClass: {{ .Values.keyVault.spcName }}
    nodePublishSecretRef:
      name: {{ .Values.keyVault.servicePrincipalSecretName }}
{{- end -}}
