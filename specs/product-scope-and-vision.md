---
title: "Product Scope and Vision"
work-item-url: https://github.com/jlucaspains/sharp-bite/issues/65
status: draft
authors: lpains
version: 1.0
---

# SharpBite – Product Scope & Vision

## 1. Vision Statement

SharpBite empowers health-conscious individuals to discover how the food and drinks they consume affect how they feel — without ever compromising their privacy. By combining effortless meal logging with quality-of-life check-ins, SharpBite surfaces meaningful, personalized patterns (e.g., *"You experience bloating about 70% of the times you eat broccoli"*) that help users make informed decisions about their diet and lifestyle.

---

## 2. Problem Statement

Most people have a vague sense that certain foods affect the way they feel, but lack the tools to confirm or quantify those relationships. Existing nutrition apps focus on calories, macros, or diet planning — not on the subjective, lived experience of wellbeing. There is no simple, privacy-first tool that connects what a person eats and drinks to how they actually feel, and then surfaces those patterns in a clear and actionable way.

---

## 3. Goals and Objectives

| # | Goal | Success Indicator |
|---|------|-------------------|
| G1 | Enable users to quickly log meals and drinks | Average log time < 60 seconds |
| G2 | Enable users to record how they feel at any point in time | Check-in completion rate > 70% of active days |
| G3 | Automatically detect correlations between food intake and wellbeing | At least one insight surfaced after 2 weeks of consistent logging |
| G4 | Keep all personal data private and on-device | Zero personal data transmitted to any server |
| G5 | Deliver a seamless experience across mobile and web | Feature parity between PWA and native mobile |
| G6 | Collect anonymous usage analytics to improve the product | Analytics pipeline via sharp-web-insights with no PII |

---

## 4. Target Audience

**Primary User:** General health-conscious individuals who want to understand the relationship between their diet and how they feel day-to-day.

### User Persona — "The Curious Health Seeker"
- **Age:** 25–55  
- **Tech-savviness:** Casual consumer; expects intuitive, low-friction UX  
- **Motivation:** Notices they sometimes feel sluggish, bloated, or energised after certain meals, but cannot pinpoint why  
- **Behaviour:** Willing to log meals and check-ins daily if the process is quick and the insights feel rewarding  
- **Pain points:** Existing health apps are too complex, too focused on weight/calories, or require account creation and cloud sync

---

## 5. Key Features and Prioritisation

### Priority 1 — Core (MVP)

| Feature | Description |
|---------|-------------|
| **Meal and Drink Logging** | Log food and drink items with free-text description, optional quantity, and timestamp. Quick entry is paramount. |
| **Quality-of-Life Check-ins** | Users record how they are feeling at a given moment with a subjective wellness score and a free-text description of symptoms or sensations (e.g., "tired", "gassy", "energised"). |
| **Pattern and Insight Engine** | Automatically analyses the relationship between logged food items and wellbeing check-ins. Surfaces insights such as frequency-based correlations (e.g., *"You feel low energy 80% of the times you drink alcohol"*). |

### Priority 2 — Important

| Feature | Description |
|---------|-------------|
| **Goals** | Users can set personal wellbeing goals (e.g., "reduce bloating") to focus the insight engine and track progress over time. |
| **Recommendations** | Based on detected patterns, the app suggests foods to favour or reduce. All recommendations are data-driven and non-medical. |

### Priority 3 — Nice to Have

| Feature | Description |
|---------|-------------|
| **Social / Community** | Optional, anonymised sharing of insights or habits with a community feed. Strictly opt-in. |
| **Apple Watch Integration** | Log meals and check-ins from the wrist; receive wellbeing reminders via watch complications. |
| **Apple Health Integration** | Read relevant health metrics (e.g., sleep, heart rate variability) from Apple Health to enrich the correlation engine. Write check-in data back to Apple Health. |

---

## 6. Out of Scope

The following are explicitly **not** part of SharpBite's scope:

- **Medical advice:** The app will never diagnose conditions, recommend treatments, or make claims about medical outcomes. All insights are observational and personal.
- **Diet planning:** No meal plans, calorie targets, macro tracking, or weight-loss programmes.
- **Nutritional database:** No calorie counts or nutritional breakdowns of food items.
- **Social login / user accounts:** No user registration, authentication, or cloud-based profiles.
- **Cloud sync across devices:** Data lives on the device only; cross-device sync is not supported.

---

## 7. Privacy and Data Architecture

Privacy is a **first-class, non-negotiable** design constraint.

| Principle | Implementation |
|-----------|----------------|
| **No user identification** | The app does not collect names, emails, phone numbers, or any personally identifiable information (PII). |
| **On-device data only** | All meal logs, check-ins, and insights are stored exclusively in local device storage (e.g., SQLite / IndexedDB). No personal data is ever transmitted to a server. |
| **Anonymous analytics only** | Aggregate, non-identifiable usage data (e.g., feature usage frequency, crash reports) is collected via the internal **sharp-web-insights** platform. No data can be traced back to an individual. |
| **No third-party tracking** | No third-party analytics SDKs, advertising networks, or data brokers. |
| **Transparent data practices** | A plain-language privacy notice within the app explains exactly what is and is not collected. |

---

## 8. Platform and Technical Targets

| Platform | Approach | Priority |
|----------|----------|----------|
| **Mobile (iOS and Android)** | Progressive Web App (PWA) installable from the browser | P1 |
| **Web (Desktop and Mobile Browser)** | Same PWA codebase; fully functional in-browser | P1 |
| **Apple Watch** | Native WatchOS companion app for quick logging and reminders | P3 |

### Technical Principles
- **Offline-first:** The app must be fully functional without an internet connection.
- **PWA standards:** Meets installability criteria (Web App Manifest, Service Worker, HTTPS).
- **Local-first storage:** All persistent data uses on-device storage APIs.
- **Lightweight:** Fast load times; no heavy dependencies that degrade mobile performance.

---

## 9. Success Metrics

| Metric | Target |
|--------|--------|
| Daily Active Usage (days with at least one log or check-in) | 5 or more days/week for retained users |
| Time to first insight | 14 days or less of consistent use |
| Average meal log time | Less than 60 seconds |
| App crash-free rate | 99.5% or higher |
| PWA install rate (of web visitors) | 20% or higher |

---

## 10. Assumptions and Constraints

- Users are willing to log meals and check-ins at least once daily for patterns to emerge.
- The pattern engine operates entirely client-side; no ML model calls to external APIs.
- Apple Watch and Apple Health integrations are dependent on Apple platform availability and will follow after the PWA MVP.
- The sharp-web-insights analytics platform is assumed to be an existing internal service managed separately.

---

## 11. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| OQ1 | What is the minimum dataset size needed before the insight engine can surface reliable patterns? | Engineering | Open |
| OQ2 | Should the app support exporting data (e.g., CSV/JSON) for user portability? | Product | Open |
| OQ3 | What is the long-term monetisation strategy, if any? | Product | Open |
| OQ4 | Will Android wearable (Wear OS) integration be considered after Apple Watch? | Product | Open |
| OQ5 | What is the target app name: SharpBite, or does another name need to be evaluated? | Product | Open |

---

*This document serves as the grounding reference for all subsequent feature specifications, technical designs, and acceptance criteria within the SharpBite project.*