# AccessAbility

![](https://help.apple.com/assets/6328D0A352ABD30BF956EBB2/6328D0B152ABD30BF956EBDF/en_GB/2b2f66e61ae2036a31e141807277a025.png)

![](images/screenshot1.png)

## Description
**AccessAbility** provides a natural language control surface for complex apps.

Any app can register a mini-grammar with AccessAbility and allow natural language to be used to execute complex actions in the app.

## Pipeline

```mermaid
graph TD

subgraph User
  A[Speech]
end

subgraph SpeechRecognition
  B[Speech Recognition]
end

subgraph Preconditioning
  C[Preconditioning]
end

subgraph LLM
  D[LLM]
end

subgraph Tokenizer
  E[Tokenizer]
end

subgraph CommandProcessor
  F[Command Processor]
end

subgraph AppModel
  G[App Model]
end

A --> B
B --> C
C --> D
D --> E
E --> F
F --> G

style User fill:#E6F3FF, stroke:#2470A0
style SpeechRecognition fill:#E6F3FF, stroke:#2470A0
style Preconditioning fill:#E6F3FF, stroke:#2470A0
style LLM fill:#E6F3FF, stroke:#2470A0
style Tokenizer fill:#E6F3FF, stroke:#2470A0
style CommandProcessor fill:#E6F3FF, stroke:#2470A0
style AppModel fill:#E6F3FF, stroke:#2470A0
```