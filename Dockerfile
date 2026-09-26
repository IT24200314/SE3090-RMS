# =================================================================================================
# Dockerfile: ASP.NET Core 10 Web API Containerization for Cloud Deployment (Root level)
# =================================================================================================

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
WORKDIR /src

# Copy project files and restore
COPY ["backend/RMS.Core/RMS.Core.csproj", "backend/RMS.Core/"]
COPY ["backend/RMS.Infrastructure/RMS.Infrastructure.csproj", "backend/RMS.Infrastructure/"]
COPY ["backend/RMS.API/RMS.API.csproj", "backend/RMS.API/"]
RUN dotnet restore "backend/RMS.API/RMS.API.csproj"

# Copy remaining source code and publish
COPY backend/ ./backend/
WORKDIR "/src/backend/RMS.API"
RUN dotnet publish "RMS.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview AS final
WORKDIR /app
COPY --from=build /app/publish .

# Environment configuration
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 5000

ENTRYPOINT ["dotnet", "RMS.API.dll"]
