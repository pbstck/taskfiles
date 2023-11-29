PROJECT:=REPLACE_ME

ifdef CI
	GIT_REVISION:=`echo ${GITHUB_SHA} | cut -c1-7`
else
	COMMIT_HASH:=`git rev-parse --short HEAD`
	GIT_STATE:=`git diff --quiet HEAD -- || echo "-dirty"`
	GIT_REVISION:=${COMMIT_HASH}${GIT_STATE}
endif

build:
	@echo "building project '${PROJECT}' on revision '${GIT_REVISION}'..."
	@echo "TODO"
	exit 1


test:
	@echo "testing project '${PROJECT}' on revision '${GIT_REVISION}'..."
	@echo "TODO"
	exit 1


lint/check:
	@echo "check linting rules..."
	@echo "TODO"
	exit 1


lint/format:
	@echo "applying linting rules..."
	@echo "TODO"
	exit 1


run:
	@echo "running project locally..."
	@echo "TODO"
	exit 1

deploy/dev:
	STAGE=dev UPPER_STAGE=DEV $(MAKE) -C . _terraform_apply

deploy/beta:
	STAGE=beta UPPER_STAGE=BETA $(MAKE) -C . _terraform_apply

deploy/prod:
	STAGE=prod UPPER_STAGE=PROD $(MAKE) -C . _terraform_apply

validate_infra:
	STAGE=dev UPPER_STAGE=DEV $(MAKE) -C . _terraform_validate

plan/dev:
	STAGE=dev UPPER_STAGE=DEV $(MAKE) -C . _terraform_plan

plan/beta:
	STAGE=beta UPPER_STAGE=BETA $(MAKE) -C . _terraform_plan

plan/prod:
	STAGE=prod UPPER_STAGE=PROD $(MAKE) -C . _terraform_plan

deliver:
	@echo "publishing artifacts"
	@echo "TODO"
	#Example : 	@aws s3 cp bin/dynamo-crawler.zip s3://pubstack-artifacts/dynamo-crawler/dynamo-crawler-${GIT_REVISION}.zip
	exit 1

	@echo "artifacts published!"


_bin:
	@mkdir -p bin

_retrieve_artifacts: _bin
	@echo "TODO"
	#Example : @aws s3 cp s3://pubstack-artifacts/dynamo-crawler/dynamo-crawler-${GIT_REVISION}.zip bin/dynamo-crawler.zip
	exit 1


_terraform_plan: _retrieve_artifacts
ifndef CI
	@$(error this TARGET should ONLY be called by the CI)
endif
ifndef PLAN_PATH
	@$(error this TARGET should be called with a PLAN_PATH parameter)
endif
	@echo "planning project ${PROJECT} revision ${GIT_REVISION} on stage ${STAGE} ..."
	cd infra && terraform init -reconfigure && (terraform workspace select ${STAGE} || terraform workspace new ${STAGE}) && terraform init -reconfigure && terraform plan -var git_revision=${GIT_REVISION} -out=${PLAN_PATH}

_terraform_apply: _retrieve_artifacts
ifndef CI
	@$(error this TARGET should ONLY be called by the CI)
endif
ifndef PLAN_PATH
	@$(error this TARGET should be called with a PLAN_PATH parameter)
endif
	@echo "deploying project ${PROJECT} revision ${GIT_REVISION} on stage ${STAGE} ..."
	cd infra && terraform init -reconfigure && (terraform workspace select ${STAGE} || terraform workspace new ${STAGE}) && terraform init -reconfigure && terraform apply ${PLAN_PATH}
	@echo "project ${PROJECT} deployed"

_terraform_validate: _mock_binaries
ifndef STAGE
	@$(error attempting to run command without STAGE argument)
endif
	@echo "validating project ${PROJECT} revision ${GIT_REVISION} on stage ${STAGE} ..."
	cd infra && terraform init -reconfigure && (terraform workspace select ${STAGE} || terraform workspace new ${STAGE}) && terraform validate

_mock_binaries: _bin
	@echo "TODO"
	exit 1

tag/beta:
	STAGE=beta $(MAKE) -C . _tag

tag/prod:
	STAGE=prod $(MAKE) -C . _tag

.PHONY: build test lint/check lint/format run deliver deploy/dev deploy/beta deploy/prod tag/beta tag/prod plan/dev plan/beta plan/prod

# custom targets
_tag_master_check:
ifndef TAG_NOT_MASTER
ifneq ($(shell git rev-parse --abbrev-ref HEAD),master)
	@echo 'attempting to tag non master branch, if you are sure about this rerun this command with TAG_NOT_MASTER=true'
	@exit 1
endif
endif

_tag: _tag_master_check _next_upgrade
	$(eval TAG := $(shell TZ=ETC/UTC date +%Y-%m-%dT%H-%M-%SZ-$${STAGE}))
	@echo "tagged version: $(TAG)"
	@git tag $(TAG)
	@echo "DONT FORGET TO 'git push origin $(TAG)'"

_next_upgrade:
	./scripts/next_upgrade.sh

.PHONY: _tag _tag_master_check _next_upgrade