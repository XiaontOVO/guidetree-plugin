不同 paper writing 类型，不要机械套 6 个 phase。按项目类型选。
```yaml
research_type_patterns:
  conference_paper:
    required_phases:
      - Paper Planning
      - Figure Generation
      - Writing
      - Compilation
      - Improvement
    optional_phases:
      - Presentation
    note: >
      会议论文有严格页数限制和时间线。P1-P5 是必须的。P6 看是否有 poster/slides 需求。
      Improvement 至少一轮，建议两轮。

  journal_paper:
    required_phases:
      - Paper Planning
      - Figure Generation
      - Writing
      - Compilation
      - Improvement
    optional_phases:
      - Presentation
    note: >
      期刊论文没有硬性页数限制，但需要更深度的 improvement（通常 2-3 轮 review-fix）。
      Discussion section 在 journal 中通常是必须的。Figure 质量要求更高。

  workshop_paper:
    required_phases:
      - Paper Planning
      - Writing
      - Compilation
    optional_phases:
      - Figure Generation
      - Improvement
      - Presentation
    note: >
      Workshop paper 通常更短更轻量。P1+P3+P4 就够了。Figure 和 Improvement 按需加入。
      不要给 workshop paper 套 conference 级别的完整流程。

  presentation_only:
    required_phases:
      - Presentation
    optional_phases: []
    usually_skip:
      - Paper Planning
      - Figure Generation
      - Writing
      - Compilation
      - Improvement
    note: >
      只有 presentation 的情况（已有论文，只需做 slides/poster）。不要发明 paper writing phase。
      输入是已完成的论文 PDF 和素材。

  poster_only:
    required_phases:
      - Presentation
    optional_phases:
      - Paper Planning
    note: >
      只需要 poster。Presentation phase 中只做 poster generation stage，跳过 slides 和 talk prep。
      如果需要从论文中提取内容做 poster，可以加轻量 P1 来规划 poster 布局。

  thesis_chapter:
    required_phases:
      - Paper Planning
      - Figure Generation
      - Writing
      - Compilation
      - Improvement
    optional_phases:
      - Presentation
    note: >
      论文章节比普通论文长，page budget 不是硬限制，但结构规划更重要。
      Literature review 在 thesis 中更深入，Related Work section 通常更长。
```
