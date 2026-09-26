# API

## Human-readable guide

The application is an ASP.NET Core minimal API in `src/WTech.API`. It currently
serves one sample endpoint. Forecast values are generated at request time and
are not backed by a database or external weather service.

### `GET /weatherforecast`

Returns five forecast entries for the next five days. Each entry contains a
date, Celsius temperature, summary, and a computed Fahrenheit temperature.
The endpoint is named `GetWeatherForecast` in the OpenAPI metadata.

Swagger/OpenAPI middleware and the Swagger UI are registered only when the app
is running in the Development environment. HTTPS redirection is configured for
the request pipeline; behavior depends on the hosting environment and its
forwarded-header/TLS configuration.

### Configuration and runtime

The project targets .NET 8 and enables nullable reference types and implicit
usings. Environment-specific settings are in `appsettings.*.json`. The
Dockerfile publishes the application and runs `WTech.API.dll` using the ASP.NET
runtime image.

## AI-parsable reference

```yaml
application:
  project: src/WTech.API/WTech.API.csproj
  target_framework: net8.0
  entry_point: src/WTech.API/Program.cs
  container_definition: src/WTech.API/Dockerfile
routes:
  - method: GET
    path: /weatherforecast
    operation_name: GetWeatherForecast
    response: array
    item_fields:
      - Date
      - TemperatureC
      - Summary
      - TemperatureF
    count: 5
    persistence: none
middleware:
  https_redirection: enabled
  swagger:
    enabled_only_when: Development
dependencies:
  centrally_managed: true
  versions_file: Directory.Packages.props
```

## Change checklist

### Human-readable guide

When adding endpoints, update this page with the method, route, response shape,
authentication requirements, and relevant configuration. Add automated tests
when a test project exists; at present the repository has no test projects.

### AI-parsable reference

| Change | Update |
| --- | --- |
| Route or middleware | `src/WTech.API/Program.cs` and this page |
| Package version | `Directory.Packages.props` and lock file as appropriate |
| Container behavior | `src/WTech.API/Dockerfile` |
| API documentation | OpenAPI metadata and this page |
