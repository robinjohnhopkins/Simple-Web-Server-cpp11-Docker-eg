** Original project: https://gitlab.com/eidheim/Simple-Web-Server._**
** added Dockerfile **

Simple-Web-Server
=================

A very simple, fast, multithreaded, platform independent HTTP and HTTPS server and client library implemented using C++11 and Asio (both Boost.Asio and standalone Asio can be used). Created to be an easy way to make REST resources available from C++ applications. 

See https://gitlab.com/eidheim/Simple-WebSocket-Server for an easy way to make WebSocket/WebSocket Secure endpoints in C++. Also, feel free to check out the new C++ IDE supporting C++11/14/17: https://gitlab.com/cppit/jucipp. 

### Features

* Asynchronous request handling
* Thread pool if needed
* Platform independent
* HTTPS support
* HTTP persistent connection (for HTTP/1.1)
* Client supports chunked transfer encoding
* Timeouts, if any of Server::timeout_request and Server::timeout_content are >0 (default: Server::timeout_request=5 seconds, and Server::timeout_content=300 seconds)
* Simple way to add REST resources using regex for path, and anonymous functions

### Usage

See http_examples.cpp or https_examples.cpp for example usage. 

See particularly the JSON-POST (using Boost.PropertyTree) and the GET /match/[number] examples, which are most relevant.

### Dependencies

* Boost.Asio or standalone Asio
* Boost is required to compile the examples
* For HTTPS: OpenSSL libraries 

### Compile and run

Compile with a C++11 compliant compiler:
```sh
mkdir build
cd build
cmake ..
make
cd ..
```

#### HTTP

Run the server and client examples: `./build/http_examples`

Direct your favorite browser to for instance http://localhost:8080/

#### HTTPS

Before running the server, an RSA private key (server.key) and an SSL certificate (server.crt) must be created. Follow, for instance, the instructions given here (for a self-signed certificate): http://www.akadia.com/services/ssh_test_certificate.html

Run the server and client examples: `./build/https_examples`

Direct your favorite browser to for instance https://localhost:8080/

## Docker
use Dockerfile
If you want to use https then you can alter the CMD option in Dockerfile to use https:
<code>
CMD ["./build/http_examples"]
</code>

### builds the image from the Dockerfile. -t specifies ‘name:tag'
docker build -t  helloworld:v1 .

### runs the image mapping external_port:internal_docker_port
docker run -p 8080:8080  -it --rm --name HelloWorld helloworld:v1

### use browser to access running container functionality
Direct your favorite browser to for instance 
http://localhost:8080/          maps to web/index.html
http://localhost:8080/test.html maps to web/test.html

REST GET /match/[number]   sample REST content of cpp sample
e.g.
http://localhost:8080/match/1234

otherwise static content from /web e.g. / returns web/index.html
  GET-example simulating heavy work in a separate thread
    server.resource["^/work$"]["GET"]


## Kubernetes
### Rename docker image
cd .../Simple-Web-Server
above we named the image helloworld:v1 - next we add another tag to the image id then remove the original tag
docker tag helloworld:v1 <your_docker_hub_name>/cpp11webexample:v1
docker rmi helloworld:v1
docker push <your_docker_hub_name>/cpp11webexample:v1

image is now on https://hub.docker.com/

### install kubernetes
options:
	desktop
		docker desktop for mac
		minikube - this is what I did - see Nigel Poulton ‘getting started with Kubernetes’ pluralsight
	kubeadm
	from scratch
	cloud scenarios - PaaS IaaS options

#### Installing Minikube on Mac
brew install kubectl
kubectl version --client
brew cask install minikube
brew install docker-machine-driver-xhyve
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
minikube start --vm-driver=xhyve
kubectl config current-context
kubectl get nodes
minikube stop
minikube delete
minikube start --vm-driver=xhyve --kubernetes-version="v1.6.0"
kubectl get nodes

#### get mapped tcp ports on mac
netstat -ap tcp

## kubernetes commands
$ kubectl get nodes
NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     master    6h        v1.13.2

$ kubectl describe nodes
Name:               minikube
Roles:              master
… 
Addresses:
  InternalIP:  192.xx.xx.xx
  Hostname:    minikube

Info: when a port is exposed externally, 192.xx.xx.xx above is the external ip

### The following commands get the current list of Services and then delete the Service called "hello-svc"
$ kubectl get svc
$ kubectl delete svc hello-svc

### The following commands list the "app" label attached to all running Pods and then print the contents of the "svc.yml" manifest file to the screen
$ kubectl describe pods | grep app
$ cat svc.yml

### The following command deploys a new Service from the "svc.yml". The YAML file is shown at the bottom of this document
$ kubectl create -f svc.yml

$ kubectl get svc
NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
cpp11webexample-svc   NodePort    10.99.152.22   <none>        8080:30001/TCP   7d
kubernetes            ClusterIP   10.96.0.1      <none>        443/TCP          10d

$ kubectl describe svc/cpp11webexample-svc

### create deployment from file
$ kubectl apply -f deploy.yml --record					# —record important for rollout history

### test app in browser
http://192.xx.xx.xx:30001/ 

### additional kubernetes
kubectl get all
kubectl delete  svc/hello-svc
kubectl get ep -o json
kubectl get ep -o yaml
kubectl delete rc hello-rc			# gets rid of pods as well - show as Terminating, then gone
kubectl get pods
kubectl describe deploy hello-deploy
kubectl get rs
kubectl describe rs 
kubectl rollout status deployments hello-deploy
kubectl get deploy hello-deploy
kubectl rollout history deployments hello-deploy
kubectl get rs
kubectl describe deploy hello-deploy
kubectl rollout undo deployment hello-deploy --to-revision=1
kubectl get deploy
kubectl rollout status deployments hello-deploy


## Not needed - The Replicaton Controller YAML file can be used to run up multiple instances

kubectl get pods -o wide
kubectl get pods/hello-pod
kubectl get pods --all-namespaces

kubectl delete pods/hello-pod

kubectl create -f rc.yml
kubectl get rc -o wide
kubectl describe rc
kubectl apply -f rc.yml

kubectl get rc
kubectl get pods

kubectl status
kubectl cluster-info

kubectl proxy
	serves son api in browser
	http://127.0.0.1:8001/

### minikube dashboard
ran the following which auto invoked the dashboard in a browser!
minikube dashboard


### Installing Minikube on Windows 10
#####Get the kubectl.exe binary from this URL and copy it into your %PATH%
https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/windows/amd64/kubectl.exe

##### Get the Minikube installer from GitHub
https://github.com/kubernetes/minikube/releases
Run the installer


minikube version
minikube start --vm-driver=hyperv --kubernetes-version="v1.6.0"

kubectl get nodes

minikube
minikube dashboard


###  K8s on AWS using kops
dig NS k8s.tech-force-one.com

# Install kubectl on Mac
brew install kubectl

# Install latest release of kubectl on Linux
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl


#Install "kops" on Linux
curl -LO https://github.com/kubernetes/kops/releases/download/1.5.3/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops


# Install and configure the AWS CLI on Linux     
sudo apt-get install awscli
aws configure

# Create and then list a new S3 bucket
aws s3 mb s3://cluster-1.k8s.tech-force-one.com
aws s3 ls | grep k8s

export KOPS_STATE_STORE=s3://cluster-1.k8s.tech-force-one.com    
cp ~/.ssh/authorized_keys ~/.ssh/id_rsa.pub

kops create cluster \
 --cloud=aws --zones=eu-west-1 \
 --dns-zone=k8s.tech-force-one.com \
 --name cluster-1.k8s.tech-force-one.com  --yes

 
kops validate cluster

kubectl get nodes

kops delete cluster --name=cluster-1.k8s.tech-force-one.com --yes


###  Manual install
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

apt-get install -y docker.io kubeadm kubectl kubelet kubernetes-cni

kubeadm init

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/
export KUBECONFIG=$HOME/admin.conf

kubectl get nodes

kubectl get pods --all-namespaces

kubectl apply --filename https://git.io/weave-kube-1.6

kubectl get nodes

kubectl get pods --all-namespaces

kubectl get nodes

