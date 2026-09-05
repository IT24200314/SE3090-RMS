class AiTrace {
  final String id;
  final String timestamp;
  final String agent;
  final String action;
  final String state; // 'SUCCESS' | 'HITL_PAUSE'
  final String duration;
  final String details;

  AiTrace({
    required this.id,
    required this.timestamp,
    required this.agent,
    required this.action,
    required this.state,
    required this.duration,
    required this.details,
  });

  factory AiTrace.fromJson(Map<String, dynamic> json) {
    return AiTrace(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? 'Just now',
      agent: json['agent'] ?? '',
      action: json['action'] ?? '',
      state: json['state'] ?? 'SUCCESS',
      duration: json['duration'] ?? '300ms',
      details: json['details'] ?? '',
    );
  }
}
