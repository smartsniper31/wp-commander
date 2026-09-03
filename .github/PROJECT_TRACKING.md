# 📊 WP Commander - Project Tracking & Management

**Central Hub** pour tracking de tous les tasks, issues, et progrès du projet.

---

## 🎯 How to Use This System

### 1. **GitHub Issues** (Bug/Feature Requests)
**Location**: [GitHub Issues](../../issues)

### 2. **GitHub Projects** (Workflow Management)
**Location**: [GitHub Projects](../../projects)

Structure:
- **PHASE 0 - Blockers Critiques** (Sept 1-16)
- **PHASE 1 - Quality & Polish** (Sept 17-Oct 7)
- **PHASE 2 - Launch Prep** (Oct 8-14)
- **PHASE 3 - Launch** (Oct 15-21)
- **PHASE 4 - Post-Launch** (Oct 22+)

### 3. **Milestones** (Timeline Tracking)
**Location**: [Milestones](../../milestones)

Chaque phase = milestone avec deadline.

### 4. **Discussions** (Q&A & Knowledge Base)
**Location**: [Discussions](../../discussions)

Pour decisions, architectural discussions, troubleshooting.

---

## 📋 Task Lifecycle

```
BACKLOG → IN PROGRESS → IN REVIEW → DONE
```

### Status Definitions

| Status | Meaning | Owner Action |
|--------|---------|--------------|
| **Backlog** | Planifié, pas commencé | Attendre priorité |
| **In Progress** | Actuellement en cours | Updater progress regulièrement |
| **In Review** | Code review/QA en cours | Adresser feedback |
| **Done** | Complet & merged | Checklist validée |

---

## 🔄 Weekly Workflow

### Monday (Start of Week)
- [ ] Review sprint goals
- [ ] Assign tasks for week
- [ ] Update status labels
- [ ] Identify blockers

### Wednesday (Mid-Week)
- [ ] Progress check-in (50% tasks done?)
- [ ] Resolve blockers
- [ ] Adjust timeline if needed

### Friday (End of Week)
- [ ] Complete assigned tasks
- [ ] Code review & merge
- [ ] Move tasks to Done
- [ ] Prepare status report

---

## 📌 Label Convention

### Priority Labels
```
priority:critical  - Must do this week (blockers)
priority:high      - Important, do this sprint
priority:medium    - Nice to have, next sprint
priority:low       - Backlog, future consideration
```

### Phase Labels
```
phase:0     - Blockers Critiques
phase:1     - Quality & Polish
phase:2     - Launch Prep
phase:3     - Launch
phase:4     - Post-Launch
```

### Category Labels
```
security    - Security-related
testing     - Tests & QA
documentation - Docs
devops      - CI/CD, deployment
design      - UI/UX, branding
legal       - Compliance, legal
bug         - Bug fixes
feature     - New feature
```

### Type Labels
```
blocker     - Blocks other tasks
breaking    - Breaking change
tech-debt   - Technical debt
enhancement - Improvement
```

---

## 🔍 Issue Template (GitHub)

When creating issue, use template:

```markdown
## Description
[Clear description of task/issue]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Files/Areas Affected
- `path/to/file1.dart`
- `path/to/file2.php`

## Dependencies
Blocks/Depends on: [Issue #XX]

## Estimated Effort
- [ ] 1 day
- [ ] 2-3 days
- [ ] 1 week
- [ ] 2+ weeks

## Notes
[Additional context]
```

---

## 📝 Commit Message Convention

### Format
```
[PHASE-X] [CATEGORY] Brief description (#IssueNumber)

Longer description with details...

Closes #IssueNumber
```

### Examples
```
[PHASE-0] [security] Implement JWT authentication (#1)
[PHASE-0] [assets] Generate app screenshots (#2)
[PHASE-1] [testing] Add API service tests (#14)
[PHASE-2] [marketing] Create CodeCanyon thumbnail (#18)
```

### Commit Prefixes
```
feat:    New feature implementation
fix:     Bug fix
docs:    Documentation
test:    Test additions
refactor: Code refactoring
chore:   Build, dependencies
ci:      CI/CD changes
perf:    Performance improvement
```

---

## 🚀 Pull Request Workflow

### PR Title Format
```
[PHASE-X] [CATEGORY] Brief description
```

### PR Description Template
```markdown
## 🔗 Related Issue
Fixes #XXX

## 📝 Description
What does this PR do?

## 🔍 Changes Made
- [ ] Change 1
- [ ] Change 2
- [ ] Change 3

## ✅ Checklist
- [ ] Code follows style guide
- [ ] All tests passing
- [ ] New tests added (if needed)
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Performance impact: [none/minimal/significant]

## 🧪 Testing
How to test this change?

## 📸 Screenshots (if applicable)
[Add screenshots/GIFs]

## ⚠️ Risks
Any potential risks?
```

---

## 📊 Progress Tracking

### Weekly Progress Report

Every Friday, run this command:

```bash
# Generate progress report
./scripts/progress_report.sh

# Output: week-X-progress.md in docs/
```

Content template:
```markdown
# Week X Progress Report

**Period**: [Date range]  
**Target Completion**: [X%]  
**Actual Completion**: [X%]

## Completed Tasks
- [x] Task 1
- [x] Task 2
- [x] Task 3

## In Progress
- [ ] Task 4 (70% done, on track)
- [ ] Task 5 (40% done, needs support)

## Blockers
- 🚫 [Blocker description] - Action: [planned fix]

## Next Week
- Priority 1
- Priority 2
- Priority 3

## Team Notes
[Any important notes]
```

---

## 🎯 Metrics to Track

### Velocity
```
Tasks completed per week = Velocity
Week 1: 8 tasks
Week 2: 7 tasks
...
Average Velocity: 7.5 tasks/week
```

### Burndown
```
Tasks remaining per week
Plot: X-axis (week), Y-axis (tasks remaining)
Should show downward trend
```

### Code Quality
```
Test Coverage: Track %
Code Review: Track PR review time
Bugs Found: Track per phase
```

---

## 🔗 Integration with Tools

### GitHub + Slack Integration
Notifications sent to Slack:
- Issue assigned: @person
- PR ready for review: #channel
- Task completed: ✅ emoji
- Blocker encountered: 🚫 emoji

### GitHub + Email
Enable notifications:
- Settings → Notifications
- Watching: All Activity
- Participating and @mentions

---

## 📈 Dashboard View

**Recommended View Setup** (GitHub Projects):

```
Board Columns:
├── Backlog (all planned tasks)
├── Ready (next sprint, prioritized)
├── In Progress (current work)
├── In Review (PR under review)
└── Done (completed & verified)
```

**Filters**:
- By Phase (PHASE-0, PHASE-1, etc)
- By Priority (critical, high, medium)
- By Assignee
- By Label

---

## ✨ Best Practices

### Do's ✅
- [ ] One issue = one task/feature
- [ ] Clear acceptance criteria
- [ ] Descriptive commit messages
- [ ] Link related issues
- [ ] Update issues during work
- [ ] Review before merge
- [ ] Test before marking done

### Don'ts ❌
- [ ] Large PRs (>500 lines)
- [ ] Vague issue descriptions
- [ ] Skipping code review
- [ ] Committing to main directly
- [ ] Untracked changes
- [ ] Merging failed tests

---

## 🆘 When You Get Stuck

1. **Update Issue**: Leave comment with problem
2. **Tag Reviewer**: @mention for help
3. **Create Discussion**: For architectural questions
4. **Escalate**: Mark as blocker if critical
5. **Daily Standup**: Report in team sync

---

## 📞 Communication Channels

| Channel | Purpose | Frequency |
|---------|---------|-----------|
| GitHub Issues | Task tracking | Continuous |
| GitHub PRs | Code review | Continuous |
| GitHub Discussions | Q&A, decisions | As needed |
| Weekly Standup | Progress sync | Every Monday |
| Slack | Urgent updates | Real-time |

---

## 🎓 Resources

- [GitHub Docs](https://docs.github.com)
- [Conventional Commits](https://www.conventionalcommits.org)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins)
- [Agile Best Practices](https://www.atlassian.com/agile)

---

**Version**: 1.0  
**Last Updated**: September 3, 2026  
**Maintained By**: [Your Team]
