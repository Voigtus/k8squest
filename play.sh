#!/bin/bash
# Quick launcher for K8sQuest

cd "$(dirname "$0")"

if [ ! -d "venv" ]; then
  echo "❌ Virtual environment not found. Please run ./install.sh first"
  exit 1
fi

# Check and install jq if needed (required for some level validations)
if ! command -v jq &> /dev/null; then
    echo "📦 jq not found. Installing jq (required for Level 33 and other validations)..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq || { echo "❌ Failed to install jq. Please install manually: brew install jq"; exit 1; }
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y jq || { echo "❌ Failed to install jq. Please install manually: sudo apt-get install jq"; exit 1; }
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "💡 For Windows, please install jq manually:"
        echo "   Option 1 (Chocolatey): choco install jq"
        echo "   Option 2 (Scoop): scoop install jq"
        echo "   Option 3: Download from https://stedolan.github.io/jq/download/"
        exit 1
    else
        echo "❌ Unsupported OS. Please install jq manually."
        echo "💡 Download from: https://stedolan.github.io/jq/download/"
        exit 1
    fi
    echo "✅ jq installed successfully"
fi

# Set PYTHONPATH to include the project root
export PYTHONPATH="$(pwd):$PYTHONPATH"

# Use venv Python directly (cross-platform)
if [ -f "venv/bin/python3" ]; then
  venv/bin/python3 engine/engine.py
elif [ -f "venv/Scripts/python.exe" ]; then
  venv/Scripts/python.exe engine/engine.py
else
  echo "❌ Virtual environment Python not found"
  exit 1
fi
