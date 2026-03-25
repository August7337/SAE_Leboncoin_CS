namespace LeboncoinAPI.Services;

public static class AuthorizationClaimTypes
{
    public const string Permission = "permission";
}

public static class AppRoles
{
    public const string Client = "Client";
    public const string ServiceLocation = "Service_Location";
    public const string ServiceComptabilite = "Service_Comptabilite";
    public const string ServiceContentieux = "Service_Contentieux";

    public const string AllServices = ServiceLocation + "," + ServiceComptabilite + "," + ServiceContentieux;
}

public static class AppPermissions
{
    public const string AppViewHome = "app.view.home";
    public const string AppViewFavorites = "app.view.favorites";
    public const string AppViewGdprData = "app.view.gdpr_data";
    public const string AppViewMessages = "app.view.messages";
    public const string AppViewMyAnnonces = "app.view.my_annonces";
    public const string AppViewMyReservations = "app.view.my_reservations";

    public const string DashboardSettings = "dashboard.settings";
    public const string DashboardIncidentsLocation = "dashboard.incidents.location";
    public const string DashboardIncidentsComptabilite = "dashboard.incidents.comptabilite";
    public const string DashboardIncidentsContentieux = "dashboard.incidents.contentieux";

    public const string IncidentReadAll = "incident.read.all";
    public const string IncidentTakeInCharge = "incident.take_in_charge";
    public const string IncidentClassWithoutFollowUp = "incident.class_without_follow_up";
    public const string IncidentRequestOwnerExplanation = "incident.request_owner_explanation";
    public const string IncidentDecideRefund = "incident.decide_refund";
    public const string IncidentProcessRefund = "incident.process_refund";
    public const string IncidentContentieuxClose = "incident.contentieux.close";
    public const string IncidentContentieuxLegal = "incident.contentieux.legal";
}
