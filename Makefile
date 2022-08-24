NAME   := resec
IMG    := pruiz/${NAME}
SRC    := johnalotoski/${NAME}
REV    ?= master
VER    ?= ${REV}
CID    := $$(git log -1 --pretty=%h)

checkout:
	@[ -d src ] || git clone https://github.com/${SRC} src
	@(cd src && git checkout ${REV})
	@(cd src && git pull)

build: RESEC_VERSION=${VER}-$(shell cd src; git log -1 --pretty=%h)
build: checkout
	@docker build -t ${IMG} --build-arg RESEC_VERSION=${RESEC_VERSION} src
	@docker tag ${IMG} ${IMG}:${CID}
	@docker tag ${IMG} ${IMG}:${VER}
	@docker tag ${IMG} ${IMG}:${RESEC_VERSION}

push: RESEC_VERSION=${VER}-$(shell cd src; git log -1 --pretty=%h)
push:
	@docker push ${IMG}:${VER}
	@docker push ${IMG}:${RESEC_VERSION}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
