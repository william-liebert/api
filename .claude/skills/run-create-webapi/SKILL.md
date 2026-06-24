---
name: run-create-webapi
description: Generate and run new Web APIs using ASP.NET Core templates
version: 0.1.0
---

# Web API Generator

This skill creates new ASP.NET Core Web API projects with standard configurations.

## Prerequisites

```bash
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0
```

## Generate New Web API

To create a new Web API project:

```bash
dotnet new webapi -n MyNewWebApi --output ./MyNewWebApi
cd MyNewWebApi
dotnet add package Microsoft.AspNetCore.OpenApi
dotnet add package Swashbuckle.AspNetCore
```

## Run (Agent Path)

1. Build the project:
   ```bash
   dotnet build
   ```

2. Run the API:
   ```bash
   dotnet run
   ```

3. The API will be available at http://localhost:5000 or https://localhost:5001

## Run (Human Path)

For a human to start the API:

```bash
dotnet run
```

This starts the development server and opens the browser to the Swagger UI.

## Gotchas

- Make sure you're running on .NET 8.0 SDK
- The default port is 5000 for HTTP and 5001 for HTTPS
- Swagger UI is available at `/swagger` when running in Development environment
- Ensure `dotnet` command is available in PATH

## Troubleshooting

**Issue**: "The specified framework 'Microsoft.AspNetCore.App' wasn't found"
**Fix**: Install the .NET 8.0 runtime and SDK

**Issue**: Port already in use
**Fix**: Change the port in appsettings.json or use `dotnet run --urls "http://localhost:5002"`

**Issue**: Swagger UI not showing
**Fix**: Ensure you're running in Development environment or add `app.UseSwagger()` and `app.UseSwaggerUI()` to Program.cs