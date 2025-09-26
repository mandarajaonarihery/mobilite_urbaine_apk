class Api{
  //Adresse de la base
  static const String baseUrl = "https://gateway.tsirylab.com";

  //Endpoints
  static const String login = "/serviceauth/auth/login";
  static const String user = "/serviceauth/users/{id}";
  static const String vehiculeDocumentation = "/serviceflotte/vehicules/with-docs/{immatriculation}/{municipality_id}";
  static const String infraction = "/serviceflotte/infractions";
  static const String agentCitizen = "/serviceflotte/agents/citizen";
}