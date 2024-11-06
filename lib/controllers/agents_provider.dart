import 'package:flutter/material.dart';
import 'package:jobility/models/request/agents/agents.dart';
import 'package:jobility/models/response/agent/getAgent.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/helpers/agencies_helper.dart';

class AgentNotifier extends ChangeNotifier {
  late List<Agents> allAgents;
  late Future<List<JobsResponse>> agentJobs;
  late Map<String, dynamic> chat;

  Agents? agent;

  Future<List<Agents>> getAgents() {
    var agents = AgencyHelper.getAgents();
    return agents;
  }

  Future<GetAgent> getAgentInfo(String uid) {
    var getAgent = AgencyHelper.getAgentInfo(uid);
    return getAgent;
  }

  Future<List<JobsResponse>> getAgentJobs(String uid) {
    agentJobs = AgencyHelper.getAgentJobs(uid);
    return agentJobs;
  }
}
