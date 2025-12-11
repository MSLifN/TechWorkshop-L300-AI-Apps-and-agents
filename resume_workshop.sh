#!/bin/bash

# TechWorkshop L300 - Resume Script
# Created: December 10, 2025
# This script helps you resume your workshop session

echo "=========================================="
echo "TechWorkshop L300: AI Apps and Agents"
echo "Resume Script"
echo "=========================================="
echo ""

# Navigate to src directory
cd /workspaces/TechWorkshop-L300-AI-Apps-and-agents/src

# Activate virtual environment
echo "✓ Activating Python virtual environment..."
source venv/bin/activate

echo "✓ Virtual environment activated"
echo ""

# Show current status
echo "=========================================="
echo "CURRENT WORKSHOP STATUS"
echo "=========================================="
echo ""
echo "COMPLETED:"
echo "  ✓ Exercise 01: Deploy & Configure Resources"
echo "  ✓ Task 02_01: Single-agent solution created"
echo "  ✓ Fixed AZURE_AI_AGENT_ENDPOINT in .env file"
echo "  ✓ Assigned Azure AI Developer role"
echo "  ✓ Assigned Cognitive Services Contributor role"
echo ""
echo "IN PROGRESS:"
echo "  ⏳ Task 02_02: Create multi-agent solution"
echo "     - Customer Loyalty Agent prompt: ✓ Created"
echo "     - Customer Loyalty Agent initializer: ✓ Created"
echo "     - Agent creation: ⏸️  WAITING (permissions propagating)"
echo ""
echo "NEXT STEPS:"
echo "  1. Wait for Azure role permissions to propagate (5-15 min from ~1:00 PM)"
echo "  2. Create Customer Loyalty Agent"
echo "  3. Create remaining 4 agents (Interior Design, Inventory, Shopper, Cart Manager)"
echo "  4. Update chat_app.py to enable multi-agent mode"
echo "  5. Test the multi-agent application"
echo ""
echo "=========================================="
echo "COMMANDS TO TRY"
echo "=========================================="
echo ""
echo "1. Test if permissions have propagated (retry agent creation):"
echo "   python app/agents/customerLoyaltyAgent_initializer.py"
echo ""
echo "2. If successful, you'll see:"
echo "   'Created Zava Customer Loyalty Agent, ID: asst_xxxxx'"
echo "   Copy the ID to .env file under 'customer_loyalty'"
echo ""
echo "3. If permissions still not ready, wait a few more minutes"
echo ""
echo "4. Alternative: Create agents manually at https://ai.azure.com"
echo ""
echo "=========================================="
echo "ENVIRONMENT CHECK"
echo "=========================================="
echo ""
echo "Python version: $(python --version)"
echo "Current directory: $(pwd)"
echo "Virtual environment: $VIRTUAL_ENV"
echo ""
echo "Key .env variables:"
grep -E "^AZURE_AI_AGENT_ENDPOINT|^AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME" .env
echo ""
echo "Role assignments on AI Foundry resource:"
az role assignment list \
  --assignee "admin@MngEnvMCAP105953.onmicrosoft.com" \
  --scope "/subscriptions/49beb517-d771-4d32-b7ff-34953d511e8d/resourceGroups/techworkshop-l300-ai-agents/providers/Microsoft.CognitiveServices/accounts/aif-gw5ehcx5adkvc" \
  --query "[].roleDefinitionName" \
  -o tsv
echo ""
echo "=========================================="
echo "Ready to continue! Try the command above."
echo "=========================================="
