# agent-orchestrator

Skill para o Claude Code com um agente principal que divide tarefas, delega a subagentes focados e pode criar novos agentes e skills.

## Instalar em uma máquina nova

Pré-requisitos: Git, PowerShell 7 (`pwsh`) e Claude Code.

```bash
git clone git@github.com:camargoz/agent-orchestrator.git
cd agent-orchestrator
pwsh -NoProfile -File install.ps1
```

Isso copia a skill para `~\.claude\skills\orchestrator`. Ela fica disponível em **todos os projetos** dessa máquina. Reinicie o Claude Code depois.

### Só em um projeto

```bash
pwsh -NoProfile -File install.ps1 -ProjectRoot "C:\caminho\do\projeto"
```

A skill vai para `<projeto>\.claude\skills\orchestrator`. Se quiser versionar essa instalação junto do projeto, faça commit dessa pasta.

### Atualizar

```bash
git pull
pwsh -NoProfile -File install.ps1
```

## Usar

Em qualquer projeto, peça ao Claude algo como:

- "Use o orchestrator para dividir esta tarefa entre agentes."
- "Liste os agentes e skills disponíveis neste projeto."
- "Crie um agente para revisar testes de performance."

O agente principal lê `.claude/agents/` e `.claude/skills/` do projeto em que você está, além dos globais em `~\.claude\`.

## Estrutura

```
skills/orchestrator/
├── SKILL.md              # regras do agente principal
├── templates/
│   ├── agent.md.tmpl     # molde para novos agentes
│   └── skill.md.tmpl     # molde para novas skills
└── scripts/
    └── catalog.ps1       # lista agentes e skills disponíveis
install.ps1               # instala a skill em global ou em um projeto
```

## Observações

- Subagentes não criam subagentes: a orquestração é de um nível.
- Agentes criados na sessão podem exigir reiniciar o Claude Code para aparecer como `subagent_type`. Enquanto isso, o orquestrador usa o prompt do arquivo `.md` num subagente genérico.
- Agentes e skills criados em `<projeto>\.claude\` ficam no repositório desse projeto. Os criados em `~\.claude\` ficam só na máquina.
