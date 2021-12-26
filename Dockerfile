FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["src/RequestManagerApi/RequestManagerApi.csproj", "src/RequestManagerApi/"]
RUN dotnet restore "src/RequestManagerApi/RequestManagerApi.csproj"
COPY . .
WORKDIR "/src/src/RequestManagerApi"
RUN dotnet build "RequestManagerApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RequestManagerApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RequestManagerApi.dll"]
