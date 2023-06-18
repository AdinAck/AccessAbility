# AccessAbility

![](https://help.apple.com/assets/6328D0A352ABD30BF956EBB2/6328D0B152ABD30BF956EBDF/en_GB/2b2f66e61ae2036a31e141807277a025.png)

![](images/screenshot1.png)

## Description
**AccessAbility** provides a natural language control surface for complex apps.

Any app can register a mini-grammar with AccessAbility and allow natural language to be used to execute complex actions in the app.

## Pipeline

```mermaid
graph LR

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
B --> D
C --> D
D --> E
E --> F
F --> G
```