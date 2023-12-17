# k8s-ho's world

## Architecture
- This is an environment created for Terraform practice.
<img width="1359" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/aaebed95-89cb-48a2-be23-3dc68d0bec56">

<br><br>

## [+] Usage
1. Move your key pair file into the "my_world" directory
<img width="731" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/d4f608ed-25f1-4306-8ecb-e773f098555b"/>
<br><br><br>
2. Change the value of the local variable to match your information.
<img width="731" alt="스크린샷 2023-12-17 오후 9 23 12" src="https://github.com/k8s-ho/my_world/assets/118821939/e663d63b-ba0e-4e23-b1d6-115d87523711">

<br><br><br>
3. Let’s run terraform!!
``` bash
chmod 600 *.pem # chmod 600 [your key pair file]
terraform init
terraform apply
```
<br>

## [!] Caution
```bash
In the case of iPhone, when using wired tethering, the public IP sometimes does not match.
Therefore, you must create an instance and put the public IP that is actually accessed through tcpdump in bastion sg.
```
<br>

## [-] Tear down
```bash
terraform destroy
```
