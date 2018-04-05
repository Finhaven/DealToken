# Heirarchy

| Symbol        | Meaning       | Memonic |
|---------------|---------------|---------|
| `△`           | Inherits from | "is a"  |
| `V`, `>`, `<` | Depends on    | "has a" |

```
TOKENS         FACTORIES             VALIDATORS

  (EIP-902)
ReferenceToken
     △
     | +----- DealFactory ----> TokenValidator
     | |                             △    △
     | |                             |    |
     | |+------------------ DealValidator |
     | ||                         |       |
     | VV                         V       |
     Deal <-------------------- PhaseValidator
     △                                    △
     |                                    |
StaggeredDeal <------- StaggeredPhaseValidator
```
