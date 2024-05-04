FROM mcr.microsoft.com/dotnet/sdk:8.0 AS sdk
WORKDIR /app

COPY ./NuGet.config ./NuGet.config
COPY ./WTech.API.sln ./WTech.API.sln
COPY ./src/WTech.API/WTech.API.csproj ./src/WTech.API/WTech.API.csproj
COPY ./src/WTech.API/packages.lock.json ./src/WTech.API/packages.lock.json
COPY ./Directory.Packages.props ./Directory.Packages.props
RUN dotnet restore --locked-mode

COPY . .
RUN dotnet build -c Release -o /app/out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=sdk /app/out .
ENTRYPOINT ["dotnet", "WTech.API.dll"]