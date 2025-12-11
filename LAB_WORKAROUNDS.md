# Lab Workarounds and Known Issues

This document tracks issues encountered during the workshop that required workarounds or deviations from the lab instructions.

---

## Table of Contents
- [Azure Authentication Issues](#azure-authentication-issues)
- [Security Control Tag for Resource Group](#security-control-tag-for-resource-group)
- [Azure AI Foundry Agent Creation Permissions](#azure-ai-foundry-agent-creation-permissions)
- [Azure AI Foundry Project Endpoint](#azure-ai-foundry-project-endpoint)
- [WebSocket Connection Errors](#websocket-connection-errors)

---

## Azure Authentication Issues

### Issue
Conditional Access Policy error `53003` when logging into Azure from GitHub Codespaces.

### Error Message
```
AADSTS53003: Access has been blocked by Conditional Access policies
```

### Workaround
Use device code authentication flow instead of interactive browser login:
```bash
az login --use-device-code
```

This bypasses Conditional Access policies that may block authentication from cloud development environments.

### Lab Impact
- Exercise 01 - Task 01 (Azure login)

---

## Security Control Tag for Resource Group

### Issue
Some Azure subscriptions have security policies that may flag or prevent resource group creation without proper tags for governance and compliance tracking.

### Workaround
Add the `SecurityControl=ignore` tag when creating the resource group:

```bash
az group create \
  --name techworkshop-l300-ai-agents \
  --location swedencentral \
  --tags SecurityControl=ignore
```

### Purpose
- Bypasses certain security scanning policies during workshop exercises
- Allows resource creation in locked-down subscriptions
- Indicates this is a temporary learning/testing resource group

### Lab Impact
- Exercise 01 - Task 01 (Resource group creation)

### Note
Remember to clean up the resource group after completing the workshop (Exercise 07) to maintain subscription hygiene.

---

## Azure AI Foundry Agent Creation Permissions

### Issue
When running agent initializer scripts (e.g., `inventoryAgent_initializer.py`), received permission denied error.

### Error Message
```
ClientAuthenticationError: (PermissionDenied) The principal lacks the required data action 
'Microsoft.CognitiveServices/accounts/AIServices/agents/write' to perform 
'POST /api/projects/{projectName}/assistants' operation.
```

### Root Cause
The default role assignments don't include the necessary **data action** permissions to create agents via the Azure AI Agents SDK. The specific data action required is `Microsoft.CognitiveServices/accounts/AIServices/agents/write`.

### Workaround
Assign the **Cognitive Services User** role at the AI Foundry resource level:

```bash
# Get your user principal
USER_EMAIL="your-email@domain.com"

# Assign Cognitive Services User role (REQUIRED - has data actions)
az role assignment create \
  --role "Cognitive Services User" \
  --assignee "$USER_EMAIL" \
  --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.CognitiveServices/accounts/<ai-foundry-name>"
```

**Important Notes:**
- **"Cognitive Services User"** is the correct role - it includes `Microsoft.CognitiveServices/*` as a **data action**
- **"Cognitive Services Contributor"** will NOT work - it only has control plane actions, not data actions
- **"Azure AI Developer"** does NOT include AIServices/agents permissions
- Permissions may take 5-15 minutes to propagate, but usually work immediately

### Alternative Solution
Create agents manually through the Azure AI Foundry portal:
1. Go to https://ai.azure.com
2. Navigate to your project
3. Go to "Agents" section
4. Create agents manually using the prompts from `src/prompts/*.txt`
5. Copy the agent IDs and update `src/.env` file

### Lab Impact
- Exercise 02 - Task 02 (Creating agents)
### Tested Solution
Example with actual resource names:
```bash
az role assignment create \
  --role "Cognitive Services User" \
  --assignee "admin@MngEnvMCAP105953.onmicrosoft.com" \
  --scope "/subscriptions/49beb517-d771-4d32-b7ff-34953d511e8d/resourceGroups/techworkshop-l300-ai-agents/providers/Microsoft.CognitiveServices/accounts/aif-gw5ehcx5adkvc"
```

After assignment, run the agent initializer:
```bash
cd src
source venv/bin/activate
python app/agents/customerLoyaltyAgent_initializer.py
```

**Last Updated**: December 11, 2025 - Verified correct role is "Cognitive Services User"
---

## Azure AI Foundry Project Endpoint

### Issue
The lab documentation may not be clear about which endpoint to use for `AZURE_AI_AGENT_ENDPOINT`.

### Incorrect Endpoint
```
https://<ai-foundry-name>.cognitiveservices.azure.com/
```
This is the **Azure OpenAI endpoint**, not the project endpoint.

### Correct Endpoint Format
```
https://<ai-foundry-name>.services.ai.azure.com/api/projects/<project-name>
```

### How to Find the Correct Endpoint
1. Go to https://ai.azure.com
2. Navigate to your project
3. Go to "Project settings" or "Overview"
4. Look for "Project connection string" or "Discovery URL"
5. The endpoint format should be: `https://<hub-name>.services.ai.azure.com/api/projects/<project-name>`

### Example
```bash
# In src/.env file
AZURE_AI_AGENT_ENDPOINT="https://aif-gw5ehcx5adkvc.services.ai.azure.com/api/projects/proj-gw5ehcx5adkvc"
```

### Lab Impact
- Exercise 02 - Task 02 (Creating agents)

---

## WebSocket Connection Errors

### Issue
When running the chat application in single-agent mode (Exercise 02, Task 01), WebSocket connections fail with `ResourceNotFoundError`.

### Error Message
```
azure.core.exceptions.ResourceNotFoundError: (404) Resource not found
at line 168: thread = project_client.agents.threads.create()
```

### Root Cause
The `chat_app.py` file contains infrastructure for multi-agent architecture that attempts to create Azure AI Agent threads, but this is not needed for single-agent mode which uses direct OpenAI API calls.

### Workaround
Comment out the thread creation lines in `src/chat_app.py`:

```python
# Around line 168-170 in websocket_endpoint function
# thread = project_client.agents.threads.create()
# logging.info(f"Created thread, thread ID is: {thread.id}")
```

### Lab Impact
- Exercise 02 - Task 01 (Single agent implementation)
- These lines should be uncommented when implementing multi-agent mode in Task 02

---

## Missing Prompt Files

### Issue
If you receive errors about missing prompt files when running agent initializers or the application.

### Required Prompt Files
The following files should exist in `src/prompts/`:
- `CustomerLoyaltyAgentPrompt.txt`
- `InventoryAgentPrompt.txt`
- `ShopperAgentPrompt.txt`
- `CartManagerPrompt.txt`
- `InteriorDesignAgentPrompt.txt`
- `DiscountLogicPrompt.txt`
- `aiSearchToolPrompt.txt`

### Workaround
Refer to Exercise 02, Task 02 in the lab documentation (`docs/02_implement_multimodal_ai_shopping_assistant/02_02.md`) for the complete content of each prompt file.

### Lab Impact
- Exercise 02 - Task 02 (Multi-agent implementation)

---

## Tips for Success

### 1. Environment Variables
Always double-check your `src/.env` file has all required variables:
- Azure OpenAI endpoints and keys
- Cosmos DB credentials
- Azure AI Search credentials
- Storage account credentials
- Application Insights connection string
- Agent IDs (after creation)

### 2. Virtual Environment
Always activate the Python virtual environment before running scripts:
```bash
cd src
source venv/bin/activate
```

### 3. Role Propagation Delays
After assigning Azure roles, wait 10-15 minutes before attempting operations that require those permissions.

### 4. Agent ID Management
After creating agents (manually or via script), verify the agent IDs are correctly saved in `src/.env`:
```bash
customer_loyalty="asst_xxxxx"
inventory_agent="asst_xxxxx"
interior_designer="asst_xxxxx"
cora="asst_xxxxx"
cart_manager="asst_xxxxx"
```

---

## Contributing to This Document

If you encounter additional issues during the workshop, please document them using this template:

```markdown
## Issue Title

### Issue
Brief description of the problem

### Error Message
```
Exact error message or behavior
```

### Root Cause
Why this happens

### Workaround
Step-by-step solution

### Lab Impact
- Which exercise and task this affects
```

---

## Azure AI Agents SDK Race Condition

### Issue
Intermittent error when processing agent runs with tool calls: `Runs in status "queued" do not accept tool outputs.`

### Error Message
```
[ERROR] Conversation failed: (None) Runs in status "queued" do not accept tool outputs.
Code: None
Message: Runs in status "queued" do not accept tool outputs.
```

### Root Cause
Timing issue in Azure AI Agents SDK where `create_and_process()` attempts to submit tool outputs before the run transitions from "queued" to "in_progress" status. This is a race condition in the SDK's internal polling mechanism.

### Impact
- Error is sporadic and non-blocking
- Conversation continues to work
- Other agent interactions in the same session process successfully
- Telemetry and tracing data is still collected

### Workaround
No code changes required. This is an SDK-level issue that will be resolved in future SDK updates. The error can be safely ignored as it doesn't affect application functionality.

### Lab Impact
- Exercise 02, 03, 04 - Agent execution
- Does not prevent lab completion

---

## Agent Model Configuration Documentation Inconsistency

### Issue
Documentation inconsistency regarding which AI model should be used for agent creation, particularly for the Cora agent.

### Error Message
No error - documentation discrepancy only.

### Root Cause
- Exercise 04 Task 04_01 (line 80) states: "You should see the `gpt-5-mini` deployment that you created in Exercise 01 listed here, as well as `phi4` for Cora."
- However, Exercise 02 Task 02_02 instructions and `env_sample.txt` both specify `AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME="gpt-5-mini"` for all agents
- All agent initializer scripts use `model=os.environ["AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME"]`
- This creates confusion about whether Cora (or any agents) should use phi-4 model

### Recommended Fix
Documentation should be updated to clarify:
- **Option A**: If phi-4 is intended for Cora, update Exercise 02 instructions to specify using phi-4 for Cora agent creation
- **Option B**: If gpt-5-mini is correct for all agents, remove the "phi4 for Cora" reference from Exercise 04 documentation

### Current Workaround
Follow Exercise 02 instructions as written - use `gpt-5-mini` for all agents including Cora. The phi-4 deployment exists but is not actively used in the current lab design.

### Lab Impact
- Exercise 02 Task 02_02 - Agent creation
- Exercise 04 Task 04_01 - Monitoring and observability expectations
- May cause confusion when monitoring shows only gpt-5-mini usage instead of expected phi-4 metrics

---

**Last Updated**: December 11, 2025
