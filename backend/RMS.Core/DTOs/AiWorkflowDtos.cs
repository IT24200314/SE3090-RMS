// =================================================================================================
// File: AiWorkflowDtos.cs
// Module: RMS.Core / AI Agentic Orchestration DTOs
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Core Layer - Data Transfer Objects for LangGraph Agentic AI Requests & Traces
// Purpose: Models incoming client requests to start agent workflows and structured responses
//          containing intermediate reasoning traces, contractor recommendations, and HITL flags.
// =================================================================================================

using System.Text.Json.Serialization;

namespace RMS.Core.DTOs;

/// <summary>
/// Payload sent to start an agentic multi-agent workflow.
/// </summary>
public class StartAiWorkflowDto
{
    [JsonPropertyName("domain_objective")]
    public string DomainObjective { get; set; } = string.Empty;

    [JsonPropertyName("target_entity_type")]
    public string TargetEntityType { get; set; } = "MAINTENANCE"; // "MAINTENANCE", "TENANT_APPLICATION", "LEASE"

    [JsonPropertyName("target_entity_id")]
    public string? TargetEntityId { get; set; }

    [JsonPropertyName("tenant_income")]
    public decimal? TenantIncome { get; set; }

    [JsonPropertyName("property_rent")]
    public decimal? PropertyRent { get; set; }

    [JsonPropertyName("issue_description")]
    public string? IssueDescription { get; set; }

    [JsonPropertyName("reported_priority")]
    public string? ReportedPriority { get; set; }
}

/// <summary>
/// Payload to resume a paused LangGraph workflow after human approval.
/// </summary>
public class HitlApprovalDto
{
    [JsonPropertyName("workflow_id")]
    public string WorkflowId { get; set; } = string.Empty;

    [JsonPropertyName("manager_action")]
    public string ManagerAction { get; set; } = "APPROVE"; // "APPROVE" or "REJECT"

    [JsonPropertyName("manager_notes")]
    public string? ManagerNotes { get; set; }
}
