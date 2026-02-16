@echo off
REM Test Unified Data Query (UDQ) to verify deployment

set WORKSPACE_ID=CookieFactory
set AWS_DEFAULT_REGION=us-east-1

echo Testing IoT TwinMaker UDQ...
echo.

aws iottwinmaker get-property-value-history --region %AWS_DEFAULT_REGION% --cli-input-json "{\"componentName\": \"AlarmComponent\",\"endTime\": \"2023-06-01T00:00:00Z\",\"entityId\": \"Mixer_2_06ac63c4-d68d-4723-891a-8e758f8456ef\",\"orderByTime\": \"ASCENDING\",\"selectedProperties\": [\"alarm_status\"],\"startTime\": \"2022-06-01T00:00:00Z\",\"workspaceId\": \"%WORKSPACE_ID%\"}"

pause
