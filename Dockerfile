FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["k8stest.csproj", "./"]
RUN dotnet restore "./k8stest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "k8stest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "k8stest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "k8stest.dll"]
