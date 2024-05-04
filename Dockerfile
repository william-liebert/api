FROM mcr.microsoft.com/dotnet/sdk:8.0 AS sdk
WORKDIR /app

COPY /app/NuGet.config /app/NuGet.config
COPY /app/WTech.API.sln /app/WTech.API.sln
COPY /app/src/WTech.API/WTech.API.csproj /app/src/WTech.API/WTech.API.csproj
COPY /app/src/WTech.API/packages.lock.json /app/src/WTech.API/packages.lock.json
COPY /app/Directory.Packages.props /app/Directory.Packages.props
RUN dotnet restore --locked-mode

COPY . .
WORKDIR /app/src/WTech.API/
RUN dotnet publish -c Release -o /app/out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=sdk /app/out .
ENTRYPOINT ["dotnet", "WTech.API.dll"]