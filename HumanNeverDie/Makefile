# 환경변수 설정
ISDEV ?= false

# Tuist 환경변수 설정
ifeq ($(ISDEV),true)
   TUIST_ENV = TUIST_IS_DEV=true
else
   TUIST_ENV = TUIST_IS_DEV=false
endif

install:
	@make close_xcode
	@echo "\033[34m[1/4] Running 'tuist clean'...\033[39m"
	@make clean
	@echo "\033[34m[2/4] Running 'tuist install'...\033[39m"
	@make fetch
	@echo "\033[34m[3/4] Running 'tuist generate'...\033[39m"
	@make generate_no_open
	@echo "\033[34m[4/4] Running 'tuist graph'...\033[39m"
	@make open_xcode
	@echo "\033[32mCompleted!\033[39m"

clean:
	@tuist clean
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

edit:
	@tuist edit

fetch:
	@tuist install

depency_graph:
	@tuist graph --skip-external-dependencies

generate_no_open:
	@$(TUIST_ENV) tuist generate --no-open
	
generate:
	@$(TUIST_ENV) tuist generate
	
open_xcode:
	@open Modulerproject.xcworkspace
	
close_xcode:
	-@pkill -x Xcode

feature:
	@echo "$(YELLOW)📱 Feature 생성$(NC)"
	@echo ""
	@read -p "Feature 이름: " feature_name; \
	if [ -z "$$feature_name" ]; then \
		echo "$(RED)❌ Feature 이름이 필요합니다$(NC)"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "$(GREEN)✨ Creating feature: $$feature_name$(NC)"; \
	tuist scaffold feature --name $$feature_name; \
	python3 scripts/add_feature_dependency.py $$feature_name; \
	tuist generate
	
domain:
	@echo "$(YELLOW)📱 Domain 생성$(NC)"
	@echo ""
	@read -p "Domain 이름: " domain_name; \
	if [ -z "$$domain_name" ]; then \
		echo "❌ Domain 이름이 필요합니다"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "✨ Creating domain: $$domain_name"; \
	tuist scaffold domain --name $$domain_name; \
	python3 scripts/add_domain_dependency.py $$domain_name; \
	tuist generate
