# AccessAbility

![](images/screenshot1.png)

## Description
**AccessAbility** provides a natural language control surface for complex apps.

Any app can register a mini-grammar with AccessAbility and allow natural language to be used to execute complex actions in the app.

## Pipeline

```mermaid
flowchart TD
    A[Speech] --> B[Speech Recognition - Swift]
    B --> D[GPT4 - OpenAI API]
    C[Preconditioning] --> D
    D --> E[Tokenizer]
    E --> F[Command Processor]
    F --> G[App Model]
    G --> D
    G --> H[View]
```

## Demo
[Here](https://youtu.be/-AF6FgfQURc) is a demo video.
