# Remote backup tool

## Register the remote service
Go for a declaration of the remote service inside .ssh/config file

## Use a SSH public key for a passwordless authentication
Generate a public/private ssh key pair, then copy/paste toyr complete (with mail address) key inside :
.ssh/authorized_keys

## Activate the script before direct use :
```chmod +x backup_script.sh```

## Change the settings
```
service_name="cinevoraces"
distant_directory="/home/ubuntu/cinevoraces_infra/backup"
local_directory="/home/rasbpi/cinevoraces-backups"
max_items=100
```

## Add it as a native function, registering it in your .bashrc file :
```
backup_cinevoraces(){
  copy & paste the script content here
}
```
Don't forget to reload your modified .bashrc
```source ~/.bashrc```

## Add a cronjob for automation
```crontab -e```\

Then add your cronjob line :\

```0 4 * * * /bin/bash -c "backup_cinevoraces"```
