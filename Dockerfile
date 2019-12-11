FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["simpleapi.csproj", "./"]
RUN dotnet restore "./simpleapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "simpleapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "simpleapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "simpleapi.dll"]
