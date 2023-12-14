# k8s-ho's world

## Architecture
<img width="1359" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/aaebed95-89cb-48a2-be23-3dc68d0bec56">

<br><br>

## Usage
1. Move your key pair file into the "my_world" directory
<img width="731" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/d4f608ed-25f1-4306-8ecb-e773f098555b"/>
<br><br><br>
2. Change the default value of the "key_name" variable in "main.tf" to your key pair name.
<img width="731" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/382eb832-fa80-4bdf-abae-ce547b8b09a5"/>

<br><br><br>
3. Let’s run terraform!!
``` bash
chmod 600 *.pem # chmod 600 [your key pair file]
terraform init
terraform apply
```
<br>

## tear down
```bash
terraform destroy
```
