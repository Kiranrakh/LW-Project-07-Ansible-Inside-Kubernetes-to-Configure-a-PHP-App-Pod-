# 🚀 PHP App Deployment on Kubernetes using Ansible Inside Pod (Minikube + EC2)

---

## 🔧 Setup Environment (on EC2 Ubuntu 22.04)

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# Install Docker
sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

---

## 🚀 Start Minikube with Docker

```bash
minikube start --driver=docker
```

---

## 🐳 Build Custom PHP Image with SSH

```bash
cd ~/LW-Project-07
docker build -t php-app-with-ssh .
```

---

## 📦 Apply Kubernetes Pods

```bash
cd ~/LW-Project-07/k8s
kubectl apply -f php-app-pod.yaml
kubectl apply -f ansible-pod.yaml
```

---

## 🔍 Check Pods & IPs

```bash
kubectl get pods -o wide
```

---

## ⚙️ Setup Inside Ansible Pod

```bash
kubectl exec -it ansible -- bash
apt update
apt install -y ansible sshpass openssh-client python3
mkdir /ansible && cd /ansible
```

---

## ⚙️ Setup Inside PHP Pod

```bash
kubectl exec -it php-app -- bash
apt update
apt install -y openssh-server python3
echo 'root:root' | chpasswd
service ssh start
```

---

## 🧠 Inside Ansible Pod — Prepare Hosts File

```bash
cd /ansible
echo -e "[web]\n<php-pod-IP> ansible_connection=ssh ansible_user=root ansible_password=root ansible_python_interpreter=/usr/bin/python3" > hosts
export ANSIBLE_HOST_KEY_CHECKING=False
```

---

## 📂 Add File to Be Copied

```bash
mkdir files
cd files
nano profile.php  # add HTML+PHP content
```

---

## 🚀 Run Ansible Commands

```bash
ansible -i hosts all -m ping
ansible-playbook -i hosts playbook.yml
```

---

## 🌐 Expose PHP App via NodePort

```bash
kubectl apply -f php-app-service.yaml
minikube service php-app --url
```

---

## 📞 Fix Apache Permissions Inside PHP Pod (if 403 Forbidden)

```bash
kubectl exec -it php-app -- bash
cd /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
service apache2 restart
```

---

## 🌍 Access App in Browser

```
http://<EC2_Public_IP>:<NodePort>
```
