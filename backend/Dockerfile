# =================================================================================================
# Dockerfile: ASP.NET Core 10 Web API Containerization for Cloud Deployment (Render / Railway / Azure)
# =================================================================================================

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-alpine AS build
WORKDIR /src

# Copy project files and restore
COPY ["RMS.Core/RMS.Core.csproj", "RMS.Core/"]
COPY ["RMS.Infrastructure/RMS.Infrastructure.csproj", "RMS.Infrastructure/"]
COPY ["RMS.API/RMS.API.csproj", "RMS.API/"]
RUN dotnet restore "RMS.API/RMS.API.csproj"

# Copy remaining code and build
COPY . .
WORKDIR "/src/RMS.API"
RUN dotnet publish "RMS.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview-alpine AS final
WORKDIR /app
COPY --from=build /app/publish .

# Environment configuration
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 5000

ENTRYPOINT ["dotnet", "RMS.API.dll"]
