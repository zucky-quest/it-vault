APM_VERSION := $(shell cat .apm-version 2>/dev/null || echo 0.31.0)
APM_BIN ?= apm
UV_BIN ?= uv

.PHONY: setup apm-install apm-compile skills-doc skills-doc-check apm-sync apm-verify apm-orphan-check

# =============================================================================
# AI エージェント設定（APM）
# =============================================================================
# SSOT は apm.yml + .apm/。生成物（AGENTS.md / .mcp.json / .codex / .claude/rules /
# skills）はコミット済みのため、利用するだけなら APM CLI は不要。
# 設定を変更する場合のみ APM CLI（$(APM_VERSION)）を導入し、編集後に make apm-sync する。
# apm-sync はスキル一覧の生成に uv も使うため、あわせて make setup が必要。

setup:
	@command -v $(UV_BIN) >/dev/null 2>&1 || python3 -m pip install --user uv
	@echo "APM version pinned: $(APM_VERSION)"
	@command -v $(APM_BIN) >/dev/null 2>&1 || echo "APM not found. Install it with: curl -sSL https://aka.ms/apm-unix | APM_INSTALL_DIR='$$HOME/.local/bin' APM_LIB_DIR='$$HOME/.local/lib/apm' sh -s -- @v$(APM_VERSION)"

apm-install:  # apm.yml/.apm を各ツールへ配備（MCP/skills/rules + apm.lock.yaml 生成）
	$(APM_BIN) install

apm-compile:  # .apm/instructions から AGENTS.md を生成
	$(APM_BIN) compile -t codex --no-links --single-agents


apm-sync: apm-install apm-compile skills-doc  # AI 設定を全再生成（.apm / apm.yml を編集したら実行）

apm-verify:  # 生成物が .apm/apm.yml と整合しているか検査（CI と同じ。再生成→差分なしを確認）
	# スキル一覧の検査は再生成より前に行う。git diff 方式は HEAD との比較なので、コミット前に
	# 一覧を手で書き換えた状態は apm-sync の再生成で消えてしまい検出できない
	# （APM 生成物は再生成→git diff で検出するため順序に依存しない）。
	$(MAKE) skills-doc-check
	$(MAKE) apm-sync
	$(APM_BIN) audit --ci --no-drift
	# .codex/config.toml は対象外: apm 0.25.0 以降 codex ターゲットの MCP 設定は
	# 実行環境の codex CLI 有無で出力が変わり非決定的なため（詳細は ci.yml のコメント参照）。
	git diff --exit-code -- AGENTS.md .mcp.json .claude/rules .claude/skills .agents/skills

apm-orphan-check:  # 生成物に供給源が無い orphan（例: ソース無しの skill）を検出
	$(UV_BIN) run python scripts/check_apm_orphans.py

# =============================================================================
# スキル評価
# =============================================================================
# Eval / Benchmark（pass 率の測定）は skill-creator とサブエージェントに依存するため
# Claude Code 上でのみ実行できる（/evaluating-skills）。以下はランタイムを問わず
# 実行できる静的ゲートで、CI でも回す。詳細は docs/develop/skill-evaluation.md。
