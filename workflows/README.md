# n8n Workflows

## Absence Approval Workflow

**File:** `absence-approval-workflow.json`

### Workflow Overview

Automated absence request processing with conditional approval logic based on request date and coverage requirements.

### Workflow Diagram
```
Form Submission
    ↓
Webhook Trigger
    ↓
Date Check (Past or Future?)
    ↓
┌───────────────────┬────────────────────┐
│ PAST DATE         │ FUTURE DATE        │
│ (Retroactive)     │ (Planned)          │
├───────────────────┼────────────────────┤
│ → Log to Sheet    │ → Send Approval    │
│ → Notify Teacher  │   Email (Principal)│
└───────────────────┤                    │
                    │ Wait for Response  │
                    ↓                    │
            ┌───────┴──────┐            │
            │ APPROVED?    │            │
            ├──────┬───────┤            │
         YES│      │NO     │            │
            ↓      ↓       │            │
    Coverage?  Decline     │            │
    ┌──┴──┐    Email       │            │
   YES   NO               │            │
    │     │                │            │
 Email  Log               │            │
 Front  to                │            │
 Desk  Sheet              │            │
    │     │                │            │
    └──┬──┘                │            │
       │                   │            │
    Log to                │            │
    Sheet                 │            │
       │                   │            │
   Confirm                │            │
   Email ←────────────────┘            │
```

### Nodes & Logic

#### 1. Webhook Trigger
- **Type:** POST
- **Path:** `/webhook/absence-request`
- **Accepts:** JSON payload with form data

#### 2. Date Check
- **Logic:** Compare request date with current date
- **Output:** `isPastDate` (boolean)

#### 3. Branch: Past Date (Auto-Approve)
- **Action:** Log directly to Google Sheets
- **Status:** "Approved - Retroactive Sick Leave"
- **Notification:** Confirmation email to requester

#### 4. Branch: Future Date (Requires Approval)
- **Action:** Send approval email to principal
- **Contains:** Approve/Decline buttons (webhook callbacks)
- **Wait:** For principal's response

#### 5. Approval Decision
- **If Declined:**
  - Send decline email to requester
  - Workflow ends
  
- **If Approved:**
  - Check coverage requirement
  - Continue to next step

#### 6. Coverage Check
- **Condition:** `coverageNeeded === "yes"`
- **If Yes:**
  - Email front desk with coverage details
  - Include: date, teacher name, reason
  
- **If No:**
  - Skip coverage notification

#### 7. Data Logging
- **Target:** Google Sheets
- **Columns:** Name, Email, Date, Reason, Coverage, Status, Timestamp
- **Purpose:** Audit trail and reporting

#### 8. Final Notification
- **Action:** Confirmation email to requester
- **Content:** Request approved and logged

### Configuration Requirements

**Gmail Credentials:**
- OAuth2 authentication
- Scopes: send email
- Configure in n8n credentials

**Google Sheets:**
- Service account or OAuth
- Sheet ID: [Your Sheet ID]
- Sheet name: "Absence Requests"

**Environment Variables:**
- `WEBHOOK_URL`: https://absences.smaschool.org
- `N8N_PROTOCOL`: https
- `N8N_HOST`: absences.smaschool.org

### Testing

**Test Past Date (Auto-Approve):**
```bash
curl -X POST https://absences.smaschool.org/webhook/absence-request \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "email": "jane@example.com",
    "date": "2026-02-10",
    "reason": "Sick Leave",
    "coverageNeeded": "no"
  }'
```

**Test Future Date (Needs Approval):**
```bash
curl -X POST https://absences.smaschool.org/webhook/absence-request \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "email": "john@example.com",
    "date": "2026-03-15",
    "reason": "Vacation",
    "coverageNeeded": "yes"
  }'
```

### Maintenance

**Import Workflow:**
```bash
# In n8n UI
1. Click "Import from File"
2. Select absence-approval-workflow.json
3. Configure credentials
4. Activate workflow
```

**Update Workflow:**
1. Make changes in n8n UI
2. Test thoroughly
3. Export updated JSON
4. Commit to Git