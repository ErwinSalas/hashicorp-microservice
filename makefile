tf-apply: 
	cd terraform && terraform apply

packer-build: 
	cd packer && packer init image.pkr.hcl && packer build -var-file=variables.hcl image.pkr.hcl  

nomad-token:
	cd terraform && ../shared/scripts/post-setup.sh

bind-nomad:
	cd terraform && export NOMAD_ADDR=$(terraform output -raw lb_address_consul_nomad):4646 && export NOMAD_TOKEN=$(cat nomad.token)

deploy-product:
	nomad run ./nomad/products-service.nomad 

deploy-auth:
	nomad run ./nomad/auth-service.nomad 

deploy-api:
	nomad run ./nomad/api-gateway.nomad 

deploy-orders:
	nomad run ./nomad/orders-service.nomad 

fmt-nomad: 
	nomad fmt ./nomad


init:
	make tf-apply && make nomad-token && make bind-nomad
	