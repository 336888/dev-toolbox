.PHONY: help lint fmt check

help: ## 列出所有命令
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}'

lint: ## shellcheck 检查所有脚本
	@command -v shellcheck >/dev/null || { echo "需要 shellcheck：apt install shellcheck" >&2; exit 1; }
	shellcheck scripts/*.sh

fmt: ## shfmt 格式化，统一 2 空格缩进
	@command -v shfmt >/dev/null || { echo "需要 shfmt：go install mvdan.cc/sh/v3/cmd/shfmt@latest" >&2; exit 1; }
	shfmt -w -i 2 scripts/*.sh

check: lint fmt ## lint + fmt 一起跑，提交前用这个
	@echo "检查通过"
