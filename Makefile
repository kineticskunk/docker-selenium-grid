NAME := kineticskunk
VERSION := $(or $(VERSION),$(VERSION),3.0.1-einsteinium-kineticskunk)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),SeleniumHQ-KineticSkunk)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chrome firefox phantomjs chrome_debug firefox_debug maven_chrome maven_firefox toolium_chrome toolium_firefox 

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_phantomjs \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_maven_firefox \
	generate_maven_chrome \
	generate_toolium_firefox \
	generate_toolium_chrome

build: all

ci: build test

base:
	cd ./Base && docker build $(BUILD_ARGS) -t $(NAME)/base:$(VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

hub: base generate_hub
	cd ./Hub && docker build $(BUILD_ARGS) -t $(NAME)/hub:$(VERSION) .

generate_nodebase:
	cd ./NodeBase && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

nodebase: base generate_nodebase
	cd ./NodeBase && docker build $(BUILD_ARGS) -t $(NAME)/node-base:$(VERSION) .

generate_chrome:
	cd ./NodeChrome && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome: nodebase generate_chrome
	cd ./NodeChrome && docker build $(BUILD_ARGS) -t $(NAME)/node-chrome:$(VERSION) .

generate_firefox:
	cd ./NodeFirefox && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox: nodebase generate_firefox
	cd ./NodeFirefox && docker build $(BUILD_ARGS) -t $(NAME)/node-firefox:$(VERSION) .

generate_maven_firefox:
	cd ./NodeMavenFirefox && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

maven_firefox: generate_maven_firefox firefox
	cd ./NodeMavenFirefox && docker build $(BUILD_ARGS) -t $(NAME)/node-maven-firefox:$(VERSION) .

generate_maven_chrome:
	cd ./NodeMavenChrome && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

maven_chrome: generate_maven_chrome chrome
	cd ./NodeMavenChrome && docker build $(BUILD_ARGS) -t $(NAME)/node-maven-chrome:$(VERSION) .

generate_toolium_firefox:
	cd ./NodeTooliumFirefox && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

toolium_firefox: generate_toolium_firefox firefox
	cd ./NodeTooliumFirefox && docker build $(BUILD_ARGS) -t $(NAME)/node-toolium-firefox:$(VERSION) .

generate_toolium_chrome:
	cd ./NodeTooliumChrome && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

toolium_chrome: generate_toolium_chrome chrome
	cd ./NodeTooliumChrome && docker build $(BUILD_ARGS) -t $(NAME)/node-toolium-chrome:$(VERSION) .

generate_chrome_debug:
	cd ./NodeDebug && ./generate.sh NodeChromeDebug node-chrome Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome_debug: generate_chrome_debug chrome
	cd ./NodeChromeDebug && docker build $(BUILD_ARGS) -t $(NAME)/node-chrome-debug:$(VERSION) .

generate_firefox_debug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox_debug: generate_firefox_debug firefox
	cd ./NodeFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/node-firefox-debug:$(VERSION) .

generate_phantomjs:
	cd ./NodePhantomJS && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

phantomjs: nodebase generate_phantomjs
	cd ./NodePhantomJS && docker build $(BUILD_ARGS) -t $(NAME)/node-phantomjs:$(VERSION) .

tag_latest:
	docker tag $(NAME)/base:$(VERSION) $(NAME)/base:latest
	docker tag $(NAME)/hub:$(VERSION) $(NAME)/hub:latest
	docker tag $(NAME)/node-base:$(VERSION) $(NAME)/node-base:latest
	docker tag $(NAME)/node-chrome:$(VERSION) $(NAME)/node-chrome:latest
	docker tag $(NAME)/node-firefox:$(VERSION) $(NAME)/node-firefox:latest
	docker tag $(NAME)/node-phantomjs:$(VERSION) $(NAME)/node-phantomjs:latest
	docker tag $(NAME)/node-chrome-debug:$(VERSION) $(NAME)/node-chrome-debug:latest
	docker tag $(NAME)/node-firefox-debug:$(VERSION) $(NAME)/node-firefox-debug:latest
	docker tag $(NAME)/node-maven-chrome:$(VERSION) $(NAME)/node-maven-chrome:latest
	docker tag $(NAME)/node-maven-firefox:$(VERSION) $(NAME)/node-maven-firefox:latest
	docker tag $(NAME)/node-toolium-chrome:$(VERSION) $(NAME)/node-toolium-chrome:latest
	docker tag $(NAME)/node-toolium-firefox:$(VERSION) $(NAME)/node-toolium-firefox:latest

release_latest:
	docker push $(NAME)/base:latest
	docker push $(NAME)/hub:latest
	docker push $(NAME)/node-base:latest
	docker push $(NAME)/node-chrome:latest
	docker push $(NAME)/node-firefox:latest
	docker push $(NAME)/node-phantomjs:latest
	docker push $(NAME)/node-chrome-debug:latest
	docker push $(NAME)/node-firefox-debug:latest
	docker push $(NAME)/node-maven-chrome:latest
	docker push $(NAME)/node-maven-firefox:latest
	docker push $(NAME)/node-toolium-chrome:latest
	docker push $(NAME)/node-toolium-firefox:latest

tag_major_minor:
	docker tag $(NAME)/base:$(VERSION) $(NAME)/base:$(MAJOR)
	docker tag $(NAME)/hub:$(VERSION) $(NAME)/hub:$(MAJOR)
	docker tag $(NAME)/node-base:$(VERSION) $(NAME)/node-base:$(MAJOR)
	docker tag $(NAME)/node-chrome:$(VERSION) $(NAME)/node-chrome:$(MAJOR)
	docker tag $(NAME)/node-firefox:$(VERSION) $(NAME)/node-firefox:$(MAJOR)
	docker tag $(NAME)/node-phantomjs:$(VERSION) $(NAME)/node-phantomjs:$(MAJOR)
	docker tag $(NAME)/node-chrome-debug:$(VERSION) $(NAME)/node-chrome-debug:$(MAJOR)
	docker tag $(NAME)/node-firefox-debug:$(VERSION) $(NAME)/node-firefox-debug:$(MAJOR)


	docker tag $(NAME)/node-maven-chrome:$(VERSION) $(NAME)/node-maven-chrome:$(MAJOR)
	docker tag $(NAME)/node-maven-firefox:$(VERSION) $(NAME)/node-maven-firefox:$(MAJOR)

	docker tag $(NAME)/node-toolium-chrome:$(VERSION) $(NAME)/node-toolium-chrome:$(MAJOR)
	docker tag $(NAME)/node-toolium-firefox:$(VERSION) $(NAME)/node-toolium-firefox:$(MAJOR)


	docker tag $(NAME)/base:$(VERSION) $(NAME)/base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/hub:$(VERSION) $(NAME)/hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-base:$(VERSION) $(NAME)/node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-chrome:$(VERSION) $(NAME)/node-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-firefox:$(VERSION) $(NAME)/node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-phantomjs:$(VERSION) $(NAME)/node-phantomjs:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-chrome-debug:$(VERSION) $(NAME)/node-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-firefox-debug:$(VERSION) $(NAME)/node-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-maven-chrome:$(VERSION) $(NAME)/node-maven-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-maven-firefox:$(VERSION) $(NAME)/node-maven-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-toolium-chrome:$(VERSION) $(NAME)/node-toolium-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-toolium-firefox:$(VERSION) $(NAME)/node-toolium-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/base:$(VERSION) $(NAME)/base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/hub:$(VERSION) $(NAME)/hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-base:$(VERSION) $(NAME)/node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-chrome:$(VERSION) $(NAME)/node-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-firefox:$(VERSION) $(NAME)/node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-phantomjs:$(VERSION) $(NAME)/node-phantomjs:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-chrome-debug:$(VERSION) $(NAME)/node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-firefox-debug:$(VERSION) $(NAME)/node-firefox-debug:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-phantomjs | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-phantomjs version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-maven-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-maven-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-maven-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-maven-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-toolium-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-toolium-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/node-toolium-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/node-toolium-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/base:$(VERSION)
	docker push $(NAME)/hub:$(VERSION)
	docker push $(NAME)/node-base:$(VERSION)
	docker push $(NAME)/node-chrome:$(VERSION)
	docker push $(NAME)/node-firefox:$(VERSION)
	docker push $(NAME)/node-phantomjs:$(VERSION)
	docker push $(NAME)/node-chrome-debug:$(VERSION)
	docker push $(NAME)/node-firefox-debug:$(VERSION)
	docker push $(NAME)/node-maven-chrome:$(VERSION)
	docker push $(NAME)/node-maven-firefox:$(VERSION)
	docker push $(NAME)/node-toolium-chrome:$(VERSION)
	docker push $(NAME)/node-toolium-firefox:$(VERSION)
	docker push $(NAME)/base:$(MAJOR)
	docker push $(NAME)/hub:$(MAJOR)
	docker push $(NAME)/node-base:$(MAJOR)
	docker push $(NAME)/node-chrome:$(MAJOR)
	docker push $(NAME)/node-firefox:$(MAJOR)
	docker push $(NAME)/node-phantomjs:$(MAJOR)
	docker push $(NAME)/node-chrome-debug:$(MAJOR)
	docker push $(NAME)/node-firefox-debug:$(MAJOR)
	docker push $(NAME)/node-maven-chrome:$(MAJOR)
	docker push $(NAME)/node-maven-firefox:$(MAJOR)
	docker push $(NAME)/node-toolium-chrome:$(MAJOR)
	docker push $(NAME)/node-toolium-firefox:$(MAJOR)
	docker push $(NAME)/base:$(MAJOR).$(MINOR)
	docker push $(NAME)/hub:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-phantomjs:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-maven-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-maven-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-toolium-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/node-toolium-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/hub:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-phantomjs:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-maven-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-maven-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-toolium-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/node-toolium-firefox:$(MAJOR_MINOR_PATCH)

test:
	VERSION=$(VERSION) ./test.sh
	VERSION=$(VERSION) ./test.sh debug

.PHONY: \
	all \
	base \
	build \
	chrome \
	chrome_debug \
	ci \
	firefox \
	firefox_debug \
	phantomjs \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_phantomjs \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_maven_chrome \
	generate_maven_firefox \
	generate_toolium_chrome \
	generate_toolium_firefox \
	hub \
	nodebase \
	release \
	maven_chrome \
	maven_firefox \
	toolium_chrome_debug \
	toolium_firefox_debug \
	tag_latest \
	test
