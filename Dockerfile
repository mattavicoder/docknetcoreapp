FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["randomApp.csproj", "./"]
RUN dotnet restore "randomApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "randomApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "randomApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "randomApp.dll"]
