# Quick Build Guide - AWS IoT TwinMaker Cookie Factory

## Environment
- **Region**: us-east-1
- **Python**: 3.11
- **Node.js**: Latest
- **Docker**: Latest
- **AWS CLI**: Latest
- **CDK**: Latest

## Build Steps

### 1. Run Build Script
```cmd
cd d:\shared\trial\aws-iot-twinmaker-samples
build.bat
```

### 2. Manual Step (During Build)
When prompted:
1. Open: https://us-east-1.console.aws.amazon.com/iottwinmaker/home
2. Create workspace: `CookieFactory`
3. Select role containing: `IoTTwinMakerWorkspaceRole`
4. Return to script and press any key

### 3. Setup Grafana (After Build)
```cmd
# Follow instructions in:
docs\grafana_local_docker_setup.md

# Import dashboard from:
src\workspaces\cookiefactory\sample_dashboards\mixer_alarms_dashboard.json
```

### 4. Test Deployment
```cmd
test_udq.bat
```

## Cleanup
```cmd
cleanup.bat
```

## Key Files Created
- `build.bat` - Main build script
- `test_udq.bat` - Verify deployment
- `cleanup.bat` - Remove all resources

## Console Links
- **TwinMaker Console**: https://us-east-1.console.aws.amazon.com/iottwinmaker/home
- **Grafana Local**: http://localhost:3000 (after setup)
- **Dashboard**: http://localhost:3000/d/y1FGfj57z/aws-iot-twinmaker-mixer-alarm-dashboard

## Troubleshooting
- If `libGL.so.1` error on Linux: `sudo yum install mesa-libGL`
- Ensure AWS credentials are configured: `aws sts get-caller-identity`
- Check all prerequisites are installed before running build.bat
