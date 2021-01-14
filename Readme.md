secret-provider-class-library
------
Helm library, which adds helpful functions to mount secrets on pod start by [secrets-store-csi-driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver) and chosen provider.

```helmyaml
keyVault:
  enabled: false
  secrets:
    - example
  spcName: secret-privider-class
  kvName: 'key-vault'
  provider: azure
  tenantId: 123
  secretsDir: /secrets
  volumeName: kvsecrets
  servicePrincipalSecretName: kvcreds

```
