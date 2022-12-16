# We need to setup a new virtual machine for our Vault Demo. 

## Create a resource group
```
az group create --name vault-rg --location eastus
```

## Create a virtual machine
```
az vm create --resource-group vault-rg  --name vaultVM --image "UbuntuLTS"  --admin-username azureuser    --admin-password Pass@word1234! --size="Standard_D2s_v3"
```

## Login to the VM 
```
ssh <username>@<public-ip>
```


# Let Install Vault

## Update APT Repo 
```
sudo apt update && sudo apt install gpg
```

## GPG Key 
```
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

## Adding Vault Repo 
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

## Installing Vault
```
sudo apt update && sudo apt install vault
```

## Verify Vault is installed 
```
vault --help
```



## Start Vault in a Dev Mode
```
nohup vault server -dev > vault_output.txt &
```

## Export Vault Variables 
```
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXX" 
```

## Check Vault Status 
```
vault status
```



## Let create a our First Secrets 
```
vault kv put -mount=secret hello foo=world
```

## To Read / Get the Secrets
```
vault kv get -mount=secret hello
```

# To Update the existing Secrets
```
vault kv put -mount=secret hello foo=world amit=vashist
```

## To Read / Get the Updated Secrets
```
vault kv get -mount=secret hello
```

