.ONESHELL:

VARS="./config/prod.tfvars"
BOLD=$(shell tput bold)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

prep:
ifndef PROJECT_ID
    $(error PROJECT_ID is undefined. Please run `source env.sh`)
endif
ifndef TF_STATEBUCKET
    $(error TF_STATEBUCKET is undefined. Please run `source env.sh`)
endif
ifndef TF_WORKSPACENAME
    $(error TF_WORKSPACENAME is undefined. Please run `source env.sh`)
endif

	@if terraform workspace select $(TF_WORKSPACENAME) && [ -d .terraform/plugins ]; then
		@echo "\nWorkspace $(YELLOW)$(BOLD)$(TF_WORKSPACENAME)$(RESET) already initialized\n"
	else
		@echo "Initializing workspace $(YELLOW)$(BOLD)$(TF_WORKSPACENAME)$(RESET)\n";\
		terraform init \
			# -backend=true \
			# -backend-config="bucket=$(TF_STATEBUCKET)" \
            -upgrade \
            -reconfigure;\
		terraform workspace select $(TF_WORKSPACENAME) || terraform workspace new $(TF_WORKSPACENAME); \
	fi

plan: prep
	@terraform plan \
		-var-file="$(VARS)"

apply: prep
	@terraform apply \
		-var-file="$(VARS)"

destroy: prep
	@terraform destroy\
        -var-file="$(VARS)"

