# Heirarchy

| Symbol        | Meaning       |
|---------------|---------------|
| `△`           | Inherits from |
| `V`, `>`, `<` | Depends on    |

```

ReferenceToken
     △
     |  +---DealFactory----+
     |  |                  |
     |  V                  V
     Deal <--------- DealValidator ----> PhaseValidator
      △                                       △
      |                                       |
StaggeredDeal <------------------ StaggeredPhaseValidator
```
