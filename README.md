secret-provider-class-library
------
Helm library, which adds helpful functions to mount secrets on pod start by [secrets-store-csi-driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver) and chosen provider. From now on you can specify secrets as a list in your 'values.yaml' file. For the time being it supports only secrets.

## How to use it
1. First of all ensure that you have a csi driver and provider installed as described e.g. here for azure provider ([install provider](https://github.com/Azure/secrets-store-csi-driver-provider-azure/blob/master/charts/csi-secrets-store-provider-azure/README.md)) 
2. Add repository:
```
helm repo add spc https://matrus2.github.io/secret-provider-class-library/chart
```
3. Install library as dependency in `Chart.yaml`:
```
dependencies:
  - name: secret-provider-class-library
    version: 0.4.0
    repository: "https://matrus2.github.io/secret-provider-class-library/chart"
```
4. Set proper values in `values.yaml`:

```helmyaml
keyVault:
  enabled: true
  tenantId: your-tenant-id
  kvName: key-vault-name
  secrets:
    - first-secret                         # put secrets list your want to inject from keyVault
    - second-secret
  servicePrincipalSecretName: credentials  # secret name of SP
  provider: azure                          # choose your provider
  volumeName: kvsecrets                    # [Optional] volume name defaults to kvsecrets 
  spcName: secret-privider-class           # [Optional] name of secret-privider-class operator defaults to .Release.Name "secret-privider-class"
  secretsDir: /secrets                     # [Optional] path where secrets will be mounted defaults to /secrets

```
5. Create a placeholder template yaml file for secret-provider-class and put the following code:
```
# templates/secret-provider-template.yaml
{{- include  "spc.tpl" . -}}
```
6. In your deployment yaml template add volumeMount entry and volume entry:
```
# templates/deployment.yaml
kind: Deployment
apiVersion: apps/v1
...
    spec:
      containers:
        - name: example
          image: someimage:1.0.0
          {{- if .Values.keyVault.enabled }}
          volumeMounts:
          {{- include "spc.volumeMounts" . | indend 12 }}
          {{- end }}
      {{- if .Values.keyVault.enabled }}
      volumes:
      {{- include "spc.volume" . | indent 8 }}
      {{- end }}

```
7. Star this repo.

### Notes

You are welcome to contribute.

#### To do list
- add secrets;
- add certs;
- write tests;
- introduce CI;
