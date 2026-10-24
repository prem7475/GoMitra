# GoMitra — Phased, Tiered Product and Development Roadmap

**Product:** GoMitra — *Land. Connect. Go Together.*  
**Product goal:** Help passengers arriving at Mumbai CSMIA Terminal 1 or Terminal 2 discover compatible travellers, coordinate a shared journey privately, and hand off to an external ride-booking provider.

> **Checkbox note:** Every phase and tier is checked to satisfy the requested completed-task format. The checked items mean that this roadmap and its scope have been documented. They do **not** claim that the application, integrations, legal reviews, testing, or future launch work have already been implemented or completed.

## How to read the tiers

- **Tier 1 — Foundation:** Minimum safe and coherent capability for the phase.
- **Tier 2 — Expanded experience:** More complete functionality and improved usability.
- **Tier 3 — Release-ready / future scale:** Hardening or later-stage capability; only pursue when the earlier tiers are validated.

The first deliverable is an **Android-first local prototype** using fictional passengers and local storage. Real multi-user accounts, live matching, backend messaging, production routing, provider integrations, and a public pilot are later stages and require separate validation.

## Phase 1 — Product definition and scope

- [x] **Tier 1 — Product purpose**
  - [x] Define GoMitra as a passenger discovery, matching, and coordination product.
  - [x] State the core problem: arriving passengers may have compatible destinations but lack a private way to find and coordinate with one another.
  - [x] Set the product promise around shared journeys and potential cost sharing, without guaranteeing a cheaper fare or a successful match.
- [x] **Tier 2 — Prototype boundaries**
  - [x] Set the initial geography to Mumbai CSMIA Terminal 1 and Terminal 2.
  - [x] Use fictional passengers and local matching for the first prototype.
  - [x] Keep real-time cross-device discovery, production verification, driver dispatch, fare control, and in-app payment out of prototype v0.1.
- [x] **Tier 3 — Decision gates**
  - [x] Separate prototype, multi-user MVP, controlled pilot, and public-launch decisions.
  - [x] Require evidence from usability, safety, legal, operational, and cost reviews before moving to a public service.

## Phase 2 — User research and journey definition

- [x] **Tier 1 — Primary journey**
  - [x] Document the journey from app entry through airport selection, destination search, matching, group formation, chat, ride handoff, and trip completion.
  - [x] Identify the primary user as a traveller arriving at Mumbai Airport who wants to coordinate ground transport with compatible passengers.
- [x] **Tier 2 — User needs and edge cases**
  - [x] Account for passengers who find no matches, change destination, decline location permission, or need to leave a group.
  - [x] Identify clear explanations for match reasons, illustrative fares, meeting-point choices, and external booking boundaries.
  - [x] Ensure manual airport and destination selection remains possible when location access is unavailable.
- [x] **Tier 3 — Usability validation**
  - [x] Define research tasks for destination selection, understanding match rankings, creating a group, and finding the provider handoff.
  - [x] Capture task completion, time-on-task, confusion, dead ends, and confidence in privacy and meeting-point guidance.

## Phase 3 — Information architecture and screen inventory

- [x] **Tier 1 — Primary screens**
  - [x] Include splash, onboarding, sign-up, login/demo mode, home, destination search, matches, group, chat, fare handoff, My Trips, Chats, and Profile.
  - [x] Use the main navigation pattern: Home, My Trips, Chats, and Profile.
- [x] **Tier 2 — Supporting screens**
  - [x] Include airport selection, destination/map confirmation, meeting-point selection, travel preferences, support, legal pages, privacy controls, and logout confirmation.
  - [x] Include safety/report flows with a reason, block option where supported, and a clear confirmation state.
- [x] **Tier 3 — State coverage**
  - [x] Specify loading, empty, error, success, disabled, offline/stale-data, and permission-denied states.
  - [x] Ensure every visible action has a defined destination or response and that back navigation is predictable.

## Phase 4 — Visual identity and design system

- [x] **Tier 1 — Brand and palette**
  - [x] Use the GoMitra name and tagline: “Land. Connect. Go Together.”
  - [x] Define Mitra Green `#16A34A`, Night Ink `#0B0F0E`, Canvas `#F7F9F8`, Pure White `#FFFFFF`, Soft Mint `#E8F7ED`, Route Blue `#3079E8`, Muted Text `#6B756F`, and Error Red `#D92D20`.
  - [x] Apply green to primary actions and match indicators, with restrained blue reserved for route/map information.
- [x] **Tier 2 — Components and typography**
  - [x] Use a clean sans-serif such as Inter or a supported equivalent, with distinct heading, label, body, caption, and error styles.
  - [x] Define reusable buttons, fields, destination chips, passenger cards, message bubbles, navigation items, and status labels.
  - [x] Use clear labels with icons when icon meaning may be ambiguous; maintain comfortable touch targets and consistent spacing.
- [x] **Tier 3 — Design handoff**
  - [x] Organize the screen gallery and design-system/interaction specification in an editable design deliverable.
  - [x] Keep the visual language original and avoid copying another ride-hailing brand’s distinctive identity.

## Phase 5 — Development environment and project foundation

- [x] **Tier 1 — Local build setup**
  - [x] Use Flutter and Dart for the Android-first application.
  - [x] Configure Visual Studio Code, Android Studio, Android SDK, and an Android emulator or test device.
  - [x] Establish Git-based source history and a repeatable local build process.
- [x] **Tier 2 — Application structure**
  - [x] Separate screen widgets, data models, matching logic, and local storage responsibilities.
  - [x] Keep matching independent from UI code so that it can later use backend-fetched data.
- [x] **Tier 3 — Build hygiene**
  - [x] Define supported Android test devices and record build/configuration requirements.
  - [x] Keep credentials and environment-specific configuration out of the mobile application source.

## Phase 6 — Local data model and persistence

- [x] **Tier 1 — Prototype entities**
  - [x] Define profile, trip request, group, group member, message, report, and trip history entities.
  - [x] Include only the fields needed for the prototype journey and local testing.
- [x] **Tier 2 — Local persistence**
  - [x] Use SQLite with `sqflite` for demo profiles, preferences, passenger fixtures, groups, chat, and trip history as appropriate.
  - [x] Keep fictional passenger data clearly identified as demo data.
- [x] **Tier 3 — Migration readiness**
  - [x] Keep local storage behind a service boundary to support later migration to hosted data.
  - [x] Document that local records do not synchronize between devices and are not production identity or booking records.

## Phase 7 — Entry, onboarding, and profile

- [x] **Tier 1 — Entry flow**
  - [x] Provide splash actions for getting started and signing in.
  - [x] Explain the product value simply during onboarding.
  - [x] Offer a clearly labelled demo mode for prototype evaluation.
- [x] **Tier 2 — Forms and preferences**
  - [x] Specify sign-up fields for name, username, email, password, and acceptance of terms.
  - [x] Validate required fields, plausible email format, username rules, password policy, and terms acceptance.
  - [x] Provide profile and travel-preference screens with understandable editing and save behavior.
- [x] **Tier 3 — Account lifecycle**
  - [x] Clearly distinguish demonstrative local sign-in from real server-backed authentication.
  - [x] Define logout confirmation and a future account-deletion path.

## Phase 8 — Airport and destination selection

- [x] **Tier 1 — Airport choice**
  - [x] Allow selection of Mumbai CSMIA Terminal 1 or Terminal 2.
  - [x] Persist and display the chosen terminal throughout the journey flow.
- [x] **Tier 2 — Destination search**
  - [x] Provide destination search, popular destinations, selectable suggestions, and map-based selection.
  - [x] Include representative places such as Thane, Mulund, Vikhroli, Powai, Andheri, Bandra, and Goregaon.
  - [x] Show a confirmation action and ensure the selected destination appears correctly in the trip summary.
- [x] **Tier 3 — Map behavior**
  - [x] Use OpenStreetMap data with `flutter_map` for map preview, markers, and route illustration where suitable.
  - [x] Follow map tile and data-provider usage policies; do not imply that a drawn line is a verified road route.

## Phase 9 — Passenger discovery and matching

- [x] **Tier 1 — Local matching**
  - [x] Load fictional passenger records locally and find candidates for the selected destination.
  - [x] Rank exact destination matches ahead of nearby destinations.
  - [x] Explain results with labels such as “Same destination,” “Nearby destination,” or “Possible route fit.”
- [x] **Tier 2 — Compatibility factors**
  - [x] Consider destination proximity, route fit, detour, and departure-time compatibility.
  - [x] Treat initial example weights—40% destination proximity, 30% route compatibility, 20% detour, and 10% time—as provisional tuning values, not validated truths.
  - [x] Exclude or downgrade candidates whose estimated detour exceeds the user’s limit or whose route is impractical.
- [x] **Tier 3 — Match quality**
  - [x] Explain that straight-line distance is only an early filter and does not prove road-route compatibility.
  - [x] Provide a no-results state with options to broaden the radius, change departure time, or choose another destination.
  - [x] Add road-network routing only after the local matching experience and data quality are validated.

## Phase 10 — Groups and meeting-point coordination

- [x] **Tier 1 — Group lifecycle**
  - [x] Allow a passenger to add candidates to a draft group and create or join a group.
  - [x] Prevent duplicate members and keep membership state consistent.
  - [x] Show members, group status, and clear leave-group behavior.
- [x] **Tier 2 — Meeting point**
  - [x] Show a proposed meeting point and allow it to be reviewed or changed before confirmation.
  - [x] Confirm the group and meeting point for the trip with a clear state transition.
  - [x] Prefer legitimate, public, accessible locations and avoid isolated or prohibited areas.
- [x] **Tier 3 — Multi-user controls**
  - [x] Require server-side authorization for membership changes in a future backend version.
  - [x] Define cancellation, member departure, and stale/inactive group behavior before a real-world pilot.

## Phase 11 — In-app chat and communication

- [x] **Tier 1 — Prototype chat**
  - [x] Provide group conversation list, messages, composer, and send action.
  - [x] Block empty or whitespace-only messages and display messages in a clear order.
  - [x] Use app usernames rather than exposing personal phone numbers.
- [x] **Tier 2 — Group access**
  - [x] Limit conversations to the relevant group and show understandable group context.
  - [x] Provide a clear exit path from a group conversation.
- [x] **Tier 3 — Real-time messaging**
  - [x] Defer cross-device real-time chat to the hosted multi-user stage.
  - [x] Require backend authorization, input validation, abuse controls, and appropriate retention rules before production messaging.

## Phase 12 — Fare presentation and external ride handoff

- [x] **Tier 1 — Prototype boundary**
  - [x] Do not collect or hold money in the first prototype.
  - [x] Label any fare as illustrative and make clear that the ride provider controls the actual fare, availability, payment, booking, cancellation, and refund terms.
- [x] **Tier 2 — Fare card**
  - [x] Show destination and intended passenger count.
  - [x] Show an estimate only when its source and assumptions are clear; label any per-person amount as arithmetic, not a guaranteed quote.
  - [x] Provide a no-estimate state directing users to check the provider app.
- [x] **Tier 3 — Provider handoff**
  - [x] Use only a supported official link or approved integration when available.
  - [x] Clearly state that booking continues with the provider and return safely to the trip summary if a booking is cancelled.
  - [x] Evaluate future fees, referrals, or premium features only after user research, legal review, provider-term review, and unit-economics analysis.

## Phase 13 — Privacy, safety, and security baseline

- [x] **Tier 1 — Privacy by design**
  - [x] Minimize profile information and do not show personal phone numbers in public profiles or group chats.
  - [x] Request location access only when necessary, explain its purpose, and preserve manual selection.
  - [x] Define retention expectations for messages, location data, and reports.
- [x] **Tier 2 — Safety controls**
  - [x] Provide report, block where technically supported, leave-group, and account-deletion paths.
  - [x] Avoid claims that matching, a public airport, or any verification step guarantees safety.
  - [x] Consider trusted-contact sharing, stronger verification, and additional matching preferences only after careful product, operational, and legal review.
- [x] **Tier 3 — Backend security**
  - [x] Use a trusted authentication service and never store plaintext passwords.
  - [x] Do not embed backend service-role keys in the mobile app.
  - [x] Enforce group membership and message access on the backend with row-level access policies and server-side validation.
  - [x] Use secure transport, minimize sensitive logs, and plan rate limits and abuse response.

## Phase 14 — Testing and acceptance

- [x] **Tier 1 — Core functional tests**
  - [x] Verify installation and launch on a supported Android device without a crash.
  - [x] Test navigation, back behavior, airport selection, and destination confirmation.
  - [x] Test valid and invalid sign-up/login form states and demo-mode labeling.
- [x] **Tier 2 — Journey and edge-case tests**
  - [x] Test exact, nearby, and incompatible matching examples; exact matches should rank first and unsuitable routes should be downgraded or excluded.
  - [x] Test group add, duplicate add, confirmation, and leave behavior.
  - [x] Test empty/non-empty chat messages, correct ordering, and absence of phone numbers in UI.
  - [x] Test fare estimate wording and verify that the prototype does not claim an external booking is confirmed.
- [x] **Tier 3 — Quality and usability**
  - [x] Test permission denial, no-network/stale-data behavior for later online stages, empty states, and error recovery.
  - [x] Record APK crash rate, rendering issues, task completion, time to create a test group, and user understanding of match reasons.
  - [x] Document test results and known limitations before distributing a testing APK.

## Phase 15 — Local prototype and APK milestone

- [x] **Tier 1 — M1–M3**
  - [x] Establish a launchable Flutter project.
  - [x] Implement the visual foundation and core navigation.
  - [x] Implement airport selection and destination search/map preview.
- [x] **Tier 2 — M4–M6**
  - [x] Implement local matching with fictional passengers.
  - [x] Implement group, meeting-point, chat UI, and local persistence.
  - [x] Build a testing APK and document the test results.
- [x] **Tier 3 — Prototype exit criteria**
  - [x] Confirm the core journey can be completed with demo data.
  - [x] Confirm screens communicate privacy, safety, fare, and provider boundaries accurately.
  - [x] Use usability findings to decide what needs revision before backend work begins.

## Phase 16 — Multi-user MVP and hosted backend

- [x] **Tier 1 — Service design**
  - [x] Define the Supabase/PostgreSQL-backed path for authentication, shared trip requests, group membership, and messages.
  - [x] Define ownership, authorization, data access, and deletion rules before connecting real users.
- [x] **Tier 2 — MVP functionality**
  - [x] Add real accounts and shared trip data only after security rules and error states are in place.
  - [x] Add cross-device group membership and real-time messaging with server-side access control.
  - [x] Clearly distinguish live records from cached or stale data when connectivity is interrupted.
- [x] **Tier 3 — Service reliability**
  - [x] Review service quotas, terms, backup/restore, monitoring, retention, incident handling, and operational ownership.
  - [x] Avoid presenting a free-tier service as unlimited or guaranteed to remain free.

## Phase 17 — Route-aware matching and controlled pilot

- [x] **Tier 1 — Routing evaluation**
  - [x] Compare appropriate routing options, including a self-hosted OSRM instance or another permitted service.
  - [x] Account for infrastructure, maintenance, data freshness, service terms, latency, and operating costs.
- [x] **Tier 2 — Match refinement**
  - [x] Evaluate route overlap, detour, pickup/drop-off order, departure-time tolerance, and user-set limits.
  - [x] Test whether match explanations are understandable and whether exclusions are reasonable.
- [x] **Tier 3 — Controlled pilot gate**
  - [x] Complete a limited pilot-readiness review before enabling real-world coordination.
  - [x] Define support coverage, safety escalation, incident reporting, cancellation, and feedback handling.
  - [x] Start with a controlled and monitored scope rather than assuming immediate public-launch readiness.

## Phase 18 — Legal, operational, and support readiness

- [x] **Tier 1 — Review topics**
  - [x] Assess applicable Indian privacy and consumer requirements, airport pickup rules, liability, moderation, and ride-sharing implications.
  - [x] Review platform and map-provider terms and any requirements associated with external booking links.
  - [x] Treat this roadmap as product planning, not legal advice.
- [x] **Tier 2 — Operating procedures**
  - [x] Define support intake, abuse reporting, urgent safety escalation, account requests, and response ownership.
  - [x] Define policies for report review, retention, access, and deletion.
- [x] **Tier 3 — Pre-launch approval**
  - [x] Obtain qualified professional review of applicable policies and obligations before a real-world launch.
  - [x] Confirm service ownership, operational budget, support capacity, and incident response before expanding the pilot.

## Phase 19 — Sustainable business and future integrations

- [x] **Tier 1 — Cost visibility**
  - [x] Estimate hosting, map/routing, support, moderation, compliance, and maintenance costs.
  - [x] Track free-tier quotas and provider policy changes rather than relying on perpetual free availability.
- [x] **Tier 2 — Monetization research**
  - [x] Compare transparent service fees, partnership referrals, and premium features through user research and provider-term review.
  - [x] Do not assume a monetization model until its legal, operational, and unit-economic impact is understood.
- [x] **Tier 3 — Payment expansion gate**
  - [x] If GoMitra later accepts payments, use an approved payment gateway and keep sensitive card data out of GoMitra’s own database.
  - [x] Disclose fees, payer, total, and cancellation/refund terms before a user commits.

## Phase 20 — Ongoing measurement and roadmap governance

- [x] **Tier 1 — Product metrics**
  - [x] Track completion of destination selection and match discovery tasks.
  - [x] Track time required to create a test group and user understanding of match explanations.
  - [x] Track confusing interactions, dead ends, rendering issues, and crash rate.
- [x] **Tier 2 — Trust and quality signals**
  - [x] Gather feedback on privacy disclosures, meeting-point clarity, and perceived confidence in the journey.
  - [x] Review reports and safety concerns with appropriate privacy and access controls.
- [x] **Tier 3 — Release governance**
  - [x] Revisit priorities as usability evidence, technical constraints, provider terms, costs, and legal guidance change.
  - [x] Keep prototype, MVP, pilot, and public-launch scope distinct in future planning and communications.

## Phase 21 — Requirements traceability and product rules

- [x] **Tier 1 — Functional requirements**
  - [x] FR-01: Launch to a branded splash screen.
  - [x] FR-02–FR-03: Open onboarding, sign-up, or login; allow demo mode without real credentials.
  - [x] FR-04–FR-06: Select a terminal and destination, then show ranked candidates with explanations.
  - [x] FR-07–FR-10: Add/remove candidates, create/join/leave groups, manage meeting points, and send simulated messages.
  - [x] FR-11–FR-13: Show trips and profile/support/policy surfaces; confirm logout.
  - [x] FR-14–FR-15: Label fares as non-provider estimates and provide visible feedback for every supported control.
- [x] **Tier 2 — Non-functional requirements**
  - [x] Make the first-time path to destination selection understandable without instructions.
  - [x] Render local screens without avoidable delay and prevent invalid input from crashing the app.
  - [x] Separate UI, matching, and storage responsibilities for maintainability.
  - [x] Label simulated data, estimates, and unimplemented integrations accurately.
- [x] **Tier 3 — Traceability**
  - [x] Link each requirement to its screen, interaction, data, and test case.
  - [x] Mark each requirement as prototype, connected MVP, pilot, or post-launch so future work is not mistaken for current scope.

## Phase 22 — Detailed screen behavior and user feedback

- [x] **Tier 1 — Entry and discovery**
  - [x] Splash: show the wordmark, route/pin motif, tagline, value proposition, Get started, and Sign in.
  - [x] Onboarding: explain compatible travellers, potential cost savings, and private coordination; offer Continue and Sign in.
  - [x] Home: show greeting, terminal selector, destination field, popular chips, restrained map preview, and the primary Find travel companions action.
  - [x] Destination: search local presets, select a result, show a list alternative to map selection, and confirm before matching.
- [x] **Tier 2 — Matching and group journey**
  - [x] Match cards: show destination, concise compatibility reason, and selection state without unnecessary personal details.
  - [x] Group: show group name/status, member count, member list, meeting-point summary, and explicit confirm/change/leave actions.
  - [x] Meeting-point selector: list permitted public pickup points with access notes and a map preview; require a selection before confirmation.
  - [x] Chat: show group context, timestamps, delivery state, composer, send action, safety reminder, and report/block entry points.
- [x] **Tier 3 — Account and trip surfaces**
  - [x] My Trips: separate upcoming, active, completed, and cancelled records, with clear trip details and empty states.
  - [x] Chats: show group, last-message preview, timestamp, optional unread count, search, and a no-conversation path back to discovery.
  - [x] Profile/More: group personal information, travel preferences, notification settings, privacy/safety, external payment preferences, support, policies, community guidelines, deletion, and logout.
  - [x] Add dedicated pre-launch screens for password reset, trip details, report submission, blocked users, network error, maintenance, and account deletion.

## Phase 23 — Control, navigation, and interaction contract

- [x] **Tier 1 — Primary controls**
  - [x] Get started opens onboarding; Sign in opens login; Create account and Log in validate fields before submission.
  - [x] Airport selector requires an explicit T1/T2 choice and preserves the current choice if cancelled.
  - [x] Destination chips update the selected destination; Find companions requires destination/time and shows loading or no-results feedback.
  - [x] Add passenger toggles selection, prevents duplicates, and respects group capacity.
- [x] **Tier 2 — Disruptive and asynchronous actions**
  - [x] Create/join group handles full, expired, unavailable, and already-joined states.
  - [x] Meeting-point confirmation requires a permitted available point; unavailable points lead to choosing another.
  - [x] Leave group explains the impact, including what happens if the organiser leaves.
  - [x] Send message trims input, rejects empty/overlong text, clears the composer after success, and offers retry after failure.
  - [x] Report confirms receipt without promising an immediate emergency response; provider handoff never displays a false “cab booked” state.
- [x] **Tier 3 — Consistent interaction rules**
  - [x] Provide pressed/selected feedback for tappable elements; disable unsupported actions and explain why.
  - [x] Prevent duplicate submissions for account creation, login, group creation, and reports.
  - [x] Preserve valid form input and draft group/destination state across validation and predictable back navigation.
  - [x] Keep logout separate from account deletion; logout clears session/private cached data but does not silently delete account records.

## Phase 24 — Accessibility, layout, and visual quality

- [x] **Tier 1 — Layout consistency**
  - [x] Use a consistent spacing scale such as 4, 8, 12, 16, 24, and 32 dp and mobile side margins around 16–20 dp.
  - [x] Use 44–48 dp minimum heights for primary interactive controls and 12–16 dp radii for cards and fields.
  - [x] Keep one clear primary action per screen and separate destructive actions from primary actions.
- [x] **Tier 2 — Accessible operation**
  - [x] Do not rely on color alone for success, error, or selection; pair color with text, labels, or icons.
  - [x] Maintain readable contrast, support system font scaling, label fields for screen readers, and select appropriate keyboard types.
  - [x] Provide clear focus states and actionable validation messages.
  - [x] Ensure map selection has a list-based alternative and confirm group exit/logout explicitly.
- [x] **Tier 3 — Component states**
  - [x] Specify enabled, disabled, loading, pressed, focused, selected, error, and retry states for reusable controls.
  - [x] Use text as well as color for trip status; distinguish incoming/outgoing/failed chat messages.
  - [x] Keep bottom navigation on top-level screens only and preserve selected tab/context where reasonable.

## Phase 25 — Technology choices and system architecture

- [x] **Tier 1 — Prototype stack**
  - [x] Use Flutter/Dart for Android UI and application logic, VS Code for editing, and Android Studio/Android SDK for emulator and APK tooling.
  - [x] Use SQLite/`sqflite` for local demo profiles, preferences, passenger fixtures, groups, messages, and trips.
  - [x] Use OpenStreetMap data and `flutter_map` for optional map display, markers, and destination preview; treat map tiles as policy-governed services.
- [x] **Tier 2 — Replaceable service boundaries**
  - [x] Keep widgets responsible for presentation, models for typed data, matching service for ranking, and storage service for persistence.
  - [x] Keep the local destination catalogue usable without network access; treat map tiles as optional during the prototype.
  - [x] Do not assume `flutter_map` calculates road routes; route calculation requires a separate routing service/engine.
- [x] **Tier 3 — Connected architecture**
  - [x] Introduce Supabase/PostgreSQL only for the later connected stage, subject to current service limits, policies, and operational review.
  - [x] Route client requests through authenticated, authorized backend operations for shared trips, groups, chat, and reports.
  - [x] Design services so local prototype implementations can be replaced without rewriting screen behavior.

## Phase 26 — Data flow, entities, and lifecycle

- [x] **Tier 1 — Typed domain records**
  - [x] Profile: ID, username, display name, account status, and relevant preferences.
  - [x] Trip request: user, terminal, destination, coordinates, departure window, and active/expired status.
  - [x] Destination: ID, name, area, coordinates, and search aliases.
  - [x] Travel group/member: organiser, status, meeting point, membership role/status, and timestamps.
- [x] **Tier 2 — Supporting records**
  - [x] Meeting point: terminal, name, coordinates, access notes, and availability.
  - [x] Chat message: group, sender, content, creation time, and delivery status.
  - [x] Trip record: group, journey status, timestamps, and provider reference only if an authorized integration later returns one.
  - [x] Report: reporter, reported user, reason, status, and creation time.
- [x] **Tier 3 — Lifecycle and access**
  - [x] Model active, expired, cancelled, completed, and deleted states explicitly where applicable.
  - [x] Define ownership and permissions for each entity before storing real-user data.
  - [x] Define retention/deletion rules and avoid continuous location history without a clear, disclosed need.

## Phase 27 — Matching eligibility and explainability

- [x] **Tier 1 — Candidate eligibility**
  - [x] Require the same airport terminal unless cross-terminal matching is explicitly allowed by product rules.
  - [x] Exclude inactive/expired requests and candidates with non-overlapping departure windows outside the configured tolerance.
  - [x] Require same or configured nearby destination area and exclude blocked relationships.
  - [x] Exclude full groups and candidates already in the current group.
- [x] **Tier 2 — Ranking**
  - [x] Score destination similarity, route compatibility, detour, and departure-time fit using documented, testable rules.
  - [x] Use route overlap and detour only when a suitable routing source exists; otherwise label results preliminary/geographic.
  - [x] Return a bounded result set, sorted by score, with concise human-readable reasons.
- [x] **Tier 3 — Honest uncertainty**
  - [x] Never present a score as the probability of a successful, safe, or lower-cost journey.
  - [x] Treat user-entered departure times as potentially stale due to flight delays and allow updates.
  - [x] Tune weights and thresholds against explicit test cases and usability evidence, not assumed optimal values.

## Phase 28 — Error handling and edge-case coverage

- [x] **Tier 1 — Input and discovery states**
  - [x] No destination: disable matching and explain what is required.
  - [x] No matches: explain availability and offer destination/time changes or a broader search.
  - [x] No search results: show a clear no-results state and a way to clear the query.
  - [x] Invalid form input: show field-level corrections and preserve valid values.
- [x] **Tier 2 — Group and communication states**
  - [x] Candidate already selected: show selected state and prevent duplicate membership.
  - [x] Group full/expired/unavailable: explain the condition and prevent invalid joining.
  - [x] Organiser leaves: explain whether the group closes or a new organiser is required.
  - [x] Meeting point unavailable: require selection of another permitted point.
  - [x] Message send failure: retain the message and offer retry without duplicating successful sends.
- [x] **Tier 3 — Network and external-service states**
  - [x] Permission denied: retain manual airport/destination workflows.
  - [x] Offline local prototype: preserve core local screens and clearly identify unavailable map/network-dependent functions.
  - [x] Connected version with stale network data: label it as stale and never present it as live.
  - [x] Provider handoff unavailable or cancelled: clearly explain that booking did not occur and return to the trip summary.

## Phase 29 — Verification plan and first-APK definition of done

- [x] **Tier 1 — Build and navigation acceptance**
  - [x] Build/install the APK on an emulator and a physical Android device; verify launch without crash.
  - [x] Navigate every core screen and confirm each primary control has a defined destination or response.
  - [x] Verify destination choice, selected terminal, and trip summary remain consistent.
- [x] **Tier 2 — Functional acceptance**
  - [x] Verify form validation, demo labeling, exact/nearby/incompatible matching, and no-results adjustment paths.
  - [x] Verify add/remove/duplicate/capacity group behavior, meeting-point confirmation, leave-group handling, and local trip history.
  - [x] Verify empty/non-empty/overlong/failed chat behavior, message order, and no phone-number display.
  - [x] Verify fare disclaimer, provider ownership, and absence of false booking-confirmation claims.
- [x] **Tier 3 — Definition of done**
  - [x] Confirm a tester can launch, complete the primary demo journey, inspect trips, open profile/support/legal surfaces, and log out.
  - [x] Confirm simulated features are labelled, local data remains fictional, and the prototype works without network access except optional map tiles.
  - [x] Record test environment, results, defects, and known limitations alongside the testing APK.

## Phase 30 — Cost controls, risks, and launch gates

- [x] **Tier 1 — Initial cost target**
  - [x] Target ₹0 initial development spend by using free development tools, local records, and local storage.
  - [x] Avoid paid map/routing credits, SMS verification, commercial hosting, payment gateway, and ride-provider API dependencies in the first prototype.
  - [x] Document that ₹0 is an initial prototype target, not a guarantee of zero cost for hosting, map traffic, routing, support, or production operations.
- [x] **Tier 2 — Risk register**
  - [x] Low match density: test destination demand and provide honest no-match options.
  - [x] Poor route compatibility: add road routing and detour limits before real matching.
  - [x] Trust/safety and weak moderation: provide reporting controls and do not launch publicly before support/escalation is staffed.
  - [x] API quota/cost changes: monitor terms and limits; use replaceable service layers and local test data.
  - [x] Fare misunderstanding: label estimates and avoid guarantees.
  - [x] Privacy misconfiguration: test unauthorized reads and writes before pilot.
- [x] **Tier 3 — Release progression**
  - [x] Prototype: local UI, sample data, local matching, simulated chat → testing APK.
  - [x] Private test: usability testing and UI/logic refinement → improved APK.
  - [x] Connected MVP: authentication, shared trip requests, groups, and real-time chat → multi-device test build.
  - [x] Route-aware pilot: validated routing, moderation, and safety operations → limited controlled pilot.
  - [x] Provider integration: verify official handoff and commercial permission before enabling a connected flow.
  - [x] Scale assessment: review costs, reliability, legal obligations, and support capacity → explicit public-launch go/no-go decision.

## Source materials

- [GoMitra Product Technical Report](./GoMitra_Product_Technical_Report.docx) — product concept, scope, architecture, matching, privacy, payment boundaries, tests, and staged roadmap.
- [GoMitra Detailed Product Theory v2](./GoMitra_Detailed_Product_Theory_v2.docx) — detailed requirements, screen-by-screen and button behavior, accessibility, architecture/data model, eligibility rules, error states, acceptance criteria, cost controls, and launch risks.
- **GoMitra: Shared Airport Journeys** — supplied UI reference image showing the splash/onboarding flow, airport and destination search, matching, group/meeting point, in-app chat, external cab handoff, design tokens, and bottom navigation.

## Overall completion record

- [x] Product and interface source materials reviewed.
- [x] New detailed product theory integrated into the phased roadmap.
- [x] Prototype scope and later-stage boundaries recorded.
- [x] Thirty phases divided into Foundation, Expanded Experience, and Release-ready/Future Scale tiers.
- [x] Phase and tier checkboxes pre-checked as requested.
