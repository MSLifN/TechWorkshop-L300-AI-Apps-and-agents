# Workshop Status - December 10, 2025

## Current Position
**Exercise 02, Task 02** - Creating multi-agent solution

## What's Been Completed ✅

### Exercise 01: Deploy & Configure Resources
- ✅ Azure resources deployed via Bicep
- ✅ Resource group created: `techworkshop-l300-ai-agents`
- ✅ AI Foundry project configured
- ✅ Model deployments created: gpt-5-mini, Phi-4, text-embedding-3-large
- ✅ .env file created and configured
- ✅ Storage account permissions assigned

### Exercise 02, Task 01: Single-Agent Solution
- ✅ Single agent example created (`src/app/tools/singleAgentExample.py`)
- ✅ chat_app.py modified to use single agent
- ✅ Application tested locally

### Exercise 02, Task 02: Multi-Agent Solution (IN PROGRESS)
- ✅ Customer Loyalty Agent prompt created (`src/prompts/CustomerLoyaltyAgentPrompt.txt`)
- ✅ Customer Loyalty Agent initializer created (`src/app/agents/customerLoyaltyAgent_initializer.py`)
- ✅ Fixed AZURE_AI_AGENT_ENDPOINT (was using wrong endpoint format)
- ✅ Assigned Azure AI Developer role to user
- ✅ Assigned Cognitive Services Contributor role to user
- ⏳ **WAITING**: Azure role permissions to propagate (5-15 minutes)

## Current Blocker

**Azure RBAC Permission Propagation**
- Role assignments were created at ~12:52 PM UTC
- Permissions can take 5-15 minutes to propagate
- Current error when running `customerLoyaltyAgent_initializer.py`:
  ```
  PermissionDenied: The principal lacks the required data action 
  'Microsoft.CognitiveServices/accounts/AIServices/agents/write'
  ```

## What Needs to Be Done Next

### Immediate (when permissions propagate):
1. **Create Customer Loyalty Agent**
   ```bash
   cd /workspaces/TechWorkshop-L300-AI-Apps-and-agents/src
   source venv/bin/activate
   python app/agents/customerLoyaltyAgent_initializer.py
   ```
   - Copy the agent ID to `.env` file under `customer_loyalty="asst_xxxxx"`

### Remaining Tasks in 02_02:

2. **Create remaining agent prompt files** in `src/prompts/`:
   - ❌ `InteriorDesignAgentPrompt.txt` ✅ (already exists!)
   - ❌ `InventoryAgentPrompt.txt`
   - ❌ `ShopperAgentPrompt.txt`
   - ❌ `CartManagerPrompt.txt`

3. **Create remaining agent initializers** in `src/app/agents/`:
   - ❌ `interiorDesignAgent_initializer.py`
   - ❌ `inventoryAgent_initializer.py`
   - ❌ `shopperAgent_initializer.py`
   - ❌ `cartManagerAgent_initializer.py`

4. **Run each initializer script** and save agent IDs to `.env`

5. **Update chat_app.py** to enable multi-agent mode:
   - Comment out lines 45 and 250-256 (single-agent code)
   - Uncomment lines 46-49 (imports)
   - Uncomment lines 117-118 (MCP server)
   - Uncomment lines 127-138 (handoff service)
   - Uncomment lines 258-600 (multi-agent handling)

6. **Test the multi-agent application**

## Quick Start Tomorrow

Run this script to resume:
```bash
./resume_workshop.sh
```

Or manually:
```bash
cd /workspaces/TechWorkshop-L300-AI-Apps-and-agents/src
source venv/bin/activate
python app/agents/customerLoyaltyAgent_initializer.py
```

## Key Configuration Details

### Resource Names
- Resource Group: `techworkshop-l300-ai-agents`
- AI Foundry: `aif-gw5ehcx5adkvc`
- Project: `proj-gw5ehcx5adkvc`
- Subscription ID: `49beb517-d771-4d32-b7ff-34953d511e8d`

### Important Endpoints
- Azure OpenAI: `https://aif-gw5ehcx5adkvc.cognitiveservices.azure.com/`
- AI Foundry Project: `https://aif-gw5ehcx5adkvc.services.ai.azure.com/api/projects/proj-gw5ehcx5adkvc`

### Role Assignments (completed)
- Azure AI Developer ✅
- Cognitive Services Contributor ✅
- Storage Blob Data Contributor ✅

## Known Issues
- See [LAB_WORKAROUNDS.md](LAB_WORKAROUNDS.md) for documented workarounds
- Permissions propagation delay (expected, not an error)

## Reference
- Lab docs: `docs/02_implement_multimodal_ai_shopping_assistant/02_02.md`
- Workarounds: `LAB_WORKAROUNDS.md`
