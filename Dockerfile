FROM mcr.microsoft.com/dotnet/sdk:8.0 AS sdk
WORKDIR /app
COPY ./NuGet.config ./NuGet.config
COPY ./WTech.API.sln ./WTech.API.sln
COPY ./src/WTech.API/WTech.API.csproj ./src/WTech.API/WTech.API.csproj
COPY ./src/WTech.API/packages.lock.json ./src/WTech.API/packages.lock.json
COPY ./Directory.Packages.props ./Directory.Packages.props
RUN dotnet restore --locked-mode --verbosity normal
COPY . .
RUN dotnet publish --configuration Release --verbosity normal

FROM mcr.microsoft.com/dotnet/aspnet:8.0
ENV ASPNET__ENVIRONMENT=prod
WORKDIR /app
COPY --from=sdk /app/src/WTech.API/bin/Release/net8.0/publish/ .
ENTRYPOINT ["dotnet", "WTech.API.dll"]