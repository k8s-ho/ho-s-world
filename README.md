# k8s-ho's world

## Architecture
- This is an environment created for Terraform practice.
<img width="1359" alt="aba" src="https://github.com/k8s-ho/my_world/assets/118821939/bef3c2d5-da34-464e-82e6-d2b56beec836">

<br><br>

## [+] Usage
1. Move your key pair file into the "my_world" directory
<img width="731" alt="abc" src="https://github.com/k8s-ho/my_world/assets/118821939/d4f608ed-25f1-4306-8ecb-e773f098555b"/>
<br><br><br>
2. Change the value of the local variable to match your information.
<img width="731" alt="ccc" src="https://github.com/k8s-ho/my_world/assets/118821939/75bff852-b64d-4aa1-b625-7a9eb8946b9d">

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
