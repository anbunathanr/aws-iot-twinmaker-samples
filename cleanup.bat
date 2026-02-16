@echo off
REM Cleanup/Teardown Script for Cookie Factory

echo ========================================
echo Cookie Factory Teardown
echo ========================================
echo WARNING: This will delete all resources!
echo.
pause

set AWS_DEFAULT_REGION=us-east-1
set WORKSPACE_ID=CookieFactory
set TIMESTREAM_TELEMETRY_STACK_NAME=CookieFactoryTelemetry
set GETTING_STARTED_DIR=%CD%

echo.
echo [1/3] Deleting Grafana dashboard role...
python src\modules\grafana\cleanup_grafana_dashboard_role.py --workspace-id %WORKSPACE_ID% --region %AWS_DEFAULT_REGION%

echo.
echo [2/3] Deleting workspace and content...
cd src\workspaces\cookiefactory
python -m setup_content --telemetry-stack-name %TIMESTREAM_TELEMETRY_STACK_NAME% --workspace-id %WORKSPACE_ID% --region-name %AWS_DEFAULT_REGION% --delete-all --delete-workspace-role-and-bucket
cd %GETTING_STARTED_DIR%

echo.
echo [3/3] Deleting Timestream stack...
aws cloudformation delete-stack --stack-name %TIMESTREAM_TELEMETRY_STACK_NAME% --region %AWS_DEFAULT_REGION%
aws cloudformation wait stack-delete-complete --stack-name %TIMESTREAM_TELEMETRY_STACK_NAME% --region %AWS_DEFAULT_REGION%

echo.
echo Teardown complete!
pause
