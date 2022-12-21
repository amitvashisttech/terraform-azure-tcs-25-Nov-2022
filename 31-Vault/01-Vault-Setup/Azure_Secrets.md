## In order to enable Azure Secret Engine in Vault, we have to follow the below steps: 


#### 1. Login to Azure Portal
#### 2. Go to Azure AD & Note the Tenant_ID
#### 3. Go to Azure AD -> App Registrations -> New Registrations -> Name : vault-testing -> Register -> Note the Application ClientID. 
#### 4. Go to Azure AD -> Certificate & Secrets -> Client Secrets -> New Secrets -> Add, Note Secret_Value. 
#### 5. Go to Azure AD -> API Permission -> Microsoft Graph -> Add the Following Permissions: -> Grant admin consent for Default Directory
```
Permission                    NameType
Application.Read.All          Delegated
Application.ReadWrite.All     Delegated
Directory.AccessAsUser.All    Delegated
Directory.Read.All            Delegated
Directory.ReadWrite.All	      Delegated
Group.Read.All	              Delegated
Group.ReadWrite.All           Delegated
GroupMember.Read.All          Delegated
GroupMember.ReadWrite.All     Delegated
```

```
Permission                    Name	Type
Application.Read.All	        Application
Application.ReadWrite.All	    Application
Application.ReadWrite.OwnedBy Application
Directory.Read.All	          Application
Directory.ReadWrite.All	      Application
Group.Read.All	              Application
Group.ReadWrite.All	          Application
GroupMember.Read.All	        Application
GroupMember.ReadWrite.All	    Application
```

#### 6. Go to Search Bar -> Subscription -> Note Subscription_ID
#### 7. Go to Search Bar -> Subscription -> IAM -> Add role assignment -> Select Owner -> Select Member -> vault-testing -> Review + Submit. 
#### 8. Go to Search Bar -> Resource Group -> vault-testing




## Configure Vault to Use Azure AD. 

#### Enable the Azure Secrets Engine 

```
vault secrets list 
vault secrets enable azure
```

#### Export Azure Variables
```
export TENANT_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	
export CLIENT_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
export CLIENT_SECRET="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export SUBSCRIPTION_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

#### Configure Azure Secret Engine
```
vault write azure/config     subscription_id=$SUBSCRIPTION_ID     tenant_id=$TENANT_ID     client_id=$CLIENT_ID     client_secret=$CLIENT_SECRET     use_microsoft_graph_api=true
```

#### Create a Role
```
vault write azure/roles/my-role ttl=1h azure_roles=-<<EOF
    [
        {
            "role_name": "Contributor",
            "scope":  "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/vault-testing"
        }
    ]
   EOF

```

#### Request Azure Credentials 
```
 vault read azure/creds/my-role
```


#### Add a Wirte App Policy 
```
vault policy write apps - <<EOF
 path "azure/creds/my-role" {
  capabilities = [ "read" ]
 }
 EOF
 ```

#### Create a variable named APPS_TOKEN to capture the token created with the apps policy attached.
```
APPS_TOKEN=$(vault token create -policy=apps -field=token)
```

#### Read credentials from the my-role azure role with the APPS_TOKEN.
```
VAULT_TOKEN=$APPS_TOKEN vault read azure/creds/my-role
```


#### Manage leases
```
vault list sys/leases/lookup/azure/creds/my-role
LEASE_ID=$(vault list -format=json sys/leases/lookup/azure/creds/my-role | jq -r ".[0]")
echo $LEASE_ID
```
```
vault lease renew azure/creds/my-role/$LEASE_ID
vault list sys/leases/lookup/azure/creds/my-role
echo $LEASE_ID
vault list sys/leases/lookup/azure/creds/my-role
```
```
VAULT_TOKEN=$APPS_TOKEN vault read azure/creds/my-role
vault lease revoke azure/creds/my-role/$LEASE_ID
vault list sys/leases/lookup/azure/creds/my-role
```
