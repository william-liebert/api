# Use the official .NET SDK image as base
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY src/WTech.API/*.csproj ./src/WTech.API/
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR /app/src/WTech.API
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image for final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/src/WTech.API/out .
ENTRYPOINT ["dotnet", "WTech.API.dll"]