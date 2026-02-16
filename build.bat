@echo off
REM AWS IoT TwinMaker Cookie Factory Build Script
REM Environment: Python 3.11, Latest Node.js, Docker, AWS CLI, CDK
REM Region: us-east-1

echo ========================================
echo AWS IoT TwinMaker Cookie Factory Setup
echo ========================================

REM Step 1: Set Environment Variables
echo.
echo [1/10] Setting environment variables...
set AWS_DEFAULT_REGION=us-east-1
set CDK_DEFAULT_REGION=us-east-1
set TIMESTREAM_TELEMETRY_STACK_NAME=CookieFactoryTelemetry
set WORKSPACE_ID=CookieFactory
set GETTING_STARTED_DIR=%CD%

REM Get AWS Account ID
for /f "tokens=*" %%i in ('aws sts get-caller-identity --query Account --output text') do set CDK_DEFAULT_ACCOUNT=%%i
echo AWS Account: %CDK_DEFAULT_ACCOUNT%
echo Region: %AWS_DEFAULT_REGION%

REM Step 2: Verify Prerequisites
echo.
echo [2/10] Verifying prerequisites...
aws --version
python --version
node --version
npm --version
cdk --version
docker --version

REM Step 3: Bootstrap CDK
echo.
echo [3/10] Bootstrapping CDK...
cdk bootstrap aws://%CDK_DEFAULT_ACCOUNT%/%AWS_DEFAULT_REGION%

REM Step 4: Docker Authentication
echo.
echo [4/10] Authenticating Docker...
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

REM Step 5: Install Python Dependencies
echo.
echo [5/10] Installing Python dependencies...
pip install -r src\workspaces\cookiefactory\requirements.txt

REM Step 6: Create IoT TwinMaker Workspace Role
echo.
echo [6/10] Creating IoT TwinMaker workspace role...
python src\workspaces\cookiefactory\setup_cloud_resources\create_iottwinmaker_workspace_role.py --region %AWS_DEFAULT_REGION%

echo.
echo ========================================
echo MANUAL STEP REQUIRED
echo ========================================
echo 1. Go to: https://us-east-1.console.aws.amazon.com/iottwinmaker/home
echo 2. Create workspace named: CookieFactory
echo 3. Use role containing: IoTTwinMakerWorkspaceRole
echo 4. Press any key when workspace is created...
pause

REM Step 7: Create Grafana Dashboard Role
echo.
echo [7/10] Creating Grafana dashboard role...
python src\modules\grafana\create_grafana_dashboard_role.py --workspace-id %WORKSPACE_ID% --region %AWS_DEFAULT_REGION% --account-id %CDK_DEFAULT_ACCOUNT%

REM Step 8: Deploy Timestream Telemetry Module
echo.
echo [8/10] Deploying Timestream telemetry module...
cd src\modules\timestream_telemetry\cdk
call npm install
call cdk deploy --require-approval never
cd %GETTING_STARTED_DIR%

REM Step 9: Import Cookie Factory Content
echo.
echo [9/10] Importing Cookie Factory content...
cd src\workspaces\cookiefactory
python -m setup_content --telemetry-stack-name %TIMESTREAM_TELEMETRY_STACK_NAME% --workspace-id %WORKSPACE_ID% --region-name %AWS_DEFAULT_REGION% --import-all
cd %GETTING_STARTED_DIR%

REM Step 10: Complete
echo.
echo [10/10] Build complete!
echo.
echo ========================================
echo Next Steps:
echo ========================================
echo 1. Setup Grafana: See docs\grafana_local_docker_setup.md
echo 2. Import dashboard: src\workspaces\cookiefactory\sample_dashboards\mixer_alarms_dashboard.json
echo 3. Test UDQ query with: test_udq.bat
echo ========================================

pause
