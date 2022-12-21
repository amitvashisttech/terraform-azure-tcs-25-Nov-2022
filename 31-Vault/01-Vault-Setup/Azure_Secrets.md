## In order to enable Azure Secret Engine in Vault, we have to follow the below steps: 


#### 1. Login to Azure Portal
#### 2. Go to Azure AD & Note the Tenant_ID
#### 3. Go to Azure AD -> App Registrations -> New Registrations -> Name : vault-testing -> Register -> Note the Application ClientID. 
#### 4. Go to Azure AD -> Certificate & Secrets -> Client Secrets -> New Secrets -> Add, Note Secret_Value. 
#### 5. Go to Azure AD -> API Permission -> Microsoft Graph -> Add the Following Permissions: 
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
